import { Job as BullJob, Worker } from "bullmq";

import { getPaymentAdapter, getStorageAdapter } from "./adapters/index.js";
import { config, validateConfig } from "./config.js";

validateConfig();
import { getQueueRedis } from "./lib/redis.js";
import { closeJobQueues, enqueueJob, shouldRunBull, type AppJobType } from "./lib/jobs.js";
import { logger } from "./lib/logger.js";
import { prisma } from "./lib/db/prisma.js";
import { sendEmail } from "./lib/email.js";
import { sendPushBatch } from "./lib/push.js";
import { sendNotification } from "./modules/notifications/index.js";
import { createPayoutForBooking, submitPayout, reconcilePayoutStatus } from "./lib/payout-service.js";

const storageAdapter = getStorageAdapter(config.storageDriver, {
  storagePath: config.storagePath,
  mediaPublicBaseUrl: config.mediaPublicBaseUrl
});

const paymentAdapter = getPaymentAdapter(config.paymentDriver, {
  baseOrigin: config.webOrigin,
  paydunyaMasterKey: config.paydunyaMasterKey,
  paydunyaPublicKey: config.paydunyaPublicKey,
  paydunyaPrivateKey: config.paydunyaPrivateKey,
  paydunyaToken: config.paydunyaToken,
  paydunyaEnv: config.paydunyaEnv,
  paydunyaBaseUrl: config.paydunyaBaseUrl
});

type LocalJob = {
  id: string;
  type: string;
  payloadJson: string;
  attempts: number;
};

