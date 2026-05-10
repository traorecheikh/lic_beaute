abstract final class StorageKeys {
  // ── Secure storage (flutter_secure_storage) ───────────────────────────────
  static const accessToken = 'ba_access_token';
  static const refreshToken = 'ba_refresh_token';
  static const userId = 'ba_user_id';
  static const userRole = 'ba_user_role';

  // ── Hive box names ────────────────────────────────────────────────────────
  static const salonCacheBox = 'ba_salons';
  static const bookingCacheBox = 'ba_bookings';
  static const notificationBox = 'ba_notifications';
  static const profileBox = 'ba_profile';
  static const settingsBox = 'ba_settings';
  static const outboxBox = 'ba_outbox';

  // ── Hive keys (within boxes) ─────────────────────────────────────────────
  static const salonListKey = 'salon_list';
  static const salonDetailKeyPrefix = 'salon_detail:';
  static const salonListEtag = 'salon_list_etag';
  static const bookingsListKeyPrefix = 'bookings_list:';
  static const bookingDetailKeyPrefix = 'booking_detail:';
  static const currentUser = 'current_user';
  static const paymentMethods = 'payment_methods';
  static const notificationsList = 'notifications_list';
  static const benefitsList = 'benefits_list';
  static const vouchersList = 'vouchers_list';
  static const outboxItems = 'outbox_items';
  static const onboardingCompleted = 'onboarding_completed';
}
