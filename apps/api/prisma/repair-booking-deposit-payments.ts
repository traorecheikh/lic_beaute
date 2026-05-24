import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../src/generated/prisma/client.ts";
import dotenv from "dotenv";
import path from "node:path";
import { fileURLToPath } from "node:url";

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.resolve(scriptDir, "../../../.env") });

const adapter = new PrismaPg(
  process.env.DATABASE_URL ??
    "postgresql://postgres:postgres@localhost:5434/beaute_avenue?schema=public",
  { schema: "public" }
);
const prisma = new PrismaClient({ adapter });

const dryRun = process.argv.includes("--dry-run");

async function main() {
  const candidates = await prisma.booking.findMany({
    where: {
      source: "marketplace",
      depositAmountXof: { gt: 0 },
      payments: { none: {} }
    },
    select: {
      id: true,
      depositAmountXof: true,
      status: true,
      depositPaymentStatus: true,
      paymentProvider: true
    }
  });

  console.log(`Found ${candidates.length} booking(s) with missing payment row.`);

  if (dryRun || candidates.length === 0) {
    for (const b of candidates) {
      console.log(
        `[DRY-RUN] booking=${b.id} status=${b.status} deposit=${b.depositAmountXof} depositPaymentStatus=${b.depositPaymentStatus}`
      );
    }
    return;
  }

  for (const b of candidates) {
    const paymentStatus =
      b.depositPaymentStatus === "authorized" ||
      b.depositPaymentStatus === "succeeded" ||
      b.depositPaymentStatus === "failed" ||
      b.depositPaymentStatus === "refunded"
        ? b.depositPaymentStatus
        : "pending";
    await prisma.payment.create({
      data: {
        bookingId: b.id,
        provider: b.paymentProvider ?? "paydunya",
        status: paymentStatus,
        amountXof: b.depositAmountXof,
        idempotencyKey: `booking-${b.id}-deposit-repair`
      }
    });
    console.log(`Repaired booking ${b.id} with status=${paymentStatus}`);
  }

  console.log("Repair complete.");
}

main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