export async function handleJob(type: AppJobType, payload: Record<string, unknown>): Promise<void> {
  switch (type) {
    case "deposit_settlement": {
      const booking = await prisma.booking.findUnique({
        where: { id: payload.bookingId as string },
        // Only release fully settled payments — "authorized" is not captured yet
        include: { payments: { where: { status: "succeeded" }, take: 1 } }
      });
      if (!booking) return;

      const payment = booking.payments[0];
      if (!payment) return;

      const existingRelease = await prisma.settlementEvent.findFirst({
        where: { paymentId: payment.id, eventType: "released" }
      });
      if (existingRelease) return;

      // Carry forward fees from the "held" event
      const heldEvent = await prisma.settlementEvent.findFirst({
        where: { paymentId: payment.id, eventType: "held" },
        select: { platformFeeXof: true, payoutAmountXof: true }
      });

      await prisma.settlementEvent.create({
        data: {
          bookingId: booking.id,
          paymentId: payment.id,
          eventType: "released",
          amountXof: payment.amountXof,
          platformFeeXof: heldEvent?.platformFeeXof ?? 0,
          payoutAmountXof: heldEvent?.payoutAmountXof ?? payment.amountXof,
          providerReference: payment.providerTxId ?? undefined
        }
      });

      if (config.merchantPayoutEnabled) {
        try {
          await createPayoutForBooking(booking.id);
        } catch (err) {
          logger.error("[worker] failed to create payout on deposit_settlement", { bookingId: booking.id, error: String(err) });
        }
      }
      return;
    }

    case "process_merchant_payout": {
      const payoutId = payload.payoutId as string;
      await submitPayout(payoutId);
      return;
    }

    case "payout_reconciliation": {
      const pendingPayouts = await prisma.merchantPayout.findMany({
        where: { status: "pending" }
      });
      for (const p of pendingPayouts) {
        await reconcilePayoutStatus(p.id);
      }

      // Atomically claim all retryable payouts to prevent duplicate processing
      // from overlapping reconciliation cycles. `updateMany` ensures that only
      // records still in "failed_retryable" are updated — a second concurrent
      // cycle will find zero records to update and exit early.
      const claimResult = await prisma.merchantPayout.updateMany({
        where: {
          status: "failed_retryable",
          attemptCount: { lt: 5 },
          OR: [
            { nextRetryTime: null },
            { nextRetryTime: { lte: new Date() } }
          ]
        },
        data: { status: "scheduled" }
      });

      if (claimResult.count === 0) return;

      // Find the just-claimed payouts and set per-payout retry metadata
      const claimedPayouts = await prisma.merchantPayout.findMany({
        where: { status: "scheduled", attemptCount: { lt: 5 } }
      });

      for (const p of claimedPayouts) {
        const nextAttempt = p.attemptCount + 1;
        const backoffMinutes = Math.pow(2, nextAttempt) * 5;
        const nextRetryTime = new Date(Date.now() + backoffMinutes * 60 * 1000);

        await prisma.merchantPayout.update({
          where: { id: p.id },
          data: {
            attemptCount: nextAttempt,
            nextRetryTime,
            status: "scheduled"
          }
        });

        await enqueueJob({
          type: "process_merchant_payout",
          payload: { payoutId: p.id },
          bookingId: p.bookingId ?? undefined
        });
      }
      return;
    }

    case "refund_reconciliation": {
      const payment = await prisma.payment.findUnique({ where: { id: payload.paymentId as string } });
      if (!payment || !payment.providerTxId) return;

      if (["authorized", "succeeded"].includes(payment.status)) {
        // Dedupe check BEFORE calling external provider to prevent duplicate refund attempts
        const existingRefund = await prisma.settlementEvent.findFirst({
          where: { paymentId: payment.id, eventType: "refunded" }
        });
        if (existingRefund) return;

        // Atomically claim the refund slot: if another worker races here, only one will win
        const originalStatus = payment.status as "authorized" | "succeeded";
        const claimed = await prisma.payment.updateMany({
          where: { id: payment.id, status: { in: ["authorized", "succeeded"] } },
          data: { status: "refunded" }
        });
        if (claimed.count === 0) return; // lost the race — another worker already refunded

        let refund: Awaited<ReturnType<typeof paymentAdapter.requestRefund>>;
        try {
          // Resolve phone number for PayDunya disbursement
          const clientPhone = config.paymentDriver === "paydunya"
            ? await prisma.booking.findUnique({
                where: { id: payment.bookingId },
                select: { client: { select: { phone: true } } }
              }).then((b) => b?.client?.phone ?? null)
            : null;

          refund = await paymentAdapter.requestRefund({
            providerRef: payment.providerTxId,
            amountXof: payment.amountXof,
            reason: "booking_cancelled",
            phone: clientPhone ?? undefined
          });
        } catch (providerErr) {
          // Roll back status so next job retry can re-attempt the external call
          await prisma.payment.update({ where: { id: payment.id }, data: { status: originalStatus } });
          throw providerErr;
        }
        await prisma.booking.update({
          where: { id: payment.bookingId },
          data: { depositPaymentStatus: "refunded" }
        });
        await prisma.settlementEvent.create({
          data: {
            bookingId: payment.bookingId,
            paymentId: payment.id,
            eventType: "refunded",
            amountXof: payment.amountXof,
            providerReference: refund.refundRef
          }
        });
      }
      return;
    }

    case "booking_reminder": {
      const booking = await prisma.booking.findUnique({
        where: { id: payload.bookingId as string },
        include: { client: true, service: true }
      });
      if (!booking || !["pending", "confirmed"].includes(booking.status)) return;

      const windowLabel = payload.window === "1h" ? "dans 1 heure" : "demain";
      await sendNotification(
        booking.clientId,
        "Rappel de réservation",
        `Votre rendez-vous pour ${booking.service.name} est ${windowLabel}.`
      ).catch((err) => logger.warn("[WORKER] push reminder failed", { bookingId: booking.id, err }));

      if (booking.client.email) {
        const { buildEmailHtml } = await import("./lib/email-html.js");
        await sendEmail({
          to: booking.client.email,
          subject: `Rappel — Votre RDV pour ${booking.service.name} ${windowLabel}`,
          text: `Bonjour,\n\nRappel : votre rendez-vous pour "${booking.service.name}" est prévu ${windowLabel}.\n\nÀ bientôt sur BeautéAvenue.`,
          html: buildEmailHtml({
            preheader: `Rappel de réservation ${windowLabel}`,
            greeting: "Bonjour,",
            bodyLines: [
              `Rappel : votre rendez-vous pour <strong>${booking.service.name}</strong> est prévu <strong>${windowLabel}</strong>.`
            ],
            ignoreNote: false,
            footerNote: "À bientôt sur BeautéAvenue."
          })
        }).catch((err) => logger.warn("[WORKER] reminder email failed", { to: booking.client.email, err }));
      }
      return;
    }

    case "new_booking_salon": {
      const booking = await prisma.booking.findUnique({
        where: { id: payload.bookingId as string },
        include: { service: true, client: { select: { fullName: true } } }
      });
      if (!booking) return;

      const salonStaff = await prisma.user.findMany({
        where: { salonId: booking.salonId, role: { in: ["salon_owner", "salon_manager"] } },
        select: { id: true, email: true }
      });
      const title = "Nouvelle réservation";
      const clientName = booking.client?.fullName ?? "Un client";
      const serviceName = booking.service.name;
      const startsLabel = new Date(booking.startsAt).toLocaleString("fr-FR", {
        weekday: "long", day: "numeric", month: "long", hour: "2-digit", minute: "2-digit"
      });
      const notifBody = `${clientName} — ${serviceName}`;
      await Promise.all(salonStaff.map((u) =>
        sendNotification(u.id, title, notifBody).catch((err) =>
          logger.warn("[WORKER] new_booking_salon notify failed", { userId: u.id, err })
        )
      ));
      const ownerEmail = salonStaff.find((u) => u.email)?.email;
      if (ownerEmail) {
        const { buildEmailHtml } = await import("./lib/email-html.js");
        await sendEmail({
          to: ownerEmail,
          subject: `Nouvelle réservation — ${serviceName}`,
          text: `Bonjour,\n\n${clientName} vient de réserver "${serviceName}" pour le ${startsLabel}.\n\nConsultez l'agenda sur votre espace pro.\n\n— L'équipe Beauté Avenue`,
          html: buildEmailHtml({
            preheader: "Nouvelle réservation",
            greeting: "Bonjour,",
            bodyLines: [
              `<strong>${clientName}</strong> vient de réserver <strong>"${serviceName}"</strong> pour le <strong>${startsLabel}</strong>.`,
              `Consultez l'agenda sur votre espace pro.`
            ],
            cta: { url: `${config.webOrigin}/pro/calendar`, label: "Voir mon agenda" },
            ignoreNote: false,
            footerNote: "— L'équipe Beauté Avenue"
          })
        }).catch((err) => logger.warn("[WORKER] new_booking_salon email failed", { to: ownerEmail, err }));
      }
      return;
    }

    case "salon_submitted_admin": {
      const adminTokens = await prisma.pushToken.findMany({
        where: { revokedAt: null, role: "platform_admin" }
      });
      const adminUsers = await prisma.user.findMany({
        where: { role: "platform_admin" },
        select: { id: true, email: true }
      });
      const salonName = payload.salonName ?? "Nouveau salon";
      const salonId = (payload.salonId as string | undefined) ?? "";
      const isResubmission = payload.resubmission === true;
      const notifTitle = isResubmission ? "Dossier mis à jour" : "Nouveau dossier à valider";
      const notifBody = isResubmission
        ? `${salonName} a fourni les informations demandées.`
        : `${salonName} attend votre validation.`;

      await Promise.all(adminUsers.map((u) =>
        prisma.notification.create({ data: { userId: u.id, title: notifTitle, body: notifBody, channel: "push" } })
          .catch(() => {})
      ));
      const tokens = adminTokens.map((t) => t.token);
      if (tokens.length > 0) {
        await sendPushBatch(
          tokens,
          { title: notifTitle, body: notifBody },
          { type: "salon_pending_review", salonId }
        ).catch((err) => logger.warn("[WORKER] salon_submitted_admin push failed", { err }));
      }
      const emailSubject = isResubmission
        ? `[Beauté Avenue] Dossier mis à jour — ${salonName}`
        : `[Beauté Avenue] Nouveau dossier à valider — ${salonName}`;
      const emailText = isResubmission
        ? `Le salon "${salonName}" a fourni les informations complémentaires demandées et attend votre validation.\n\nConnectez-vous au backoffice : /admin/salons/${salonId}`
        : `Un nouveau salon "${salonName}" a soumis son dossier et attend votre approbation.\n\nConnectez-vous au backoffice : /admin/salons/${salonId}`;
      const { buildEmailHtml } = await import("./lib/email-html.js");
      await Promise.all(
        adminUsers
          .filter((u) => u.email)
          .map((u) =>
            sendEmail({
              to: u.email!,
              subject: emailSubject,
              text: emailText,
              html: buildEmailHtml({
                preheader: isResubmission ? "Dossier mis à jour" : "Nouveau dossier à valider",
                greeting: "Bonjour,",
                bodyLines: [
                  isResubmission
                    ? `Le salon <strong>${salonName}</strong> a fourni les informations complémentaires demandées.`
                    : `Un nouveau salon <strong>${salonName}</strong> a soumis son dossier.`,
                  isResubmission ? "Il attend votre validation." : "Il attend votre approbation."
                ],
                cta: { url: `${config.webOrigin ?? "https://admin.beauteavenue.sn"}/admin/salons/${salonId}`, label: "Voir le dossier" },
                ignoreNote: false,
                footerNote: "— Beauté Avenue"
              })
            })
              .catch((err) => logger.warn("[WORKER] salon_submitted_admin email failed", { to: u.email, err }))
          )
      );
      return;
    }

    case "media_cleanup": {
      if (!payload.objectKey) return;
      logger.info("[WORKER] media_cleanup: running", { objectKey: payload.objectKey });
      await storageAdapter.delete(payload.objectKey as string);
      return;
    }

    case "media_review_notify": {
      const adminTokens = await prisma.pushToken.findMany({
        where: { revokedAt: null, role: "platform_admin" }
      });
      const tokens = adminTokens.map((t) => t.token);
      if (tokens.length > 0) {
        await sendPushBatch(
          tokens,
          { title: "Nouvelle photo à vérifier", body: "Un fichier attend votre approbation." },
          { type: "media_pending_review", mediaId: (payload.mediaId as string | undefined) ?? "", salonId: (payload.salonId as string | undefined) ?? "" }
        );
      }
      return;
    }

    case "notification_retry": {
      const notification = await prisma.notification.findUnique({
        where: { id: payload.notificationId as string }
      });
      if (!notification) return;

      await sendNotification(
        notification.userId,
        notification.title,
        notification.body
      ).catch((err) => logger.warn("[WORKER] notification_retry failed", { notificationId: notification.id, err }));
      return;
    }

    case "subscription_expiry_check": {
      if (!config.subscriptionExpiryEnabled) {
        logger.info("[WORKER] subscription expiry check disabled via config");
        return;
      }
      const now = new Date();
      const graceDurationMs = config.subscriptionGracePeriodDays * 24 * 60 * 60 * 1000;
      const { buildEmailHtml } = await import("./lib/email-html.js");

      // Step 1: active → past_due (grace starts)
      const toGrace = await prisma.subscription.findMany({
        where: { status: "active", expiresAt: { lt: now }, gracePeriodEndsAt: null },
        include: { salon: { select: { id: true, staffMembers: { where: { role: "salon_owner" }, select: { email: true }, take: 1 } } } }
      });
      for (const sub of toGrace) {
        const gracePeriodEndsAt = new Date(now.getTime() + graceDurationMs);
        await prisma.subscription.update({
          where: { id: sub.id },
          data: { status: "past_due", gracePeriodEndsAt }
          // isVisibleInMarketplace stays true during grace
        });
        const ownerEmail = sub.salon.staffMembers[0]?.email;
        if (ownerEmail) {
          await sendEmail({
            to: ownerEmail,
            subject: "Votre abonnement BeautéAvenue expire dans 3 jours",
            text: `Bonjour,\n\nVotre abonnement a expiré. Vous disposez de 3 jours (jusqu'au ${gracePeriodEndsAt.toLocaleDateString("fr-FR")}) pour renouveler avant que votre salon ne soit suspendu.\n\nRenouvelez sur https://beauteavenue.sn/pro/subscription`,
            html: buildEmailHtml({
              preheader: "Votre abonnement a expiré",
              greeting: "Bonjour,",
              bodyLines: [
                `Votre abonnement a expiré.`,
                `Vous disposez de <strong>3 jours</strong> (jusqu'au <strong>${gracePeriodEndsAt.toLocaleDateString("fr-FR")}</strong>) pour renouveler avant que votre salon ne soit suspendu.`
              ],
              cta: { url: "https://beauteavenue.sn/pro/subscription", label: "Renouveler mon abonnement" },
              ignoreNote: false,
              footerNote: "— L'équipe Beauté Avenue"
            })
          }).catch((err) => logger.warn("[WORKER] grace email failed", { to: ownerEmail, err }));
        }
      }
      if (toGrace.length > 0) {
        logger.info("[WORKER] subscription_expiry_check: grace started", { count: toGrace.length });
      }

      // Step 2: past_due → expired (grace over) — also apply any pending downgrade
      const toExpire = await prisma.subscription.findMany({
        where: { status: "past_due", gracePeriodEndsAt: { lt: now } },
        include: { salon: { select: { id: true, name: true, staffMembers: { where: { role: "salon_owner" }, select: { email: true }, take: 1 } } } }
      });
      for (const sub of toExpire) {
        const downgradedTier = sub.pendingTier ?? undefined;
        await prisma.$transaction([
          prisma.subscription.update({
            where: { id: sub.id },
            data: {
              status: "expired",
              ...(downgradedTier ? { tier: downgradedTier, pendingTier: null } : {})
            }
          }),
          prisma.salon.update({
            where: { id: sub.salonId },
            data: {
              isVisibleInMarketplace: false,
              canReceiveBookings: false,
              ...(downgradedTier ? { subscriptionTier: downgradedTier } : {})
            }
          })
        ]);
        const ownerEmail = sub.salon.staffMembers[0]?.email;
        if (ownerEmail) {
          await sendEmail({
            to: ownerEmail,
            subject: "Votre salon BeautéAvenue est suspendu",
            text: `Bonjour,\n\nVotre abonnement a expiré et votre salon est maintenant suspendu. Pour le réactiver, renouvelez votre abonnement sur https://beauteavenue.sn/pro/subscription`,
            html: buildEmailHtml({
              preheader: "Votre salon est suspendu",
              greeting: "Bonjour,",
              bodyLines: [
                `Votre abonnement a expiré et votre salon est maintenant <strong>suspendu</strong>.`,
                `Pour le réactiver, renouvelez votre abonnement.`
              ],
              cta: { url: "https://beauteavenue.sn/pro/subscription", label: "Réactiver mon abonnement" },
              ignoreNote: false,
              footerNote: "— L'équipe Beauté Avenue"
            })
          }).catch((err) => logger.warn("[WORKER] expired email failed", { to: ownerEmail, err }));
        }
      }
      if (toExpire.length > 0) {
        logger.info("[WORKER] subscription_expiry_check: expired", { count: toExpire.length });
      }

      const nextMidnight = new Date();
      nextMidnight.setUTCHours(24, 0, 0, 0);
      await enqueueJob({ type: "subscription_expiry_check", payload: {}, runAfter: nextMidnight });
      return;
    }

    case "platform_settings_cleanup": {
      const cutoff = new Date(Date.now() - 24 * 60 * 60 * 1000);
      const deleted = await prisma.platformSetting.deleteMany({
        where: {
          OR: [
            { key: { startsWith: "otp:challenge:" }, updatedAt: { lt: cutoff } },
            { key: { startsWith: "otp:ratelimit:" }, updatedAt: { lt: cutoff } }
          ]
        }
      });
      if (deleted.count > 0) {
        logger.info("[WORKER] platform_settings_cleanup: cleared ephemeral entries", { count: deleted.count });
      }
      const nextHour = new Date();
      nextHour.setHours(nextHour.getHours() + 1, 0, 0, 0);
      await enqueueJob({ type: "platform_settings_cleanup", payload: {}, runAfter: nextHour });
      return;
    }

    case "prestige_score_refresh": {
      // Single raw SQL UPDATE — scales to 100k salons without N round-trips or OOM.
      // Formula: 0.45×ratingScore + 0.25×availability + 0.15×photoScore + 0.15×premiumBonus
      // Minimum 3 reviews required before prestige score counts (prevents gaming with single review)
      const result = await prisma.$executeRaw`
        UPDATE "Salon" s SET
          "prestigeScore" = sub.score,
          "isPrestige" = (s."subscriptionTier" = 'premium' AND sub.score >= 0.3)
        FROM (
          SELECT
            s2.id,
            ROUND(CAST(
              CASE WHEN COALESCE(rc.cnt, 0) < 3 THEN 0.0 ELSE
                0.45 * ((s2."averageRating" * LN(GREATEST(COALESCE(rc.cnt, 0), 0) + 1)) / 15.0)
                + 0.25 * CASE WHEN s2."canReceiveBookings" THEN 1.0 ELSE 0.0 END
                + 0.15 * LEAST(COALESCE(gc.cnt, 0)::float / 10.0, 1.0)
                + 0.15 * CASE WHEN s2."subscriptionTier" = 'premium' THEN 1.0 ELSE 0.0 END
              END
            AS numeric), 3) AS score
          FROM "Salon" s2
          LEFT JOIN (SELECT "salonId", COUNT(*)::int AS cnt FROM "Review" GROUP BY "salonId") rc ON rc."salonId" = s2.id
          LEFT JOIN (SELECT "salonId", COUNT(*)::int AS cnt FROM "SalonGalleryImage" GROUP BY "salonId") gc ON gc."salonId" = s2.id
          WHERE s2."approvalStatus" = 'approved' AND s2."isVisibleInMarketplace" = true
        ) sub
        WHERE s.id = sub.id
      `;
      logger.info("[WORKER] prestige_score_refresh: updated", { count: result });

      const nextMidnight = new Date();
      nextMidnight.setUTCHours(24, 0, 0, 0);
      await enqueueJob({ type: "prestige_score_refresh", payload: {}, runAfter: nextMidnight });
      return;
    }

    default:
      logger.warn("[WORKER] unknown job type", { jobType: type });
      return;
  }
}

