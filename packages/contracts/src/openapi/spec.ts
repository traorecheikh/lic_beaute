import { z } from "zod";
import { zodToJsonSchema } from "zod-to-json-schema";

import {
  adminAuditDetailSchema,
  adminAuditFiltersSchema,
  adminAuditSummarySchema,
  adminDashboardSchema,
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
  otpRequestSchema,
  otpVerifySchema
} from "../domain/auth.js";
import { bookingCreateSchema, bookingSummarySchema } from "../domain/booking.js";
import { salonDetailSchema, salonSummarySchema } from "../domain/salon.js";
import { apiErrorSchema, paginatedResponse } from "../http/common.js";

type JsonSchema = Record<string, unknown>;

const toOpenApiSchema = (schema: Parameters<typeof zodToJsonSchema>[0], name?: string): JsonSchema => {
  const result = zodToJsonSchema(schema, {
    name,
    target: "openApi3",
    $refStrategy: "none"
  }) as Record<string, unknown>;
  // zodToJsonSchema with a name wraps output in { $ref: "#/definitions/<name>", definitions: { <name>: schema } }
  // Unwrap it so components/schemas entries are plain schema objects (not $refs to nowhere)
  if (name && result.$ref === `#/definitions/${name}` && result.definitions) {
    const defs = result.definitions as Record<string, JsonSchema>;
    if (defs[name]) return defs[name];
  }
  return result as JsonSchema;
};

const ref = (name: string) => ({ $ref: `#/components/schemas/${name}` });

const logoutResponseSchema = z.object({
  revoked: z.boolean()
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
  EmailLoginInput: emailLoginSchema,
  OtpRequestInput: otpRequestSchema,
  OtpVerifyInput: otpVerifySchema,
  AuthSession: authSessionSchema,
  LogoutResponse: logoutResponseSchema,
  CurrentUser: currentUserSchema,
  SalonSummary: salonSummarySchema,
  SalonSummaryListResponse: paginatedResponse(salonSummarySchema),
  SalonDetail: salonDetailSchema,
  BookingCreateInput: bookingCreateSchema,
  BookingSummary: bookingSummarySchema,
  BookingSummaryListResponse: paginatedResponse(bookingSummarySchema),
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
  AdminAuditDetail: adminAuditDetailSchema
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
                    timestamp: { type: "string", format: "date-time" }
                  },
                  required: ["status", "timestamp"]
                }
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
          400: {
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
            description: "OTP request accepted"
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
    "/api/v1/auth/logout": {
      post: {
        tags: ["auth"],
        summary: "Logout current session",
        security: [{ bearerAuth: [] }],
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
      }
    },
    "/api/v1/me": {
      get: {
        tags: ["auth"],
        summary: "Current user",
        security: [{ bearerAuth: [] }],
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
      }
    },
    "/api/v1/salons": {
      get: {
        tags: ["salons"],
        summary: "List salons",
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
        parameters: [
          {
            name: "id",
            in: "path",
            required: true,
            schema: { type: "string" }
          }
        ],
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
    "/api/v1/bookings": {
      get: {
        tags: ["bookings"],
        summary: "List bookings",
        security: [{ bearerAuth: [] }],
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
      },
      post: {
        tags: ["bookings"],
        summary: "Create booking",
        security: [{ bearerAuth: [] }],
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
      }
    },
    "/api/v1/admin/dashboard": {
      get: {
        tags: ["admin"],
        summary: "Admin dashboard",
        security: [{ bearerAuth: [] }],
        responses: {
          200: {
            description: "Admin KPI dashboard",
            content: {
              "application/json": {
                schema: ref("AdminDashboard")
              }
            }
          },
          401: {
            description: "Unauthorized",
            content: {
              "application/json": {
                schema: ref("ApiError")
              }
            }
          }
        }
      }
    },
    "/api/v1/admin/salons/pending": {
      get: {
        tags: ["admin"],
        summary: "List pending salon approvals",
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: "search", in: "query", required: false, schema: { type: "string" } },
          { name: "category", in: "query", required: false, schema: { type: "string" } },
          { name: "city", in: "query", required: false, schema: { type: "string" } },
          { name: "status", in: "query", required: false, schema: { type: "string" } }
        ],
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
      }
    },
    "/api/v1/admin/salons/{salonId}": {
      get: {
        tags: ["admin"],
        summary: "Salon approval detail",
        security: [{ bearerAuth: [] }],
        parameters: [
          {
            name: "salonId",
            in: "path",
            required: true,
            schema: { type: "string" }
          }
        ],
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
      }
    },
    "/api/v1/admin/salons/{salonId}/approve": {
      post: {
        tags: ["admin"],
        summary: "Approve salon listing",
        security: [{ bearerAuth: [] }],
        parameters: [
          {
            name: "salonId",
            in: "path",
            required: true,
            schema: { type: "string" }
          }
        ],
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
      }
    },
    "/api/v1/admin/salons/{salonId}/reject": {
      post: {
        tags: ["admin"],
        summary: "Reject salon listing",
        security: [{ bearerAuth: [] }],
        parameters: [
          {
            name: "salonId",
            in: "path",
            required: true,
            schema: { type: "string" }
          }
        ],
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
      }
    },
    "/api/v1/admin/salons/{salonId}/request-info": {
      post: {
        tags: ["admin"],
        summary: "Request more information for salon listing",
        security: [{ bearerAuth: [] }],
        parameters: [
          {
            name: "salonId",
            in: "path",
            required: true,
            schema: { type: "string" }
          }
        ],
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
            description: "Salon updated to needs_info",
            content: {
              "application/json": {
                schema: ref("AdminSalonDetail")
              }
            }
          }
        }
      }
    },
    "/api/v1/admin/subscriptions": {
      get: {
        tags: ["admin"],
        summary: "List subscription lifecycles",
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: "search", in: "query", required: false, schema: { type: "string" } },
          { name: "tier", in: "query", required: false, schema: { type: "string" } },
          { name: "status", in: "query", required: false, schema: { type: "string" } }
        ],
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
      }
    },
    "/api/v1/admin/subscriptions/{subscriptionId}": {
      get: {
        tags: ["admin"],
        summary: "Subscription detail",
        security: [{ bearerAuth: [] }],
        parameters: [
          {
            name: "subscriptionId",
            in: "path",
            required: true,
            schema: { type: "string" }
          }
        ],
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
      }
    },
    "/api/v1/admin/subscriptions/{subscriptionId}/override": {
      post: {
        tags: ["admin"],
        summary: "Apply admin subscription override",
        security: [{ bearerAuth: [] }],
        parameters: [
          {
            name: "subscriptionId",
            in: "path",
            required: true,
            schema: { type: "string" }
          }
        ],
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
      }
    },
    "/api/v1/admin/audit": {
      get: {
        tags: ["admin"],
        summary: "List admin audit events",
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: "actor", in: "query", required: false, schema: { type: "string" } },
          { name: "entityType", in: "query", required: false, schema: { type: "string" } },
          { name: "action", in: "query", required: false, schema: { type: "string" } }
        ],
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
      }
    },
    "/api/v1/admin/audit/{auditId}": {
      get: {
        tags: ["admin"],
        summary: "Audit event detail",
        security: [{ bearerAuth: [] }],
        parameters: [
          {
            name: "auditId",
            in: "path",
            required: true,
            schema: { type: "string" }
          }
        ],
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
      }
    }
  }
};
