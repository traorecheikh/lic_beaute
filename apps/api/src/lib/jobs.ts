import { createHash } from "node:crypto";

import { Queue } from "bullmq";

import { config } from "../config.js";
import { prisma } from "./db/prisma.js";
import { logger } from "./logger.js";
import { getQueueRedis } from "./redis.js";

export type AppJobType =
  | "deposit_settlement"
  | "deposit_resolution_scan"
  | "deposit_resolution_finalize"
  | "refund_reconciliation"
  | "booking_reminder"
  | "new_booking_salon"
  | "salon_submitted_admin"
  | "media_cleanup"
  | "media_review_notify"
  | "notification_retry"
  | "subscription_expiry_check"
  | "platform_settings_cleanup"
  | "prestige_score_refresh"
  | "process_merchant_payout"
  | "payout_reconciliation";

export type AppQueueName = "payments" | "notifications" | "maintenance";

const JOB_QUEUE: Record<AppJobType, AppQueueName> = {
  deposit_settlement: "payments",
  deposit_resolution_scan: "maintenance",
  deposit_resolution_finalize: "maintenance",
  refund_reconciliation: "payments",
  booking_reminder: "notifications",
  new_booking_salon: "notifications",
  salon_submitted_admin: "notifications",
  media_cleanup: "maintenance",
  media_review_notify: "notifications",
  notification_retry: "notifications",
  subscription_expiry_check: "maintenance",
  platform_settings_cleanup: "maintenance",
  prestige_score_refresh: "maintenance",
  process_merchant_payout: "payments",
  payout_reconciliation: "payments"
};

type JobDbClient = {
  job: {
    findFirst: (args: { where: { type: string; payloadJson: string; status: string }; select: { id: true } }) => Promise<{ id: string } | null>;
    updateMany: (args: { where: { bookingId?: string; type?: string; status?: string; payloadJson?: { contains: string } }; data: { status: string } }) => Promise<{ count: number }>;
    create: (args: {
      data: {
        queue: string;
        type: string;
        payloadJson: string;
        bookingId?: string | null;
        status: string;
        runAfter: Date;
      };
    }) => Promise<unknown>;
  };
};

const queues: Partial<Record<AppQueueName, Queue>> = {};

function stableStringify(value: unknown): string {
  if (value === null || typeof value !== "object") return JSON.stringify(value);
  if (Array.isArray(value)) return `[${value.map((v) => stableStringify(v)).join(",")}]`;
  const obj = value as Record<string, unknown>;
  const keys = Object.keys(obj).sort();
  return `{${keys.map((k) => `${JSON.stringify(k)}:${stableStringify(obj[k])}`).join(",")}}`;
}

function makeJobId(type: AppJobType, payload: unknown, runAfter: Date): string {
  const raw = `${type}:${stableStringify(payload)}:${runAfter.toISOString()}`;
  return createHash("sha1").update(raw).digest("hex");
}

async function getQueue(name: AppQueueName): Promise<Queue | null> {
  if (queues[name]) return queues[name]!;
  const connection = await getQueueRedis();
  if (!connection) return null;
  queues[name] = new Queue(name, { connection });
  return queues[name]!;
}

export function shouldRunBull() {
  return (config.workerDriver === "bull" || config.workerDriver === "hybrid") && !!config.redisUrl;
}

export async function closeJobQueues() {
  await Promise.all(Object.values(queues).map((q) => q?.close()));
}

export async function enqueueJob(input: {
  type: AppJobType;
  payload: Record<string, unknown>;
  bookingId?: string;
  runAfter?: Date;
  status?: string;
  attempts?: number;
  jobId?: string;
  dbClient?: JobDbClient;
}) {
  const db = input.dbClient ?? prisma;
  const runAfter = input.runAfter ?? new Date();
  const queueName = JOB_QUEUE[input.type];
  const payloadJson = stableStringify(input.payload);

  const existingPending = await db.job.findFirst({
    where: { type: input.type, payloadJson, status: "pending" },
    select: { id: true }
  });
  if (!existingPending) {
    try {
      await db.job.create({
        data: {
          queue: queueName,
          type: input.type,
          payloadJson,
          bookingId: input.bookingId ?? null,
          status: input.status ?? "pending",
          runAfter
        }
      });
    } catch (err: any) {
      // P2002 = unique constraint violation — another worker already created this job
      if (err?.code !== 'P2002') throw err;
    }
  }

  if (!shouldRunBull()) return;
  const queue = await getQueue(queueName);
  if (!queue) {
    logger.warn("[JOBS] Bull queue unavailable, mirrored only in DB", { type: input.type, queue: queueName });
    return;
  }

  const delay = Math.max(0, runAfter.getTime() - Date.now());
  await queue.add(input.type, input.payload, {
    jobId: input.jobId ?? makeJobId(input.type, input.payload, runAfter),
    delay,
    attempts: input.attempts ?? 3,
    backoff: { type: "exponential", delay: 60_000 },
    removeOnComplete: 500,
    removeOnFail: 2000
  });
}

export function queueForJob(type: AppJobType): AppQueueName {
  return JOB_QUEUE[type];
}
