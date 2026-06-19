import {
  getNotificationsApi,
  resolveAccessToken,
  withApiError
} from "./shared";

export async function fetchNotificationsUnreadCount(token: string): Promise<number> {
  return withApiError(async () => {
    const result = await getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsGet({});
    return (result as unknown as { unreadCount: number }).unreadCount ?? 0;
  }, async () => {
    const result = await getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsGet({});
    return (result as unknown as { unreadCount: number }).unreadCount ?? 0;
  });
}

export async function fetchNotifications(token: string) {
  return withApiError(
    () => getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsGet(),
    () => getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsGet()
  );
}

export async function markNotificationRead(token: string, id: string) {
  return withApiError(
    () => getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsIdReadPost({ id }),
    () => getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsIdReadPost({ id })
  );
}

export async function markAllNotificationsRead(token: string) {
  return withApiError(
    () => getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsReadAllPost(),
    () => getNotificationsApi(resolveAccessToken(token) ?? token).apiV1NotificationsReadAllPost()
  );
}
