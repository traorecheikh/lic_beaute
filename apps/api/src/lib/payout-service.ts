import { prisma } from "./db/prisma.js";
import { logger } from "./logger.js";
import { config } from "../config.js";
import { getPaymentAdapter } from "../adapters/index.js";
import { enqueueJob } from "./jobs.js";

export async function checkPayoutEligibility(bookingId: string) {
  const booking = await prisma.booking.findUnique({
    where: { id: bookingId },
    include: {
      salon: true,
      payments: { where: { status: "succeeded" }, take: 1 }
    }
  });

  if (!booking) {
    return { eligible: false, reason: "booking_not_found" };
  }

  if (booking.status !== "completed") {
    return { eligible: false, reason: "booking_not_completed", booking };
  }

  const payment = booking.payments[0];
  if (!payment) {
    return { eligible: false, reason: "payment_missing", booking };
  }
  if (payment.status !== "succeeded") {
    return { eligible: false, reason: "payment_not_succeeded", booking, payment };
  }

  if (!booking.salon.payoutMethod || !booking.salon.payoutPhone) {
    return { eligible: false, reason: "salon_payout_details_missing", booking, payment };
  }

  if (booking.salon.payoutVerificationStatus !== "verified") {
    return { eligible: false, reason: "salon_payout_details_unverified", booking, payment };
  }

  if (booking.salon.isSuspended) {
    return { eligible: false, reason: "salon_suspended", booking, payment };
  }

  if (booking.isUnderFraudReview) {
    return { eligible: false, reason: "booking_under_fraud_review", booking, payment };
  }

  if (booking.refundRequested) {
    return { eligible: false, reason: "refund_request_open", booking, payment };
  }
  if (booking.disputeOpen) {
    return { eligible: false, reason: "dispute_open", booking, payment };
  }

  const existingPayout = await prisma.merchantPayout.findUnique({
    where: { bookingId }
  });
  if (existingPayout && existingPayout.status !== "cancelled") {
    return { eligible: false, reason: "payout_already_exists", booking, payment };
  }

  const grossAmount = booking.depositAmountXof;
  if (grossAmount <= 0) {
    return { eligible: false, reason: "payout_amount_zero_or_negative", booking, payment };
  }

  return { eligible: true, booking, payment };
}

