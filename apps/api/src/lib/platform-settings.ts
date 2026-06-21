import { prisma } from "./db/prisma.js";

export type MerchantPayoutCadence = "immediate" | "daily" | "twice_weekly" | "weekly";
export type MerchantPayoutWeekday =
  | "monday"
  | "tuesday"
  | "wednesday"
  | "thursday"
  | "friday"
  | "saturday"
  | "sunday";

export type MerchantPayoutPolicy = {
  cadence: MerchantPayoutCadence;
  minimumPayoutXof: number;
  releaseHourUtc: number;
  weeklyDay: MerchantPayoutWeekday;
  secondWeeklyDay: MerchantPayoutWeekday;
};

const WEEKDAY_TO_INDEX: Record<MerchantPayoutWeekday, number> = {
  sunday: 0,
  monday: 1,
  tuesday: 2,
  wednesday: 3,
  thursday: 4,
  friday: 5,
  saturday: 6
};

function clampInteger(value: string | undefined, fallback: number, min: number, max: number) {
  const parsed = Number.parseInt(value ?? "", 10);
  if (!Number.isFinite(parsed)) return fallback;
  return Math.min(max, Math.max(min, parsed));
}

function parseCadence(value: string | undefined): MerchantPayoutCadence {
  if (value === "daily" || value === "twice_weekly" || value === "weekly") return value;
  return "immediate";
}

function parseWeekday(value: string | undefined, fallback: MerchantPayoutWeekday): MerchantPayoutWeekday {
  if (
    value === "monday" ||
    value === "tuesday" ||
    value === "wednesday" ||
    value === "thursday" ||
    value === "friday" ||
    value === "saturday" ||
    value === "sunday"
  ) {
    return value;
  }
  return fallback;
}

function setUtcReleaseHour(source: Date, releaseHourUtc: number) {
  const next = new Date(source);
  next.setUTCHours(releaseHourUtc, 0, 0, 0);
  return next;
}

function nextDailySlot(from: Date, releaseHourUtc: number) {
  const slot = setUtcReleaseHour(from, releaseHourUtc);
  if (slot.getTime() < from.getTime()) {
    slot.setUTCDate(slot.getUTCDate() + 1);
  }
  return slot;
}

function nextWeeklySlot(from: Date, releaseHourUtc: number, weekdays: number[]) {
  const ordered = [...new Set(weekdays)].sort((a, b) => a - b);
  let best: Date | null = null;
  for (const weekday of ordered) {
    const slot = setUtcReleaseHour(from, releaseHourUtc);
    const currentWeekday = slot.getUTCDay();
    let delta = weekday - currentWeekday;
    if (delta < 0) delta += 7;
    slot.setUTCDate(slot.getUTCDate() + delta);
    if (slot.getTime() < from.getTime()) {
      slot.setUTCDate(slot.getUTCDate() + 7);
    }
    if (!best || slot.getTime() < best.getTime()) {
      best = slot;
    }
  }
  return best ?? nextDailySlot(from, releaseHourUtc);
}

export async function getPlatformSettingMap(keys: string[]) {
  const platformSetting = prisma.platformSetting as unknown as {
    findMany?: (args: { where: { key: { in: string[] } }; select: { key: true; value: true } }) => Promise<Array<{ key: string; value: string }>>;
    findUnique?: (args: { where: { key: string }; select?: { value: true } }) => Promise<{ value: string } | null>;
  };

  if (typeof platformSetting.findMany === "function") {
    const rows = await platformSetting.findMany({
      where: { key: { in: keys } },
      select: { key: true, value: true }
    });
    return Object.fromEntries(rows.map((row) => [row.key, row.value]));
  }

  if (typeof platformSetting.findUnique === "function") {
    const rows = await Promise.all(
      keys.map(async (key) => {
        const row = await platformSetting.findUnique!({ where: { key }, select: { value: true } });
        return row ? [key, row.value] as const : null;
      })
    );
    return Object.fromEntries(rows.filter((row): row is readonly [string, string] => row !== null));
  }

  return {};
}

export async function getMerchantPayoutPolicy(): Promise<MerchantPayoutPolicy> {
  const map = await getPlatformSettingMap([
    "merchant_payout_cadence",
    "merchant_payout_minimum_xof",
    "merchant_payout_release_hour_utc",
    "merchant_payout_weekly_day",
    "merchant_payout_second_weekly_day"
  ]);

  return {
    cadence: parseCadence(map["merchant_payout_cadence"]),
    minimumPayoutXof: clampInteger(map["merchant_payout_minimum_xof"], 200, 1, 5_000_000),
    releaseHourUtc: clampInteger(map["merchant_payout_release_hour_utc"], 21, 0, 23),
    weeklyDay: parseWeekday(map["merchant_payout_weekly_day"], "friday"),
    secondWeeklyDay: parseWeekday(map["merchant_payout_second_weekly_day"], "tuesday")
  };
}

export async function getDepositMinimumXof() {
  const platformSetting = prisma.platformSetting as unknown as {
    findUnique?: (args: { where: { key: string }; select?: { value: true } }) => Promise<{ value: string } | null>;
    findMany?: (args: {
      where: { key: { in: string[] } };
      select: { key: true; value: true };
    }) => Promise<Array<{ key: string; value: string }>>;
  };

  if (typeof platformSetting.findUnique === "function") {
    const setting = await platformSetting.findUnique({
      where: { key: "deposit_minimum_xof" },
      select: { value: true }
    });
    return clampInteger(setting?.value, 2000, 0, 5_000_000);
  }

  if (typeof platformSetting.findMany === "function") {
    const rows = await platformSetting.findMany({
      where: { key: { in: ["deposit_minimum_xof"] } },
      select: { key: true, value: true }
    });
    return clampInteger(rows[0]?.value, 2000, 0, 5_000_000);
  }

  return 2000;
}

export function resolvePayoutReleaseAt(eligibleAt: Date, policy: MerchantPayoutPolicy) {
  if (policy.cadence === "immediate") return new Date(eligibleAt);
  if (policy.cadence === "daily") return nextDailySlot(eligibleAt, policy.releaseHourUtc);
  if (policy.cadence === "weekly") {
    return nextWeeklySlot(eligibleAt, policy.releaseHourUtc, [WEEKDAY_TO_INDEX[policy.weeklyDay]]);
  }
  return nextWeeklySlot(eligibleAt, policy.releaseHourUtc, [
    WEEKDAY_TO_INDEX[policy.weeklyDay],
    WEEKDAY_TO_INDEX[policy.secondWeeklyDay]
  ]);
}

export function resolveNextPayoutReleaseAt(currentReleaseAt: Date, policy: MerchantPayoutPolicy) {
  return resolvePayoutReleaseAt(new Date(currentReleaseAt.getTime() + 1000), policy);
}
