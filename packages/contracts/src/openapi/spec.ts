import { z } from "zod";
import { zodToJsonSchema } from "zod-to-json-schema";

import {
  adminAuditDetailSchema,
  adminAuditFiltersSchema,
  adminAuditSummarySchema,
  adminDashboardSchema,
  adminSalonCreateInputSchema,
  adminSalonDecisionSchema,
  adminSalonDetailSchema,
  adminSalonQueueFiltersSchema,
  adminSalonQueueItemSchema,
  adminSubscriptionDetailSchema,
  adminSubscriptionOverrideSchema,
  adminSubscriptionSummarySchema
} from "../domain/admin.js";
import {
  authSessionSchema,
  currentUserSchema,
  emailLoginSchema,
  emailOtpRequestSchema,
  emailOtpVerifySchema,
  emailOtpAcceptedResponseSchema,
  otpRequestSchema,
  otpVerifySchema,
  refreshInputSchema,
  registerInputSchema,
  updateMeInputSchema
} from "../domain/auth.js";
import { bookingCreateSchema, bookingRescheduleSchema, bookingSummarySchema } from "../domain/booking.js";
import { reviewCreateInputSchema, reviewSchema } from "../domain/review.js";
import {
  clientAddressCreateSchema,
  clientAddressListResponseSchema,
  clientAddressSchema,
  clientAddressUpdateSchema,
  clientBenefitSchema,
  clientPaymentMethodCreateSchema,
  clientPaymentMethodSchema,
  clientPaymentMethodUpdateSchema,
  clientVoucherSchema,
  profileOptionsSchema,
  proClientBenefitCreateSchema,
  proVoucherCreateSchema,
  redeemVoucherInputSchema
} from "../domain/profile.js";
import {
  availabilitySlotSchema,
  proAnalyticsSchema,
  proBlockedSlotCreateInputSchema,
  proBlockedSlotSchema,
  proBookingDetailSchema,
  proBookingFullDetailSchema,
  proBookingStatusUpdateSchema,
  proCheckoutCompleteInputSchema,
  proCheckoutCompleteResultSchema,
  proCheckoutDetailsSchema,
  proClientDetailSchema,
  proClientSummarySchema,
  proDashboardSchema,
  proHoursUpdateInputSchema,
  proInvoiceSchema,
  proManualBookingCreatedSchema,
  proManualBookingInputSchema,
  proPayoutEventSchema,
  proReviewSchema,
  proReviewResponseInputSchema,
  proSalonHourSchema,
  proSalonProfileSchema,
  proSalonUpdateInputSchema,
  proServiceCreateInputSchema,
  proServiceSchema,
  proServiceUpdateInputSchema,
  proStaffCreateInputSchema,
  proStaffMemberSchema,
  proStaffUpdateInputSchema,
  proSubscriptionCheckoutInputSchema,
  proSubscriptionCheckoutResultSchema,
  proSubscriptionSchema,
  proSubscriptionUpdateInputSchema
} from "../domain/pro.js";
import { salonDetailSchema, salonSummarySchema } from "../domain/salon.js";
import { favoriteItemSchema, favoriteListResponseSchema } from "../domain/favorite.js";
import {
  paymentInitiateInputSchema,
  paymentInitiateResponseSchema,
  paymentStatusResponseSchema,
  paymentReconcileResponseSchema,
  paymentWebhookBodySchema,
  paydunyaMethodListResponseSchema,
  paydunyaTransactionExecuteInputSchema,
  paydunyaTransactionExecuteResponseSchema,
  proSubscriptionExecuteInputSchema,
  proSubscriptionExecuteResponseSchema
} from "../domain/payment.js";
import { pushTokenRegisterSchema } from "../domain/notification.js";
import { mediaUploadResponseSchema, mediaAssetSchema } from "../domain/media.js";
import { apiErrorSchema, paginatedResponse } from "../http/common.js";

type JsonSchema = Record<string, unknown>;

type Operation = {
  tags: string[];
  summary: string;
  security?: Array<Record<string, string[]>>;
  parameters?: Array<Record<string, unknown>>;
  requestBody?: Record<string, unknown>;
  responses: Record<string, unknown>;
};

const toOpenApiSchema = (schema: Parameters<typeof zodToJsonSchema>[0], name?: string): JsonSchema => {
  const result = zodToJsonSchema(schema, {
    name,
    target: "openApi3",
    $refStrategy: "none"
  }) as Record<string, unknown>;

  if (name && result.$ref === `#/definitions/${name}` && result.definitions) {
    const defs = result.definitions as Record<string, JsonSchema>;
    if (defs[name]) return defs[name];
  }

  return result as JsonSchema;
};

const ref = (name: string) => ({ $ref: `#/components/schemas/${name}` });

const withBearer = (operation: Operation): Operation => ({
  ...operation,
  security: [{ bearerAuth: [] }]
});

const pathParam = (name: string, description: string) => ({
  name,
  in: "path",
  required: true,
  description,
  schema: { type: "string" }
});

const queryParam = (name: string, type: "string" | "integer" = "string") => ({
  name,
  in: "query",
  required: false,
  schema: type === "integer" ? { type: "integer" } : { type: "string" }
});

const deletedResponseSchema = z.object({ deleted: z.boolean() });
const updatedResponseSchema = z.object({ updated: z.boolean() });
const acceptedOtpResponseSchema = z.object({
  accepted: z.boolean(),
  channel: z.string(),
  destination: z.string()
});

const adminSalonQueueResponseSchema = paginatedResponse(adminSalonQueueItemSchema);
const adminAuditSummaryListResponseSchema = paginatedResponse(adminAuditSummarySchema);
const adminSubscriptionListResponseSchema = z.object({
  summary: z.object({
    premiumCount: z.number().int().nonnegative(),
    standardCount: z.number().int().nonnegative(),
    pausedCount: z.number().int().nonnegative()
  }),
  items: z.array(adminSubscriptionSummarySchema),
  total: z.number().int().nonnegative()
});

