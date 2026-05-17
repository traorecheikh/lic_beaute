import { describe, expect, it, vi } from "vitest";

vi.mock("../config.js", () => ({
  config: { emailDriver: "noop" }
}));

import { logger } from "./logger.js";
import { sendEmail } from "./email.js";

describe("sendEmail", () => {
  it("logs noop delivery", async () => {
    const spy = vi.spyOn(logger, "info").mockImplementation(() => undefined);
    await sendEmail({ to: "a@x.com", subject: "Hi", text: "Body" });
    expect(spy).toHaveBeenCalledWith("[EMAIL:noop] would send email", {
      to: "a@x.com",
      subject: "Hi"
    });
    spy.mockRestore();
  });

  it("warns on unknown driver", async () => {
    vi.resetModules();
    vi.doMock("../config.js", () => ({ config: { emailDriver: "smtp" } }));
    const loggerModule = await import("./logger.js");
    const { sendEmail: sendEmailDynamic } = await import("./email.js");
    const warnSpy = vi.spyOn(loggerModule.logger, "warn").mockImplementation(() => undefined);

    await sendEmailDynamic({ to: "b@x.com", subject: "Hi", text: "Body" });

    expect(warnSpy).toHaveBeenCalledWith("[EMAIL] unknown driver, falling back to noop", {
      driver: "smtp"
    });
    warnSpy.mockRestore();
  });
});
