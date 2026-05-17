import { config } from "../config.js";
import { logger } from "./logger.js";

export type EmailMessage = {
  to: string;
  subject: string;
  text: string;
  html?: string;
};

export async function sendEmail(message: EmailMessage): Promise<void> {
  switch (config.emailDriver) {
    case "noop":
      logger.info("[EMAIL:noop] would send email", { to: message.to, subject: message.subject });
      return;

    case "resend": {
      const { Resend } = await import("resend");
      const resend = new Resend(config.resendApiKey);
      const { error } = await resend.emails.send({
        from: config.emailFrom,
        to: message.to,
        subject: message.subject,
        text: message.text,
        html: message.html,
      });
      if (error) {
        logger.error("[EMAIL:resend] send failed", { to: message.to, error });
        throw new Error(`Resend error: ${error.message}`);
      }
      logger.info("[EMAIL:resend] sent", { to: message.to, subject: message.subject });
      return;
    }

    case "smtp": {
      const nodemailer = await import("nodemailer");
      const transporter = nodemailer.createTransport({
        host: config.smtpHost,
        port: config.smtpPort,
        secure: config.smtpPort === 465,
        auth: { user: config.smtpUser, pass: config.smtpPass },
      });
      await transporter.sendMail({
        from: config.emailFrom,
        to: message.to,
        subject: message.subject,
        text: message.text,
        html: message.html,
      });
      logger.info("[EMAIL:smtp] sent", { to: message.to, subject: message.subject });
      return;
    }

    default:
      logger.warn("[EMAIL] unknown driver, falling back to noop", { driver: config.emailDriver });
  }
}
