import { Job as BullJob, Worker } from "bullmq";

import { getPaymentAdapter, getStorageAdapter } from "./adapters/index.js";
import { config, validateConfig } from "./config.js";

validateConfig();
import { getQueueRedis } from "./lib/redis.js";
import { closeJobQueues, enqueueJob, shouldRunBull, type AppJobType } from "./lib/jobs.js";
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
  intechBaseUrl: config.intechBaseUrl,
  intechCallbackHmacEnabled: config.intechCallbackHmacEnabled,
  intechHmacSecretKey: config.intechHmacSecretKey,
  intechHmacMaxAgeMs: config.intechHmacMaxAgeMs,
  intechRequestTimeoutMs: config.intechRequestTimeoutMs,
  baseOrigin: config.webOrigin
});

type LocalJob = {
  id: string;
  type: string;
  payloadJson: string;
  attempts: number;
};

async function handleJob(type: AppJobType, payload: Record<string, string>): Promise<void> {
  switch (type) {
    case "deposit_settlement": {
      const booking = await prisma.booking.findUnique({
        where: { id: payload.bookingId },
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

      await prisma.settlementEvent.create({
        data: {
          bookingId: booking.id,
          paymentId: payment.id,
          eventType: "released",
          amountXof: payment.amountXof,
          providerReference: payment.providerTxId ?? undefined
        }
      });
      return;
    }

    case "refund_reconciliation": {
      const payment = await prisma.payment.findUnique({ where: { id: payload.paymentId } });
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
          refund = await paymentAdapter.requestRefund({
            providerRef: payment.providerTxId,
            amountXof: payment.amountXof,
            reason: "booking_cancelled"
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
        where: { id: payload.bookingId },
        include: { client: true, service: true }
      });
      if (!booking || !["pending", "confirmed"].includes(booking.status)) return;

      await sendNotification(
        booking.clientId,
        "Rappel de réservation",
        `Votre rendez-vous pour ${booking.service.name} est demain.`
      );
      return;
    }

    case "media_cleanup": {
      if (!payload.objectKey) return;
      logger.info("[WORKER] media_cleanup: running", { objectKey: payload.objectKey });
      await storageAdapter.delete(payload.objectKey);
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
          { type: "media_pending_review", mediaId: payload.mediaId ?? "", salonId: payload.salonId ?? "" }
        );
      }
      return;
    }

    case "notification_retry": {
      const notification = await prisma.notification.findUnique({ where: { id: payload.notificationId } });
      if (!notification) return;
      logger.info("[WORKER] notification_retry: noop push driver", { notificationId: notification.id });
      return;
    }

    case "subscription_expiry_check": {
      const expired = await prisma.subscription.findMany({
        where: { status: "active", expiresAt: { lt: new Date() } }
      });
      for (const sub of expired) {
        await prisma.$transaction([
          prisma.subscription.update({ where: { id: sub.id }, data: { status: "expired" } }),
          prisma.salon.update({
            where: { id: sub.salonId },
            data: { subscriptionTier: "standard", isVisibleInMarketplace: false, canReceiveBookings: false }
          })
        ]);
      }
      if (expired.length > 0) {
        logger.info("[WORKER] subscription_expiry_check: expired", { count: expired.length });
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
      type: { in: ["prestige_score_refresh", "subscription_expiry_check", "platform_settings_cleanup"] },
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

  if (!existing.has("subscription_expiry_check")) {
    const nextMidnight = new Date();
    nextMidnight.setUTCHours(24, 0, 0, 0);
    await enqueueJob({ type: "subscription_expiry_check", payload: {}, runAfter: nextMidnight });
  }

  if (!existing.has("platform_settings_cleanup")) {
    const nextHour = new Date();
    nextHour.setHours(nextHour.getHours() + 1, 0, 0, 0);
    await enqueueJob({ type: "platform_settings_cleanup", payload: {}, runAfter: nextHour });
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
