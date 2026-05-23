import type { PaymentAdapter } from "./payment/index.js";
import { IntechAdapter } from "./payment/intech.js";
import { MockPaymentAdapter } from "./payment/mock.js";
import { PayDunyaAdapter } from "./payment/paydunya.js";
import type { OtpAdapter } from "./otp/index.js";
import { AfricasTalkingOtpAdapter, NoopOtpAdapter } from "./otp/index.js";
import type { StorageAdapter } from "./storage/index.js";
import { LocalStorageAdapter, NoopStorageAdapter } from "./storage/index.js";
import { R2StorageAdapter } from "./storage/r2.js";

export { type PaymentAdapter } from "./payment/index.js";
export { type OtpAdapter, NoopOtpAdapter } from "./otp/index.js";
export { type StorageAdapter, LocalStorageAdapter, NoopStorageAdapter } from "./storage/index.js";
export { R2StorageAdapter } from "./storage/r2.js";

export function createOtpAdapter(
  driver: string,
  config: {
    atApiKey?: string;
    atUsername?: string;
    atSenderId?: string;
  }
): OtpAdapter {
  switch (driver) {
    case "at":
    case "africastalking": {
      if (!config.atApiKey || !config.atUsername) {
        throw new Error("AT_API_KEY and AT_USERNAME required for Africa's Talking OTP driver");
      }
      return new AfricasTalkingOtpAdapter(config.atApiKey, config.atUsername, config.atSenderId);
    }
    default:
      return new NoopOtpAdapter();
  }
}

// Singleton storage adapter instance — shared across controllers and worker.
let _storageAdapter: StorageAdapter | null = null;

export function getStorageAdapter(
  driver: string,
  config: {
    storagePath?: string;
    r2AccountId?: string;
    r2AccessKeyId?: string;
    r2SecretAccessKey?: string;
    r2Bucket?: string;
    mediaPublicBaseUrl?: string;
  }
): StorageAdapter {
  if (_storageAdapter) return _storageAdapter;

  switch (driver) {
    case "local":
      _storageAdapter = new LocalStorageAdapter(
        config.storagePath ?? ".data/uploads",
        `${(config.mediaPublicBaseUrl ?? "").replace(/\/$/, "")}/static`
      );
      break;
    case "r2":
      _storageAdapter = new R2StorageAdapter(
        config.r2AccountId ?? "",
        config.r2AccessKeyId ?? "",
        config.r2SecretAccessKey ?? "",
        config.r2Bucket ?? "beauteavenu",
        config.mediaPublicBaseUrl ?? "https://media.beauteavenu.com"
      );
      break;
    default:
      _storageAdapter = new NoopStorageAdapter();
      break;
  }

  return _storageAdapter;
}

export function createStorageAdapter(
  driver: string,
  config: {
    storagePath?: string;
    r2AccountId?: string;
    r2AccessKeyId?: string;
    r2SecretAccessKey?: string;
    r2Bucket?: string;
    mediaPublicBaseUrl?: string;
  }
): StorageAdapter {
  return getStorageAdapter(driver, config);
}

export function getR2Adapter(): R2StorageAdapter | null {
  if (_storageAdapter instanceof R2StorageAdapter) return _storageAdapter;
  return null;
}

// Singleton payment adapter instance — shared across controllers and worker.
let _paymentAdapter: PaymentAdapter | null = null;

export function getPaymentAdapter(
  driver: string,
  config: {
    baseOrigin: string;
    paydunyaMasterKey?: string;
    paydunyaPrivateKey?: string;
    paydunyaToken?: string;
    paydunyaEnv?: string;
    paydunyaBaseUrl?: string;
  }
): PaymentAdapter {
  if (_paymentAdapter) return _paymentAdapter;
  _paymentAdapter = createPaymentAdapter(driver, config);
  return _paymentAdapter;
}

export function createPaymentAdapter(
  driver: string,
  config: {
    baseOrigin: string;
    paydunyaMasterKey?: string;
    paydunyaPrivateKey?: string;
    paydunyaToken?: string;
    paydunyaEnv?: string;
    paydunyaBaseUrl?: string;
  }
): PaymentAdapter {
  switch (driver) {
    case "mock":
      return new MockPaymentAdapter();
    case "paydunya": {
      if (!config.paydunyaMasterKey || !config.paydunyaPrivateKey || !config.paydunyaToken) {
        throw new Error("PAYDUNYA_MASTER_KEY, PAYDUNYA_PRIVATE_KEY, and PAYDUNYA_TOKEN required for paydunya driver");
      }
      return new PayDunyaAdapter(
        config.paydunyaMasterKey,
        config.paydunyaPrivateKey,
        config.paydunyaToken,
        config.baseOrigin,
        (config.paydunyaEnv ?? "sandbox") as "sandbox" | "production",
        config.paydunyaBaseUrl ?? "https://app.paydunya.com"
      );
    }
    default:
      return new MockPaymentAdapter();
  }
}
