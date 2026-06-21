import { prisma } from "./db/prisma.js";
import { logger } from "./logger.js";
import { config } from "../config.js";
import { getPaymentAdapter } from "../adapters/index.js";
import { enqueueJob } from "./jobs.js";
import { isPayoutResolution, syncTerminalSettlementState } from "./deposit-settlement.js";
import { sendEmail } from "./email.js";
import { buildPayoutReceiptPdf } from "./pdf.js";
import {
  getMerchantPayoutPolicy,
  resolveNextPayoutReleaseAt,
  resolvePayoutReleaseAt
} from "./platform-settings.js";

function providerMinimumMessage(amount: number) {
  return `Montant cumule inferieur au minimum de versement (${amount} XOF).`;
}

function formatMoneyXof(amount: number) {
  return amount.toLocaleString("fr-FR");
}

export async function notifyPayoutSucceeded(params: {
  payoutId: string;
  salonId: string;
  payoutMethod: string;
  grossAmount: number;
  platformCommissionAmount: number;
  merchantPayoutAmount: number;
  beneficiaryNameSnapshot: string;
  beneficiaryPhoneSnapshot: string;
  transactionReference: string | null;
}) {
  const owner = await prisma.user.findFirst({
    where: { salonId: params.salonId, role: "salon_owner", email: { not: null } },
    select: { email: true, fullName: true, salon: { select: { name: true } } }
  });
  if (!owner?.email) return;

  const { buildEmailHtml } = await import("./email-html.js");
  const pdf = await buildPayoutReceiptPdf({
    payoutReference: params.transactionReference ?? params.payoutId,
    issuedAt: new Date().toLocaleString("fr-FR"),
    status: "Reussi",
    grossAmountLabel: formatMoneyXof(params.grossAmount),
    commissionAmountLabel: formatMoneyXof(params.platformCommissionAmount),
    payoutAmountLabel: formatMoneyXof(params.merchantPayoutAmount),
    payoutMethod: params.payoutMethod,
    salonName: owner.salon?.name ?? "Salon",
    beneficiaryLabel: `${params.beneficiaryNameSnapshot} (${params.beneficiaryPhoneSnapshot})`,
    transactionReference: params.transactionReference
  });

  await sendEmail({
    to: owner.email,
    subject: "Versement effectue | Beauté Avenue",
    text:
      `Bonjour ${owner.fullName ?? ""},\n\n` +
      `Votre versement de ${formatMoneyXof(params.merchantPayoutAmount)} FCFA a ete effectue.\n` +
      `Reference: ${params.transactionReference ?? params.payoutId}\n\n` +
      `Le recu PDF est joint a cet email.\n\n` +
      `L'equipe Beauté Avenue`,
    html: buildEmailHtml({
      preheader: "Versement effectue",
      greeting: `Bonjour ${owner.fullName ?? ""},`,
      bodyLines: [
        `Votre versement de <strong>${formatMoneyXof(params.merchantPayoutAmount)} FCFA</strong> a ete effectue.`,
        `<strong>Reference :</strong> ${params.transactionReference ?? params.payoutId}`
      ],
      cta: { url: `${config.webOrigin}/pro/payouts`, label: "Voir mes versements" },
      ignoreNote: false,
      footerNote: "Le recu PDF est joint a cet email."
    }),
    attachments: [{
      filename: `versement-${params.payoutId.slice(0, 8)}.pdf`,
      content: pdf,
      contentType: "application/pdf"
    }]
  }).catch((err) => logger.warn("[payout-service] payout success email failed", {
    payoutId: params.payoutId,
    to: owner.email,
    error: String(err)
  }));
}

function buildBatchJobId(salonId: string, releaseBatchAt: Date) {
  return `merchant-payout-batch:${salonId}:${releaseBatchAt.toISOString()}`;
}

async function schedulePayoutBatchProcessing(salonId: string, releaseBatchAt: Date) {
  await enqueueJob({
    type: "process_merchant_payout_batch",
    payload: { salonId, releaseBatchAt: releaseBatchAt.toISOString() },
    runAfter: releaseBatchAt,
    jobId: buildBatchJobId(salonId, releaseBatchAt)
  });
}

