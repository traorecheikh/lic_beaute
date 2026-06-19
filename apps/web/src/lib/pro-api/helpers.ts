export const dayOfWeekLabel: Record<number, string> = {
  0: "Dimanche",
  1: "Lundi",
  2: "Mardi",
  3: "Mercredi",
  4: "Jeudi",
  5: "Vendredi",
  6: "Samedi"
};

export const dayOfWeekOrder = [1, 2, 3, 4, 5, 6, 0];

export function getDayLabel(dayOfWeek: number) {
  return dayOfWeekLabel[dayOfWeek] ?? `Jour ${dayOfWeek}`;
}
