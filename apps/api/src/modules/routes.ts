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
  app.post("/api/v1/auth/register", authLimit, (req, rep) => auth.register(req, rep));
  app.post("/api/v1/auth/login", authLimit, (req, rep) => auth.login(req, rep));
  const uploadDocLimit = { config: { rateLimit: { max: isDevOrTest ? 200000 : 2000, timeWindow: "1 minute" } } };
  app.post("/api/v1/auth/upload-registration-doc", uploadDocLimit, (req, rep) => media.uploadRegistrationDoc(req, rep));
  app.get("/api/v1/platform/registration-docs", (req, rep) => admin.listDocumentsPublic(req, rep));
  app.get("/api/v1/platform/categories", (req, rep) => admin.listCategoriesPublic(req, rep));
  app.get("/api/v1/platform/check-uniqueness", (req, rep) => admin.checkUniquenessPublic(req, rep));
  app.post("/api/v1/auth/otp/request", otpLimit, (req, rep) => auth.requestOtp(req, rep));
  app.post("/api/v1/auth/otp/verify", otpLimit, (req, rep) => auth.verifyOtp(req, rep));
  app.post("/api/v1/auth/otp/email/request", otpLimit, (req, rep) => auth.requestEmailOtp(req, rep));
  app.post("/api/v1/auth/otp/email/verify", otpLimit, (req, rep) => auth.verifyEmailOtp(req, rep));
  app.post("/api/v1/auth/refresh", authLimit, (req, rep) => auth.refresh(req, rep));
  app.post("/api/v1/auth/staff-invite/redeem", authLimit, (req, rep) => auth.redeemStaffInvite(req, rep));
  app.post("/api/v1/auth/logout", (req, rep) => auth.logout(req, rep));
  app.post("/api/v1/auth/setup-account", authLimit, (req, rep) => auth.setupAccount(req, rep));
  app.post("/api/v1/auth/reset-password", authLimit, (req, rep) => auth.resetPassword(req, rep));
  app.post("/api/v1/auth/magic-login", authLimit, (req, rep) => auth.magicLogin(req, rep));
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

  // ── Favorites ─────────────────────────────────────────────────────────────
  app.get("/api/v1/favorites", (req, rep) => catalog.listFavorites(req, rep));
  app.post("/api/v1/favorites/:salonId", (req, rep) => catalog.addFavorite(req, rep));
  app.delete("/api/v1/favorites/:salonId", (req, rep) => catalog.removeFavorite(req, rep));

  // ── Bookings ──────────────────────────────────────────────────────────────
  app.get("/api/v1/bookings", (req, rep) => bookings.list(req, rep));
  app.post("/api/v1/bookings", (req, rep) => bookings.create(req, rep));
  app.get("/api/v1/bookings/:bookingId", (req, rep) => bookings.detail(req, rep));
  app.post("/api/v1/bookings/:bookingId/cancel", (req, rep) => bookings.cancel(req, rep));
  app.post("/api/v1/bookings/:bookingId/reschedule", (req, rep) => bookings.reschedule(req, rep));
  app.post("/api/v1/bookings/:bookingId/review", (req, rep) => bookings.submitReview(req, rep));

  // ── Payments ──────────────────────────────────────────────────────────────
  app.post("/api/v1/payments/deposits/initiate", (req, rep) => payments.initiate(req, rep));
  app.get("/api/v1/payments/methods", (req, rep) => payments.getMethods(req, rep));
  app.post("/api/v1/payments/deposits/execute", (req, rep) => payments.executePayment(req, rep));
  app.get("/api/v1/payments/:paymentId", (req, rep) => payments.status(req, rep));
  app.post("/api/v1/payments/:paymentId/reconcile", (req, rep) => payments.reconcile(req, rep));
  app.post("/api/v1/payments/webhooks/paydunya", {
    preParsing: async (request, _reply, payload) => {
      const chunks: Buffer[] = [];
      for await (const chunk of payload) chunks.push(Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk as string));
      const raw = Buffer.concat(chunks);
      (request as typeof request & { rawBody: string }).rawBody = raw.toString("utf-8");
      return Readable.from(raw) as typeof payload;
    }
  }, (req, rep) => payments.webhookPayDunya(req, rep));
  app.post("/api/v1/payments/:paymentId/refund", (req, rep) => payments.refund(req, rep));

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
  app.post("/api/v1/admin/salons", (req, rep) => admin.createSalon(req, rep));
  app.post("/api/v1/admin/salons/:salonId/approve", (req, rep) => admin.approveSalon(req, rep));
  app.post("/api/v1/admin/salons/:salonId/reject", (req, rep) => admin.rejectSalon(req, rep));
  app.post("/api/v1/admin/salons/:salonId/request-info", (req, rep) => admin.requestSalonInfo(req, rep));
  app.post("/api/v1/admin/salons/:salonId/send-password-reset", (req, rep) => admin.sendPasswordReset(req, rep));
  app.post("/api/v1/admin/salons/:salonId/send-magic-link", (req, rep) => admin.sendMagicLink(req, rep));
  app.get("/api/v1/admin/subscriptions/cancellation-stats", (req, rep) => admin.cancellationStats(req, rep));
  app.get("/api/v1/admin/subscriptions", (req, rep) => admin.listSubscriptions(req, rep));
  app.get("/api/v1/admin/subscriptions/:subscriptionId", (req, rep) => admin.subscriptionDetail(req, rep));
  app.post("/api/v1/admin/subscriptions/:subscriptionId/override", (req, rep) => admin.overrideSubscription(req, rep));
  app.post("/api/v1/admin/subscriptions/:subscriptionId/manual-extend", (req, rep) => admin.manualExtendSubscription(req, rep));
  app.get("/api/v1/admin/invoices/:invoiceId/pdf", (req, rep) => admin.downloadInvoicePdf(req, rep));
  app.get("/api/v1/admin/audit", (req, rep) => admin.listAudit(req, rep));
  app.get("/api/v1/admin/audit/email", (req, rep) => admin.listEmailAudit(req, rep));
  app.get("/api/v1/admin/audit/:auditId", (req, rep) => admin.auditDetail(req, rep));
  app.get("/api/v1/admin/config/settings", (req, rep) => admin.listSettings(req, rep));
  app.patch("/api/v1/admin/config/settings/:key", (req, rep) => admin.updateSetting(req, rep));
  app.post("/api/v1/admin/paydunya/sandbox-test", (req, rep) => admin.paydunyaSandboxTest(req, rep));
  app.get("/api/v1/admin/config/categories", (req, rep) => admin.listCategories(req, rep));
  app.post("/api/v1/admin/config/categories", (req, rep) => admin.upsertCategory(req, rep));
  app.delete("/api/v1/admin/config/categories/:id", (req, rep) => admin.deleteCategory(req, rep));
  app.get("/api/v1/admin/config/documents", (req, rep) => admin.listDocuments(req, rep));
  app.post("/api/v1/admin/config/documents", (req, rep) => admin.upsertDocument(req, rep));
  app.delete("/api/v1/admin/config/documents/:id", (req, rep) => admin.deleteDocument(req, rep));
}