async function processMirrorJob(type: AppJobType, payload: Record<string, string>) {
  const payloadJson = JSON.stringify(payload);
  const mirror = await prisma.job.findFirst({
    where: { type, payloadJson, status: "pending" },
    orderBy: { createdAt: "asc" }
  });

  if (mirror) {
    await prisma.job.update({ where: { id: mirror.id }, data: { status: "running", lockedAt: new Date() } });
  }

  try {
    await handleJob(type, payload);
    if (mirror) {
      await prisma.job.update({ where: { id: mirror.id }, data: { status: "completed", lockedAt: null } });
    }
  } catch (err) {
    if (mirror) {
      const attempts = mirror.attempts + 1;
      await prisma.job.update({
        where: { id: mirror.id },
        data: {
          status: attempts >= 3 ? "failed" : "pending",
          attempts,
          lastError: String(err),
          runAfter: new Date(Date.now() + attempts * 60_000),
          lockedAt: null
        }
      });
    }
    throw err;
  }
}

async function reclaimStuckJobs() {
  const staleThreshold = new Date(Date.now() - 10 * 60 * 1000);
  const result = await prisma.job.updateMany({
    where: { status: "running", lockedAt: { lt: staleThreshold } },
    data: { status: "pending", lockedAt: null }
  });
  if (result.count > 0) {
    logger.warn("[WORKER] reclaimed stuck jobs", { count: result.count });
  }
}

