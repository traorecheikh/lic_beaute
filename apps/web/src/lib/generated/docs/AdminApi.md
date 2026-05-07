# AdminApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1AdminAuditAuditIdGet**](AdminApi.md#apiv1adminauditauditidget) | **GET** /api/v1/admin/audit/{auditId} | Audit event detail |
| [**apiV1AdminAuditGet**](AdminApi.md#apiv1adminauditget) | **GET** /api/v1/admin/audit | List admin audit events |
| [**apiV1AdminDashboardGet**](AdminApi.md#apiv1admindashboardget) | **GET** /api/v1/admin/dashboard | Admin dashboard |
| [**apiV1AdminSalonsPendingGet**](AdminApi.md#apiv1adminsalonspendingget) | **GET** /api/v1/admin/salons/pending | List pending salon approvals |
| [**apiV1AdminSalonsSalonIdApprovePost**](AdminApi.md#apiv1adminsalonssalonidapprovepost) | **POST** /api/v1/admin/salons/{salonId}/approve | Approve salon listing |
| [**apiV1AdminSalonsSalonIdGet**](AdminApi.md#apiv1adminsalonssalonidget) | **GET** /api/v1/admin/salons/{salonId} | Salon approval detail |
| [**apiV1AdminSalonsSalonIdRejectPost**](AdminApi.md#apiv1adminsalonssalonidrejectpost) | **POST** /api/v1/admin/salons/{salonId}/reject | Reject salon listing |
| [**apiV1AdminSalonsSalonIdRequestInfoPost**](AdminApi.md#apiv1adminsalonssalonidrequestinfopost) | **POST** /api/v1/admin/salons/{salonId}/request-info | Request more information for salon listing |
| [**apiV1AdminSubscriptionsGet**](AdminApi.md#apiv1adminsubscriptionsget) | **GET** /api/v1/admin/subscriptions | List subscription lifecycles |
| [**apiV1AdminSubscriptionsSubscriptionIdGet**](AdminApi.md#apiv1adminsubscriptionssubscriptionidget) | **GET** /api/v1/admin/subscriptions/{subscriptionId} | Subscription detail |
| [**apiV1AdminSubscriptionsSubscriptionIdOverridePost**](AdminApi.md#apiv1adminsubscriptionssubscriptionidoverridepost) | **POST** /api/v1/admin/subscriptions/{subscriptionId}/override | Apply admin subscription override |



## apiV1AdminAuditAuditIdGet

> AdminAuditDetail apiV1AdminAuditAuditIdGet(auditId)

Audit event detail

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminAuditAuditIdGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string | Audit identifier
    auditId: auditId_example,
  } satisfies ApiV1AdminAuditAuditIdGetRequest;

  try {
    const data = await api.apiV1AdminAuditAuditIdGet(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **auditId** | `string` | Audit identifier | [Defaults to `undefined`] |

### Return type

[**AdminAuditDetail**](AdminAuditDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Audit event detail |  -  |
| **404** | Audit event not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminAuditGet

> AdminAuditSummaryListResponse apiV1AdminAuditGet(actor, entityType, action)

List admin audit events

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminAuditGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string (optional)
    actor: actor_example,
    // string (optional)
    entityType: entityType_example,
    // string (optional)
    action: action_example,
  } satisfies ApiV1AdminAuditGetRequest;

  try {
    const data = await api.apiV1AdminAuditGet(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **actor** | `string` |  | [Optional] [Defaults to `undefined`] |
| **entityType** | `string` |  | [Optional] [Defaults to `undefined`] |
| **action** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**AdminAuditSummaryListResponse**](AdminAuditSummaryListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Audit event list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminDashboardGet

> AdminDashboard apiV1AdminDashboardGet()

Admin dashboard

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminDashboardGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  try {
    const data = await api.apiV1AdminDashboardGet();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**AdminDashboard**](AdminDashboard.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Admin KPI dashboard |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminSalonsPendingGet

> AdminSalonQueueResponse apiV1AdminSalonsPendingGet(search, category, city, status)

List pending salon approvals

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminSalonsPendingGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string (optional)
    search: search_example,
    // string (optional)
    category: category_example,
    // string (optional)
    city: city_example,
    // string (optional)
    status: status_example,
  } satisfies ApiV1AdminSalonsPendingGetRequest;

  try {
    const data = await api.apiV1AdminSalonsPendingGet(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **search** | `string` |  | [Optional] [Defaults to `undefined`] |
| **category** | `string` |  | [Optional] [Defaults to `undefined`] |
| **city** | `string` |  | [Optional] [Defaults to `undefined`] |
| **status** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**AdminSalonQueueResponse**](AdminSalonQueueResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Pending salon queue |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminSalonsSalonIdApprovePost

> AdminSalonDetail apiV1AdminSalonsSalonIdApprovePost(salonId)

Approve salon listing

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminSalonsSalonIdApprovePostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string | Salon identifier
    salonId: salonId_example,
  } satisfies ApiV1AdminSalonsSalonIdApprovePostRequest;

  try {
    const data = await api.apiV1AdminSalonsSalonIdApprovePost(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **salonId** | `string` | Salon identifier | [Defaults to `undefined`] |

### Return type

[**AdminSalonDetail**](AdminSalonDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Approved salon |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminSalonsSalonIdGet

> AdminSalonDetail apiV1AdminSalonsSalonIdGet(salonId)

Salon approval detail

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminSalonsSalonIdGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string | Salon identifier
    salonId: salonId_example,
  } satisfies ApiV1AdminSalonsSalonIdGetRequest;

  try {
    const data = await api.apiV1AdminSalonsSalonIdGet(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **salonId** | `string` | Salon identifier | [Defaults to `undefined`] |

### Return type

[**AdminSalonDetail**](AdminSalonDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Salon approval detail |  -  |
| **404** | Salon not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminSalonsSalonIdRejectPost

> AdminSalonDetail apiV1AdminSalonsSalonIdRejectPost(salonId, adminSalonDecisionInput)

Reject salon listing

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminSalonsSalonIdRejectPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string | Salon identifier
    salonId: salonId_example,
    // AdminSalonDecisionInput
    adminSalonDecisionInput: ...,
  } satisfies ApiV1AdminSalonsSalonIdRejectPostRequest;

  try {
    const data = await api.apiV1AdminSalonsSalonIdRejectPost(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **salonId** | `string` | Salon identifier | [Defaults to `undefined`] |
| **adminSalonDecisionInput** | [AdminSalonDecisionInput](AdminSalonDecisionInput.md) |  | |

### Return type

[**AdminSalonDetail**](AdminSalonDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Rejected salon |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminSalonsSalonIdRequestInfoPost

> AdminSalonDetail apiV1AdminSalonsSalonIdRequestInfoPost(salonId, adminSalonDecisionInput)

Request more information for salon listing

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminSalonsSalonIdRequestInfoPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string | Salon identifier
    salonId: salonId_example,
    // AdminSalonDecisionInput
    adminSalonDecisionInput: ...,
  } satisfies ApiV1AdminSalonsSalonIdRequestInfoPostRequest;

  try {
    const data = await api.apiV1AdminSalonsSalonIdRequestInfoPost(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **salonId** | `string` | Salon identifier | [Defaults to `undefined`] |
| **adminSalonDecisionInput** | [AdminSalonDecisionInput](AdminSalonDecisionInput.md) |  | |

### Return type

[**AdminSalonDetail**](AdminSalonDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Salon moved to needs_info |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminSubscriptionsGet

> AdminSubscriptionListResponse apiV1AdminSubscriptionsGet(search, tier, status)

List subscription lifecycles

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminSubscriptionsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string (optional)
    search: search_example,
    // string (optional)
    tier: tier_example,
    // string (optional)
    status: status_example,
  } satisfies ApiV1AdminSubscriptionsGetRequest;

  try {
    const data = await api.apiV1AdminSubscriptionsGet(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **search** | `string` |  | [Optional] [Defaults to `undefined`] |
| **tier** | `string` |  | [Optional] [Defaults to `undefined`] |
| **status** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**AdminSubscriptionListResponse**](AdminSubscriptionListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Subscription list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminSubscriptionsSubscriptionIdGet

> AdminSubscriptionDetail apiV1AdminSubscriptionsSubscriptionIdGet(subscriptionId)

Subscription detail

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminSubscriptionsSubscriptionIdGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string | Subscription identifier
    subscriptionId: subscriptionId_example,
  } satisfies ApiV1AdminSubscriptionsSubscriptionIdGetRequest;

  try {
    const data = await api.apiV1AdminSubscriptionsSubscriptionIdGet(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **subscriptionId** | `string` | Subscription identifier | [Defaults to `undefined`] |

### Return type

[**AdminSubscriptionDetail**](AdminSubscriptionDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Subscription detail |  -  |
| **404** | Subscription not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminSubscriptionsSubscriptionIdOverridePost

> AdminSubscriptionDetail apiV1AdminSubscriptionsSubscriptionIdOverridePost(subscriptionId, adminSubscriptionOverrideInput)

Apply admin subscription override

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminSubscriptionsSubscriptionIdOverridePostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string | Subscription identifier
    subscriptionId: subscriptionId_example,
    // AdminSubscriptionOverrideInput
    adminSubscriptionOverrideInput: ...,
  } satisfies ApiV1AdminSubscriptionsSubscriptionIdOverridePostRequest;

  try {
    const data = await api.apiV1AdminSubscriptionsSubscriptionIdOverridePost(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **subscriptionId** | `string` | Subscription identifier | [Defaults to `undefined`] |
| **adminSubscriptionOverrideInput** | [AdminSubscriptionOverrideInput](AdminSubscriptionOverrideInput.md) |  | |

### Return type

[**AdminSubscriptionDetail**](AdminSubscriptionDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated subscription lifecycle |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

