abstract final class StorageKeys {
  // ── Secure storage (flutter_secure_storage) ───────────────────────────────
  static const accessToken  = 'ba_access_token';
  static const refreshToken = 'ba_refresh_token';
  static const userId       = 'ba_user_id';
  static const userRole     = 'ba_user_role';

  // ── Hive box names ────────────────────────────────────────────────────────
  static const salonCacheBox   = 'ba_salons';
  static const bookingCacheBox = 'ba_bookings';
  static const notificationBox = 'ba_notifications';
  static const profileBox      = 'ba_profile';
  static const settingsBox     = 'ba_settings';

  // ── Hive keys (within boxes) ─────────────────────────────────────────────
  static const salonListKey  = 'salon_list';
  static const salonListEtag = 'salon_list_etag';
  static const currentUser   = 'current_user';
}
