import { describe, expect, it } from "vitest";

import { computeAvailableSlots } from "./availability.js";

const baseHours = { isOpen: true, opensAt: "09:00", closesAt: "17:00" };
const service30min = { durationMinutes: 30 };
const date = new Date("2026-05-01");

describe("computeAvailableSlots", () => {
  it("returns empty array when salon is closed", () => {
    const slots = computeAvailableSlots({
      hours: { isOpen: false, opensAt: null, closesAt: null },
      service: service30min,
      date,
      blockedSlots: [],
      existingBookings: [],
      employees: []
    });
    expect(slots).toHaveLength(0);
  });

  it("generates slots within opening hours", () => {
    const slots = computeAvailableSlots({
      hours: baseHours,
      service: service30min,
      date,
      blockedSlots: [],
      existingBookings: [],
      employees: []
    });
    // 09:00 to 17:00 = 480 min, 30min slots every 15min = (480 - 30) / 15 + 1 = 31 slots
    expect(slots.length).toBe(31);
    expect(slots[0].startsAt).toContain("09:00");
    expect(slots[0].endsAt).toContain("09:30");
  });

  it("excludes slots blocked at salon scope", () => {
    const slots = computeAvailableSlots({
      hours: baseHours,
      service: service30min,
      date,
      blockedSlots: [
        {
          startsAt: new Date("2026-05-01T09:00:00"),
          endsAt: new Date("2026-05-01T11:00:00"),
          scope: "salon",
          employeeId: null
        }
      ],
      existingBookings: [],
      employees: []
    });
    // 09:00–11:00 blocked, first available is 11:00 → (17:00 - 11:00 = 360min, 30min every 15min = 23)
    expect(slots.every((s) => new Date(s.startsAt) >= new Date("2026-05-01T11:00:00"))).toBe(true);
  });

  it("excludes slots conflicting with existing bookings (no employees)", () => {
    const slots = computeAvailableSlots({
      hours: baseHours,
      service: service30min,
      date,
      blockedSlots: [],
      existingBookings: [
        {
          startsAt: new Date("2026-05-01T10:00:00"),
          endsAt: new Date("2026-05-01T10:30:00"),
          employeeId: null
        }
      ],
      employees: []
    });
    // 09:45 would overlap: 09:45–10:15 overlaps 10:00–10:30
    // 10:00 overlaps exactly
    // 10:15 would overlap: 10:15–10:45 overlaps 10:00–10:30
    const conflictStarts = ["09:45", "10:00", "10:15"].map((t) => `2026-05-01T${t}`);
    for (const s of conflictStarts) {
      expect(slots.some((slot) => slot.startsAt.startsWith(s))).toBe(false);
    }
  });

  it("assigns available employee to each slot", () => {
    const slots = computeAvailableSlots({
      hours: baseHours,
      service: service30min,
      date,
      blockedSlots: [],
      existingBookings: [],
      employees: [{ id: "emp-1", schedulingEnabled: true }]
    });
    expect(slots.every((s) => s.employeeId === "emp-1")).toBe(true);
  });
});
