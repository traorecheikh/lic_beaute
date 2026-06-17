import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

const mocks = vi.hoisted(() => {
  const adapter = {
    createDisbursementInvoice: vi.fn(),
    submitDisbursement: vi.fn(),
    checkDisbursementStatus: vi.fn(),
    getApproximateBalance: vi.fn(),
    resolveWithdrawMode: vi.fn((pm: string) => pm === "wave_senegal" ? "wave-senegal" : "orange-money-senegal")
  };

  const tx = {
    merchantPayout: {
      create: vi.fn(),
      update: vi.fn(),
      updateMany: vi.fn(),
      findUnique: vi.fn()
    },
    ledgerEntry: {
      create: vi.fn()
    },
    auditLog: {
      create: vi.fn()
    }
  };

  const prisma = {
    booking: {
      findUnique: vi.fn()
    },
    merchantPayout: {
      findUnique: vi.fn(),
      create: vi.fn(),
      update: vi.fn(),
      updateMany: vi.fn(),
      findMany: vi.fn()
    },
    platformSetting: {
      findUnique: vi.fn()
    },
    ledgerEntry: {
      create: vi.fn(),
      findMany: vi.fn()
    },
    $transaction: vi.fn(async (fn: (txArg: typeof tx) => Promise<any>) => fn(tx))
  };

  return { adapter, tx, prisma };
});

vi.mock("../adapters/index.js", () => ({
  getPaymentAdapter: () => mocks.adapter
}));

vi.mock("./db/prisma.js", () => ({
  prisma: mocks.prisma
}));

vi.mock("./jobs.js", () => ({
  enqueueJob: vi.fn()
}));

import {
  checkPayoutEligibility,
  createPayoutForBooking,
  submitPayout,
  reconcilePayoutStatus
} from "./payout-service.js";