const schemaEntries = {
  ApiError: apiErrorSchema,

  RegisterInput: registerInputSchema,
  EmailLoginInput: emailLoginSchema,
  OtpRequestInput: otpRequestSchema,
  OtpVerifyInput: otpVerifySchema,
  RefreshInput: refreshInputSchema,
  UpdateMeInput: updateMeInputSchema,
  AuthSession: authSessionSchema,
  LogoutResponse: z.object({ revoked: z.boolean() }),
  OtpAcceptedResponse: acceptedOtpResponseSchema,
  EmailOtpRequestInput: emailOtpRequestSchema,
  EmailOtpVerifyInput: emailOtpVerifySchema,
  EmailOtpAcceptedResponse: emailOtpAcceptedResponseSchema,
  CurrentUser: currentUserSchema,
  ProfileOptions: profileOptionsSchema,
  ClientPaymentMethod: clientPaymentMethodSchema,
  ClientPaymentMethodCreateInput: clientPaymentMethodCreateSchema,
  ClientPaymentMethodUpdateInput: clientPaymentMethodUpdateSchema,
  ClientBenefit: clientBenefitSchema,
  ClientVoucher: clientVoucherSchema,
  RedeemVoucherInput: redeemVoucherInputSchema,
  ProClientBenefitCreateInput: proClientBenefitCreateSchema,
  ProVoucherCreateInput: proVoucherCreateSchema,

  SalonSummary: salonSummarySchema,
  SalonSummaryListResponse: paginatedResponse(salonSummarySchema),
  SalonDetail: salonDetailSchema,
  FavoriteItem: favoriteItemSchema,
  FavoriteListResponse: favoriteListResponseSchema,

  BookingCreateInput: bookingCreateSchema,
  BookingSummary: bookingSummarySchema,
  BookingSummaryListResponse: paginatedResponse(bookingSummarySchema),
  BookingRescheduleInput: bookingRescheduleSchema,

  AdminDashboard: adminDashboardSchema,
  AdminSalonQueueFilters: adminSalonQueueFiltersSchema,
  AdminSalonQueueItem: adminSalonQueueItemSchema,
  AdminSalonQueueResponse: adminSalonQueueResponseSchema,
  AdminSalonDetail: adminSalonDetailSchema,
  AdminSalonDecisionInput: adminSalonDecisionSchema,
  AdminSubscriptionSummary: adminSubscriptionSummarySchema,
  AdminSubscriptionListResponse: adminSubscriptionListResponseSchema,
  AdminSubscriptionDetail: adminSubscriptionDetailSchema,
  AdminSubscriptionOverrideInput: adminSubscriptionOverrideSchema,
  AdminAuditFilters: adminAuditFiltersSchema,
  AdminAuditSummary: adminAuditSummarySchema,
  AdminAuditSummaryListResponse: adminAuditSummaryListResponseSchema,
  AdminAuditDetail: adminAuditDetailSchema,

  ProDashboard: proDashboardSchema,
  ProSalonProfile: proSalonProfileSchema,
  ProSalonUpdateInput: proSalonUpdateInputSchema,
  ProService: proServiceSchema,
  ProServiceCreateInput: proServiceCreateInputSchema,
  ProServiceUpdateInput: proServiceUpdateInputSchema,
  ProStaffMember: proStaffMemberSchema,
  ProStaffCreateInput: proStaffCreateInputSchema,
  ProStaffUpdateInput: proStaffUpdateInputSchema,
  ProSalonHour: proSalonHourSchema,
  ProHoursUpdateInput: proHoursUpdateInputSchema,
  ProBlockedSlot: proBlockedSlotSchema,
  ProBlockedSlotCreateInput: proBlockedSlotCreateInputSchema,
  ProBookingDetail: proBookingDetailSchema,
  ProBookingFullDetail: proBookingFullDetailSchema,
  ProBookingStatusUpdate: proBookingStatusUpdateSchema,
  ProManualBookingInput: proManualBookingInputSchema,
  ProManualBookingCreated: proManualBookingCreatedSchema,
  ProClientSummary: proClientSummarySchema,
  ProClientDetail: proClientDetailSchema,
  ProCheckoutDetails: proCheckoutDetailsSchema,
  ProCheckoutCompleteInput: proCheckoutCompleteInputSchema,
  ProCheckoutCompleteResult: proCheckoutCompleteResultSchema,
  ProReview: proReviewSchema,
  ProReviewResponseInput: proReviewResponseInputSchema,
  ProAnalytics: proAnalyticsSchema,
  ProSubscription: proSubscriptionSchema,
  ProSubscriptionUpdateInput: proSubscriptionUpdateInputSchema,
  ProSubscriptionCheckoutInput: proSubscriptionCheckoutInputSchema,
  ProSubscriptionCheckoutResult: proSubscriptionCheckoutResultSchema,
  ProPayoutEvent: proPayoutEventSchema,
  ProInvoice: proInvoiceSchema,

  PaymentInitiateInput: paymentInitiateInputSchema,
  PaymentInitiateResponse: paymentInitiateResponseSchema,
  PaymentStatusResponse: paymentStatusResponseSchema,
  PaymentReconcileResponse: paymentReconcileResponseSchema,
  PaymentWebhookBody: paymentWebhookBodySchema,
  PaydunyaMethodListResponse: paydunyaMethodListResponseSchema,
  PaydunyaExecutePaymentInput: paydunyaTransactionExecuteInputSchema,
  PaydunyaExecutePaymentResponse: paydunyaTransactionExecuteResponseSchema,
  ProSubscriptionExecuteInput: proSubscriptionExecuteInputSchema,
  ProSubscriptionExecuteResponse: proSubscriptionExecuteResponseSchema,

  PushTokenInput: pushTokenRegisterSchema,

  MediaUploadResponse: mediaUploadResponseSchema,
  MediaAsset: mediaAssetSchema,

  UpdatedResponse: updatedResponseSchema,
  DeletedResponse: deletedResponseSchema
} as const;

const componentsSchemas = Object.fromEntries(
  Object.entries(schemaEntries).map(([name, schema]) => [name, toOpenApiSchema(schema, name)])
);

