import type {
  ProSalonUpdateInput,
  ProSalonProfileHoursInner,
  ProBlockedSlotCreateInput
} from "@/lib/generated";
import {
  getProApi,
  getMediaApi,
  resolveAccessToken,
  withApiError,
  fetchWithProAuth
} from "./shared";

export async function fetchProSalon(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSalonGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSalonGet()
  );
}

export async function updateProSalon(token: string, payload: ProSalonUpdateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSalonPatch({ proSalonUpdateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProSalonPatch({ proSalonUpdateInput: payload })
  );
}

// ─── Media ────────────────────────────────────────────────────────────────────

export async function uploadProMedia(token: string, file: File, purpose: string) {
  const formData = new FormData();
  formData.append("purpose", purpose);
  formData.append("file", file);
  const result = await fetchWithProAuth<{ assetId: string; publicUrl?: string }>("/api/v1/media/upload", {
    method: "POST",
    body: formData
  }, token);
  return { id: result.assetId, publicUrl: result.publicUrl ?? "" };
}

export async function deleteProMediaAsset(token: string, mediaId: string) {
  return withApiError(
    () => getMediaApi(resolveAccessToken(token) ?? token).apiV1MediaMediaIdDelete({ mediaId }),
    () => getMediaApi(resolveAccessToken(token) ?? token).apiV1MediaMediaIdDelete({ mediaId })
  );
}

// ─── Hours ────────────────────────────────────────────────────────────────────

export async function fetchProHours(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProHoursGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProHoursGet()
  );
}

export async function updateProHours(token: string, hours: ProSalonProfileHoursInner[]) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProHoursPut({ proSalonProfileHoursInner: hours }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProHoursPut({ proSalonProfileHoursInner: hours })
  );
}

// ─── Blocked Slots ────────────────────────────────────────────────────────────

export async function fetchProBlockedSlots(token: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBlockedSlotsGet(),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBlockedSlotsGet()
  );
}

export async function createProBlockedSlot(token: string, payload: ProBlockedSlotCreateInput) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBlockedSlotsPost({ proBlockedSlotCreateInput: payload }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBlockedSlotsPost({ proBlockedSlotCreateInput: payload })
  );
}

export async function deleteProBlockedSlot(token: string, slotId: string) {
  return withApiError(
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBlockedSlotsSlotIdDelete({ slotId }),
    () => getProApi(resolveAccessToken(token) ?? token).apiV1ProBlockedSlotsSlotIdDelete({ slotId })
  );
}