async function pollJobs() {
  await reclaimStuckJobs();
  const now = new Date();
  const jobs = await prisma.job.findMany({
    where: { status: "pending", runAfter: { lte: now } },
    take: config.workerBatchSize,
    orderBy: { createdAt: "asc" }
  });

  for (const job of jobs) {
    const claimed = await prisma.job.updateMany({
      where: { id: job.id, status: "pending", runAfter: { lte: now } },
      data: { status: "running", lockedAt: new Date() }
    });
    if (claimed.count === 0) continue;

    try {
      await handleJob(job.type as AppJobType, JSON.parse(job.payloadJson) as Record<string, string>);
      await prisma.job.update({ where: { id: job.id }, data: { status: "completed", lockedAt: null } });
    } catch (err) {
      const attempts = job.attempts + 1;
      await prisma.job.update({
        where: { id: job.id },
        data: {
          status: attempts >= 3 ? "failed" : "pending",
          attempts,
          lastError: String(err),
          runAfter: new Date(Date.now() + attempts * 60_000),
          lockedAt: null
        }
      });
      logger.error("[WORKER] job failed", { jobId: job.id, jobType: job.type, err: String(err) });
    }
  }
}

async function ensureRecurringSeedJobs() {
  const pending = await prisma.job.findMany({
    where: {
      type: { in: ["prestige_score_refresh", "subscription_expiry_check", "platform_settings_cleanup", "payout_reconciliation"] },
      status: { in: ["pending", "running"] }
    },
    select: { type: true }
  });
  const existing = new Set(pending.map((p) => p.type));

  if (!existing.has("prestige_score_refresh")) {
    const nextMidnight = new Date();
    nextMidnight.setUTCHours(24, 0, 0, 0);
    await enqueueJob({ type: "prestige_score_refresh", payload: {}, runAfter: nextMidnight });
  }

  if (config.subscriptionExpiryEnabled && !existing.has("subscription_expiry_check")) {
    const nextMidnight = new Date();
    nextMidnight.setUTCHours(24, 0, 0, 0);
    await enqueueJob({ type: "subscription_expiry_check", payload: {}, runAfter: nextMidnight });
  }

  if (!existing.has("platform_settings_cleanup")) {
    const nextHour = new Date();
    nextHour.setHours(nextHour.getHours() + 1, 0, 0, 0);
    await enqueueJob({ type: "platform_settings_cleanup", payload: {}, runAfter: nextHour });
  }

  if (!existing.has("payout_reconciliation")) {
    const nextHour = new Date();
    nextHour.setHours(nextHour.getHours() + 1, 0, 0, 0);
    await enqueueJob({ type: "payout_reconciliation", payload: {}, runAfter: nextHour });
  }
}

