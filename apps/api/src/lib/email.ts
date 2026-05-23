import { config } from "../config.js";
import { logger } from "./logger.js";

export type EmailMessage = {
  to: string;
  subject: string;
  text: string;
  html?: string;
};

async function writeEmailAudit(
  message: EmailMessage,
  status: "sent" | "failed" | "skipped",
  errorMessage?: string
) {
  try {
    const { prisma } = await import("./db/prisma.js");
    await prisma.emailAudit.create({
      data: {
        to: message.to,
        subject: message.subject,
        driver: config.emailDriver,
        status,
        errorMessage: errorMessage ?? null
      }
    });
  } catch (err) {
    logger.warn("[EMAIL:audit] write failed", {
      to: message.to,
      subject: message.subject,
      err: String(err)
    });
  }
}

export async function sendEmail(message: EmailMessage): Promise<void> {
  switch (config.emailDriver) {
    case "noop":
      logger.info("[EMAIL:noop] would send email", { to: message.to, subject: message.subject });
      await writeEmailAudit(message, "skipped");
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
        await writeEmailAudit(message, "failed", error.message);
        throw new Error(`Resend error: ${error.message}`);
      }
      logger.info("[EMAIL:resend] sent", { to: message.to, subject: message.subject });
      await writeEmailAudit(message, "sent");
      return;
    }

    case "brevo": {
      const payload: Record<string, unknown> = {
        sender: { email: config.emailFrom },
        to: [{ email: message.to }],
        subject: message.subject,
        textContent: message.text,
      };
      if (message.html) {
        payload.htmlContent = message.html;
      }
      const res = await fetch("https://api.brevo.com/v3/smtp/email", {
        method: "POST",
        headers: {
          "api-key": config.brevoApiKey,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      });
      if (!res.ok) {
        const body = await res.text().catch(() => "");
        logger.error("[EMAIL:brevo] send failed", {
          to: message.to,
          status: res.status,
          body,
        });
        await writeEmailAudit(message, "failed", `Brevo API ${res.status}: ${body}`);
        throw new Error(`Brevo API error: ${res.status} ${body}`);
      }
      logger.info("[EMAIL:brevo] sent", { to: message.to, subject: message.subject });
      await writeEmailAudit(message, "sent");
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
      await writeEmailAudit(message, "sent");
      return;
    }

    default:
      logger.warn("[EMAIL] unknown driver, falling back to noop", { driver: config.emailDriver });
      await writeEmailAudit(message, "skipped", "unknown_driver");
  }
}
