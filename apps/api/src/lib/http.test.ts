import { describe, expect, it, vi } from "vitest";

import { HttpAuthError } from "./auth/index.js";
import { fail, handleError, ok } from "./http.js";

describe("http helpers", () => {
  it("ok sends status and payload", () => {
    const send = vi.fn();
    const code = vi.fn(() => ({ send }));
    ok({ code } as never, { a: 1 }, 201);
    expect(code).toHaveBeenCalledWith(201);
    expect(send).toHaveBeenCalledWith({ a: 1 });
  });

  it("fail sends error envelope", () => {
    const send = vi.fn();
    const code = vi.fn(() => ({ send }));
    fail({ code } as never, 422, "bad", "msg");
    expect(code).toHaveBeenCalledWith(422);
    expect(send).toHaveBeenCalledWith({ code: "bad", message: "msg" });
  });

  it("handleError maps HttpAuthError", () => {
    const send = vi.fn();
    const code = vi.fn(() => ({ send }));
    handleError(new HttpAuthError(401, "invalid", "nope"), { code } as never);
    expect(code).toHaveBeenCalledWith(401);
    expect(send).toHaveBeenCalledWith({ code: "invalid", message: "nope" });
  });

  it("handleError maps unknown errors to internal_error", () => {
    const send = vi.fn();
    const code = vi.fn(() => ({ send }));
    handleError(new Error("x"), { code } as never);
    expect(code).toHaveBeenCalledWith(500);
    expect(send).toHaveBeenCalledWith({ code: "internal_error", message: "Erreur interne." });
  });
});

