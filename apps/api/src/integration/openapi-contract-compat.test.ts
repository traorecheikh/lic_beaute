import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "vitest";

describe("OpenAPI contract compatibility", () => {
  it("loads generated OpenAPI document and validates minimal structure", () => {
    const path = resolve(process.cwd(), "openapi/openapi.json");
    const json = JSON.parse(readFileSync(path, "utf8")) as Record<string, unknown>;

    expect(typeof json.openapi).toBe("string");
    expect(typeof json.info).toBe("object");
    expect(typeof json.paths).toBe("object");
  });
});

