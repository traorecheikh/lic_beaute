import { prisma } from "./src/lib/db/prisma.ts";
import { enqueueJob } from "./src/lib/jobs.ts";
import { logger } from "./src/lib/logger.ts";

async function main() {
  logger.info("Mirroring payout_reconciliation jobs to Redis...");

  const pendingJobs = await prisma.job.findMany({
    where: {
      type: "payout_reconciliation",
      status: "pending"
    },
    orderBy: {
      createdAt: "asc"
    }
  });

  logger.info(`Found ${pendingJobs.length} pending payout_reconciliation jobs`);

  for (const job of pendingJobs) {
    logger.info(`Mirroring job ${job.id} to Redis`);
    try {
      await enqueueJob({
        type: "payout_reconciliation",
        payload: {},
        bookingId: null,
        runAfter: new Date(job.runAfter),
        status: "pending"
      });
      logger.info(`Successfully mirrored job ${job.id}`);
    } catch (err) {
      logger.error(`Failed to mirror job ${job.id}`, { error: err });
    }
  }

  logger.info("Mirroring complete");
  await prisma.$disconnect();
}

main().catch((err) => {
  logger.error("Failed to mirror payout reconciliation jobs", { error: err });
  process.exit(1);
});