import type { ProVoucherCreateInput } from "@/lib/generated";
import {
  getProApi,
  resolveAccessToken,
  withApiError
} from "./shared";

export async function createProVoucher(token: string, payload: ProVoucherCreateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProVouchersPost({ proVoucherCreateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProVouchersPost({ proVoucherCreateInput: payload })
  );
}
