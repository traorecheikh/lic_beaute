import type { ProServiceCreateInput, ProServiceUpdateInput } from "@/lib/generated";
import {
  getProApi,
  resolveAccessToken,
  withApiError
} from "./shared";

export async function fetchProServices(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesGet()
  );
}

export async function createProService(token: string, payload: ProServiceCreateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesPost({ proServiceCreateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesPost({ proServiceCreateInput: payload })
  );
}

export async function updateProService(token: string, serviceId: string, payload: ProServiceUpdateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesServiceIdPatch({ serviceId, proServiceUpdateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesServiceIdPatch({ serviceId, proServiceUpdateInput: payload })
  );
}

export async function deleteProService(token: string, serviceId: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesServiceIdDelete({ serviceId }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProServicesServiceIdDelete({ serviceId })
  );
}
