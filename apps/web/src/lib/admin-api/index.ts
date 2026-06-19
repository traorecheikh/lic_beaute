// Shared infrastructure
export { ApiError, registerAdminSessionController } from "./shared";
export type { AuthSession, AdminSessionController } from "./shared";

// Auth
export { loginAdmin, fetchCurrentUser, logoutAdmin, refreshAdminSession, forgotPassword, changePassword } from "./auth";

// Dashboard
export { fetchAdminDashboard, fetchCancellationStats } from "./dashboard";

// Salons
export {
  fetchPendingSalons,
  fetchSalons,
  fetchSalonDetail,
  createSalon,
  checkSalonUniqueness,
  approveSalonRequest,
  rejectSalonRequest,
  requestSalonInfo,
  fetchAdminSalonServices,
  createAdminSalonService,
  updateAdminSalonService,
  deleteAdminSalonService,
  sendPasswordReset,
  sendMagicLink,
  verifySalonPayoutSettings
} from "./salons";

// Subscriptions
export {
  fetchSubscriptions,
  fetchSubscriptionDetail,
  overrideSubscription,
  manualExtendSubscription
} from "./subscriptions";

// Audit
export { fetchAuditEvents, fetchAuditDetail, fetchEmailAuditEvents } from "./audit";
export type { EmailAuditItem } from "./audit";

// Config
export {
  fetchPublicPricing,
  fetchPlatformSettings,
  updatePlatformSetting,
  fetchPlatformCategories,
  upsertPlatformCategory,
  deletePlatformCategory,
  fetchPlatformServiceSuggestions,
  upsertPlatformServiceSuggestion,
  deletePlatformServiceSuggestion,
  fetchPlatformRequiredDocuments,
  upsertPlatformRequiredDocument,
  deletePlatformRequiredDocument
} from "./config";

// Payouts
export {
  fetchAdminPayoutVerificationQueue,
  fetchAdminMerchantPayouts,
  fetchAdminMerchantPayoutDetail,
  reconcileAdminPayout,
  retryAdminPayout,
  approveAdminPayout,
  cancelAdminPayout
} from "./payouts";

// Public endpoints
export {
  fetchPublicRegistrationDocs,
  fetchPublicCategories,
  fetchPublicServiceSuggestions,
  checkPublicUniqueness,
  uploadRegistrationDoc
} from "./public";
