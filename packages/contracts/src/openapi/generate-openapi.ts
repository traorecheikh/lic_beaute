import { mkdirSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { openApiSpec } from "./spec.js";

const currentDir = dirname(fileURLToPath(import.meta.url));
const outputPath = resolve(currentDir, "../../../../apps/api/openapi/openapi.json");

mkdirSync(dirname(outputPath), { recursive: true });
writeFileSync(outputPath, `${JSON.stringify(openApiSpec, null, 2)}\n`);
console.log(`OpenAPI generated at ${outputPath}`);