export async function checkPayoutEligibility(bookingId: string, excludePayoutId?: string) {
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

  const resolution = (!booking.depositResolution || booking.depositResolution === "pending") && booking.status === "completed"
    ? "completed"
    : (booking.depositResolution ?? "pending");
  if (!isPayoutResolution(resolution)) {
    return { eligible: false, reason: "booking_not_settlement_eligible", booking };
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

  const existingPayout = await prisma.merchantPayout.findFirst({
    where: {
      bookingId,
      id: excludePayoutId ? { not: excludePayoutId } : undefined,
      status: { not: "cancelled" }
    }
  });
  if (existingPayout) {
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
  const eligibleAt = new Date();
  const holdHours = config.merchantPayoutHoldHours;
  const holdEndsAt = new Date(eligibleAt.getTime() + holdHours * 3600 * 1000);
  const payoutPolicy = await getMerchantPayoutPolicy();
  const releaseBatchAt = resolvePayoutReleaseAt(holdEndsAt, payoutPolicy);

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
        status: eligible ? "scheduled" : "blocked",
        disburseId: `merchant_payout_${createdPlaceholder}`,
        releaseBatchAt: eligible ? releaseBatchAt : null,
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

    if (typeof (tx as any).booking?.update === "function") {
      await tx.booking.update({
        where: { id: bookingId },
        data: {
          depositSettlementStatus: eligible ? "payout_scheduled" : "blocked",
          depositResolutionAt: booking.depositResolutionAt ?? eligibleAt
        }
      });
    }

    return updated;
  });

  if (eligible) {
    await schedulePayoutBatchProcessing(booking.salonId, releaseBatchAt);
  }

  return payout;
}

function payoutBatchDisburseId(batchId: string) {
  return `merchant_payout_batch_${batchId}`;
}

function payoutDestinationKey(payout: {
  payoutMethod: string;
  beneficiaryPhoneSnapshot: string;
  beneficiaryNameSnapshot: string;
}) {
  return [
    payout.payoutMethod,
    payout.beneficiaryPhoneSnapshot,
    payout.beneficiaryNameSnapshot
  ].join("::");
}

async function mirrorBatchFieldsToPayouts(batchId: string, data: Record<string, unknown>) {
  await prisma.merchantPayout.updateMany({
    where: { batchId },
    data: data as any
  });
}

