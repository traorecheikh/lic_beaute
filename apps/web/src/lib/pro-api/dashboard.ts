import {
  getProApi,
  resolveAccessToken,
  withApiError
} from "./shared";

export async function fetchProDashboard(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProDashboardGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProDashboardGet()
  );
}
