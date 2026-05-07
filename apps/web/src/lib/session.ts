const sessionStorageKey = "beauteavenue.admin.accessToken";

export function getAdminAccessToken() {
  return window.localStorage.getItem(sessionStorageKey);
}

export function setAdminAccessToken(token: string) {
  window.localStorage.setItem(sessionStorageKey, token);
}

export function clearAdminAccessToken() {
  window.localStorage.removeItem(sessionStorageKey);
}