export const openApiSpec = {
  openapi: "3.0.3",
  info: {
    title: "Beauté Avenue API",
    version: "0.1.0",
    description: "Contract v1 for the Beauté Avenue modular monolith."
  },
  servers: [{ url: "http://localhost:3000" }],
  components: {
    securitySchemes: {
      bearerAuth: {
        type: "http",
        scheme: "bearer",
        bearerFormat: "JWT"
      }
    },
    schemas: componentsSchemas
  },
  paths: {
    "/health": {
      get: {
        tags: ["health"],
        summary: "Healthcheck",
        responses: {
          200: {
            description: "Healthy service",
            content: {
              "application/json": {
                schema: {
                  type: "object",
                  properties: {
                    status: { type: "string" },
                    timestamp: { type: "string", format: "date-time" },
                    database: {
                      type: "object",
                      properties: {
                        driver: { type: "string" },
                        mode: { type: "string" },
                        attempts: { type: "integer" }
                      }
                    }
                  },
                  required: ["status", "timestamp", "database"]
                }
              }
            }
          }
        }
      }
    },

    "/api/v1/auth/register": {
      post: {
        tags: ["auth"],
        summary: "Register client or salon owner",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("RegisterInput")
            }
          }
        },
        responses: {
          201: {
            description: "Authenticated session",
            content: {
              "application/json": {
                schema: ref("AuthSession")
              }
            }
          },
          409: {
            description: "Duplicate account",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      }
    },
    "/api/v1/auth/login": {
      post: {
        tags: ["auth"],
        summary: "Email login",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("EmailLoginInput")
            }
          }
        },
        responses: {
          200: {
            description: "Authenticated session",
            content: {
              "application/json": {
                schema: ref("AuthSession")
              }
            }
          },
          401: {
            description: "Invalid credentials",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      }
    },
    "/api/v1/auth/otp/request": {
      post: {
        tags: ["auth"],
        summary: "Request an OTP code",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("OtpRequestInput")
            }
          }
        },
        responses: {
          202: {
            description: "OTP request accepted",
            content: {
              "application/json": {
                schema: ref("OtpAcceptedResponse")
              }
            }
          }
        }
      }
    },
    "/api/v1/auth/otp/verify": {
      post: {
        tags: ["auth"],
        summary: "Verify OTP",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("OtpVerifyInput")
            }
          }
        },
        responses: {
          200: {
            description: "Authenticated session",
            content: {
              "application/json": {
                schema: ref("AuthSession")
              }
            }
          }
        }
      }
    },
    "/api/v1/auth/otp/email/request": {
      post: {
        tags: ["auth"],
        summary: "Request an OTP code via email",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("EmailOtpRequestInput")
            }
          }
        },
        responses: {
          202: {
            description: "OTP request accepted",
            content: {
              "application/json": {
                schema: ref("EmailOtpAcceptedResponse")
              }
            }
          },
          409: {
            description: "Email already in use",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      }
    },
    "/api/v1/auth/otp/email/verify": {
      post: {
        tags: ["auth"],
        summary: "Verify email OTP and create/login client",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("EmailOtpVerifyInput")
            }
          }
        },
        responses: {
          200: {
            description: "Authenticated session",
            content: {
              "application/json": {
                schema: ref("AuthSession")
              }
            }
          },
          401: {
            description: "Invalid or expired code",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      }
    },
    "/api/v1/auth/refresh": {
      post: {
        tags: ["auth"],
        summary: "Refresh access token",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("RefreshInput")
            }
          }
        },
        responses: {
          200: {
            description: "Refreshed session",
            content: {
              "application/json": {
                schema: ref("AuthSession")
              }
            }
          },
          401: {
            description: "Session expired",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      }
    },
    "/api/v1/auth/logout": {
      post: withBearer({
        tags: ["auth"],
        summary: "Logout current session",
        requestBody: {
          required: false,
          content: {
            "application/json": {
              schema: ref("RefreshInput")
            }
          }
        },
        responses: {
          200: {
            description: "Session revoked",
            content: {
              "application/json": {
                schema: ref("LogoutResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/me": {
      get: withBearer({
        tags: ["auth"],
        summary: "Current user",
        responses: {
          200: {
            description: "Authenticated user",
            content: {
              "application/json": {
                schema: ref("CurrentUser")
              }
            }
          }
        }
      }),
      patch: withBearer({
        tags: ["auth"],
        summary: "Update current user",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("UpdateMeInput")
            }
          }
        },
        responses: {
          200: {
            description: "Updated user",
            content: {
              "application/json": {
                schema: ref("CurrentUser")
              }
            }
          }
        }
      }),
      delete: withBearer({
        tags: ["auth"],
        summary: "Delete current user account (GDPR right to erasure)",
        responses: {
          200: {
            description: "Account deleted",
            content: {
              "application/json": {
                schema: ref("DeletedResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/metadata/profile-options": {
      get: withBearer({
        tags: ["auth"],
        summary: "Profile dropdown and preference options",
        responses: {
          200: {
            description: "Profile options",
            content: {
              "application/json": {
                schema: ref("ProfileOptions")
              }
            }
          }
        }
      })
    },
    "/api/v1/me/payment-methods": {
      get: withBearer({
        tags: ["auth"],
        summary: "List saved payment methods",
        responses: {
          200: {
            description: "Payment methods",
            content: {
              "application/json": {
                schema: toOpenApiSchema(z.object({ items: z.array(clientPaymentMethodSchema) }))
              }
            }
          }
        }
      }),
      post: withBearer({
        tags: ["auth"],
        summary: "Create a saved payment method",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ClientPaymentMethodCreateInput")
            }
          }
        },
        responses: {
          201: {
            description: "Created payment method",
            content: {
              "application/json": {
                schema: ref("ClientPaymentMethod")
              }
            }
          }
        }
      })
    },
    "/api/v1/me/payment-methods/{paymentMethodId}": {
      patch: withBearer({
        tags: ["auth"],
        summary: "Update a saved payment method",
        parameters: [pathParam("paymentMethodId", "Payment method identifier")],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ClientPaymentMethodUpdateInput")
            }
          }
        },
        responses: {
          200: {
            description: "Updated payment method",
            content: {
              "application/json": {
                schema: ref("ClientPaymentMethod")
              }
            }
          }
        }
      }),
      delete: withBearer({
        tags: ["auth"],
        summary: "Delete a saved payment method",
        parameters: [pathParam("paymentMethodId", "Payment method identifier")],
        responses: {
          200: {
            description: "Deleted payment method",
            content: {
              "application/json": {
                schema: ref("DeletedResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/me/payment-methods/{paymentMethodId}/default": {
      post: withBearer({
        tags: ["auth"],
        summary: "Set the default saved payment method",
        parameters: [pathParam("paymentMethodId", "Payment method identifier")],
        responses: {
          200: {
            description: "Default payment method",
            content: {
              "application/json": {
                schema: ref("ClientPaymentMethod")
              }
            }
          }
        }
      })
    },
    "/api/v1/me/benefits": {
      get: withBearer({
        tags: ["auth"],
        summary: "List client memberships and packages",
        responses: {
          200: {
            description: "Benefits",
            content: {
              "application/json": {
                schema: toOpenApiSchema(z.object({ items: z.array(clientBenefitSchema) }))
              }
            }
          }
        }
      })
    },
    "/api/v1/me/vouchers": {
      get: withBearer({
        tags: ["auth"],
        summary: "List redeemed vouchers",
        responses: {
          200: {
            description: "Vouchers",
            content: {
              "application/json": {
                schema: toOpenApiSchema(z.object({ items: z.array(clientVoucherSchema) }))
              }
            }
          }
        }
      })
    },
    "/api/v1/me/vouchers/redeem": {
      post: withBearer({
        tags: ["auth"],
        summary: "Redeem a voucher code",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("RedeemVoucherInput")
            }
          }
        },
        responses: {
          201: {
            description: "Redeemed voucher",
            content: {
              "application/json": {
                schema: ref("ClientVoucher")
              }
            }
          }
        }
      })
    },

    "/api/v1/salons": {
      get: {
        tags: ["salons"],
        summary: "List salons",
        parameters: [
          queryParam("city"),
          queryParam("category"),
          queryParam("search"),
          queryParam("page"),
          queryParam("pageSize"),
          { name: "lat", in: "query", required: false, schema: { type: "number" } },
          { name: "lng", in: "query", required: false, schema: { type: "number" } },
          { name: "sort", in: "query", required: false, schema: { type: "string", enum: ["nearby", "rating", "trending"] } }
        ],
        responses: {
          200: {
            description: "Salon list",
            content: {
              "application/json": {
                schema: ref("SalonSummaryListResponse")
              }
            }
          }
        }
      }
    },
    "/api/v1/salons/{id}": {
      get: {
        tags: ["salons"],
        summary: "Salon details",
        parameters: [pathParam("id", "Salon identifier")],
        responses: {
          200: {
            description: "Salon detail",
            content: {
              "application/json": {
                schema: ref("SalonDetail")
              }
            }
          },
          404: {
            description: "Not found",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      }
    },

    "/api/v1/favorites": {
      get: withBearer({
        tags: ["favorites"],
        summary: "List client favorites",
        responses: {
          200: {
            description: "Favorite salons list",
            content: {
              "application/json": {
                schema: ref("FavoriteListResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/favorites/{salonId}": {
      post: withBearer({
        tags: ["favorites"],
        summary: "Add salon to favorites",
        parameters: [pathParam("salonId", "Salon identifier")],
        responses: {
          201: {
            description: "Added to favorites",
            content: {
              "application/json": {
                schema: ref("FavoriteItem")
              }
            }
          },
          404: {
            description: "Salon not found",
            content: { "application/json": { schema: ref("ApiError") } }
          }
        }
      }),
      delete: withBearer({
        tags: ["favorites"],
        summary: "Remove salon from favorites",
        parameters: [pathParam("salonId", "Salon identifier")],
        responses: {
          200: {
            description: "Removed from favorites",
            content: {
              "application/json": {
                schema: ref("DeletedResponse")
              }
            }
          }
        }
      })
    },

    "/api/v1/bookings": {
      get: withBearer({
        tags: ["bookings"],
        summary: "List bookings",
        responses: {
          200: {
            description: "Booking list",
            content: {
              "application/json": {
                schema: ref("BookingSummaryListResponse")
              }
            }
          }
        }
      }),
      post: withBearer({
        tags: ["bookings"],
        summary: "Create booking",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("BookingCreateInput")
            }
          }
        },
        responses: {
          201: {
            description: "Created booking",
            content: {
              "application/json": {
                schema: ref("BookingSummary")
              }
            }
          }
        }
      })
    },
    "/api/v1/bookings/{bookingId}": {
      get: withBearer({
        tags: ["bookings"],
        summary: "Get booking detail",
        parameters: [pathParam("bookingId", "Booking identifier")],
        responses: {
          200: {
            description: "Booking detail",
            content: {
              "application/json": {
                schema: ref("BookingSummary")
              }
            }
          },
          404: {
            description: "Booking not found",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      })
    },
    "/api/v1/bookings/{bookingId}/cancel": {
      post: withBearer({
        tags: ["bookings"],
        summary: "Cancel a booking",
        parameters: [pathParam("bookingId", "Booking identifier")],
        responses: {
          200: {
            description: "Cancelled booking",
            content: {
              "application/json": {
                schema: ref("BookingSummary")
              }
            }
          },
          404: {
            description: "Booking not found",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      })
    },
    "/api/v1/bookings/{bookingId}/reschedule": {
      post: withBearer({
        tags: ["bookings"],
        summary: "Reschedule a booking",
        parameters: [pathParam("bookingId", "Booking identifier")],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("BookingRescheduleInput")
            }
          }
        },
        responses: {
          200: {
            description: "Rescheduled booking",
            content: {
              "application/json": {
                schema: ref("BookingSummary")
              }
            }
          },
          404: {
            description: "Booking not found",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      })
    },
    "/api/v1/bookings/{bookingId}/review": {
      post: withBearer({
        tags: ["bookings"],
        summary: "Submit a review for a completed booking",
        parameters: [pathParam("bookingId", "Booking identifier")],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: toOpenApiSchema(reviewCreateInputSchema)
            }
          }
        },
        responses: {
          201: {
            description: "Review created",
            content: {
              "application/json": {
                schema: toOpenApiSchema(reviewSchema)
              }
            }
          },
          404: {
            description: "Booking not found",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      })
    },

    "/api/v1/admin/dashboard": {
      get: withBearer({
        tags: ["admin"],
        summary: "Admin dashboard",
        responses: {
          200: {
            description: "Admin KPI dashboard",
            content: {
              "application/json": {
                schema: ref("AdminDashboard")
              }
            }
          }
        }
      })
    },
    "/api/v1/admin/salons/pending": {
      get: withBearer({
        tags: ["admin"],
        summary: "List pending salon approvals",
        parameters: [queryParam("search"), queryParam("category"), queryParam("city"), queryParam("status")],
        responses: {
          200: {
            description: "Pending salon queue",
            content: {
              "application/json": {
                schema: ref("AdminSalonQueueResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/admin/salons/{salonId}": {
      get: withBearer({
        tags: ["admin"],
        summary: "Salon approval detail",
        parameters: [pathParam("salonId", "Salon identifier")],
        responses: {
          200: {
            description: "Salon approval detail",
            content: {
              "application/json": {
                schema: ref("AdminSalonDetail")
              }
            }
          },
          404: {
            description: "Salon not found",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      })
    },
    "/api/v1/admin/salons/{salonId}/approve": {
      post: withBearer({
        tags: ["admin"],
        summary: "Approve salon listing",
        parameters: [pathParam("salonId", "Salon identifier")],
        responses: {
          200: {
            description: "Approved salon",
            content: {
              "application/json": {
                schema: ref("AdminSalonDetail")
              }
            }
          }
        }
      })
    },
    "/api/v1/admin/salons/{salonId}/reject": {
      post: withBearer({
        tags: ["admin"],
        summary: "Reject salon listing",
        parameters: [pathParam("salonId", "Salon identifier")],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("AdminSalonDecisionInput")
            }
          }
        },
        responses: {
          200: {
            description: "Rejected salon",
            content: {
              "application/json": {
                schema: ref("AdminSalonDetail")
              }
            }
          }
        }
      })
    },
    "/api/v1/admin/salons/{salonId}/request-info": {
      post: withBearer({
        tags: ["admin"],
        summary: "Request more information for salon listing",
        parameters: [pathParam("salonId", "Salon identifier")],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("AdminSalonDecisionInput")
            }
          }
        },
        responses: {
          200: {
            description: "Salon moved to needs_info",
            content: {
              "application/json": {
                schema: ref("AdminSalonDetail")
              }
            }
          }
        }
      })
    },
    "/api/v1/admin/subscriptions": {
      get: withBearer({
        tags: ["admin"],
        summary: "List subscription lifecycles",
        parameters: [queryParam("search"), queryParam("tier"), queryParam("status")],
        responses: {
          200: {
            description: "Subscription list",
            content: {
              "application/json": {
                schema: ref("AdminSubscriptionListResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/admin/subscriptions/{subscriptionId}": {
      get: withBearer({
        tags: ["admin"],
        summary: "Subscription detail",
        parameters: [pathParam("subscriptionId", "Subscription identifier")],
        responses: {
          200: {
            description: "Subscription detail",
            content: {
              "application/json": {
                schema: ref("AdminSubscriptionDetail")
              }
            }
          },
          404: {
            description: "Subscription not found",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      })
    },
    "/api/v1/admin/subscriptions/{subscriptionId}/override": {
      post: withBearer({
        tags: ["admin"],
        summary: "Apply admin subscription override",
        parameters: [pathParam("subscriptionId", "Subscription identifier")],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("AdminSubscriptionOverrideInput")
            }
          }
        },
        responses: {
          200: {
            description: "Updated subscription lifecycle",
            content: {
              "application/json": {
                schema: ref("AdminSubscriptionDetail")
              }
            }
          }
        }
      })
    },
    "/api/v1/admin/audit": {
      get: withBearer({
        tags: ["admin"],
        summary: "List admin audit events",
        parameters: [queryParam("actor"), queryParam("entityType"), queryParam("action")],
        responses: {
          200: {
            description: "Audit event list",
            content: {
              "application/json": {
                schema: ref("AdminAuditSummaryListResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/admin/audit/{auditId}": {
      get: withBearer({
        tags: ["admin"],
        summary: "Audit event detail",
        parameters: [pathParam("auditId", "Audit identifier")],
        responses: {
          200: {
            description: "Audit event detail",
            content: {
              "application/json": {
                schema: ref("AdminAuditDetail")
              }
            }
          },
          404: {
            description: "Audit event not found",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      })
    },

    "/api/v1/pro/dashboard": {
      get: withBearer({
        tags: ["pro"],
        summary: "Salon operational dashboard",
        responses: {
          200: {
            description: "Pro dashboard",
            content: {
              "application/json": {
                schema: ref("ProDashboard")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/salon": {
      get: withBearer({
        tags: ["pro"],
        summary: "Get owned salon profile",
        responses: {
          200: {
            description: "Salon profile",
            content: {
              "application/json": {
                schema: ref("ProSalonProfile")
              }
            }
          }
        }
      }),
      patch: withBearer({
        tags: ["pro"],
        summary: "Update owned salon profile",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProSalonUpdateInput")
            }
          }
        },
        responses: {
          200: {
            description: "Updated salon profile",
            content: {
              "application/json": {
                schema: ref("ProSalonProfile")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/services": {
      get: withBearer({
        tags: ["pro"],
        summary: "List salon services",
        responses: {
          200: {
            description: "Service list",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: ref("ProService")
                }
              }
            }
          }
        }
      }),
      post: withBearer({
        tags: ["pro"],
        summary: "Create salon service",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProServiceCreateInput")
            }
          }
        },
        responses: {
          201: {
            description: "Created service",
            content: {
              "application/json": {
                schema: ref("ProService")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/services/{serviceId}": {
      patch: withBearer({
        tags: ["pro"],
        summary: "Update salon service",
        parameters: [pathParam("serviceId", "Service identifier")],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProServiceUpdateInput")
            }
          }
        },
        responses: {
          200: {
            description: "Updated service",
            content: {
              "application/json": {
                schema: ref("ProService")
              }
            }
          }
        }
      }),
      delete: withBearer({
        tags: ["pro"],
        summary: "Archive salon service",
        parameters: [pathParam("serviceId", "Service identifier")],
        responses: {
          200: {
            description: "Deletion result",
            content: {
              "application/json": {
                schema: ref("DeletedResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/staff": {
      get: withBearer({
        tags: ["pro"],
        summary: "List salon staff",
        responses: {
          200: {
            description: "Staff list",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: ref("ProStaffMember")
                }
              }
            }
          }
        }
      }),
      post: withBearer({
        tags: ["pro"],
        summary: "Create salon staff",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProStaffCreateInput")
            }
          }
        },
        responses: {
          201: {
            description: "Created staff",
            content: {
              "application/json": {
                schema: ref("ProStaffMember")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/staff/{employeeId}": {
      patch: withBearer({
        tags: ["pro"],
        summary: "Update salon staff",
        parameters: [pathParam("employeeId", "Employee identifier")],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProStaffUpdateInput")
            }
          }
        },
        responses: {
          200: {
            description: "Updated staff",
            content: {
              "application/json": {
                schema: ref("UpdatedResponse")
              }
            }
          }
        }
      }),
      delete: withBearer({
        tags: ["pro"],
        summary: "Archive salon staff",
        parameters: [pathParam("employeeId", "Employee identifier")],
        responses: {
          200: {
            description: "Deletion result",
            content: {
              "application/json": {
                schema: ref("DeletedResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/hours": {
      get: withBearer({
        tags: ["pro"],
        summary: "List opening hours",
        responses: {
          200: {
            description: "Hours list",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: ref("ProSalonHour")
                }
              }
            }
          }
        }
      }),
      put: withBearer({
        tags: ["pro"],
        summary: "Update opening hours",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProHoursUpdateInput")
            }
          }
        },
        responses: {
          200: {
            description: "Update result",
            content: {
              "application/json": {
                schema: ref("UpdatedResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/blocked-slots": {
      get: withBearer({
        tags: ["pro"],
        summary: "List blocked slots",
        responses: {
          200: {
            description: "Blocked slot list",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: ref("ProBlockedSlot")
                }
              }
            }
          }
        }
      }),
      post: withBearer({
        tags: ["pro"],
        summary: "Create blocked slot",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProBlockedSlotCreateInput")
            }
          }
        },
        responses: {
          201: {
            description: "Created blocked slot",
            content: {
              "application/json": {
                schema: ref("ProBlockedSlot")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/blocked-slots/{slotId}": {
      delete: withBearer({
        tags: ["pro"],
        summary: "Delete blocked slot",
        parameters: [pathParam("slotId", "Blocked slot identifier")],
        responses: {
          200: {
            description: "Deletion result",
            content: {
              "application/json": {
                schema: ref("DeletedResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/bookings": {
      get: withBearer({
        tags: ["pro"],
        summary: "List pro bookings",
        parameters: [queryParam("status"), queryParam("date"), queryParam("page", "integer"), queryParam("pageSize", "integer")],
        responses: {
          200: {
            description: "Booking list",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: ref("ProBookingDetail")
                }
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/bookings/manual": {
      post: withBearer({
        tags: ["pro"],
        summary: "Create manual booking",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProManualBookingInput")
            }
          }
        },
        responses: {
          201: {
            description: "Created manual booking",
            content: {
              "application/json": {
                schema: ref("ProManualBookingCreated")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/bookings/{bookingId}": {
      get: withBearer({
        tags: ["pro"],
        summary: "Get booking detail",
        parameters: [pathParam("bookingId", "Booking identifier")],
        responses: {
          200: {
            description: "Booking detail",
            content: {
              "application/json": {
                schema: ref("ProBookingFullDetail")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/bookings/{bookingId}/accept": {
      post: withBearer({
        tags: ["pro"],
        summary: "Accept booking",
        parameters: [pathParam("bookingId", "Booking identifier")],
        responses: {
          200: {
            description: "Updated booking status",
            content: {
              "application/json": {
                schema: ref("ProBookingStatusUpdate")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/bookings/{bookingId}/reject": {
      post: withBearer({
        tags: ["pro"],
        summary: "Reject booking",
        parameters: [pathParam("bookingId", "Booking identifier")],
        responses: {
          200: {
            description: "Updated booking status",
            content: {
              "application/json": {
                schema: ref("ProBookingStatusUpdate")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/bookings/{bookingId}/start": {
      post: withBearer({
        tags: ["pro"],
        summary: "Start booking",
        parameters: [pathParam("bookingId", "Booking identifier")],
        responses: {
          200: {
            description: "Updated booking status",
            content: {
              "application/json": {
                schema: ref("ProBookingStatusUpdate")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/bookings/{bookingId}/complete": {
      post: withBearer({
        tags: ["pro"],
        summary: "Complete booking",
        parameters: [pathParam("bookingId", "Booking identifier")],
        responses: {
          200: {
            description: "Updated booking status",
            content: {
              "application/json": {
                schema: ref("ProBookingStatusUpdate")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/clients": {
      get: withBearer({
        tags: ["pro"],
        summary: "List salon clients",
        parameters: [queryParam("search")],
        responses: {
          200: {
            description: "Client list",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: ref("ProClientSummary")
                }
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/clients/{clientId}": {
      get: withBearer({
        tags: ["pro"],
        summary: "Get salon client detail",
        parameters: [pathParam("clientId", "Client identifier")],
        responses: {
          200: {
            description: "Client detail",
            content: {
              "application/json": {
                schema: ref("ProClientDetail")
              }
            }
          },
          404: {
            description: "Client not found",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/clients/benefits": {
      post: withBearer({
        tags: ["pro"],
        summary: "Assign a membership or package to a client",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProClientBenefitCreateInput")
            }
          }
        },
        responses: {
          201: {
            description: "Created client benefit",
            content: {
              "application/json": {
                schema: ref("ClientBenefit")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/vouchers": {
      post: withBearer({
        tags: ["pro"],
        summary: "Create a voucher code",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProVoucherCreateInput")
            }
          }
        },
        responses: {
          201: {
            description: "Created voucher",
            content: {
              "application/json": {
                schema: toOpenApiSchema(z.object({
                  id: z.string(),
                  code: z.string(),
                  title: z.string(),
                  description: z.string().nullable(),
                  discountLabel: z.string(),
                  expiresAt: z.string().nullable(),
                  maxRedemptions: z.number().int().nullable()
                }))
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/checkout/{bookingId}": {
      get: withBearer({
        tags: ["pro"],
        summary: "Get checkout details for a booking",
        parameters: [pathParam("bookingId", "Booking identifier")],
        responses: {
          200: {
            description: "Checkout details",
            content: {
              "application/json": {
                schema: ref("ProCheckoutDetails")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/checkout/{bookingId}/complete": {
      post: withBearer({
        tags: ["pro"],
        summary: "Complete checkout for a booking",
        parameters: [pathParam("bookingId", "Booking identifier")],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProCheckoutCompleteInput")
            }
          }
        },
        responses: {
          200: {
            description: "Checkout result",
            content: {
              "application/json": {
                schema: ref("ProCheckoutCompleteResult")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/reviews": {
      get: withBearer({
        tags: ["pro"],
        summary: "List salon reviews",
        responses: {
          200: {
            description: "Review list",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: ref("ProReview")
                }
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/reviews/{reviewId}/response": {
      post: withBearer({
        tags: ["pro"],
        summary: "Respond to a review",
        parameters: [pathParam("reviewId", "Review identifier")],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProReviewResponseInput")
            }
          }
        },
        responses: {
          200: {
            description: "Update result",
            content: {
              "application/json": {
                schema: ref("UpdatedResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/analytics": {
      get: withBearer({
        tags: ["pro"],
        summary: "Get salon analytics",
        parameters: [queryParam("period")],
        responses: {
          200: {
            description: "Analytics snapshot",
            content: {
              "application/json": {
                schema: ref("ProAnalytics")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/subscription": {
      get: withBearer({
        tags: ["pro"],
        summary: "Get subscription details",
        responses: {
          200: {
            description: "Subscription details",
            content: {
              "application/json": {
                schema: ref("ProSubscription")
              }
            }
          }
        }
      }),
      patch: withBearer({
        tags: ["pro"],
        summary: "Update subscription settings",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProSubscriptionUpdateInput")
            }
          }
        },
        responses: {
          200: {
            description: "Update result",
            content: {
              "application/json": {
                schema: ref("UpdatedResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/subscription/checkout": {
      post: withBearer({
        tags: ["pro"],
        summary: "Initiate premium subscription checkout",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProSubscriptionCheckoutInput")
            }
          }
        },
        responses: {
          200: {
            description: "Checkout initialization",
            content: {
              "application/json": {
                schema: ref("ProSubscriptionCheckoutResult")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/subscription/charge/{chargeId}/execute": {
      post: withBearer({
        tags: ["pro"],
        summary: "Execute subscription payment (two-step flow)",
        parameters: [
          {
            name: "chargeId",
            in: "path",
            required: true,
            schema: { type: "string" }
          }
        ],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("ProSubscriptionExecuteInput")
            }
          }
        },
        responses: {
          200: {
            description: "Subscription payment execution result",
            content: {
              "application/json": {
                schema: ref("ProSubscriptionExecuteResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/payouts": {
      get: withBearer({
        tags: ["pro"],
        summary: "List settlement and payout events",
        responses: {
          200: {
            description: "Payout events",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: ref("ProPayoutEvent")
                }
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/invoices": {
      get: withBearer({
        tags: ["pro"],
        summary: "List subscription invoices",
        responses: {
          200: {
            description: "Invoice list",
            content: {
              "application/json": {
                schema: {
                  type: "array",
                  items: ref("ProInvoice")
                }
              }
            }
          }
        }
      })
    },
    "/api/v1/pro/invoices/{invoiceId}/pdf": {
      get: withBearer({
        tags: ["pro"],
        summary: "Download subscription invoice PDF",
        parameters: [pathParam("invoiceId", "Invoice identifier")],
        responses: {
          200: {
            description: "PDF binary stream",
            content: {
              "application/pdf": {
                schema: { type: "string", format: "binary" }
              }
            }
          },
          404: {
            description: "Invoice not found",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      })
    },
    "/api/v1/notifications": {
      get: withBearer({
        tags: ["notifications"],
        summary: "List notifications",
        responses: {
          200: {
            description: "Notification list",
            content: {
              "application/json": {
                schema: toOpenApiSchema(z.object({
                  items: z.array(z.object({
                    id: z.string(),
                    title: z.string(),
                    body: z.string(),
                    channel: z.string(),
                    readAt: z.string().nullable(),
                    createdAt: z.string()
                  })),
                  total: z.number().int(),
                  unreadCount: z.number().int()
                }))
              }
            }
          }
        }
      })
    },
    "/api/v1/notifications/{id}/read": {
      post: withBearer({
        tags: ["notifications"],
        summary: "Mark one notification as read",
        parameters: [pathParam("id", "Notification identifier")],
        responses: {
          200: {
            description: "Notification updated",
            content: {
              "application/json": {
                schema: toOpenApiSchema(z.object({ read: z.boolean() }))
              }
            }
          }
        }
      })
    },
    "/api/v1/notifications/read-all": {
      post: withBearer({
        tags: ["notifications"],
        summary: "Mark all notifications as read",
        responses: {
          200: {
            description: "Notifications updated",
            content: {
              "application/json": {
                schema: ref("UpdatedResponse")
              }
            }
          }
        }
      })
    },

    "/api/v1/payments/deposits/initiate": {
      post: withBearer({
        tags: ["payments"],
        summary: "Initiate deposit payment for a booking",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("PaymentInitiateInput")
            }
          }
        },
        responses: {
          201: {
            description: "Payment initiation",
            content: {
              "application/json": {
                schema: ref("PaymentInitiateResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/payments/{paymentId}": {
      get: withBearer({
        tags: ["payments"],
        summary: "Get payment status",
        parameters: [pathParam("paymentId", "Payment identifier")],
        responses: {
          200: {
            description: "Payment status",
            content: {
              "application/json": {
                schema: ref("PaymentStatusResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/payments/{paymentId}/refund": {
      post: withBearer({
        tags: ["payments"],
        summary: "Refund a payment",
        parameters: [pathParam("paymentId", "Payment identifier")],
        responses: {
          200: {
            description: "Refund result",
            content: {
              "application/json": {
                schema: ref("PaymentStatusResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/payments/methods": {
      get: withBearer({
        tags: ["payments"],
        summary: "Get available payment methods from the active provider",
        responses: {
          200: {
            description: "Available payment methods",
            content: {
              "application/json": {
                schema: ref("PaydunyaMethodListResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/payments/deposits/execute": {
      post: withBearer({
        tags: ["payments"],
        summary: "Execute a payment with a specific method (two-step flow)",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("PaydunyaExecutePaymentInput")
            }
          }
        },
        responses: {
          200: {
            description: "Payment execution result",
            content: {
              "application/json": {
                schema: ref("PaydunyaExecutePaymentResponse")
              }
            }
          }
        }
      })
    },
    "/api/v1/payments/webhooks/paydunya": {
      post: {
        tags: ["payments"],
        summary: "PayDunya payment webhook callback",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("PaymentWebhookBody")
            }
          }
        },
        responses: {
          200: {
            description: "Webhook accepted",
            content: {
              "application/json": {
                schema: toOpenApiSchema(z.object({ received: z.boolean() }))
              }
            }
          }
        }
      }
    },
    "/api/v1/payments/{paymentId}/reconcile": {
      post: withBearer({
        tags: ["payments"],
        summary: "Manually reconcile a payment (admin or pro)",
        parameters: [pathParam("paymentId", "Payment identifier")],
        responses: {
          200: {
            description: "Reconciled payment status",
            content: {
              "application/json": {
                schema: ref("PaymentReconcileResponse")
              }
            }
          },
          404: {
            description: "Payment not found",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      })
    },
    "/api/v1/push-tokens": {
      post: withBearer({
        tags: ["push"],
        summary: "Register a push notification token",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: ref("PushTokenInput")
            }
          }
        },
        responses: {
          201: {
            description: "Registered push token",
            content: {
              "application/json": {
                schema: toOpenApiSchema(z.object({
                  id: z.string(),
                  token: z.string(),
                  platform: z.string(),
                  createdAt: z.string()
                }))
              }
            }
          }
        }
      })
    },
    "/api/v1/push-tokens/{tokenId}": {
      delete: withBearer({
        tags: ["push"],
        summary: "Revoke a push notification token",
        parameters: [pathParam("tokenId", "Push token identifier")],
        responses: {
          200: {
            description: "Revoked token",
            content: {
              "application/json": {
                schema: ref("DeletedResponse")
              }
            }
          }
        }
      })
    },

    "/api/v1/media/upload": {
      post: withBearer({
        tags: ["media"],
        summary: "Upload media through API (adapter-aware: local/noop/r2)",
        requestBody: {
          required: true,
          content: {
            "multipart/form-data": {
              schema: toOpenApiSchema(z.object({
                file: z.any(),
                purpose: z.enum(["salon_cover","salon_logo","salon_gallery","kyc_document","avatar"]),
                salonId: z.string().optional()
              }))
            }
          }
        },
        responses: {
          201: {
            description: "Upload accepted and pending review",
            content: {
              "application/json": {
                schema: toOpenApiSchema(z.object({
                  assetId: z.string(),
                  uploadStatus: z.string(),
                  reviewStatus: z.string()
                }))
              }
            }
          }
        }
      })
    },
    "/api/v1/media/upload-intent": {
      post: withBearer({
        tags: ["media"],
        summary: "Request a presigned PUT URL for direct R2 upload",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: toOpenApiSchema(z.object({
                salonId: z.string().optional(),
                purpose: z.enum(["salon_cover","salon_logo","salon_gallery","kyc_document","avatar"]),
                mimeType: z.string(),
                originalFilename: z.string(),
                sizeBytes: z.number().int()
              }))
            }
          }
        },
        responses: {
          201: {
            description: "Presigned upload intent",
            content: {
              "application/json": {
                schema: toOpenApiSchema(z.object({
                  assetId: z.string(),
                  uploadUrl: z.string(),
                  expiresAt: z.string()
                }))
              }
            }
          }
        }
      })
    },
    "/api/v1/media/{mediaId}/complete": {
      post: withBearer({
        tags: ["media"],
        summary: "Confirm upload completed — triggers admin review",
        parameters: [pathParam("mediaId", "Media asset identifier")],
        responses: {
          200: {
            description: "Upload confirmed",
            content: {
              "application/json": {
                schema: toOpenApiSchema(z.object({
                  assetId: z.string(),
                  uploadStatus: z.string(),
                  reviewStatus: z.string()
                }))
              }
            }
          }
        }
      })
    },
    "/api/v1/media/{mediaId}": {
      get: withBearer({
        tags: ["media"],
        summary: "Retrieve media metadata",
        parameters: [pathParam("mediaId", "Media identifier")],
        responses: {
          200: {
            description: "Media metadata",
            content: {
              "application/json": {
                schema: ref("MediaAsset")
              }
            }
          },
          404: {
            description: "Media not found",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      }),
      delete: withBearer({
        tags: ["media"],
        summary: "Soft-delete a media asset",
        parameters: [pathParam("mediaId", "Media identifier")],
        responses: {
          200: {
            description: "Deleted media",
            content: {
              "application/json": {
                schema: ref("DeletedResponse")
              }
            }
          },
          404: {
            description: "Media not found",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      })
    },

    "/api/v1/me/addresses": {
      get: withBearer({
        tags: ["auth"],
        summary: "List saved addresses",
        responses: {
          200: {
            description: "Address list",
            content: {
              "application/json": {
                schema: toOpenApiSchema(clientAddressListResponseSchema)
              }
            }
          }
        }
      }),
      post: withBearer({
        tags: ["auth"],
        summary: "Create a saved address",
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: toOpenApiSchema(clientAddressCreateSchema)
            }
          }
        },
        responses: {
          201: {
            description: "Created address",
            content: {
              "application/json": {
                schema: toOpenApiSchema(clientAddressSchema)
              }
            }
          }
        }
      })
    },
    "/api/v1/me/addresses/{addressId}": {
      patch: withBearer({
        tags: ["auth"],
        summary: "Update a saved address",
        parameters: [pathParam("addressId", "Address identifier")],
        requestBody: {
          required: true,
          content: {
            "application/json": {
              schema: toOpenApiSchema(clientAddressUpdateSchema)
            }
          }
        },
        responses: {
          200: {
            description: "Updated address",
            content: {
              "application/json": {
                schema: ref("UpdatedResponse")
              }
            }
          }
        }
      }),
      delete: withBearer({
        tags: ["auth"],
        summary: "Delete a saved address",
        parameters: [pathParam("addressId", "Address identifier")],
        responses: {
          200: {
            description: "Deleted address",
            content: {
              "application/json": {
                schema: ref("DeletedResponse")
              }
            }
          }
        }
      })
    },

    "/api/v1/salons/{id}/availability": {
      get: {
        tags: ["catalog"],
        summary: "Get available booking slots",
        parameters: [
          pathParam("id", "Salon identifier"),
          { name: "date", in: "query", required: true, schema: { type: "string", format: "date" } },
          { name: "serviceId", in: "query", required: true, schema: { type: "string" } },
          { name: "employeeId", in: "query", required: false, schema: { type: "string" } }
        ],
        responses: {
          200: { description: "Available slots", content: { "application/json": { schema: toOpenApiSchema(z.array(availabilitySlotSchema)) } } },
          404: { description: "Salon not found", content: { "application/json": { schema: ref("ApiError") } } }
        }
      }
    },

    "/api/v1/salons/{id}/reviews": {
      get: {
        tags: ["catalog"],
        summary: "List salon reviews",
        parameters: [pathParam("id", "Salon identifier"), queryParam("page"), queryParam("pageSize")],
        responses: {
          200: { description: "Reviews list", content: { "application/json": { schema: toOpenApiSchema(paginatedResponse(reviewSchema)) } } },
          404: { description: "Salon not found", content: { "application/json": { schema: ref("ApiError") } } }
        }
      }
    },

    "/api/v1/config/pricing": {
      get: {
        tags: ["catalog"],
        summary: "Get subscription pricing tiers",
        responses: {
          200: {
            description: "Pricing info",
            content: { "application/json": { schema: toOpenApiSchema(z.object({
              standard: z.object({ tier: z.string(), priceXof: z.number().int(), label: z.string() }),
              premium: z.object({ tier: z.string(), priceXof: z.number().int(), label: z.string() }),
              commissionPercent: z.number()
            })) } }
          }
        }
      }
    },

    "/api/v1/config/support": {
      get: {
        tags: ["catalog"],
        summary: "Get support contact info",
        responses: {
          200: {
            description: "Support info",
            content: { "application/json": { schema: toOpenApiSchema(z.object({
              phone: z.string(),
              email: z.string()
            })) } }
          }
        }
      }
    },

    "/api/v1/salons/{salonId}/public-media": {
      get: {
        tags: ["media"],
        summary: "Get public media for a salon",
        parameters: [pathParam("salonId", "Salon identifier")],
        responses: {
          200: {
            description: "Public media list",
            content: { "application/json": { schema: toOpenApiSchema(z.object({
              items: z.array(z.object({
                id: z.string(), publicUrl: z.string(), purpose: z.string(),
                mimeType: z.string(), displayOrder: z.number().int(),
                createdAt: z.string().datetime()
              }))
            })) } }
          }
        }
      }
    },

    "/api/v1/admin/media/pending": {
      get: withBearer({
        tags: ["admin"],
        summary: "List media pending review",
        parameters: [queryParam("page"), queryParam("pageSize")],
        responses: {
          200: {
            description: "Pending media list",
            content: { "application/json": { schema: toOpenApiSchema(z.object({
              items: z.array(z.object({
                id: z.string(), salonId: z.string(), uploadedBy: z.string(),
                objectKey: z.string(), mimeType: z.string(), sizeBytes: z.number().int().nonnegative(),
                purpose: z.string(), uploadStatus: z.string(), reviewStatus: z.string(),
                originalFilename: z.string(), createdAt: z.string().datetime()
              })),
              total: z.number().int().nonnegative(), page: z.number().int(), pageSize: z.number().int()
            })) } }
          }
        }
      })
    },

    "/api/v1/admin/media/{mediaId}/signed-view-url": {
      post: withBearer({
        tags: ["admin"],
        summary: "Get a signed URL to preview a media asset",
        parameters: [pathParam("mediaId", "Media identifier")],
        responses: {
          200: {
            description: "Signed URL",
            content: { "application/json": { schema: toOpenApiSchema(z.object({ signedUrl: z.string(), expiresAt: z.string().datetime() })) } }
          },
          404: { description: "Media not found", content: { "application/json": { schema: ref("ApiError") } } }
        }
      })
    },

    "/api/v1/admin/media/{mediaId}/approve": {
      post: withBearer({
        tags: ["admin"],
        summary: "Approve a media asset",
        parameters: [pathParam("mediaId", "Media identifier")],
        requestBody: { required: false, content: { "application/json": { schema: toOpenApiSchema(z.object({ purpose: z.string().optional(), displayOrder: z.number().int().optional() })) } } },
        responses: {
          200: { description: "Approved", content: { "application/json": { schema: toOpenApiSchema(z.object({ approved: z.boolean(), publicUrl: z.string().nullable() })) } } },
          404: { description: "Media not found", content: { "application/json": { schema: ref("ApiError") } } },
          409: { description: "Already approved", content: { "application/json": { schema: ref("ApiError") } } }
        }
      })
    },

    "/api/v1/admin/media/{mediaId}/reject": {
      post: withBearer({
        tags: ["admin"],
        summary: "Reject a media asset",
        parameters: [pathParam("mediaId", "Media identifier")],
        requestBody: { required: true, content: { "application/json": { schema: toOpenApiSchema(z.object({ reason: z.string().min(1).max(500) })) } } },
        responses: {
          200: { description: "Rejected", content: { "application/json": { schema: toOpenApiSchema(z.object({ rejected: z.boolean() })) } } },
          404: { description: "Media not found", content: { "application/json": { schema: ref("ApiError") } } },
          409: { description: "Already rejected", content: { "application/json": { schema: ref("ApiError") } } }
        }
      })
    },

    "/api/v1/admin/salons": {
      get: withBearer({
        tags: ["admin"],
        summary: "List all salons with optional filters",
        parameters: [queryParam("search"), queryParam("status")],
        responses: {
          200: { description: "Salons list", content: { "application/json": { schema: toOpenApiSchema(adminSalonQueueResponseSchema) } } }
        }
      }),
      post: withBearer({
        tags: ["admin"],
        summary: "Create a salon manually",
        requestBody: { required: true, content: { "application/json": { schema: toOpenApiSchema(adminSalonCreateInputSchema) } } },
        responses: {
          201: { description: "Created salon", content: { "application/json": { schema: toOpenApiSchema(adminSalonDetailSchema.extend({ temporaryPassword: z.string().nullable() })) } } }
        }
      })
    },

    "/api/v1/admin/config/settings": {
      get: withBearer({
        tags: ["admin"],
        summary: "List all platform settings",
        parameters: [queryParam("group")],
        responses: {
          200: { description: "Settings list", content: { "application/json": { schema: toOpenApiSchema(z.array(z.object({ id: z.string(), group: z.string(), key: z.string(), value: z.string(), description: z.string().nullable(), updatedAt: z.string().datetime() }))) } } }
        }
      })
    },

    "/api/v1/admin/config/settings/{key}": {
      patch: withBearer({
        tags: ["admin"],
        summary: "Update a platform setting",
        parameters: [pathParam("key", "Setting key")],
        requestBody: { required: true, content: { "application/json": { schema: toOpenApiSchema(z.object({ value: z.string() })) } } },
        responses: {
          200: { description: "Updated setting", content: { "application/json": { schema: ref("UpdatedResponse") } } }
        }
      })
    },

    "/api/v1/admin/config/categories": {
      get: withBearer({
        tags: ["admin"],
        summary: "List salon categories",
        responses: {
          200: { description: "Categories list", content: { "application/json": { schema: toOpenApiSchema(z.array(z.object({ id: z.string(), name: z.string(), slug: z.string(), enabled: z.boolean(), createdAt: z.string().datetime() }))) } } }
        }
      }),
      post: withBearer({
        tags: ["admin"],
        summary: "Create or update a salon category",
        requestBody: { required: true, content: { "application/json": { schema: toOpenApiSchema(z.object({ name: z.string().min(1), slug: z.string().min(1), enabled: z.boolean().optional() })) } } },
        responses: {
          200: { description: "Upserted category" }
        }
      })
    },

    "/api/v1/admin/config/categories/{id}": {
      delete: withBearer({
        tags: ["admin"],
        summary: "Delete a salon category",
        parameters: [pathParam("id", "Category identifier")],
        responses: {
          200: { description: "Deleted category", content: { "application/json": { schema: ref("DeletedResponse") } } }
        }
      })
    },

    "/api/v1/admin/config/documents": {
      get: withBearer({
        tags: ["admin"],
        summary: "List required documents",
        responses: {
          200: { description: "Documents list", content: { "application/json": { schema: toOpenApiSchema(z.array(z.object({ id: z.string(), label: z.string(), slug: z.string(), type: z.string(), isRequired: z.boolean(), enabled: z.boolean(), createdAt: z.string().datetime() }))) } } }
        }
      }),
      post: withBearer({
        tags: ["admin"],
        summary: "Create or update a required document",
        requestBody: { required: true, content: { "application/json": { schema: toOpenApiSchema(z.object({ label: z.string().min(1), slug: z.string().min(1), type: z.string(), isRequired: z.boolean(), enabled: z.boolean().optional() })) } } },
        responses: {
          200: { description: "Upserted document" }
        }
      })
    },

    "/api/v1/admin/config/documents/{id}": {
      delete: withBearer({
        tags: ["admin"],
        summary: "Delete a required document",
        parameters: [pathParam("id", "Document identifier")],
        responses: {
          200: { description: "Deleted document", content: { "application/json": { schema: ref("DeletedResponse") } } }
        }
      })
    }
  }
};
