// Shared infrastructure — only export what was originally public
export { registerProSessionController, refreshSessionWithSingleFlight, withApiError, fetchProAuthResponse, ApiError } from "./shared";

// Auth
export {
  loginPro,
  registerProOwner,
  requestProOtp,
  verifyProOtp,
  fetchProCurrentUser,
  logoutPro,
  refreshProSession,
  forgotPassword,
  resetProPassword,
  setupProAccount,
  magicLoginPro,
  redeemStaffInviteToken
} from "./auth";

// Bookings
export {
  fetchProBookings,
  fetchProBooking,
  acceptProBooking,
  rejectProBooking,
  startProBooking,
  completeProBooking,
  createManualProBooking,
  fetchProCheckout,
  completeProCheckout,
  fetchPaymentMethods
} from "./bookings";

// Clients
export { fetchProClients, fetchProClient, createClientBenefit } from "./clients";

// Salon
export {
  fetchProSalon,
  updateProSalon,
  uploadProMedia,
  deleteProMediaAsset,
  fetchProHours,
  updateProHours,
  fetchProBlockedSlots,
  createProBlockedSlot,
  deleteProBlockedSlot
} from "./salon";

// Staff
export { fetchProStaff, createProStaff, updateProStaff, deleteProStaff, resendProStaffInvite } from "./staff";

// Services
export { fetchProServices, createProService, updateProService, deleteProService } from "./services";

// Subscription
export {
  fetchProSubscription,
  fetchProSubscriptionFeatures,
  updateProSubscription,
  checkoutProSubscription,
  executeProSubscription,
  cancelProSubscription,
  retainProSubscription,
  fetchProSubscriptionChargeStatus,
  fetchProInvoices,
  downloadProInvoicePdf
} from "./subscription";

// Payouts
export { fetchProPayouts, fetchProPayoutSettings, updateProPayoutSettings, fetchProMerchantPayouts } from "./payouts";

// Analytics
export { fetchProAnalytics } from "./analytics";

// Notifications
export { fetchNotificationsUnreadCount, fetchNotifications, markNotificationRead, markAllNotificationsRead } from "./notifications";

// Dashboard
export { fetchProDashboard } from "./dashboard";

// Vouchers
export { createProVoucher } from "./vouchers";

// Helpers
export { dayOfWeekLabel, dayOfWeekOrder, getDayLabel } from "./helpers";
