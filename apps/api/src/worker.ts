import { createPaymentAdapter } from "./adapters/index.js";
import { config } from "./config.js";
import { logger } from "./lib/logger.js";
import { prisma } from "./lib/prisma.js";
import { sendNotification } from "./modules/notifications.js";

const paymentAdapter = createPaymentAdapter(config.paymentDriver);

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

logger.info("Worker started", { pollIntervalMs: config.workerPollIntervalMs });

setInterval(() => {
  void pollJobs();
}, config.workerPollIntervalMs);
