export type SlotHours = {
  isOpen: boolean;
  opensAt: string | null;
  closesAt: string | null;
};

export type SlotBooking = {
  startsAt: Date;
  endsAt: Date;
  employeeId: string | null;
};

export type SlotBlocked = {
  startsAt: Date;
  endsAt: Date;
  scope: "salon" | "employee";
  employeeId: string | null;
};

export type SlotEmployee = {
  id: string;
  schedulingEnabled: boolean;
};

export type AvailableSlot = {
  startsAt: string;
  endsAt: string;
  employeeId: string | null;
};

function parseTimeToMinutes(time: string): number {
  const [h, m] = time.split(":").map(Number);
  return h * 60 + m;
}

function overlaps(aStart: Date, aEnd: Date, bStart: Date, bEnd: Date): boolean {
  return aStart < bEnd && aEnd > bStart;
}

export function computeAvailableSlots(params: {
  hours: SlotHours;
  service: { durationMinutes: number };
  date: Date;
  blockedSlots: SlotBlocked[];
  existingBookings: SlotBooking[];
  employees: SlotEmployee[];
  requestedEmployeeId?: string;
  slotIntervalMinutes?: number;
}): AvailableSlot[] {
  const { hours, service, date, blockedSlots, existingBookings, employees, requestedEmployeeId } = params;
  const interval = params.slotIntervalMinutes ?? 15;

  if (!hours.isOpen || !hours.opensAt || !hours.closesAt) return [];

  const opensMin = parseTimeToMinutes(hours.opensAt);
  const closesMin = parseTimeToMinutes(hours.closesAt);
  const duration = service.durationMinutes;

  if (opensMin + duration > closesMin) return [];

  const dateMs = new Date(date.getFullYear(), date.getMonth(), date.getDate()).getTime();

  const activeEmployees = employees.filter(
    (e) =>
      e.schedulingEnabled &&
      (!requestedEmployeeId || e.id === requestedEmployeeId)
  );

  const slots: AvailableSlot[] = [];

  for (let startMin = opensMin; startMin + duration <= closesMin; startMin += interval) {
    const slotStart = new Date(dateMs + startMin * 60 * 1000);
    const slotEnd = new Date(dateMs + (startMin + duration) * 60 * 1000);

    // Check salon-scope blocked slots
    const salonBlocked = blockedSlots.some(
      (b) => b.scope === "salon" && overlaps(slotStart, slotEnd, b.startsAt, b.endsAt)
    );
    if (salonBlocked) continue;

    if (activeEmployees.length > 0) {
      // Find first available employee for this slot
      const availableEmployee = activeEmployees.find((emp) => {
        const empBlocked = blockedSlots.some(
          (b) =>
            b.scope === "employee" &&
            b.employeeId === emp.id &&
            overlaps(slotStart, slotEnd, b.startsAt, b.endsAt)
        );
        if (empBlocked) return false;

        const empBooked = existingBookings.some(
          (bk) => bk.employeeId === emp.id && overlaps(slotStart, slotEnd, bk.startsAt, bk.endsAt)
        );
        return !empBooked;
      });

      if (!availableEmployee) continue;

      slots.push({
        startsAt: slotStart.toISOString(),
        endsAt: slotEnd.toISOString(),
        employeeId: availableEmployee.id
      });
    } else {
      // No employee tracking — just check salon-level bookings
      const alreadyBooked = existingBookings.some(
        (bk) =>
          bk.employeeId === null &&
          overlaps(slotStart, slotEnd, bk.startsAt, bk.endsAt)
      );
      if (alreadyBooked) continue;

      slots.push({
        startsAt: slotStart.toISOString(),
        endsAt: slotEnd.toISOString(),
        employeeId: null
      });
    }
  }

  return slots;
}
