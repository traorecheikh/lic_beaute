import { createRouter, createWebHistory } from "vue-router";

import AdminLayout from "@/layouts/AdminLayout.vue";
import ProLayout from "@/layouts/ProLayout.vue";
import { useAdminAuthStore } from "@/stores/adminAuth";
import { useProAuthStore } from "@/stores/proAuth";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      component: () => import("@/views/LandingPage.vue")
    },
    // --- Public Pro Routes ---
    {
      path: "/pro",
      name: "pro-acquisition",
      component: () => import("@/views/ProAcquisitionPage.vue")
    },
    {
      path: "/pro/register",
      name: "pro-register",
      component: () => import("@/views/ProRegistrationPage.vue")
    },
    {
      path: "/pro/login",
      name: "pro-login",
      component: () => import("@/views/ProLoginPage.vue")
    },
    {
      path: "/pro/setup-account",
      name: "pro-setup-account",
      component: () => import("@/views/ProSetupAccountPage.vue")
    },
    {
      path: "/pro/reset-password",
      name: "pro-reset-password",
      component: () => import("@/views/ProResetPasswordPage.vue")
    },
    {
      path: "/pro/magic-login",
      name: "pro-magic-login",
      component: () => import("@/views/ProMagicLoginPage.vue")
    },
    {
      path: "/payment/callback",
      name: "payment-callback",
      component: () => import("@/views/PaymentCallbackPage.vue")
    },
    // --- Protected Pro Routes ---
    {
      path: "/pro",
      meta: { requiresPro: true },
      component: ProLayout,
      children: [
        {
          path: "calendar",
          name: "pro-calendar",
          component: () => import("@/views/ProCalendarPage.vue")
        },
        {
          path: "dashboard",
          name: "pro-dashboard",
          component: () => import("@/views/ProDashboardPage.vue")
        },
        {
          path: "bookings/inbox",
          name: "pro-bookings-inbox",
          component: () => import("@/views/ProBookingInboxPage.vue")
        },
        {
          path: "checkout/:bookingId",
          name: "pro-checkout",
          component: () => import("@/views/ProCheckoutPage.vue")
        },
        {
          path: "clients",
          name: "pro-clients",
          component: () => import("@/views/ProClientsPage.vue")
        },
        // Vouchers hidden — promos feature disabled
        // {
        //   path: "vouchers",
        //   name: "pro-vouchers",
        //   component: () => import("@/views/ProVouchersPage.vue"),
        //   meta: { requiresAuth: true, roles: ["salon_owner"] }
        // },
        {
          path: "analytics",
          name: "pro-analytics",
          component: () => import("@/views/ProAnalyticsPage.vue")
        },
        {
          path: "subscription",
          name: "pro-subscription",
          component: () => import("@/views/ProBillingPage.vue")
        },
        {
          path: "subscription/callback",
          name: "pro-subscription-callback",
          component: () => import("@/views/SubscriptionCallback.vue")
        },
        {
          path: "payouts",
          name: "pro-payouts",
          component: () => import("@/views/ProPayoutsPage.vue")
        },
        // Salon management (Owner only)
        {
          path: "salon/profile",
          name: "pro-salon-profile",
          meta: { requiresOwner: true },
          component: () => import("@/views/ProSalonProfilePage.vue")
        },
        {
          path: "salon/services",
          name: "pro-salon-services",
          meta: { requiresOwner: true },
          component: () => import("@/views/ProServicesPage.vue")
        },
        {
          path: "salon/team",
          name: "pro-salon-team",
          meta: { requiresOwner: true },
          component: () => import("@/views/ProTeamPage.vue")
        },
        {
          path: "salon/hours",
          name: "pro-salon-hours",
          meta: { requiresOwner: true },
          component: () => import("@/views/ProHoursPage.vue")
        },
        {
          path: "account",
          name: "pro-account",
          component: () => import("@/views/ProAccountPage.vue")
        },
        {
          path: "approval-status",
          name: "pro-approval-status",
          component: () => import("@/views/ProApprovalStatusPage.vue")
        }
      ]
    },
    // --- Admin Routes ---
    {
      path: "/admin/login",
      name: "admin-login",
      component: () => import("@/views/AdminLoginPage.vue")
    },
    {
      path: "/admin",
      meta: { requiresAdmin: true },
      component: AdminLayout,
      children: [
        {
          path: "",
          redirect: "/admin/dashboard"
        },
        {
          path: "dashboard",
          name: "admin-dashboard",
          component: () => import("@/views/AdminDashboardPage.vue")
        },
        {
          path: "salons",
          name: "admin-salons",
          component: () => import("@/views/SalonApprovalPage.vue")
        },
        {
          path: "salons/new",
          name: "admin-salon-create",
          component: () => import("@/views/SalonCreatePage.vue")
        },
        {
          path: "salons/:salonId",
          name: "admin-salon-detail",
          component: () => import("@/views/SalonApprovalDetailPage.vue")
        },
        {
          path: "subscriptions",
          name: "admin-subscriptions",
          component: () => import("@/views/SubscriptionsPage.vue")
        },
        {
          path: "subscriptions/:subscriptionId",
          name: "admin-subscription-detail",
          component: () => import("@/views/SubscriptionDetailPage.vue")
        },
        {
          path: "audit",
          name: "admin-audit",
          component: () => import("@/views/AuditPage.vue")
        },
        {
          path: "audit/:auditId",
          name: "admin-audit-detail",
          component: () => import("@/views/AuditDetailPage.vue")
        },
        {
          path: "config",
          name: "admin-config",
          component: () => import("@/views/ConfigurationPage.vue")
        },
        {
          path: "account",
          name: "admin-account",
          component: () => import("@/views/AdminAccountPage.vue")
        }
      ]
    },
  ]
});

router.beforeEach(async (to) => {
  const adminAuth = useAdminAuthStore();
  const proAuth = useProAuthStore();
  const hadAdminToken = Boolean(adminAuth.accessToken);
  const hadProToken = Boolean(proAuth.accessToken);

  // Restore sessions if not initialized
  if (!adminAuth.initialized) await adminAuth.restoreSession();
  if (!proAuth.initialized) await proAuth.restoreSession();

  // Admin protection
  if (to.meta.requiresAdmin && !adminAuth.isAuthenticated) {
    return {
      name: "admin-login",
      query: {
        redirect: to.fullPath,
        ...(hadAdminToken ? { expired: "1" } : {})
      }
    };
  }

  // Pro protection
  if (to.meta.requiresPro && !proAuth.isAuthenticated) {
    return {
      name: "pro-login",
      query: {
        redirect: to.fullPath,
        ...(hadProToken ? { expired: "1" } : {})
      }
    };
  }

  // Approval guard — block access to pro features until salon is approved
  const approvalStatus = proAuth.salonApprovalStatus;
  if (
    to.meta.requiresPro &&
    proAuth.isAuthenticated &&
    to.name !== "pro-approval-status" &&
    approvalStatus !== null &&
    approvalStatus !== "approved"
  ) {
    return { name: "pro-approval-status" };
  }

  // Owner protection
  if (to.meta.requiresOwner && !proAuth.isOwner) {
    return { name: "pro-calendar" };
  }

  // Prevent logged in users from visiting login pages
  if (to.name === "admin-login" && adminAuth.isAuthenticated) {
    return { name: "admin-dashboard" };
  }
  if (to.name === "pro-login" && proAuth.isAuthenticated) {
    return { name: "pro-calendar" };
  }

  return true;
});

export default router;
