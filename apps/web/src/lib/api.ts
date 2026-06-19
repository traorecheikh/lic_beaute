/**
 * Admin API client — extracted into modules under admin-api/.
 * This file is now a backward-compatible barrel re-export.
 *
 * @module
 * @example
 * ```ts
 * // Import from @/lib/api — still works exactly as before
 * import { loginAdmin, fetchAdminDashboard } from "@/lib/api";
 * ```
 */
export {
  ApiError,
  registerAdminSessionController,
  loginAdmin,
  fetchCurrentUser,
  logoutAdmin,
  refreshAdminSession,
  forgotPassword,
  changePassword,
  fetchAdminDashboard,
  fetchCancellationStats,
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
  fetchSubscriptions,
  fetchSubscriptionDetail,
  overrideSubscription,
  manualExtendSubscription,
  fetchAuditEvents,
  fetchAuditDetail,
  fetchEmailAuditEvents,
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
  deletePlatformRequiredDocument,
  sendPasswordReset,
  sendMagicLink,
  fetchAdminPayoutVerificationQueue,
  fetchAdminMerchantPayouts,
  fetchAdminMerchantPayoutDetail,
  reconcileAdminPayout,
  retryAdminPayout,
  approveAdminPayout,
  cancelAdminPayout,
  verifySalonPayoutSettings,
  fetchPublicRegistrationDocs,
  fetchPublicCategories,
  fetchPublicServiceSuggestions,
  checkPublicUniqueness,
  uploadRegistrationDoc
} from "./admin-api/index";

export type { EmailAuditItem } from "./admin-api/audit";
