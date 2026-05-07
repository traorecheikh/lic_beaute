import dayjs from "dayjs";
import "dayjs/locale/fr";

dayjs.locale("fr");

export function formatDate(value: string) {
  return dayjs(value).format("D MMM YYYY");
}

export function formatDateTime(value: string) {
  return dayjs(value).format("D MMM YYYY · HH:mm");
}
