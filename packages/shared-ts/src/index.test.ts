import { describe, expect, it } from "vitest";
import { formatMoneyXof } from "./index.js";
import { validateForm } from "./validate-form.js";
import { z } from "zod";

const NBSP = "\u00A0"; // non-breaking space between number and currency
const NNBSP = "\u202F"; // narrow no-break space (group separator + F CFA)

describe("formatMoneyXof", () => {
  it("formats 0 as 0 F CFA", () => {
    expect(formatMoneyXof(0)).toBe(`0${NBSP}F${NNBSP}CFA`);
  });

  it("formats an integer amount without decimals", () => {
    const result = formatMoneyXof(1500);
    expect(result).toContain(`1${NNBSP}500`);
    expect(result).toContain(`F${NNBSP}CFA`);
  });

  it("formats a large amount with thousands separators", () => {
    const result = formatMoneyXof(1000000);
    expect(result).toContain(`1${NNBSP}000${NNBSP}000`);
  });

  it("rounds decimal amounts to nearest integer", () => {
    const result = formatMoneyXof(12.7);
    expect(result).toContain("13");
    // Should not show decimal places
    expect(result).not.toContain(",");
  });

  it("uses fr-SN locale convention", () => {
    const result = formatMoneyXof(500);
    // Should end with "F CFA" using proper Unicode spaces
    expect(result).toMatch(new RegExp(`\\d[\\d\\u202F]*${NBSP}F\\u202FCFA$`));
  });
});

describe("validateForm", () => {
  it("returns success with parsed data for valid input", () => {
    const schema = z.object({ name: z.string() });
    const result = validateForm<{ name: string }>(schema, { name: "Alice" });
    expect(result.success).toBe(true);
    if (result.success) {
      expect(result.data).toEqual({ name: "Alice" });
    }
  });

  it("returns errors for invalid input", () => {
    const schema = z.object({ age: z.number().min(18) });
    const result = validateForm<{ age: number }>(schema, { age: 15 });
    expect(result.success).toBe(false);
    if (!result.success) {
      expect(result.errors.age).toBeDefined();
      expect(result.formError).toBeNull();
    }
  });

  it("populates formError for root-level issues", () => {
    const schema = z.number().min(0);
    const result = validateForm<number>(schema, "not a number");
    expect(result.success).toBe(false);
    if (!result.success) {
      expect(result.formError).toBeTruthy();
    }
  });

  it("returns first error per field only", () => {
    const schema = z.object({
      email: z.string().email(),
      password: z.string().min(8)
    });
    const result = validateForm(schema, { email: "bad", password: "short" });
    expect(result.success).toBe(false);
    if (!result.success) {
      expect(Object.keys(result.errors).length).toBe(2);
      expect(result.errors.email).toBeDefined();
      expect(result.errors.password).toBeDefined();
    }
  });

  it("accepts a Zod v3-style safeParse return shape", () => {
    // Simulates Zod v3 return structure (success + data/error)
    const mockSchema = {
      safeParse: (data: unknown) => {
        if (typeof data === "string" && data.length > 0) {
          return { success: true, data };
        }
        return {
          success: false,
          error: {
            issues: [{ path: [], message: "Expected a non-empty string" }]
          }
        };
      }
    };
    const valid = validateForm<string>(mockSchema, "hello");
    expect(valid.success).toBe(true);
    if (valid.success) expect(valid.data).toBe("hello");

    const invalid = validateForm<string>(mockSchema, "");
    expect(invalid.success).toBe(false);
  });
});