describe("PayoutService", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  describe("checkPayoutEligibility", () => {
    it("returns ineligible if booking not found", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValueOnce(null);
      const res = await checkPayoutEligibility("b1");
      expect(res.eligible).toBe(false);
      expect(res.reason).toBe("booking_not_found");
    });

    it("returns ineligible if booking is not completed", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1",
        status: "confirmed",
        payments: [{ status: "succeeded" }]
      });
      const res = await checkPayoutEligibility("b1");
      expect(res.eligible).toBe(false);
      expect(res.reason).toBe("booking_not_completed");
    });

    it("returns ineligible if payment is missing", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1",
        status: "completed",
        payments: []
      });
      const res = await checkPayoutEligibility("b1");
      expect(res.eligible).toBe(false);
      expect(res.reason).toBe("payment_missing");
    });

    it("returns ineligible if salon payout details are missing", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1",
        status: "completed",
        payments: [{ status: "succeeded" }],
        salon: { payoutMethod: null, payoutPhone: null }
      });
      const res = await checkPayoutEligibility("b1");
      expect(res.eligible).toBe(false);
      expect(res.reason).toBe("salon_payout_details_missing");
    });

    it("returns ineligible if salon is unverified", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1",
        status: "completed",
        payments: [{ status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "unverified" }
      });
      const res = await checkPayoutEligibility("b1");
      expect(res.eligible).toBe(false);
      expect(res.reason).toBe("salon_payout_details_unverified");
    });

    it("returns ineligible if salon is suspended", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1",
        status: "completed",
        payments: [{ status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: true }
      });
      const res = await checkPayoutEligibility("b1");
      expect(res.eligible).toBe(false);
      expect(res.reason).toBe("salon_suspended");
    });

    it("returns eligible if all checks pass", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1",
        status: "completed",
        depositAmountXof: 10000,
        payments: [{ id: "p1", status: "succeeded", amountXof: 10000 }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
        isUnderFraudReview: false,
        refundRequested: false,
        disputeOpen: false
      });
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce(null);

      const res = await checkPayoutEligibility("b1");
      expect(res.eligible).toBe(true);
    });
  });

  describe("createPayoutForBooking", () => {
    it("calculates percentage commission correctly with rounding rules", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1",
        status: "completed",
        depositAmountXof: 10500, // 5% of 10500 is 525
        payments: [{ id: "p1", status: "succeeded", amountXof: 10500 }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
        isUnderFraudReview: false,
        refundRequested: false,
        disputeOpen: false
      });
      mocks.prisma.merchantPayout.findUnique.mockResolvedValue(null);
      mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce({ value: "5" }); // 5%

      mocks.tx.merchantPayout.create.mockResolvedValueOnce({ id: "pay_1" });
      mocks.tx.merchantPayout.update.mockResolvedValueOnce({
        id: "pay_1",
        salonId: "s1",
        bookingId: "b1",
        paymentId: "p1",
        payoutMethod: "wave_senegal",
        beneficiaryPhoneSnapshot: "+221771234567",
        grossAmount: 10500,
        platformCommissionAmount: 525,
        merchantPayoutAmount: 9975,
        status: "scheduled",
        disburseId: "merchant_payout_pay_1"
      });

      const payout = await createPayoutForBooking("b1");
      expect(payout.platformCommissionAmount).toBe(525);
      expect(payout.merchantPayoutAmount).toBe(9975);
      expect(mocks.tx.ledgerEntry.create).toHaveBeenCalledTimes(3);
    });
  });

  describe("financial calculations", () => {
    it("calculates zero commission correctly", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1",
        status: "completed",
        depositAmountXof: 10000,
        payments: [{ id: "p1", status: "succeeded", amountXof: 10000 }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
        isUnderFraudReview: false,
        refundRequested: false,
        disputeOpen: false
      });
      mocks.prisma.merchantPayout.findUnique.mockResolvedValue(null);
      mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce({ value: "0" });

      mocks.tx.merchantPayout.create.mockResolvedValueOnce({ id: "pay_1" });
      mocks.tx.merchantPayout.update.mockResolvedValueOnce({
        id: "pay_1", salonId: "s1", bookingId: "b1", paymentId: "p1",
        payoutMethod: "wave_senegal", beneficiaryPhoneSnapshot: "+221771234567",
        grossAmount: 10000, platformCommissionAmount: 0, merchantPayoutAmount: 10000,
        status: "scheduled", disburseId: "merchant_payout_pay_1"
      });

      const payout = await createPayoutForBooking("b1");
      expect(payout.platformCommissionAmount).toBe(0);
      expect(payout.merchantPayoutAmount).toBe(10000);
    });

    it("rejects negative merchant payout amount", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1",
        status: "completed",
        depositAmountXof: 100,
        payments: [{ id: "p1", status: "succeeded", amountXof: 100 }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
        isUnderFraudReview: false,
        refundRequested: false,
        disputeOpen: false
      });
      mocks.prisma.merchantPayout.findUnique.mockResolvedValue(null);
      mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce({ value: "200" }); // 200% commission

      await expect(createPayoutForBooking("b1")).rejects.toThrow(/positive/);
    });

    it("handles rounding boundary at .5 correctly", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1",
        status: "completed",
        depositAmountXof: 199, // 5% of 199 = 9.95, Math.round = 10
        payments: [{ id: "p1", status: "succeeded", amountXof: 199 }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
        isUnderFraudReview: false, refundRequested: false, disputeOpen: false
      });
      mocks.prisma.merchantPayout.findUnique.mockResolvedValue(null);
      mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce({ value: "5" });

      mocks.tx.merchantPayout.create.mockResolvedValueOnce({ id: "pay_1" });
      mocks.tx.merchantPayout.update.mockResolvedValueOnce({
        id: "pay_1", salonId: "s1", bookingId: "b1", paymentId: "p1",
        payoutMethod: "wave_senegal", beneficiaryPhoneSnapshot: "+221771234567",
        grossAmount: 199, platformCommissionAmount: 10, merchantPayoutAmount: 189,
        status: "scheduled", disburseId: "merchant_payout_pay_1"
      });

      const payout = await createPayoutForBooking("b1");
      expect(payout.platformCommissionAmount).toBe(10); // Math.round(9.95) = 10
      expect(payout.merchantPayoutAmount).toBe(189);
    });

    it("handles maximum valid amount (2^31-1 XOF)", async () => {
      const maxAmount = 2147483647;
      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1",
        status: "completed",
        depositAmountXof: maxAmount,
        payments: [{ id: "p1", status: "succeeded", amountXof: maxAmount }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
        isUnderFraudReview: false, refundRequested: false, disputeOpen: false
      });
      mocks.prisma.merchantPayout.findUnique.mockResolvedValue(null);
      mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce({ value: "5" });

      // 5% of 2147483647 = 107374182.35 → Math.round = 107374182
      const expectedCommission = 107374182;
      const expectedMerchantPayout = maxAmount - expectedCommission; // 2040109465
      mocks.tx.merchantPayout.create.mockResolvedValueOnce({ id: "pay_1" });
      mocks.tx.merchantPayout.update.mockResolvedValueOnce({
        id: "pay_1", salonId: "s1", bookingId: "b1", paymentId: "p1",
        payoutMethod: "wave_senegal", beneficiaryPhoneSnapshot: "+221771234567",
        grossAmount: maxAmount, platformCommissionAmount: expectedCommission,
        merchantPayoutAmount: expectedMerchantPayout,
        status: "scheduled", disburseId: "merchant_payout_pay_1"
      });

      const payout = await createPayoutForBooking("b1");
      expect(payout.platformCommissionAmount).toBe(107374182);
      expect(payout.merchantPayoutAmount).toBe(2040109465);
    });
  });

  describe("submitPayout", () => {
    it("sends disburse requests successfully and updates status to succeeded", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1",
        bookingId: "b1",
        paymentId: "p1",
        salonId: "s1",
        status: "scheduled",
        version: 1,
        merchantPayoutAmount: 9975,
        beneficiaryPhoneSnapshot: "+221771234567",
        payoutMethod: "wave_senegal",
        disburseId: "merchant_payout_pay_1"
      });

      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1",
        status: "completed",
        depositAmountXof: 10500,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified" }
      });

      mocks.prisma.merchantPayout.updateMany.mockResolvedValueOnce({ count: 1 });

      mocks.adapter.getApproximateBalance.mockResolvedValueOnce({ balance: 20000, currency: "XOF" });
      mocks.adapter.createDisbursementInvoice.mockResolvedValueOnce({ disburseToken: "tok_123" });
      mocks.adapter.submitDisbursement.mockResolvedValueOnce({ status: "success", transactionId: "tx_abc", providerRef: "tx_abc" });

      await submitPayout("pay_1");

      expect(mocks.adapter.createDisbursementInvoice).toHaveBeenCalledWith(expect.objectContaining({
        phone: "+221771234567",
        amountXof: 9975
      }));
      expect(mocks.adapter.submitDisbursement).toHaveBeenCalledWith({
        disburseToken: "tok_123",
        disburseId: "merchant_payout_pay_1"
      });
      expect(mocks.prisma.merchantPayout.update).toHaveBeenCalledWith(expect.objectContaining({
        where: { id: "pay_1" },
        data: expect.objectContaining({ status: "succeeded" })
      }));
    });

    it("returns early if payout already succeeded", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", status: "succeeded", version: 1
      });
      await submitPayout("pay_1");
      expect(mocks.prisma.merchantPayout.updateMany).not.toHaveBeenCalled();
    });

    it("returns early if payout is pending or cancelled", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", status: "cancelled", version: 1
      });
      await submitPayout("pay_1");
      expect(mocks.prisma.merchantPayout.updateMany).not.toHaveBeenCalled();
    });

    it("detects race condition when another worker claims the same payout", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", bookingId: "b1", paymentId: "p1", salonId: "s1",
        status: "scheduled", version: 1, merchantPayoutAmount: 5000,
        beneficiaryPhoneSnapshot: "+221771234567", payoutMethod: "wave_senegal",
        disburseId: "merchant_payout_pay_1"
      });

      mocks.prisma.merchantPayout.updateMany.mockResolvedValueOnce({ count: 0 });

      await expect(submitPayout("pay_1")).rejects.toThrow(/race condition/);
    });

    it("uses existing disburseToken on retry and calls check-status first", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", bookingId: "b1", paymentId: "p1", salonId: "s1",
        status: "failed_retryable", version: 1, merchantPayoutAmount: 5000,
        beneficiaryPhoneSnapshot: "+221771234567", payoutMethod: "wave_senegal",
        disburseId: "merchant_payout_pay_1",
        disburseToken: "tok_existing"
      });

      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1", status: "completed", depositAmountXof: 10000,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified" }
      });

      mocks.prisma.merchantPayout.updateMany.mockResolvedValueOnce({ count: 1 });
      mocks.adapter.getApproximateBalance.mockResolvedValueOnce({ balance: 20000, currency: "XOF" });

      // check-status returns failed, so we retry with existing token
      mocks.adapter.checkDisbursementStatus.mockResolvedValueOnce({ status: "failed" });
      mocks.adapter.submitDisbursement.mockResolvedValueOnce({ status: "success", transactionId: "tx_retry" });

      await submitPayout("pay_1");

      expect(mocks.adapter.checkDisbursementStatus).toHaveBeenCalledWith({
        disburseToken: "tok_existing"
      });
      expect(mocks.adapter.createDisbursementInvoice).not.toHaveBeenCalled();
      expect(mocks.adapter.submitDisbursement).toHaveBeenCalledWith({
        disburseToken: "tok_existing",
        disburseId: "merchant_payout_pay_1"
      });
    });

    it("resolves from check-status success and skips resubmission", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", bookingId: "b1", paymentId: "p1", salonId: "s1",
        status: "failed_retryable", version: 1, merchantPayoutAmount: 5000,
        beneficiaryPhoneSnapshot: "+221771234567", payoutMethod: "wave_senegal",
        disburseId: "merchant_payout_pay_1",
        disburseToken: "tok_existing",
        transactionId: null
      });

      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1", status: "completed", depositAmountXof: 10000,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified" }
      });

      mocks.prisma.merchantPayout.updateMany.mockResolvedValueOnce({ count: 1 });
      mocks.adapter.getApproximateBalance.mockResolvedValueOnce({ balance: 20000, currency: "XOF" });

      // check-status reveals the payout already succeeded
      mocks.adapter.checkDisbursementStatus.mockResolvedValueOnce({
        status: "success", transactionId: "tx_already_done", providerDisburseTxId: "pd_tx_456"
      });

      await submitPayout("pay_1");

      expect(mocks.adapter.createDisbursementInvoice).not.toHaveBeenCalled();
      expect(mocks.adapter.submitDisbursement).not.toHaveBeenCalled();
      expect(mocks.prisma.merchantPayout.update).toHaveBeenCalledWith(expect.objectContaining({
        where: { id: "pay_1" },
        data: expect.objectContaining({ status: "succeeded" })
      }));
    });

    it("resolves from check-status pending and skips resubmission", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", bookingId: "b1", paymentId: "p1", salonId: "s1",
        status: "failed_retryable", version: 1, merchantPayoutAmount: 5000,
        beneficiaryPhoneSnapshot: "+221771234567", payoutMethod: "wave_senegal",
        disburseId: "merchant_payout_pay_1",
        disburseToken: "tok_existing"
      });

      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1", status: "completed", depositAmountXof: 10000,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified" }
      });

      mocks.prisma.merchantPayout.updateMany.mockResolvedValueOnce({ count: 1 });
      mocks.adapter.getApproximateBalance.mockResolvedValueOnce({ balance: 20000, currency: "XOF" });

      mocks.adapter.checkDisbursementStatus.mockResolvedValueOnce({ status: "pending" });

      await submitPayout("pay_1");

      expect(mocks.adapter.submitDisbursement).not.toHaveBeenCalled();
      expect(mocks.prisma.merchantPayout.update).toHaveBeenCalledWith(expect.objectContaining({
        where: { id: "pay_1" },
        data: expect.objectContaining({ status: "pending" })
      }));
    });

    it("handles low approximate balance by setting to manual_review", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", bookingId: "b1", paymentId: "p1", salonId: "s1",
        status: "scheduled", version: 1, merchantPayoutAmount: 50000,
        beneficiaryPhoneSnapshot: "+221771234567", payoutMethod: "wave_senegal",
        disburseId: "merchant_payout_pay_1"
      });

      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1", status: "completed", depositAmountXof: 100000,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified" }
      });

      mocks.prisma.merchantPayout.updateMany.mockResolvedValueOnce({ count: 1 });
      mocks.adapter.getApproximateBalance.mockResolvedValueOnce({ balance: 30000, currency: "XOF" });

      await submitPayout("pay_1");

      expect(mocks.prisma.merchantPayout.update).toHaveBeenCalledWith(expect.objectContaining({
        where: { id: "pay_1" },
        data: expect.objectContaining({ status: "manual_review" })
      }));
    });

    it("handles pending submission from provider", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", bookingId: "b1", paymentId: "p1", salonId: "s1",
        status: "scheduled", version: 1, merchantPayoutAmount: 5000,
        beneficiaryPhoneSnapshot: "+221771234567", payoutMethod: "wave_senegal",
        disburseId: "merchant_payout_pay_1"
      });

      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1", status: "completed", depositAmountXof: 10000,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified" }
      });

      mocks.prisma.merchantPayout.updateMany.mockResolvedValueOnce({ count: 1 });
      mocks.adapter.getApproximateBalance.mockResolvedValueOnce({ balance: 20000, currency: "XOF" });
      mocks.adapter.createDisbursementInvoice.mockResolvedValueOnce({ disburseToken: "tok_pending" });
      mocks.adapter.submitDisbursement.mockResolvedValueOnce({ status: "pending", transactionId: "tx_pending" });

      await submitPayout("pay_1");

      expect(mocks.prisma.merchantPayout.update).toHaveBeenCalledWith(expect.objectContaining({
        where: { id: "pay_1" },
        data: expect.objectContaining({ status: "pending" })
      }));
    });

    it("handles failed submission from provider", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", bookingId: "b1", paymentId: "p1", salonId: "s1",
        status: "scheduled", version: 1, merchantPayoutAmount: 5000,
        beneficiaryPhoneSnapshot: "+221771234567", payoutMethod: "wave_senegal",
        disburseId: "merchant_payout_pay_1"
      });

      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1", status: "completed", depositAmountXof: 10000,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified" }
      });

      mocks.prisma.merchantPayout.updateMany.mockResolvedValueOnce({ count: 1 });
      mocks.adapter.getApproximateBalance.mockResolvedValueOnce({ balance: 20000, currency: "XOF" });
      mocks.adapter.createDisbursementInvoice.mockResolvedValueOnce({ disburseToken: "tok_fail" });
      mocks.adapter.submitDisbursement.mockResolvedValueOnce({ status: "failed", responseText: "Insufficient balance" });

      await submitPayout("pay_1");

      expect(mocks.prisma.merchantPayout.update).toHaveBeenCalledWith(expect.objectContaining({
        where: { id: "pay_1" },
        data: expect.objectContaining({ status: "failed_retryable" })
      }));
    });

    it("handles createDisbursementInvoice exception with retryable error", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", bookingId: "b1", paymentId: "p1", salonId: "s1",
        status: "scheduled", version: 1, merchantPayoutAmount: 5000,
        beneficiaryPhoneSnapshot: "+221771234567", payoutMethod: "wave_senegal",
        disburseId: "merchant_payout_pay_1"
      });

      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1", status: "completed", depositAmountXof: 10000,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified" }
      });

      mocks.prisma.merchantPayout.updateMany.mockResolvedValueOnce({ count: 1 });
      mocks.adapter.getApproximateBalance.mockResolvedValueOnce({ balance: 20000, currency: "XOF" });
      mocks.adapter.createDisbursementInvoice.mockRejectedValueOnce(new Error("PayDunya timeout"));

      await submitPayout("pay_1");

      expect(mocks.prisma.merchantPayout.update).toHaveBeenCalledWith(expect.objectContaining({
        where: { id: "pay_1" },
        data: expect.objectContaining({ status: "failed_retryable" })
      }));
    });

    it("handles createDisbursementInvoice exception with terminal error", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", bookingId: "b1", paymentId: "p1", salonId: "s1",
        status: "scheduled", version: 1, merchantPayoutAmount: 5000,
        beneficiaryPhoneSnapshot: "+221771234567", payoutMethod: "wave_senegal",
        disburseId: "merchant_payout_pay_1"
      });

      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1", status: "completed", depositAmountXof: 10000,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified" }
      });

      mocks.prisma.merchantPayout.updateMany.mockResolvedValueOnce({ count: 1 });
      mocks.adapter.getApproximateBalance.mockResolvedValueOnce({ balance: 20000, currency: "XOF" });
      mocks.adapter.createDisbursementInvoice.mockRejectedValueOnce(
        new Error("Numéro de téléphone bénéficiaire invalide")
      );

      await submitPayout("pay_1");

      expect(mocks.prisma.merchantPayout.update).toHaveBeenCalledWith(expect.objectContaining({
        where: { id: "pay_1" },
        data: expect.objectContaining({ status: "failed_terminal" })
      }));
    });

    it("submits payout with orange_money_senegal method", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", bookingId: "b1", paymentId: "p1", salonId: "s1",
        status: "scheduled", version: 1, merchantPayoutAmount: 5000,
        beneficiaryPhoneSnapshot: "+221771234567", payoutMethod: "orange_money_senegal",
        disburseId: "merchant_payout_pay_1"
      });

      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1", status: "completed", depositAmountXof: 10000,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "orange_money_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified" }
      });

      mocks.prisma.merchantPayout.updateMany.mockResolvedValueOnce({ count: 1 });
      mocks.adapter.getApproximateBalance.mockResolvedValueOnce({ balance: 20000, currency: "XOF" });
      mocks.adapter.createDisbursementInvoice.mockResolvedValueOnce({ disburseToken: "tok_om" });
      mocks.adapter.submitDisbursement.mockResolvedValueOnce({ status: "success", transactionId: "tx_om" });

      await submitPayout("pay_1");

      expect(mocks.adapter.resolveWithdrawMode).toHaveBeenCalledWith("orange_money_senegal");
      expect(mocks.adapter.submitDisbursement).toHaveBeenCalled();
    });
  });

  describe("reconcilePayoutStatus", () => {
    it("returns early if payout has no disburseToken", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", disburseToken: null
      });
      await reconcilePayoutStatus("pay_1");
      expect(mocks.adapter.checkDisbursementStatus).not.toHaveBeenCalled();
    });

    it("returns early if payout not found", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce(null);
      await reconcilePayoutStatus("pay_1");
      expect(mocks.adapter.checkDisbursementStatus).not.toHaveBeenCalled();
    });

    it("updates status to succeeded when check-status returns success", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", salonId: "s1", bookingId: "b1", paymentId: "p1",
        merchantPayoutAmount: 5000, status: "created",
        disburseToken: "tok_123", transactionId: null
      });
      mocks.adapter.checkDisbursementStatus.mockResolvedValueOnce({
        status: "success", transactionId: "tx_recon", providerDisburseTxId: "pd_recon"
      });

      await reconcilePayoutStatus("pay_1");

      expect(mocks.prisma.merchantPayout.update).toHaveBeenCalledWith(expect.objectContaining({
        where: { id: "pay_1" },
        data: expect.objectContaining({ status: "succeeded" })
      }));
    });

    it("does not downgrade succeeded payout when check-status returns failed", async () => {
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce({
        id: "pay_1", salonId: "s1", bookingId: "b1", paymentId: "p1",
        merchantPayoutAmount: 5000, status: "succeeded",
        disburseToken: "tok_123", completedAt: new Date()
      });
      mocks.adapter.checkDisbursementStatus.mockResolvedValueOnce({
        status: "failed", responseText: "Transaction not found"
      });

      await reconcilePayoutStatus("pay_1");

      // Should NOT update to failed since status is already succeeded
      expect(mocks.prisma.merchantPayout.update).not.toHaveBeenCalled();
    });
  });

  describe("eligibility edge cases", () => {
    it("returns ineligible if booking is under fraud review", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValue({
        id: "b1", status: "completed", depositAmountXof: 5000,
        payments: [{ status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
        isUnderFraudReview: true, refundRequested: false, disputeOpen: false
      });
      const res = await checkPayoutEligibility("b1");
      expect(res.eligible).toBe(false);
      expect(res.reason).toBe("booking_under_fraud_review");
    });

    it("returns ineligible if refund requested", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValue({
        id: "b1", status: "completed",
        payments: [{ status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
        isUnderFraudReview: false, refundRequested: true, disputeOpen: false
      });
      const res = await checkPayoutEligibility("b1");
      expect(res.eligible).toBe(false);
      expect(res.reason).toBe("refund_request_open");
    });

    it("returns ineligible if dispute is open", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValue({
        id: "b1", status: "completed",
        payments: [{ status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
        isUnderFraudReview: false, refundRequested: false, disputeOpen: true
      });
      const res = await checkPayoutEligibility("b1");
      expect(res.eligible).toBe(false);
      expect(res.reason).toBe("dispute_open");
    });

    it("returns ineligible if payout already exists (non-cancelled)", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValue({
        id: "b1", status: "completed", depositAmountXof: 5000,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
        isUnderFraudReview: false, refundRequested: false, disputeOpen: false
      });
      mocks.prisma.merchantPayout.findUnique.mockResolvedValue({
        id: "existing", status: "scheduled", bookingId: "b1"
      });

      const res = await checkPayoutEligibility("b1");
      expect(res.eligible).toBe(false);
      expect(res.reason).toBe("payout_already_exists");
    });

    it("allows duplicate payout if previous was cancelled", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValue({
        id: "b1", status: "completed", depositAmountXof: 5000,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
        isUnderFraudReview: false, refundRequested: false, disputeOpen: false
      });
      mocks.prisma.merchantPayout.findUnique.mockResolvedValue({
        id: "existing", status: "cancelled", bookingId: "b1"
      });

      const res = await checkPayoutEligibility("b1");
      expect(res.eligible).toBe(true);
    });

    it("returns ineligible if deposit amount is zero", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValue({
        id: "b1", status: "completed", depositAmountXof: 0,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
        isUnderFraudReview: false, refundRequested: false, disputeOpen: false
      });
      mocks.prisma.merchantPayout.findUnique.mockResolvedValue(null);

      const res = await checkPayoutEligibility("b1");
      expect(res.eligible).toBe(false);
      expect(res.reason).toBe("payout_amount_zero_or_negative");
    });
  });

  describe("createPayoutForBooking edge cases", () => {
    it("returns existing payout if one exists (non-cancelled)", async () => {
      const existingPayout = { id: "existing", status: "scheduled", bookingId: "b1", merchantPayoutAmount: 5000 };
      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1", status: "completed", depositAmountXof: 10000,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "verified", isSuspended: false },
        isUnderFraudReview: false, refundRequested: false, disputeOpen: false
      });
      // merchantPayout.findUnique is called by checkPayoutEligibility AND createPayoutForBooking
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce(existingPayout);
      mocks.prisma.merchantPayout.findUnique.mockResolvedValueOnce(existingPayout);

      const result = await createPayoutForBooking("b1");
      expect(result).toEqual(existingPayout);
      expect(mocks.prisma.$transaction).not.toHaveBeenCalled();
    });

    it("creates blocked payout when not eligible unless forced", async () => {
      mocks.prisma.booking.findUnique.mockResolvedValueOnce({
        id: "b1", status: "completed", depositAmountXof: 10000,
        payments: [{ id: "p1", status: "succeeded" }],
        salon: { payoutMethod: "wave_senegal", payoutPhone: "+221771234567", payoutVerificationStatus: "unverified", isSuspended: false },
        isUnderFraudReview: false, refundRequested: false, disputeOpen: false
      });
      mocks.prisma.merchantPayout.findUnique.mockResolvedValue(null);
      mocks.prisma.platformSetting.findUnique.mockResolvedValueOnce({ value: "5" });

      mocks.tx.merchantPayout.create.mockResolvedValueOnce({ id: "pay_1" });
      mocks.tx.merchantPayout.update.mockResolvedValueOnce({
        id: "pay_1", status: "blocked", disburseId: "merchant_payout_pay_1"
      });

      const payout = await createPayoutForBooking("b1");
      expect(payout.status).toBe("blocked");
    });
  });
});
