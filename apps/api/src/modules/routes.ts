import { Readable } from "node:stream";
import type { FastifyInstance } from "fastify";

import { config } from "../config.js";
import type { DatabaseRuntime } from "../lib/db/runtime.js";
import { AdminController } from "./admin/index.js";
import { AdminMediaController } from "./admin/media.js";
import { AuthController } from "./auth/index.js";
import { BookingController } from "./bookings/index.js";
import { CatalogController } from "./catalog/index.js";
import { ClientAccountController } from "./client/index.js";
import { MediaController } from "./media/index.js";
import { NotificationController } from "./notifications/index.js";
import { PaymentController } from "./payments/index.js";
import { ProController } from "./pro/index.js";
import { SearchController } from "./search/index.js";

export async function registerRoutes(app: FastifyInstance, databaseRuntime: DatabaseRuntime) {
  const auth = new AuthController();
  const catalog = new CatalogController();
  const bookings = new BookingController();
  const clientAccounts = new ClientAccountController();
  const admin = new AdminController();
  const pro = new ProController();
  const payments = new PaymentController();
  const notifications = new NotificationController();
  const media = new MediaController();
  const adminMedia = new AdminMediaController();
  const search = new SearchController();

  // ── Health ────────────────────────────────────────────────────────────────
  app.get("/health", async () => {
    return {
      status: "ok",
      timestamp: new Date().toISOString(),
      database: {
        driver: databaseRuntime.driver,
        mode: databaseRuntime.mode,
        attempts: databaseRuntime.attempts
      },
      redis: {
        status: app.redisEnabled ? "enabled" : "disabled"
      },
      worker: {
        driver: config.workerDriver
      }
    };
  });

  // ── Auth ──────────────────────────────────────────────────────────────────
  const isDevOrTest = process.env.NODE_ENV !== "production";
  const authLimit = { config: { rateLimit: { max: isDevOrTest ? 200000 : 1000, timeWindow: "1 minute" } } };
  const otpLimit = { config: { rateLimit: { max: isDevOrTest ? 2000 : 5, timeWindow: "1 minute" } } };
  // Password recovery + magic-login: still use per-IP via Fastify rate limiter as second layer
  const passwordLimit = { config: { rateLimit: { max: isDevOrTest ? 200000 : 30, timeWindow: "1 minute" } } };
  // Upload registration docs: per-IP rate limited
  const uploadDocLimit = { config: { rateLimit: { max: isDevOrTest ? 200000 : 30, timeWindow: "1 minute" } } };
  // Sensitive actions (setup-account, staff-invite): moderate per-IP limit
  const sensitiveLimit = { config: { rateLimit: { max: isDevOrTest ? 200000 : 60, timeWindow: "1 minute" } } };
  // Admin mutations: stricter per-IP limit
  const adminMutationLimit = { config: { rateLimit: { max: isDevOrTest ? 200000 : 30, timeWindow: "1 minute" } } };
  // Payment actions: per-IP limit for sensitive financial operations
  const paymentLimit = { config: { rateLimit: { max: isDevOrTest ? 200000 : 30, timeWindow: "1 minute" } } };
  app.post("/api/v1/auth/register", authLimit, (req, rep) => auth.register(req, rep));
  app.get("/api/v1/auth/check-availability", authLimit, (req, rep) => auth.checkAvailability(req, rep));
  app.post("/api/v1/auth/login", authLimit, (req, rep) => auth.login(req, rep));
  app.post("/api/v1/auth/upload-registration-doc", uploadDocLimit, (req, rep) => media.uploadRegistrationDoc(req, rep));
  app.get("/api/v1/platform/registration-docs", (req, rep) => admin.listDocumentsPublic(req, rep));
  app.get("/api/v1/platform/categories", (req, rep) => admin.listCategoriesPublic(req, rep));
  app.get("/api/v1/platform/service-suggestions", (req, rep) => admin.listServiceSuggestionsPublic(req, rep));
  app.get("/api/v1/platform/check-uniqueness", (req, rep) => admin.checkUniquenessPublic(req, rep));
  app.post("/api/v1/auth/otp/request", otpLimit, (req, rep) => auth.requestOtp(req, rep));
  app.post("/api/v1/auth/otp/verify", otpLimit, (req, rep) => auth.verifyOtp(req, rep));
  app.post("/api/v1/auth/otp/email/request", otpLimit, (req, rep) => auth.requestEmailOtp(req, rep));
  app.post("/api/v1/auth/otp/email/verify", otpLimit, (req, rep) => auth.verifyEmailOtp(req, rep));
  app.post("/api/v1/auth/refresh", authLimit, (req, rep) => auth.refresh(req, rep));
  app.post("/api/v1/auth/staff-invite/redeem", sensitiveLimit, (req, rep) => auth.redeemStaffInvite(req, rep));
  app.post("/api/v1/auth/logout", (req, rep) => auth.logout(req, rep));
  app.post("/api/v1/auth/setup-account", sensitiveLimit, (req, rep) => auth.setupAccount(req, rep));
  app.post("/api/v1/auth/forgot-password", passwordLimit, (req, rep) => auth.forgotPassword(req, rep));
  app.post("/api/v1/auth/reset-password", passwordLimit, (req, rep) => auth.resetPassword(req, rep));
  app.post("/api/v1/auth/magic-login", passwordLimit, (req, rep) => auth.magicLogin(req, rep));
app.post("/api/v1/auth/request-deletion", passwordLimit, (req, rep) => auth.requestAccountDeletion(req, rep));
app.post("/api/v1/auth/confirm-deletion", passwordLimit, (req, rep) => auth.confirmAccountDeletion(req, rep));
  app.get("/api/v1/me", (req, rep) => auth.me(req, rep));
  app.patch("/api/v1/me", (req, rep) => auth.updateMe(req, rep));
  app.get("/api/v1/metadata/profile-options", (req, rep) => clientAccounts.profileOptions(req, rep));
  app.get("/api/v1/me/payment-methods", (req, rep) => clientAccounts.listPaymentMethods(req, rep));
  app.post("/api/v1/me/payment-methods", (req, rep) => clientAccounts.createPaymentMethod(req, rep));
  app.patch("/api/v1/me/payment-methods/:paymentMethodId", (req, rep) => clientAccounts.updatePaymentMethod(req, rep));
  app.delete("/api/v1/me/payment-methods/:paymentMethodId", (req, rep) => clientAccounts.deletePaymentMethod(req, rep));
  app.post("/api/v1/me/payment-methods/:paymentMethodId/default", (req, rep) => clientAccounts.setDefaultPaymentMethod(req, rep));
  app.get("/api/v1/me/benefits", (req, rep) => clientAccounts.listBenefits(req, rep));
  app.get("/api/v1/me/vouchers", (req, rep) => clientAccounts.listVouchers(req, rep));
  app.post("/api/v1/me/vouchers/redeem", (req, rep) => clientAccounts.redeemVoucher(req, rep));
  app.get("/api/v1/me/bookings", (req, rep) => bookings.list(req, rep));
  app.get("/api/v1/me/bookings/:bookingId", (req, rep) => bookings.detail(req, rep));
  app.get("/api/v1/me/addresses", (req, rep) => clientAccounts.listAddresses(req, rep));
  app.post("/api/v1/me/addresses", (req, rep) => clientAccounts.createAddress(req, rep));
  app.patch("/api/v1/me/addresses/:addressId", (req, rep) => clientAccounts.updateAddress(req, rep));
  app.delete("/api/v1/me/addresses/:addressId", (req, rep) => clientAccounts.deleteAddress(req, rep));
  app.delete("/api/v1/me", (req, rep) => clientAccounts.deleteAccount(req, rep));

  // ── Catalog ───────────────────────────────────────────────────────────────
  app.get("/api/v1/salons", (req, rep) => catalog.list(req, rep));
  app.get("/api/v1/salons/:id", (req, rep) => catalog.detail(req, rep));
  app.get("/api/v1/salons/:id/availability", (req, rep) => catalog.availability(req, rep));
  app.get("/api/v1/salons/:id/reviews", (req, rep) => catalog.reviews(req, rep));
  app.get("/api/v1/config/pricing", (req, rep) => catalog.pricing(req, rep));
  app.get("/api/v1/config/support", (req, rep) => catalog.supportConfig(req, rep));

  // ── Favorites ─────────────────────────────────────────────────────────────
  app.get("/api/v1/favorites", (req, rep) => catalog.listFavorites(req, rep));
  app.post("/api/v1/favorites/:salonId", (req, rep) => catalog.addFavorite(req, rep));
  app.delete("/api/v1/favorites/:salonId", (req, rep) => catalog.removeFavorite(req, rep));

  // ── Search ────────────────────────────────────────────────────────────────
  app.get("/api/v1/search/suggestions", (req, rep) => search.suggestions(req, rep));
  app.get("/api/v1/search/salons", (req, rep) => search.search(req, rep));
  app.post("/api/v1/search/events", (req, rep) => search.trackEvents(req, rep));

  // ── Bookings ──────────────────────────────────────────────────────────────
  app.get("/api/v1/bookings", (req, rep) => bookings.list(req, rep));
  app.post("/api/v1/bookings", (req, rep) => bookings.create(req, rep));
  app.get("/api/v1/bookings/:bookingId", (req, rep) => bookings.detail(req, rep));
  app.post("/api/v1/bookings/:bookingId/cancel", (req, rep) => bookings.cancel(req, rep));
  app.post("/api/v1/bookings/:bookingId/reschedule", (req, rep) => bookings.reschedule(req, rep));
  app.post("/api/v1/bookings/:bookingId/review", (req, rep) => bookings.submitReview(req, rep));

  // ── Payments ──────────────────────────────────────────────────────────────
  app.post("/api/v1/payments/deposits/initiate", paymentLimit, (req, rep) => payments.initiate(req, rep));
  app.get("/api/v1/payments/methods", (req, rep) => payments.getMethods(req, rep));
  app.post("/api/v1/payments/deposits/execute", paymentLimit, (req, rep) => payments.executePayment(req, rep));
  app.get("/api/v1/payments/:paymentId", (req, rep) => payments.status(req, rep));
  app.post("/api/v1/payments/:paymentId/reconcile", paymentLimit, (req, rep) => payments.reconcile(req, rep));
  app.post("/api/v1/payments/:paymentId/refund", paymentLimit, (req, rep) => payments.refund(req, rep));
  app.post("/api/v1/payments/webhooks/paydunya", {
    preParsing: async (request, _reply, payload) => {
      const chunks: Buffer[] = [];
      for await (const chunk of payload) chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk as string));
      const raw = Buffer.concat(chunks);
      (request as typeof request & { rawBody: string }).rawBody = raw.toString("utf-8");
      return Readable.from(raw) as typeof payload;
    }
  }, (req, rep) => payments.webhookPayDunya(req, rep));
  app.post("/api/v1/payments/webhooks/paydunya-payout", paymentLimit, (req, rep) => payments.webhookPayDunyaPayout(req, rep));

  // ── Pro ───────────────────────────────────────────────────────────────────
  app.get("/api/v1/pro/dashboard", (req, rep) => pro.dashboard(req, rep));
  app.get("/api/v1/pro/salon", (req, rep) => pro.getSalon(req, rep));
  app.patch("/api/v1/pro/salon", (req, rep) => pro.updateSalon(req, rep));
  app.get("/api/v1/pro/services", (req, rep) => pro.listServices(req, rep));
  app.post("/api/v1/pro/services", (req, rep) => pro.createService(req, rep));
  app.patch("/api/v1/pro/services/:serviceId", (req, rep) => pro.updateService(req, rep));
  app.delete("/api/v1/pro/services/:serviceId", (req, rep) => pro.deleteService(req, rep));
  app.get("/api/v1/pro/staff", (req, rep) => pro.listStaff(req, rep));
  app.post("/api/v1/pro/staff", (req, rep) => pro.createStaff(req, rep));
  app.patch("/api/v1/pro/staff/:employeeId", (req, rep) => pro.updateStaff(req, rep));
  app.delete("/api/v1/pro/staff/:employeeId", (req, rep) => pro.deleteStaff(req, rep));
  app.post("/api/v1/pro/staff/:employeeId/resend-invite", (req, rep) => pro.resendStaffInvite(req, rep));
  app.get("/api/v1/pro/hours", (req, rep) => pro.getHours(req, rep));
  app.put("/api/v1/pro/hours", (req, rep) => pro.updateHours(req, rep));
  app.get("/api/v1/pro/blocked-slots", (req, rep) => pro.listBlockedSlots(req, rep));
  app.post("/api/v1/pro/blocked-slots", (req, rep) => pro.createBlockedSlot(req, rep));
  app.delete("/api/v1/pro/blocked-slots/:slotId", (req, rep) => pro.deleteBlockedSlot(req, rep));
  app.get("/api/v1/pro/bookings", (req, rep) => pro.listBookings(req, rep));
  app.post("/api/v1/pro/bookings/manual", (req, rep) => pro.createManualBooking(req, rep));
  app.get("/api/v1/pro/bookings/:bookingId", (req, rep) => pro.getBooking(req, rep));
  app.post("/api/v1/pro/bookings/:bookingId/accept", (req, rep) => pro.acceptBooking(req, rep));
  app.post("/api/v1/pro/bookings/:bookingId/reject", (req, rep) => pro.rejectBooking(req, rep));
  app.post("/api/v1/pro/bookings/:bookingId/start", (req, rep) => pro.startBooking(req, rep));
  app.post("/api/v1/pro/bookings/:bookingId/complete", (req, rep) => pro.completeBooking(req, rep));
  app.post("/api/v1/pro/bookings/:bookingId/no-show", (req, rep) => pro.markClientNoShow(req, rep));
  app.post("/api/v1/pro/bookings/:bookingId/salon-no-show", (req, rep) => pro.markSalonNoShow(req, rep));
  app.get("/api/v1/pro/clients", (req, rep) => pro.listClients(req, rep));
  app.get("/api/v1/pro/clients/:clientId", (req, rep) => pro.getClient(req, rep));
  app.post("/api/v1/pro/clients/benefits", (req, rep) => clientAccounts.createBenefitForClient(req, rep));
  app.post("/api/v1/pro/vouchers", (req, rep) => clientAccounts.createVoucherDefinition(req, rep));
  app.get("/api/v1/pro/checkout/:bookingId", (req, rep) => pro.getCheckout(req, rep));
  app.post("/api/v1/pro/checkout/:bookingId/complete", (req, rep) => pro.completeCheckout(req, rep));
  app.get("/api/v1/pro/reviews", (req, rep) => pro.listReviews(req, rep));
  app.post("/api/v1/pro/reviews/:reviewId/response", (req, rep) => pro.respondToReview(req, rep));
  app.get("/api/v1/pro/analytics", (req, rep) => pro.analytics(req, rep));
  app.get("/api/v1/pro/subscription/features", (req, rep) => pro.getSubscriptionFeatures(req, rep));
  app.get("/api/v1/pro/subscription", (req, rep) => pro.getSubscription(req, rep));
  app.patch("/api/v1/pro/subscription", (req, rep) => pro.updateSubscription(req, rep));
  app.post("/api/v1/pro/subscription/checkout", (req, rep) => pro.subscriptionCheckout(req, rep));
  app.post("/api/v1/pro/subscription/charge/:chargeId/execute", (req, rep) => pro.executeSubscriptionPayment(req, rep));
  app.post("/api/v1/pro/subscription/cancel-downgrade", (req, rep) => pro.cancelDowngrade(req, rep));
  app.post("/api/v1/pro/subscription/cancel", (req, rep) => pro.cancelSubscription(req, rep));
