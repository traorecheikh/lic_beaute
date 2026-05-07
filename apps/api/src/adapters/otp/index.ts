import { logger } from "../../lib/logger.js";

export interface OtpAdapter {
  send(phone: string, code: string): Promise<void>;
  verify(phone: string, code: string): Promise<boolean>;
}

export class NoopOtpAdapter implements OtpAdapter {
  async send(phone: string, code: string): Promise<void> {
    const maskedPhone = phone.length > 4 ? `***${phone.slice(-4)}` : "***";
    logger.info("[OTP-NOOP] code generated", { destination: maskedPhone, code, codeLength: code.length });
  }

  async verify(_phone: string, _code: string): Promise<boolean> {
    return true;
  }
}

// Africa's Talking SMS adapter — used when OTP_DRIVER=at
// Required env vars: AT_API_KEY, AT_USERNAME, AT_SENDER_ID (optional)
export class AfricasTalkingOtpAdapter implements OtpAdapter {
  constructor(
    private apiKey: string,
    private username: string,
    private senderId?: string
  ) {}

  async send(phone: string, code: string): Promise<void> {
    const message = `Votre code BeautéAvenue : ${code}. Valable 5 minutes. Ne le partagez pas.`;
    const body = new URLSearchParams({
      username: this.username,
      to: phone,
      message
    });
    if (this.senderId) body.set("from", this.senderId);

    const resp = await fetch("https://api.africastalking.com/version1/messaging", {
      method: "POST",
      headers: {
        apiKey: this.apiKey,
        Accept: "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body
    });

    if (!resp.ok) {
      const text = await resp.text().catch(() => "");
      logger.error("[OTP-AT] SMS send failed", { phone: phone.slice(-4), status: resp.status, body: text });
      throw new Error(`Africa's Talking SMS failed (${resp.status})`);
    }

    const maskedPhone = phone.length > 4 ? `***${phone.slice(-4)}` : "***";
    logger.info("[OTP-AT] SMS sent", { destination: maskedPhone });
  }

  async verify(_phone: string, _code: string): Promise<boolean> {
    // Verification is handled in-app via stored code hash (auth.ts).
    // This adapter only delivers; it does not verify.
    return true;
  }
}
