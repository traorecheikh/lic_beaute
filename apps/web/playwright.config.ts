import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: "./tests/e2e",
  timeout: 180_000,
  retries: 0,
  workers: 1,
  use: {
    baseURL: "http://127.0.0.1:4174",
    headless: process.env.PW_HEADLESS === "false" ? false : true,
    launchOptions: {
      slowMo: Number(process.env.PW_SLOWMO ?? 0)
    }
  },
  webServer: [
    {
      command: "pnpm --filter @beauteavenue/api dev",
      port: 3000,
      reuseExistingServer: true
    },
    {
      command: "pnpm exec vite --host 127.0.0.1 --port 4174",
      port: 4174,
      reuseExistingServer: true
    }
  ]
});