export async function createPayoutForBooking(bookingId: string, options?: { force?: boolean; actorUserId?: string }) {
  const eligibility = await checkPayoutEligibility(bookingId);
  const booking = eligibility.booking;
  const payment = eligibility.payment;

  if (!booking || !payment) {
    throw new Error(`Cannot create payout: booking or payment not found for booking ID ${bookingId}`);
  }

  const existing = await prisma.merchantPayout.findUnique({ where: { bookingId } });
  if (existing && existing.status !== "cancelled") {
    return existing;
  }

  const grossAmount = booking.depositAmountXof;
  const setting = await prisma.platformSetting.findUnique({
    where: { key: "commission_rate_percent" },
    select: { value: true }
  });
  const commissionRate = parseFloat(setting?.value ?? "5");
  const platformCommissionAmount = Math.round((grossAmount * commissionRate) / 100);
  const merchantPayoutAmount = grossAmount - platformCommissionAmount;

  if (merchantPayoutAmount <= 0) {
    throw new Error(`Merchant payout amount must be positive (computed: ${merchantPayoutAmount})`);
  }

  const eligible = eligibility.eligible || !!options?.force;
  const status = eligible ? "scheduled" : "blocked";
  const eligibleAt = new Date();
  
  const holdHours = config.merchantPayoutHoldHours;
  const scheduledRunTime = new Date(eligibleAt.getTime() + holdHours * 3600 * 1000);

  const payout = await prisma.$transaction(async (tx) => {
    const innerExisting = await tx.merchantPayout.findUnique({ where: { bookingId } });
    if (innerExisting && innerExisting.status !== "cancelled") {
      return innerExisting;
    }

    // Generate the final disburseId BEFORE create so it's set atomically.
    // Use a placeholder ID since we need the record's primary key.
    const createdPlaceholder = `placeholder-${Date.now()}-${Math.random().toString(36).substring(7)}`;

    const created = await tx.merchantPayout.create({
      data: {
        salonId: booking.salonId,
        bookingId,
        paymentId: payment.id,
        payoutMethod: booking.salon.payoutMethod as any,
        beneficiaryPhoneSnapshot: booking.salon.payoutPhone!,
        beneficiaryNameSnapshot: booking.salon.payoutName || booking.salon.name,
        currency: "XOF",
        grossAmount,
        platformCommissionAmount,
        merchantPayoutAmount,
        status,
        disburseId: `merchant_payout_${createdPlaceholder}`,
        eligibleAt,
        commissionType: "percentage",
        commissionConfiguredValue: commissionRate,
        commissionBaseAmount: grossAmount,
        commissionCalculatedAmount: platformCommissionAmount,
        commissionRoundingMethod: "round",
        policyVersion: "v1",
        feeResponsibilityPolicy: "platform_absorbs_fees"
      }
    });

    // Replace the placeholder with the real ID now that we have it
    const disburseId = `merchant_payout_${created.id}`;
    
    const updated = await tx.merchantPayout.update({
      where: { id: created.id },
      data: { disburseId }
    });

    await tx.ledgerEntry.create({
      data: {
        salonId: booking.salonId,
        bookingId,
        paymentId: payment.id,
        payoutId: updated.id,
        eventType: "client_payment_confirmed",
        amountXof: grossAmount,
        actorUserId: options?.actorUserId
      }
    });

    await tx.ledgerEntry.create({
      data: {
        salonId: booking.salonId,
        bookingId,
        paymentId: payment.id,
        payoutId: updated.id,
        eventType: "platform_commission_recognized",
        amountXof: -platformCommissionAmount,
        actorUserId: options?.actorUserId
      }
    });

    await tx.ledgerEntry.create({
      data: {
        salonId: booking.salonId,
        bookingId,
        paymentId: payment.id,
        payoutId: updated.id,
        eventType: "merchant_payable_created",
        amountXof: -merchantPayoutAmount,
        actorUserId: options?.actorUserId
      }
    });

    return updated;
  });

  if (status === "scheduled") {
    await enqueueJob({
      type: "process_merchant_payout",
      payload: { payoutId: payout.id },
      bookingId,
      runAfter: scheduledRunTime
    });
  }

  return payout;
}