export async function processPayoutBatchSlot(salonId: string, releaseBatchAt: Date) {
  const policy = await getMerchantPayoutPolicy();
  const scheduledPayouts = await prisma.merchantPayout.findMany({
    where: {
      salonId,
      batchId: null,
      status: "scheduled",
      releaseBatchAt: { lte: releaseBatchAt }
    },
    orderBy: { createdAt: "asc" }
  });

  if (!scheduledPayouts.length) return [];

  const grouped = new Map<string, typeof scheduledPayouts>();
  for (const payout of scheduledPayouts) {
    const key = payoutDestinationKey({
      payoutMethod: String(payout.payoutMethod),
      beneficiaryPhoneSnapshot: payout.beneficiaryPhoneSnapshot,
      beneficiaryNameSnapshot: payout.beneficiaryNameSnapshot
    });
    grouped.set(key, [...(grouped.get(key) ?? []), payout]);
  }

  const createdBatchIds: string[] = [];

  for (const payouts of grouped.values()) {
    const grossAmount = payouts.reduce((sum, payout) => sum + payout.grossAmount, 0);
    const platformCommissionAmount = payouts.reduce((sum, payout) => sum + payout.platformCommissionAmount, 0);
    const merchantPayoutAmount = payouts.reduce((sum, payout) => sum + payout.merchantPayoutAmount, 0);

    if (merchantPayoutAmount < policy.minimumPayoutXof) {
      const nextReleaseAt = resolveNextPayoutReleaseAt(releaseBatchAt, policy);
      await prisma.merchantPayout.updateMany({
        where: { id: { in: payouts.map((payout) => payout.id) } },
        data: {
          releaseBatchAt: nextReleaseAt,
          safeFailureMessage: providerMinimumMessage(policy.minimumPayoutXof)
        }
      });
      await schedulePayoutBatchProcessing(salonId, nextReleaseAt);
      continue;
    }

    const existingBatch = await prisma.merchantPayoutBatch.findFirst({
      where: {
        salonId,
        scheduledFor: releaseBatchAt,
        payoutMethod: payouts[0].payoutMethod,
        beneficiaryPhoneSnapshot: payouts[0].beneficiaryPhoneSnapshot
      }
    });

    const batch = existingBatch ?? await prisma.merchantPayoutBatch.create({
      data: {
        salonId,
        payoutMethod: payouts[0].payoutMethod,
        beneficiaryPhoneSnapshot: payouts[0].beneficiaryPhoneSnapshot,
        beneficiaryNameSnapshot: payouts[0].beneficiaryNameSnapshot,
        currency: "XOF",
        grossAmount,
        platformCommissionAmount,
        merchantPayoutAmount,
        itemCount: payouts.length,
        cadence: policy.cadence,
        scheduledFor: releaseBatchAt,
        windowStartAt: payouts.reduce<Date | null>(
          (min, payout) => !min || (payout.eligibleAt && payout.eligibleAt < min) ? (payout.eligibleAt ?? min) : min,
          null
        ) ?? null,
        windowEndAt: payouts.reduce<Date | null>(
          (max, payout) => !max || (payout.eligibleAt && payout.eligibleAt > max) ? (payout.eligibleAt ?? max) : max,
          null
        ) ?? null,
        disburseId: payoutBatchDisburseId(`placeholder_${Date.now()}_${Math.random().toString(36).slice(2, 8)}`)
      }
    });

    if (!existingBatch) {
      await prisma.merchantPayoutBatch.update({
        where: { id: batch.id },
        data: { disburseId: payoutBatchDisburseId(batch.id) }
      });
    }

    await prisma.merchantPayout.updateMany({
      where: { id: { in: payouts.map((payout) => payout.id) } },
      data: {
        batchId: batch.id,
        disburseId: payoutBatchDisburseId(batch.id),
        safeFailureMessage: null
      }
    });

    createdBatchIds.push(batch.id);
    await submitPayoutBatch(batch.id);
  }

  return createdBatchIds;
}

