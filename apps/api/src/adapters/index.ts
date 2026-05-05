import type { PaymentAdapter } from "./payment.js";
import { MockPaymentAdapter } from "./payment-mock.js";
import { PayTechAdapter } from "./payment-paytech.js";

export { type PaymentAdapter } from "./payment.js";
export { type OtpAdapter, NoopOtpAdapter } from "./otp.js";

export function createPaymentAdapter(
  driver: string,
  config: { paytechApiKey?: string; paytechApiSecret?: string; paytechEnv?: "prod" | "test"; baseOrigin: string }
): PaymentAdapter {
  switch (driver) {
    case "mock":
      return new MockPaymentAdapter();
    case "paytech": {
      if (!config.paytechApiKey || !config.paytechApiSecret) {
        throw new Error("PAYTECH_API_KEY and PAYTECH_API_SECRET required for paytech driver");
      }
      return new PayTechAdapter(config.paytechApiKey, config.paytechApiSecret, config.paytechEnv ?? "test", config.baseOrigin);
    }
    default:
      return new MockPaymentAdapter();
  }
}