export async function submitPayout(payoutId: string) {
  const payout = await prisma.merchantPayout.findUnique({
    where: { id: payoutId },
    include: { salon: true }
  });
  if (!payout) throw new Error("Payout not found");

  if (payout.status === "succeeded") {
    logger.info("[payout-service] submitPayout: payout already succeeded", { payoutId });
    return payout;
  }

  if (payout.status === "pending" || payout.status === "cancelled") {
    logger.info("[payout-service] submitPayout: payout in terminal or pending status", { payoutId, status: payout.status });
    return payout;
  }

  const claimed = await prisma.merchantPayout.updateMany({
    where: { id: payoutId, version: payout.version, status: { notIn: ["pending", "succeeded", "cancelled"] } },
    data: { status: "submitting", version: payout.version + 1 }
  });

  if (claimed.count === 0) {
    throw new Error("Payout submission race condition: already processed or claimed by another worker");
  }

  const adapter = getPaymentAdapter(config.paymentDriver, {
    baseOrigin: config.webOrigin,
    paydunyaMasterKey: config.paydunyaMasterKey,
    paydunyaPublicKey: config.paydunyaPublicKey,
    paydunyaPrivateKey: config.paydunyaPrivateKey,
    paydunyaToken: config.paydunyaToken,
    paydunyaEnv: config.paydunyaEnv,
    paydunyaBaseUrl: config.paydunyaBaseUrl
  });

  const eligibility = await checkPayoutEligibility(payout.bookingId!);
  if (!eligibility.eligible && !payout.disburseToken) {
    await prisma.merchantPayout.update({
      where: { id: payout.id },
      data: { status: "blocked", failureCategory: "eligibility", safeFailureMessage: eligibility.reason }
    });
    return;
  }

  try {
    if (adapter.getApproximateBalance) {
      const bal = await adapter.getApproximateBalance();
      if (bal.balance < payout.merchantPayoutAmount) {
        logger.warn("[payout-service] low approximate balance warning", { balance: bal.balance, amount: payout.merchantPayoutAmount });
        await prisma.merchantPayout.update({
          where: { id: payout.id },
          data: { status: "manual_review", failureCategory: "balance", safeFailureMessage: "Solde PayDunya insuffisant." }
        });
        return;
      }
    }
  } catch (err) {
    logger.warn("[payout-service] failed to retrieve balance pre-check", { error: String(err) });
  }

  let disburseToken = payout.disburseToken;

  // If a disbursement token already exists (from a previous attempt), reconcile with the provider
  // before retrying. This prevents duplicate payouts when the previous submit succeeded but
  // the response was lost.
  if (disburseToken) {
    try {
      const statusCheck = await adapter.checkDisbursementStatus!({ disburseToken });
      if (statusCheck.status === "success") {
        logger.info("[payout-service] submitPayout: check-status reports success, updating payout", { payoutId: payout.id });
        await prisma.merchantPayout.update({
          where: { id: payout.id },
          data: {
            status: "succeeded",
            transactionId: statusCheck.transactionId || payout.transactionId,
            providerDisburseTxId: statusCheck.providerDisburseTxId,
            completedAt: new Date(),
            lastReconciledAt: new Date()
          }
        });

        await prisma.ledgerEntry.create({
          data: {
            salonId: payout.salonId,
            bookingId: payout.bookingId,
            paymentId: payout.paymentId,
            payoutId: payout.id,
            eventType: "payout_succeeded",
            amountXof: payout.merchantPayoutAmount
          }
        });
        return;
      }
      if (statusCheck.status === "pending") {
        logger.info("[payout-service] submitPayout: check-status reports pending, updating status", { payoutId: payout.id });
        await prisma.merchantPayout.update({
          where: { id: payout.id },
          data: { status: "pending", lastReconciledAt: new Date() }
        });
        return;
      }
      // status = "failed" — continue to retry with existing token
      logger.info("[payout-service] submitPayout: check-status reports failed, will retry with existing token", { payoutId: payout.id });
    } catch (err: any) {
      logger.warn("[payout-service] submitPayout: check-status failed, retrying with existing token", { error: String(err), payoutId: payout.id });
    }
  } else {
    try {
      await prisma.merchantPayout.update({
        where: { id: payout.id },
        data: { status: "creating", initiatedAt: new Date() }
      });

      const withdrawMode = adapter.resolveWithdrawMode!(payout.payoutMethod);

      const invoiceRes = await adapter.createDisbursementInvoice!({
        phone: payout.beneficiaryPhoneSnapshot,
        amountXof: payout.merchantPayoutAmount,
        withdrawMode,
        callbackUrl: config.paydunyaCallbackUrl
      });
      disburseToken = invoiceRes.disburseToken;

      await prisma.merchantPayout.update({
        where: { id: payout.id },
        data: { disburseToken, status: "created", initiatedAt: new Date() }
      });
    } catch (err: any) {
      logger.error("[payout-service] createDisbursementInvoice failed", { error: String(err), payoutId: payout.id });
      const isRetryable = !err.message.includes("bénéficiaire invalide") && !err.message.includes("montant");
      await prisma.merchantPayout.update({
        where: { id: payout.id },
        data: {
          status: isRetryable ? "failed_retryable" : "failed_terminal",
          failureCategory: "create_invoice",
          failureCode: "invoice_error",
          safeFailureMessage: err.message,
          failedAt: new Date()
        }
      });
      return;
    }
  }

  try {
    await prisma.merchantPayout.update({
      where: { id: payout.id },
      data: { status: "submitting", submittedAt: new Date() }
    });

    await prisma.ledgerEntry.create({
      data: {
        salonId: payout.salonId,
        bookingId: payout.bookingId,
        paymentId: payout.paymentId,
        payoutId: payout.id,
        eventType: "payout_submitted",
        amountXof: -payout.merchantPayoutAmount
      }
    });

    const submitRes = await adapter.submitDisbursement!({
      disburseToken: disburseToken!,
      disburseId: payout.disburseId
    });

    if (submitRes.status === "success") {
      await prisma.merchantPayout.update({
        where: { id: payout.id },
        data: {
          status: "succeeded",
          transactionId: submitRes.transactionId,
          providerRef: submitRes.providerRef,
          completedAt: new Date(),
          lastReconciledAt: new Date()
        }
      });

      await prisma.ledgerEntry.create({
        data: {
          salonId: payout.salonId,
          bookingId: payout.bookingId,
          paymentId: payout.paymentId,
          payoutId: payout.id,
          eventType: "payout_succeeded",
          amountXof: payout.merchantPayoutAmount
        }
      });
    } else if (submitRes.status === "pending") {
      await prisma.merchantPayout.update({
        where: { id: payout.id },
        data: {
          status: "pending",
          transactionId: submitRes.transactionId,
          providerRef: submitRes.providerRef,
          lastReconciledAt: new Date()
        }
      });
    } else {
      await prisma.merchantPayout.update({
        where: { id: payout.id },
        data: {
          status: "failed_retryable",
          failureCategory: "submit_invoice",
          safeFailureMessage: submitRes.responseText || "Disbursement submission failed",
          failedAt: new Date()
        }
      });
    }
  } catch (err: any) {
    logger.error("[payout-service] submitDisbursement failed", { error: String(err), payoutId: payout.id });
    await prisma.merchantPayout.update({
      where: { id: payout.id },
      data: {
        status: "pending",
        failureCategory: "submit_exception",
        safeFailureMessage: err.message
      }
    });
  }
}

