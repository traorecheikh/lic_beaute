import { prisma } from "./src/lib/db/prisma.ts";
import { reconcilePayoutStatus } from "./src/lib/payout-service.ts";
import { logger } from "./src/lib/logger.ts";

async function main() {
  logger.info("Starting manual payout reconciliation...");

  const pendingPayouts = await prisma.merchantPayout.findMany({
    where: { status: "pending" }
  });

  logger.info(`Found ${pendingPayouts.length} pending payouts to reconcile`);

  for (const p of pendingPayouts) {
    logger.info(`Reconciling payout ${p.id} (amount: ${p.amountXof}, status: ${p.status})`);
    await reconcilePayoutStatus(p.id);
  }

  const failedRetryable = await prisma.merchantPayout.findMany({
    where: {
      status: "failed_retryable",
      attemptCount: { lt: 5 },
      OR: [
        { nextRetryTime: null },
        { nextRetryTime: { lte: new Date() } }
      ]
    }
  });

  logger.info(`Found ${failedRetryable.length} failed_retryable payouts to retry`);

  for (const p of failedRetryable) {
    logger.info(`Claiming payout ${p.id} for retry (attempt ${p.attemptCount})`);
    await prisma.merchantPayout.update({
      where: { id: p.id },
      data: {
        status: "scheduled",
        attemptCount: p.attemptCount + 1,
        nextRetryTime: new Date(Date.now() + Math.pow(2, p.attemptCount + 1) * 5 * 60 * 1000)
      }
    });

    await prisma.merchantPayout.update({
      where: { id: p.id },
      data: {
        status: "scheduled"
      }
    });
  }

  logger.info("Manual payout reconciliation complete");
  await prisma.$disconnect();
}

main().catch((err) => {
  logger.error("Manual payout reconciliation failed", { error: err });
  process.exit(1);
});