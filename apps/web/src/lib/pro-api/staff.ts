import type { ProStaffCreateInput, ProStaffUpdateInput } from "@/lib/generated";
import {
  getProApi,
  resolveAccessToken,
  withApiError,
  fetchWithProAuth
} from "./shared";

export async function fetchProStaff(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffGet()
  );
}

export async function createProStaff(token: string, payload: ProStaffCreateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffPost({ proStaffCreateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffPost({ proStaffCreateInput: payload })
  );
}

export async function updateProStaff(token: string, employeeId: string, payload: ProStaffUpdateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffEmployeeIdPatch({ employeeId, proStaffUpdateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffEmployeeIdPatch({ employeeId, proStaffUpdateInput: payload })
  );
}

export async function deleteProStaff(token: string, employeeId: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffEmployeeIdDelete({ employeeId }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProStaffEmployeeIdDelete({ employeeId })
  );
}

export async function resendProStaffInvite(token: string, employeeId: string): Promise<{ sent: boolean; email: string }> {
  return fetchWithProAuth(`/api/v1/pro/staff/${employeeId}/resend-invite`, {
    method: "POST"
  }, token);
}