app.post("/api/v1/pro/subscription/retain", (req, rep) => pro.retainSubscription(req, rep));
  app.get("/api/v1/pro/subscription/charge/:chargeId/status", (req, rep) => pro.getChargeStatus(req, rep));
  app.get("/api/v1/pro/payouts", (req, rep) => pro.listPayouts(req, rep));
  app.get("/api/v1/pro/payout-settings", (req, rep) => pro.getPayoutSettings(req, rep));
  app.patch("/api/v1/pro/payout-settings", (req, rep) => pro.updatePayoutSettings(req, rep));
  app.get("/api/v1/pro/merchant-payouts", (req, rep) => pro.listMerchantPayouts(req, rep));
  app.get("/api/v1/pro/invoices", (req, rep) => pro.listInvoices(req, rep));
  app.get("/api/v1/pro/invoices/:invoiceId/pdf", (req, rep) => pro.downloadInvoicePdf(req, rep));

  // ── Notifications ─────────────────────────────────────────────────────────
  app.get("/api/v1/notifications", (req, rep) => notifications.list(req, rep));
  app.post("/api/v1/notifications/:id/read", (req, rep) => notifications.markRead(req, rep));
  app.post("/api/v1/notifications/read-all", (req, rep) => notifications.markAllRead(req, rep));
  app.post("/api/v1/push-tokens", (req, rep) => notifications.registerPushToken(req, rep));
  app.delete("/api/v1/push-tokens/:tokenId", (req, rep) => notifications.revokePushToken(req, rep));

  // ── Media ─────────────────────────────────────────────────────────────────
  app.post("/api/v1/media/upload", (req, rep) => media.upload(req, rep));
  app.post("/api/v1/media/upload-intent", (req, rep) => media.uploadIntent(req, rep));
  app.post("/api/v1/media/:mediaId/complete", (req, rep) => media.completeUpload(req, rep));
  app.get("/api/v1/media/:mediaId", (req, rep) => media.get(req, rep));
  app.delete("/api/v1/media/:mediaId", (req, rep) => media.delete(req, rep));
  app.get("/api/v1/salons/:salonId/public-media", (req, rep) => media.getPublicMedia(req, rep));
  app.get("/api/v1/salons/media/:mediaId/public", (req, rep) => media.getPublicFile(req, rep));

  // ── Admin Media ───────────────────────────────────────────────────────────
  app.get("/api/v1/admin/media/pending", (req, rep) => adminMedia.listPending(req, rep));
  app.post("/api/v1/admin/media/:mediaId/signed-view-url", (req, rep) => adminMedia.signedViewUrl(req, rep));
  app.post("/api/v1/admin/media/:mediaId/approve", (req, rep) => adminMedia.approve(req, rep));
  app.post("/api/v1/admin/media/:mediaId/reject", (req, rep) => adminMedia.reject(req, rep));

  // ── Admin ─────────────────────────────────────────────────────────────────
  app.get("/api/v1/admin/dashboard", (req, rep) => admin.dashboard(req, rep));
  app.get("/api/v1/admin/salons", (req, rep) => admin.listSalons(req, rep));
  app.get("/api/v1/admin/salons/pending", (req, rep) => admin.listPendingSalons(req, rep));
  app.get("/api/v1/admin/salons/check-uniqueness", (req, rep) => admin.checkUniqueness(req, rep));
  app.get("/api/v1/admin/salons/:salonId", (req, rep) => admin.salonDetail(req, rep));
  app.post("/api/v1/admin/salons", adminMutationLimit, (req, rep) => admin.createSalon(req, rep));
  app.post("/api/v1/admin/salons/:salonId/approve", adminMutationLimit, (req, rep) => admin.approveSalon(req, rep));
  app.post("/api/v1/admin/salons/:salonId/reject", adminMutationLimit, (req, rep) => admin.rejectSalon(req, rep));
  app.post("/api/v1/admin/salons/:salonId/request-info", adminMutationLimit, (req, rep) => admin.requestSalonInfo(req, rep));
  app.post("/api/v1/admin/salons/:salonId/send-password-reset", adminMutationLimit, (req, rep) => admin.sendPasswordReset(req, rep));
  app.post("/api/v1/admin/salons/:salonId/send-magic-link", adminMutationLimit, (req, rep) => admin.sendMagicLink(req, rep));
  app.get("/api/v1/admin/subscriptions/cancellation-stats", (req, rep) => admin.cancellationStats(req, rep));
  app.get("/api/v1/admin/subscriptions", (req, rep) => admin.listSubscriptions(req, rep));
  app.get("/api/v1/admin/subscriptions/:subscriptionId", (req, rep) => admin.subscriptionDetail(req, rep));
  app.post("/api/v1/admin/subscriptions/:subscriptionId/override", adminMutationLimit, (req, rep) => admin.overrideSubscription(req, rep));
  app.post("/api/v1/admin/subscriptions/:subscriptionId/manual-extend", adminMutationLimit, (req, rep) => admin.manualExtendSubscription(req, rep));
  app.get("/api/v1/admin/invoices/:invoiceId/pdf", (req, rep) => admin.downloadInvoicePdf(req, rep));
  app.get("/api/v1/admin/audit", (req, rep) => admin.listAudit(req, rep));
  app.get("/api/v1/admin/audit/email", (req, rep) => admin.listEmailAudit(req, rep));
  app.get("/api/v1/admin/audit/:auditId", (req, rep) => admin.auditDetail(req, rep));
  app.get("/api/v1/admin/config/settings", (req, rep) => admin.listSettings(req, rep));
  app.patch("/api/v1/admin/config/settings/:key", adminMutationLimit, (req, rep) => admin.updateSetting(req, rep));
  app.post("/api/v1/admin/paydunya/sandbox-test", adminMutationLimit, (req, rep) => admin.paydunyaSandboxTest(req, rep));
  app.get("/api/v1/admin/config/categories", (req, rep) => admin.listCategories(req, rep));
  app.post("/api/v1/admin/config/categories", adminMutationLimit, (req, rep) => admin.upsertCategory(req, rep));
  app.delete("/api/v1/admin/config/categories/:id", adminMutationLimit, (req, rep) => admin.deleteCategory(req, rep));
  app.get("/api/v1/admin/config/service-suggestions", (req, rep) => admin.listServiceSuggestions(req, rep));
  app.post("/api/v1/admin/config/service-suggestions", adminMutationLimit, (req, rep) => admin.upsertServiceSuggestion(req, rep));
  app.delete("/api/v1/admin/config/service-suggestions/:id", adminMutationLimit, (req, rep) => admin.deleteServiceSuggestion(req, rep));
  app.get("/api/v1/admin/config/documents", (req, rep) => admin.listDocuments(req, rep));
  app.post("/api/v1/admin/config/documents", adminMutationLimit, (req, rep) => admin.upsertDocument(req, rep));
  app.delete("/api/v1/admin/config/documents/:id", adminMutationLimit, (req, rep) => admin.deleteDocument(req, rep));

  // ── Admin Salon Services ──────────────────────────────────────────────────
  app.get("/api/v1/admin/salons/:salonId/services", (req, rep) => admin.listSalonServices(req, rep));
  app.post("/api/v1/admin/salons/:salonId/services", adminMutationLimit, (req, rep) => admin.createSalonService(req, rep));
  app.patch("/api/v1/admin/salons/:salonId/services/:serviceId", adminMutationLimit, (req, rep) => admin.updateSalonService(req, rep));
  app.delete("/api/v1/admin/salons/:salonId/services/:serviceId", adminMutationLimit, (req, rep) => admin.deleteSalonService(req, rep));

  // Admin Payouts
  app.get("/api/v1/admin/payouts", (req, rep) => admin.listMerchantPayoutsAdmin(req, rep));
  app.get("/api/v1/admin/payouts/verification-queue", (req, rep) => admin.listPayoutVerificationQueue(req, rep));
  app.get("/api/v1/admin/payouts/:payoutId", (req, rep) => admin.payoutDetail(req, rep));
  app.post("/api/v1/admin/payouts/:payoutId/reconcile", paymentLimit, (req, rep) => admin.reconcilePayout(req, rep));
  app.post("/api/v1/admin/payouts/:payoutId/retry", paymentLimit, (req, rep) => admin.retryPayoutEndpoint(req, rep));
  app.post("/api/v1/admin/payouts/:payoutId/approve", paymentLimit, (req, rep) => admin.approvePayoutEndpoint(req, rep));
  app.post("/api/v1/admin/payouts/:payoutId/cancel", paymentLimit, (req, rep) => admin.cancelPayoutEndpoint(req, rep));
  app.post("/api/v1/admin/salons/:salonId/payout-settings/verify", paymentLimit, (req, rep) => admin.verifySalonPayoutSettings(req, rep));
}