async function startBullWorkers() {
  const connection = await getQueueRedis();
  if (!connection) {
    logger.error("[WORKER] BullMQ mode requested but Redis is unavailable");
    process.exit(1);
  }

  const workers: Worker[] = [];
  const createWorker = (queueName: string, concurrency: number) => {
    const worker = new Worker(
      queueName,
      async (job: BullJob<Record<string, string>>) => {
        await processMirrorJob(job.name as AppJobType, job.data);
      },
      { connection, concurrency }
    );
    worker.on("failed", (job, err) => {
      logger.error("[WORKER] BullMQ job failed", { queue: queueName, jobId: job?.id, name: job?.name, err: String(err) });
    });
    workers.push(worker);
  };

  createWorker("payments", config.queueConcurrencyPayments);
  createWorker("notifications", config.queueConcurrencyNotifications);
  createWorker("maintenance", config.queueConcurrencyMaintenance);

  const shutdown = async (signal: string) => {
    logger.info("[WORKER] shutting down", { signal });
    await Promise.all(workers.map((w) => w.close()));
    await closeJobQueues();
    await prisma.$disconnect();
    process.exit(0);
  };

  process.on("SIGTERM", () => void shutdown("SIGTERM"));
  process.on("SIGINT", () => void shutdown("SIGINT"));

  logger.info("Worker started", {
    mode: config.workerDriver,
    queues: ["payments", "notifications", "maintenance"],
    concurrency: {
      payments: config.queueConcurrencyPayments,
      notifications: config.queueConcurrencyNotifications,
      maintenance: config.queueConcurrencyMaintenance
    }
  });
}

async function main() {
  await ensureRecurringSeedJobs();

  if (shouldRunBull()) {
    await startBullWorkers();
    return;
  }

  logger.info("Worker started", { mode: "db", pollIntervalMs: config.workerPollIntervalMs });
  setInterval(() => {
    void pollJobs();
  }, config.workerPollIntervalMs);
}

void main().catch((err) => {
  logger.error("[WORKER] startup failed", { err: String(err) });
  process.exit(1);
});
