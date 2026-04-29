import type { PaymentAdapter } from "./payment.js";
import { MockPaymentAdapter } from "./payment-mock.js";

export { type PaymentAdapter } from "./payment.js";
export { type OtpAdapter, NoopOtpAdapter } from "./otp.js";

export function createPaymentAdapter(driver: string): PaymentAdapter {
  switch (driver) {
    case "mock":
      return new MockPaymentAdapter();
    case "wave":
      throw new Error("Wave adapter not yet implemented — set PAYMENT_DRIVER=mock");
    case "orange_money":
      throw new Error("Orange Money adapter not yet implemented — set PAYMENT_DRIVER=mock");
    default:
      return new MockPaymentAdapter();
  }
}
