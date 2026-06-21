import { prisma } from "./src/lib/db/prisma.ts";
import { enqueueJob } from "./src/lib/jobs.ts";
import { logger } from "./src/lib/logger.ts";

async function main() {
  logger.info("Creating new payout_reconciliation job...");

  const job = await enqueueJob({
    type: "payout_reconciliation",
    payload: {},
    bookingId: null,
    runAfter: new Date()
  });

  logger.info(`Created job: ${job.id}`);
  await prisma.$disconnect();
}

main().catch((err) => {
  logger.error("Failed to create payout reconciliation job", { error: err });
  process.exit(1);
});