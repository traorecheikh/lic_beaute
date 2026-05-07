import { getPaymentAdapter, getStorageAdapter, getR2Adapter } from "./adapters/index.js";
import type { R2StorageAdapter } from "./adapters/storage/r2.js";
import { config } from "./config.js";
import { logger } from "./lib/logger.js";
import { prisma } from "./lib/db/prisma.js";
import { sendPushBatch } from "./lib/push.js";
import { sendNotification } from "./modules/notifications/index.js";

const storageAdapter = getStorageAdapter(config.storageDriver, {
  storagePath: config.storagePath,
  r2AccountId: config.r2AccountId,
  r2AccessKeyId: config.r2AccessKeyId,
  r2SecretAccessKey: config.r2SecretAccessKey,
  r2Bucket: config.r2Bucket,
  mediaPublicBaseUrl: config.mediaPublicBaseUrl
});

const paymentAdapter = getPaymentAdapter(config.paymentDriver, {
  intechApiKey: config.intechApiKey,
  intechApiSecret: config.intechApiSecret,
  intechEnv: config.intechEnv,
  intechBaseUrl: config.intechBaseUrl,
  intechCallbackHmacEnabled: config.intechCallbackHmacEnabled,
  intechHmacSecretKey: config.intechHmacSecretKey,
  intechHmacMaxAgeMs: config.intechHmacMaxAgeMs,
  intechRequestTimeoutMs: config.intechRequestTimeoutMs,
  paytechApiKey: config.paytechApiKey,
  paytechApiSecret: config.paytechApiSecret,
  paytechEnv: config.paytechEnv,
  baseOrigin: config.webOrigin
});

type Job = {
  id: string;
  type: string;
  payloadJson: string;
  attempts: number;
};

async function handleJob(job: Job): Promise<void> {
  const payload = JSON.parse(job.payloadJson) as Record<string, string>;

  switch (job.type) {
    case "deposit_settlement": {
      const booking = await prisma.booking.findUnique({
        where: { id: payload.bookingId },
        include: { payments: { where: { status: { in: ["succeeded", "authorized"] } }, take: 1 } }
      });
      if (!booking) return;

      const payment = booking.payments[0];
      if (!payment) return;

      const existingRelease = await prisma.settlementEvent.findFirst({
        where: { paymentId: payment.id, eventType: "released" }
      });
      if (existingRelease) return;

      await prisma.settlementEvent.create({
        data: {
          bookingId: booking.id,
          paymentId: payment.id,
          eventType: "released",
          amountXof: payment.amountXof,
          providerReference: payment.providerTxId ?? undefined
        }
      });
      break;
    }

    case "refund_reconciliation": {
      const payment = await prisma.payment.findUnique({ where: { id: payload.paymentId } });
      if (!payment || !payment.providerTxId) return;

      if (["authorized", "succeeded"].includes(payment.status)) {
        const refund = await paymentAdapter.requestRefund({
          providerRef: payment.providerTxId,
          amountXof: payment.amountXof,
          reason: "booking_cancelled"
        });
        await prisma.payment.update({ where: { id: payment.id }, data: { status: "refunded" } });
        await prisma.booking.update({
          where: { id: payment.bookingId },
          data: { depositPaymentStatus: "refunded" }
        });
        const existingRefund = await prisma.settlementEvent.findFirst({
          where: { paymentId: payment.id, eventType: "refunded" }
        });
        if (existingRefund) return;
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
      break;
    }

    case "booking_reminder": {
      const booking = await prisma.booking.findUnique({
        where: { id: payload.bookingId },
        include: { client: true, service: true }
      });
      if (!booking || !["pending", "confirmed"].includes(booking.status)) return;

      await sendNotification(
        booking.clientId,
        "Rappel de réservation",
        `Votre rendez-vous pour ${booking.service.name} est demain.`
      );
      break;
    }

    case "media_cleanup": {
      logger.info("[WORKER] media_cleanup: running", { objectKey: payload.objectKey });
      await storageAdapter.delete(payload.objectKey);
      break;
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
          { type: "media_pending_review", mediaId: payload.mediaId ?? "", salonId: payload.salonId ?? "" }
        );
      }
      break;
    }

    case "notification_retry": {
      const notification = await prisma.notification.findUnique({ where: { id: payload.notificationId } });
      if (!notification) return;
      logger.info("[WORKER] notification_retry: noop push driver", { notificationId: notification.id });
      break;
    }

    case "subscription_expiry_check": {
      const expired = await prisma.subscription.findMany({
        where: { status: "active", expiresAt: { lt: new Date() } }
      });
      for (const sub of expired) {
        await prisma.subscription.update({ where: { id: sub.id }, data: { status: "expired" } });
        await prisma.salon.update({
          where: { id: sub.salonId },
          data: { subscriptionTier: "standard" }
        });
      }
      if (expired.length > 0) {
        logger.info("[WORKER] subscription_expiry_check: expired", { count: expired.length });
      }
      const nextMidnight = new Date();
      nextMidnight.setUTCHours(24, 0, 0, 0);
      await prisma.job.create({
        data: { queue: "default", type: "subscription_expiry_check", payloadJson: "{}", runAfter: nextMidnight }
      });
      break;
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
      await prisma.job.create({
        data: { queue: "default", type: "platform_settings_cleanup", payloadJson: "{}", runAfter: nextHour }
      });
      break;
    }

    case "prestige_score_refresh": {
      const salons = await prisma.salon.findMany({
        where: { approvalStatus: "approved", isVisibleInMarketplace: true },
        select: {
          id: true,
          averageRating: true,
          subscriptionTier: true,
          canReceiveBookings: true,
          _count: { select: { reviews: true, gallery: true } }
        }
      });

      const THRESHOLD = 0.3;
      const updates = salons.map((s) => {
        const ratingScore = (s.averageRating * Math.log(s._count.reviews + 1)) / 15;
        const availScore = s.canReceiveBookings ? 1 : 0;
        const photoScore = Math.min(s._count.gallery, 10) / 10;
        const premiumBonus = s.subscriptionTier === "premium" ? 1 : 0;

        const score =
          0.45 * ratingScore +
          0.25 * availScore +
          0.15 * photoScore +
          0.15 * premiumBonus;

        return prisma.salon.update({
          where: { id: s.id },
          data: {
            prestigeScore: Math.round(score * 1000) / 1000,
            isPrestige: s.subscriptionTier === "premium" && score >= THRESHOLD
          }
        });
      });

      await prisma.$transaction(updates);
      logger.info("[WORKER] prestige_score_refresh: updated", { count: salons.length });

      const nextMidnight = new Date();
      nextMidnight.setUTCHours(24, 0, 0, 0);
      await prisma.job.create({
        data: { queue: "default", type: "prestige_score_refresh", payloadJson: "{}", runAfter: nextMidnight }
      });
      break;
    }

    default:
      logger.warn("[WORKER] unknown job type", { jobType: job.type });
  }
}

