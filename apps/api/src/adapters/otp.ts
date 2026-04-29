import { logger } from "../lib/logger.js";

export interface OtpAdapter {
  send(phone: string, code: string): Promise<void>;
  verify(phone: string, code: string): Promise<boolean>;
}

export class NoopOtpAdapter implements OtpAdapter {
  async send(phone: string, code: string): Promise<void> {
    logger.info("[OTP-NOOP] code generated", { phone, code });
  }

  async verify(_phone: string, _code: string): Promise<boolean> {
    return true;
  }
}