export async function submitPayoutBatch(batchId: string) {
  const batch = await prisma.merchantPayoutBatch.findUnique({
    where: { id: batchId },
    include: {
      payouts: true
    }
  });
  if (!batch) throw new Error("Payout batch not found");

  if (batch.status === "succeeded") return batch;
  if (batch.status === "pending" || batch.status === "cancelled") return batch;

  const claimed = await prisma.merchantPayoutBatch.updateMany({
    where: { id: batchId, version: batch.version, status: { notIn: ["pending", "succeeded", "cancelled"] } },
    data: { status: "submitting", version: batch.version + 1 }
  });

  if (claimed.count === 0) {
    throw new Error("Payout batch submission race condition: already processed or claimed by another worker");
  }

  await mirrorBatchFieldsToPayouts(batch.id, { status: "submitting" });

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
    if (adapter.getApproximateBalance) {
      const bal = await adapter.getApproximateBalance();
      if (bal.balance < batch.merchantPayoutAmount) {
        await prisma.merchantPayoutBatch.update({
          where: { id: batch.id },
          data: { status: "manual_review", failureCategory: "balance", safeFailureMessage: "Solde PayDunya insuffisant." }
        });
        await mirrorBatchFieldsToPayouts(batch.id, {
          status: "manual_review",
          failureCategory: "balance",
          safeFailureMessage: "Solde PayDunya insuffisant."
        });
        return;
      }
    }
  } catch (err) {
    logger.warn("[payout-service] failed to retrieve batch balance pre-check", { error: String(err), batchId });
  }

  let disburseToken = batch.disburseToken;

  if (disburseToken) {
    try {
      const statusCheck = await adapter.checkDisbursementStatus!({ disburseToken });
      if (statusCheck.status === "success") {
        await prisma.merchantPayoutBatch.update({
          where: { id: batch.id },
          data: {
            status: "succeeded",
            transactionId: statusCheck.transactionId || batch.transactionId,
            providerDisburseTxId: statusCheck.providerDisburseTxId,
            completedAt: new Date(),
            lastReconciledAt: new Date()
          }
        });
        await mirrorBatchFieldsToPayouts(batch.id, {
          status: "succeeded",
          transactionId: statusCheck.transactionId || batch.transactionId,
          providerDisburseTxId: statusCheck.providerDisburseTxId,
          completedAt: new Date(),
          lastReconciledAt: new Date()
        });
        for (const payout of batch.payouts) {
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
          if (payout.bookingId) {
            await syncTerminalSettlementState(payout.bookingId);
          }
        }
        await notifyPayoutSucceeded({
          payoutId: batch.id,
          salonId: batch.salonId,
          payoutMethod: String(batch.payoutMethod),
          grossAmount: batch.grossAmount,
          platformCommissionAmount: batch.platformCommissionAmount,
          merchantPayoutAmount: batch.merchantPayoutAmount,
          beneficiaryNameSnapshot: batch.beneficiaryNameSnapshot,
          beneficiaryPhoneSnapshot: batch.beneficiaryPhoneSnapshot,
          transactionReference: statusCheck.transactionId || statusCheck.providerDisburseTxId || null
        });
        return;
      }
      if (statusCheck.status === "pending") {
        await prisma.merchantPayoutBatch.update({
          where: { id: batch.id },
          data: { status: "pending", lastReconciledAt: new Date() }
        });
        await mirrorBatchFieldsToPayouts(batch.id, {
          status: "pending",
          lastReconciledAt: new Date()
        });
        return;
      }
    } catch (err) {
      logger.warn("[payout-service] submitPayoutBatch check-status failed", { error: String(err), batchId });
    }
  } else {
    try {
      await prisma.merchantPayoutBatch.update({
        where: { id: batch.id },
        data: { status: "creating", initiatedAt: new Date() }
      });
      await mirrorBatchFieldsToPayouts(batch.id, { status: "creating", initiatedAt: new Date() });

      const withdrawMode = adapter.resolveWithdrawMode!(batch.payoutMethod);
      const invoiceRes = await adapter.createDisbursementInvoice!({
        phone: batch.beneficiaryPhoneSnapshot,
        amountXof: batch.merchantPayoutAmount,
        withdrawMode,
        callbackUrl: config.paydunyaCallbackUrl
      });
      disburseToken = invoiceRes.disburseToken;

      await prisma.merchantPayoutBatch.update({
        where: { id: batch.id },
        data: { disburseToken, status: "created", initiatedAt: new Date() }
      });
      await mirrorBatchFieldsToPayouts(batch.id, {
        disburseToken,
        status: "created",
        initiatedAt: new Date()
      });
    } catch (err: any) {
      logger.error("[payout-service] createDisbursementInvoice failed for batch", {
        error: String(err),
        batchId: batch.id,
        callbackUrl: config.paydunyaCallbackUrl,
        payoutMethod: batch.payoutMethod,
        amountXof: batch.merchantPayoutAmount,
        beneficiaryPhone: batch.beneficiaryPhoneSnapshot
      });
      const isRetryable = !String(err.message).includes("bénéficiaire invalide") && !String(err.message).includes("montant");
      const update = {
        status: isRetryable ? "failed_retryable" : "failed_terminal",
        failureCategory: "create_invoice",
        failureCode: "invoice_error",
        safeFailureMessage: String(err.message),
        failedAt: new Date()
      } as const;
      await prisma.merchantPayoutBatch.update({
        where: { id: batch.id },
        data: update
      });
      await mirrorBatchFieldsToPayouts(batch.id, update as unknown as Record<string, unknown>);
      return;
    }
  }

  try {
    await prisma.merchantPayoutBatch.update({
      where: { id: batch.id },
      data: { status: "submitting", submittedAt: new Date() }
    });
    await mirrorBatchFieldsToPayouts(batch.id, { status: "submitting", submittedAt: new Date() });

    for (const payout of batch.payouts) {
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
    }

    const submitRes = await adapter.submitDisbursement!({
      disburseToken: disburseToken!,
      disburseId: batch.disburseId
    });

    if (submitRes.status === "success") {
      await prisma.merchantPayoutBatch.update({
        where: { id: batch.id },
        data: {
          status: "succeeded",
          transactionId: submitRes.transactionId,
          providerRef: submitRes.providerRef,
          completedAt: new Date(),
          lastReconciledAt: new Date()
        }
      });
      await mirrorBatchFieldsToPayouts(batch.id, {
        status: "succeeded",
        transactionId: submitRes.transactionId,
        providerRef: submitRes.providerRef,
        completedAt: new Date(),
        lastReconciledAt: new Date()
      });
      for (const payout of batch.payouts) {
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
        if (payout.bookingId) {
          await syncTerminalSettlementState(payout.bookingId);
        }
      }
      await notifyPayoutSucceeded({
        payoutId: batch.id,
        salonId: batch.salonId,
        payoutMethod: String(batch.payoutMethod),
        grossAmount: batch.grossAmount,
        platformCommissionAmount: batch.platformCommissionAmount,
        merchantPayoutAmount: batch.merchantPayoutAmount,
        beneficiaryNameSnapshot: batch.beneficiaryNameSnapshot,
        beneficiaryPhoneSnapshot: batch.beneficiaryPhoneSnapshot,
        transactionReference: submitRes.transactionId ?? submitRes.providerRef ?? null
      });
    } else if (submitRes.status === "pending") {
      await prisma.merchantPayoutBatch.update({
        where: { id: batch.id },
        data: {
          status: "pending",
          transactionId: submitRes.transactionId,
          providerRef: submitRes.providerRef,
          lastReconciledAt: new Date()
        }
      });
      await mirrorBatchFieldsToPayouts(batch.id, {
        status: "pending",
        transactionId: submitRes.transactionId,
        providerRef: submitRes.providerRef,
        lastReconciledAt: new Date()
      });
    } else {
      await prisma.merchantPayoutBatch.update({
        where: { id: batch.id },
        data: {
          status: "failed_retryable",
          failureCategory: "submit_invoice",
          safeFailureMessage: submitRes.responseText || "Disbursement submission failed",
          failedAt: new Date()
        }
      });
      await mirrorBatchFieldsToPayouts(batch.id, {
        status: "failed_retryable",
        failureCategory: "submit_invoice",
        safeFailureMessage: submitRes.responseText || "Disbursement submission failed",
        failedAt: new Date()
      });
    }
  } catch (err: any) {
    logger.error("[payout-service] submitDisbursement failed for batch", { error: String(err), batchId: batch.id });
    await prisma.merchantPayoutBatch.update({
      where: { id: batch.id },
      data: {
        status: "pending",
        failureCategory: "submit_exception",
        safeFailureMessage: err.message
      }
    });
    await mirrorBatchFieldsToPayouts(batch.id, {
      status: "pending",
      failureCategory: "submit_exception",
      safeFailureMessage: err.message
    });
  }
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

  if (payout.batchId) {
    await submitPayoutBatch(payout.batchId);
    return prisma.merchantPayout.findUnique({ where: { id: payout.id } });
  }

  const payoutPolicy = await getMerchantPayoutPolicy();
  if (payout.merchantPayoutAmount < payoutPolicy.minimumPayoutXof && !payout.disburseToken) {
    await prisma.merchantPayout.update({
      where: { id: payout.id },
      data: {
        status: "blocked",
        failureCategory: "amount_threshold",
        safeFailureMessage: providerMinimumMessage(payoutPolicy.minimumPayoutXof)
      }
    });
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

  const eligibility = await checkPayoutEligibility(payout.bookingId!, payout.id);
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
      logger.error("[payout-service] createDisbursementInvoice failed", {
        error: String(err),
        payoutId: payout.id,
        callbackUrl: config.paydunyaCallbackUrl,
        payoutMethod: payout.payoutMethod,
        amountXof: payout.merchantPayoutAmount,
        beneficiaryPhone: payout.beneficiaryPhoneSnapshot
      });
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
      await notifyPayoutSucceeded({
        payoutId: payout.id,
        salonId: payout.salonId,
        payoutMethod: String(payout.payoutMethod),
        grossAmount: payout.grossAmount,
        platformCommissionAmount: payout.platformCommissionAmount,
        merchantPayoutAmount: payout.merchantPayoutAmount,
        beneficiaryNameSnapshot: payout.beneficiaryNameSnapshot,
        beneficiaryPhoneSnapshot: payout.beneficiaryPhoneSnapshot,
        transactionReference: submitRes.transactionId ?? submitRes.providerRef ?? null
      });
      if (payout.bookingId) {
        await syncTerminalSettlementState(payout.bookingId);
      }
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

  if (payout.batchId) {
    await reconcilePayoutBatchStatus(payout.batchId);
    return;
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
        await notifyPayoutSucceeded({
          payoutId: payout.id,
          salonId: payout.salonId,
          payoutMethod: String(payout.payoutMethod),
          grossAmount: payout.grossAmount,
          platformCommissionAmount: payout.platformCommissionAmount,
          merchantPayoutAmount: payout.merchantPayoutAmount,
          beneficiaryNameSnapshot: payout.beneficiaryNameSnapshot,
          beneficiaryPhoneSnapshot: payout.beneficiaryPhoneSnapshot,
          transactionReference: res.transactionId || payout.transactionId || res.providerDisburseTxId || null
        });
        if (payout.bookingId) {
          await syncTerminalSettlementState(payout.bookingId);
        }
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

export async function reconcilePayoutBatchStatus(batchId: string) {
  const batch = await prisma.merchantPayoutBatch.findUnique({
    where: { id: batchId },
    include: { payouts: true }
  });
  if (!batch || !batch.disburseToken) return;

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
      disburseToken: batch.disburseToken
    });

    if (res.status === "success") {
      if (batch.status !== "succeeded") {
        await prisma.merchantPayoutBatch.update({
          where: { id: batch.id },
          data: {
            status: "succeeded",
            transactionId: res.transactionId || batch.transactionId,
            providerDisburseTxId: res.providerDisburseTxId,
            completedAt: batch.completedAt || new Date(),
            lastReconciledAt: new Date()
          }
        });
        await mirrorBatchFieldsToPayouts(batch.id, {
          status: "succeeded",
          transactionId: res.transactionId || batch.transactionId,
          providerDisburseTxId: res.providerDisburseTxId,
          completedAt: batch.completedAt || new Date(),
          lastReconciledAt: new Date()
        });

        for (const payout of batch.payouts) {
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
          if (payout.bookingId) {
            await syncTerminalSettlementState(payout.bookingId);
          }
        }
        await notifyPayoutSucceeded({
          payoutId: batch.id,
          salonId: batch.salonId,
          payoutMethod: String(batch.payoutMethod),
          grossAmount: batch.grossAmount,
          platformCommissionAmount: batch.platformCommissionAmount,
          merchantPayoutAmount: batch.merchantPayoutAmount,
          beneficiaryNameSnapshot: batch.beneficiaryNameSnapshot,
          beneficiaryPhoneSnapshot: batch.beneficiaryPhoneSnapshot,
          transactionReference: res.transactionId || batch.transactionId || res.providerDisburseTxId || null
        });
      }
    } else if (res.status === "failed") {
      if (batch.status !== "succeeded") {
        await prisma.merchantPayoutBatch.update({
          where: { id: batch.id },
          data: {
            status: "failed_terminal",
            failureCategory: "check_status",
            safeFailureMessage: res.responseText || "Check status returned failed",
            failedAt: new Date(),
            lastReconciledAt: new Date()
          }
        });
        await mirrorBatchFieldsToPayouts(batch.id, {
          status: "failed_terminal",
          failureCategory: "check_status",
          safeFailureMessage: res.responseText || "Check status returned failed",
          failedAt: new Date(),
          lastReconciledAt: new Date()
        });
      }
    } else {
      await prisma.merchantPayoutBatch.update({
        where: { id: batch.id },
        data: {
          status: "pending",
          lastReconciledAt: new Date()
        }
      });
      await mirrorBatchFieldsToPayouts(batch.id, {
        status: "pending",
        lastReconciledAt: new Date()
      });
    }
  } catch (err: any) {
    logger.error("[payout-service] reconcilePayoutBatchStatus exception", { error: String(err), batchId: batch.id });
  }
}
