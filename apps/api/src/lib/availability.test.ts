import { describe, expect, it } from "vitest";

import { computeAvailableSlots, fetchAndComputeAvailableSlots } from "./availability.js";

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

  it("returns empty when service duration exceeds open window", () => {
    const slots = computeAvailableSlots({
      hours: { isOpen: true, opensAt: "09:00", closesAt: "09:15" },
      service: { durationMinutes: 30 },
      date,
      blockedSlots: [],
      existingBookings: [],
      employees: []
    });
    expect(slots).toEqual([]);
  });

  it("blocks unassigned booking when no requested employee", () => {
    const slots = computeAvailableSlots({
      hours: { isOpen: true, opensAt: "09:00", closesAt: "10:00" },
      service: { durationMinutes: 30 },
      date,
      blockedSlots: [],
      existingBookings: [{
        startsAt: new Date("2026-05-01T09:00:00"),
        endsAt: new Date("2026-05-01T09:30:00"),
        employeeId: null
      }],
      employees: [{ id: "emp-1", schedulingEnabled: true }]
    });
    expect(slots.some((s) => s.startsAt.includes("09:00"))).toBe(false);
  });

  it("respects requestedEmployeeId and employee blocked slots", () => {
    const slots = computeAvailableSlots({
      hours: { isOpen: true, opensAt: "09:00", closesAt: "10:00" },
      service: { durationMinutes: 30 },
      date,
      blockedSlots: [{
        startsAt: new Date("2026-05-01T09:00:00"),
        endsAt: new Date("2026-05-01T09:45:00"),
        scope: "employee",
        employeeId: "emp-1"
      }],
      existingBookings: [],
      employees: [{ id: "emp-1", schedulingEnabled: true }, { id: "emp-2", schedulingEnabled: false }],
      requestedEmployeeId: "emp-1"
    });
    expect(slots.every((s) => s.employeeId === "emp-1")).toBe(true);
    expect(slots.some((s) => s.startsAt.includes("09:00"))).toBe(false);
  });

  it("excludes employee when same employee is already booked on slot overlap", () => {
    const slots = computeAvailableSlots({
      hours: { isOpen: true, opensAt: "09:00", closesAt: "10:00" },
      service: { durationMinutes: 30 },
      date,
      blockedSlots: [],
      existingBookings: [{
        startsAt: new Date("2026-05-01T09:00:00"),
        endsAt: new Date("2026-05-01T09:30:00"),
        employeeId: "emp-1"
      }],
      employees: [{ id: "emp-1", schedulingEnabled: true }]
    });
    expect(slots.some((s) => s.startsAt.includes("09:00"))).toBe(false);
  });

  it("fetchAndComputeAvailableSlots maps prisma data and excludes booking id", async () => {
    const prisma = {
      salonHours: { findUnique: async () => ({ isOpen: true, opensAt: "09:00", closesAt: "10:00" }) },
      blockedSlot: { findMany: async () => [] },
      booking: { findMany: async () => [] },
      employee: { findMany: async () => [] }
    } as never;
    const slots = await fetchAndComputeAvailableSlots(prisma, {
      salonId: "s1",
      date: new Date("2026-05-01"),
      durationMinutes: 30,
      excludeBookingId: "b1",
      slotIntervalMinutes: 30
    });
    expect(slots.length).toBeGreaterThan(0);
    expect(slots[0].employeeId).toBeNull();
  });

  it("fetchAndComputeAvailableSlots maps closed salon hours and omits exclude/id/interval options", async () => {
    const prisma = {
      salonHours: { findUnique: async () => null },
      blockedSlot: { findMany: async () => [] },
      booking: { findMany: async () => [] },
      employee: { findMany: async () => [{ id: "emp-1", schedulingEnabled: true }] }
    } as never;
    const slots = await fetchAndComputeAvailableSlots(prisma, {
      salonId: "s1",
      date: new Date("2026-05-01"),
      durationMinutes: 30
    });
    expect(slots).toEqual([]);
  });

  it("fetchAndComputeAvailableSlots maps blocked-slot scope fields", async () => {
    const prisma = {
      salonHours: { findUnique: async () => ({ isOpen: true, opensAt: "09:00", closesAt: "10:00" }) },
      blockedSlot: {
        findMany: async () => [{
          startsAt: new Date("2026-05-01T09:00:00"),
          endsAt: new Date("2026-05-01T09:30:00"),
          scope: "salon",
          employeeId: null
        }]
      },
      booking: { findMany: async () => [] },
      employee: { findMany: async () => [] }
    } as never;
    const slots = await fetchAndComputeAvailableSlots(prisma, {
      salonId: "s1",
      date: new Date("2026-05-01"),
      durationMinutes: 30
    });
    expect(slots.every((s) => !s.startsAt.includes("09:00"))).toBe(true);
  });
});
