import { createPaymentAdapter } from "./adapters/index.js";
import { config } from "./config.js";
import { logger } from "./lib/logger.js";
import { prisma } from "./lib/prisma.js";
import { sendNotification } from "./modules/notifications.js";

const paymentAdapter = createPaymentAdapter(config.paymentDriver, {
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
      if (!booking) return;

      await sendNotification(
        booking.clientId,
        "Rappel de réservation",
        `Votre rendez-vous pour ${booking.service.name} est demain.`
      );
      break;
    }

    case "media_cleanup": {
      if (config.storageDriver !== "noop") {
        logger.info("[WORKER] media_cleanup: driver not noop, implement delete", { objectKey: payload.objectKey });
      } else {
        logger.info("[WORKER] media_cleanup: noop driver, skipping actual delete", { objectKey: payload.objectKey });
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

      // Re-enqueue for next midnight UTC
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
  const jobs = await prisma.job.findMany({
    where: { status: "pending", runAfter: { lte: new Date() } },
    take: config.workerBatchSize,
    orderBy: { createdAt: "asc" }
  });

  for (const job of jobs) {
    await prisma.job.update({ where: { id: job.id }, data: { status: "running", lockedAt: new Date() } });

    try {
      await handleJob(job);
      await prisma.job.update({ where: { id: job.id }, data: { status: "completed" } });
    } catch (err) {
      const attempts = job.attempts + 1;
      await prisma.job.update({
        where: { id: job.id },
        data: {
          status: attempts >= 3 ? "failed" : "pending",
          attempts,
          lastError: String(err),
          runAfter: new Date(Date.now() + attempts * 60_000)
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

logger.info("Worker started", { pollIntervalMs: config.workerPollIntervalMs });

void ensureNightlyPrestigeJob();

setInterval(() => {
  void pollJobs();
}, config.workerPollIntervalMs);
