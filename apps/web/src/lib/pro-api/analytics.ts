import {
  getProApi,
  resolveAccessToken,
  withApiError
} from "./shared";

export async function fetchProAnalytics(token: string, period: "7d" | "30d" | "90d") {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProAnalyticsGet({ period }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProAnalyticsGet({ period })
  );
}