export async function reconcilePayoutStatus(payoutId: string) {
  const payout = await prisma.merchantPayout.findUnique({
    where: { id: payoutId }
  });
  if (!payout || !payout.disburseToken) return;

  const adapter = getPaymentAdapter(config.paymentDriver, {
    baseOrigin: config.webOrigin,
    paydunyaMasterKey: config.paydunyaMasterKey,
    paydunyaPublicKey: config.paydunyaPublicKey,
    paydunyaPrivateKey: config.paydunyaPrivateKey,
    paydunyaToken: config.paydunyaToken,
    paydunyaEnv: config.paydunyaEnv,
    paydunyaBaseUrl: config.paydunyaBaseUrl
  });

  try {
    const res = await adapter.checkDisbursementStatus!({
      disburseToken: payout.disburseToken
    });

    if (res.status === "success") {
      if (payout.status !== "succeeded") {
        await prisma.merchantPayout.update({
          where: { id: payout.id },
          data: {
            status: "succeeded",
            transactionId: res.transactionId || payout.transactionId,
            providerDisburseTxId: res.providerDisburseTxId,
            completedAt: payout.completedAt || new Date(),
            lastReconciledAt: new Date()
          }
        });

        await prisma.ledgerEntry.create({
          data: {
            salonId: payout.salonId,
            bookingId: payout.bookingId,
            paymentId: payout.paymentId,
            payoutId: payout.id,
            eventType: "payout_succeeded",
            amountXof: payout.merchantPayoutAmount
          }
        });
      }
    } else if (res.status === "failed") {
      if (payout.status !== "succeeded") {
        await prisma.merchantPayout.update({
          where: { id: payout.id },
          data: {
            status: "failed_terminal",
            failureCategory: "check_status",
            safeFailureMessage: res.responseText || "Check status returned failed",
            failedAt: new Date(),
            lastReconciledAt: new Date()
          }
        });
      }
    } else {
      await prisma.merchantPayout.update({
        where: { id: payout.id },
        data: {
          status: "pending",
          lastReconciledAt: new Date()
        }
      });
    }
  } catch (err: any) {
    logger.error("[payout-service] reconcilePayoutStatus exception", { error: String(err), payoutId: payout.id });
  }
}
