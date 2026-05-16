import { config } from "../config.js";
import { logger } from "./logger.js";

export type EmailMessage = {
  to: string;
  subject: string;
  text: string;
};

export async function sendEmail(message: EmailMessage): Promise<void> {
  if (config.emailDriver === "noop") {
    logger.info("[EMAIL:noop] would send email", { to: message.to, subject: message.subject });
    return;
  }

  // Future: smtp / resend / sendgrid driver goes here.
  logger.warn("[EMAIL] unknown driver, falling back to noop", { driver: config.emailDriver });
}