async function pollJobs() {
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
    if (claimed.count === 0) {
      continue;
    }

    try {
      await handleJob(job);
      await prisma.job.update({
        where: { id: job.id },
        data: { status: "completed", lockedAt: null }
      });
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

async function ensureNightlyPrestigeJob() {
  const existing = await prisma.job.findFirst({
    where: { type: "prestige_score_refresh", status: "pending" }
  });
  if (!existing) {
    const nextMidnight = new Date();
    nextMidnight.setUTCHours(24, 0, 0, 0);
    await prisma.job.create({
      data: { queue: "default", type: "prestige_score_refresh", payloadJson: "{}", runAfter: nextMidnight }
    });
    logger.info("[WORKER] Scheduled nightly prestige_score_refresh", { runAfter: nextMidnight });
  }
}

async function ensureNightlyExpiryJob() {
  const existing = await prisma.job.findFirst({
    where: { type: "subscription_expiry_check", status: "pending" }
  });
  if (!existing) {
    const nextMidnight = new Date();
    nextMidnight.setUTCHours(24, 0, 0, 0);
    await prisma.job.create({
      data: { queue: "default", type: "subscription_expiry_check", payloadJson: "{}", runAfter: nextMidnight }
    });
    logger.info("[WORKER] Scheduled nightly subscription_expiry_check", { runAfter: nextMidnight });
  }
}

async function ensureCleanupJob() {
  const existing = await prisma.job.findFirst({
    where: { type: "platform_settings_cleanup", status: "pending" }
  });
  if (!existing) {
    const nextHour = new Date();
    nextHour.setHours(nextHour.getHours() + 1, 0, 0, 0);
    await prisma.job.create({
      data: { queue: "default", type: "platform_settings_cleanup", payloadJson: "{}", runAfter: nextHour }
    });
    logger.info("[WORKER] Scheduled platform_settings_cleanup", { runAfter: nextHour });
  }
}

logger.info("Worker started", { pollIntervalMs: config.workerPollIntervalMs });

void ensureNightlyPrestigeJob();
void ensureNightlyExpiryJob();
void ensureCleanupJob();

setInterval(() => {
  void pollJobs();
}, config.workerPollIntervalMs);
