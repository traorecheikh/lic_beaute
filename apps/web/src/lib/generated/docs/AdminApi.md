# AdminApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1AdminAuditAuditIdGet**](AdminApi.md#apiv1adminauditauditidget) | **GET** /api/v1/admin/audit/{auditId} | Audit event detail |
| [**apiV1AdminAuditGet**](AdminApi.md#apiv1adminauditget) | **GET** /api/v1/admin/audit | List admin audit events |
| [**apiV1AdminConfigCategoriesGet**](AdminApi.md#apiv1adminconfigcategoriesget) | **GET** /api/v1/admin/config/categories | List salon categories |
| [**apiV1AdminConfigCategoriesIdDelete**](AdminApi.md#apiv1adminconfigcategoriesiddelete) | **DELETE** /api/v1/admin/config/categories/{id} | Delete a salon category |
| [**apiV1AdminConfigCategoriesPost**](AdminApi.md#apiv1adminconfigcategoriespostoperation) | **POST** /api/v1/admin/config/categories | Create or update a salon category |
| [**apiV1AdminConfigDocumentsGet**](AdminApi.md#apiv1adminconfigdocumentsget) | **GET** /api/v1/admin/config/documents | List required documents |
| [**apiV1AdminConfigDocumentsIdDelete**](AdminApi.md#apiv1adminconfigdocumentsiddelete) | **DELETE** /api/v1/admin/config/documents/{id} | Delete a required document |
| [**apiV1AdminConfigDocumentsPost**](AdminApi.md#apiv1adminconfigdocumentspostoperation) | **POST** /api/v1/admin/config/documents | Create or update a required document |
| [**apiV1AdminConfigSettingsGet**](AdminApi.md#apiv1adminconfigsettingsget) | **GET** /api/v1/admin/config/settings | List all platform settings |
| [**apiV1AdminConfigSettingsKeyPatch**](AdminApi.md#apiv1adminconfigsettingskeypatchoperation) | **PATCH** /api/v1/admin/config/settings/{key} | Update a platform setting |
| [**apiV1AdminDashboardGet**](AdminApi.md#apiv1admindashboardget) | **GET** /api/v1/admin/dashboard | Admin dashboard |
| [**apiV1AdminMediaMediaIdApprovePost**](AdminApi.md#apiv1adminmediamediaidapprovepostoperation) | **POST** /api/v1/admin/media/{mediaId}/approve | Approve a media asset |
| [**apiV1AdminMediaMediaIdRejectPost**](AdminApi.md#apiv1adminmediamediaidrejectpostoperation) | **POST** /api/v1/admin/media/{mediaId}/reject | Reject a media asset |
| [**apiV1AdminMediaMediaIdSignedViewUrlPost**](AdminApi.md#apiv1adminmediamediaidsignedviewurlpost) | **POST** /api/v1/admin/media/{mediaId}/signed-view-url | Get a signed URL to preview a media asset |
| [**apiV1AdminMediaPendingGet**](AdminApi.md#apiv1adminmediapendingget) | **GET** /api/v1/admin/media/pending | List media pending review |
| [**apiV1AdminSalonsGet**](AdminApi.md#apiv1adminsalonsget) | **GET** /api/v1/admin/salons | List all salons with optional filters |
| [**apiV1AdminSalonsPendingGet**](AdminApi.md#apiv1adminsalonspendingget) | **GET** /api/v1/admin/salons/pending | List pending salon approvals |
| [**apiV1AdminSalonsPost**](AdminApi.md#apiv1adminsalonspostoperation) | **POST** /api/v1/admin/salons | Create a salon manually |
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


## apiV1AdminConfigCategoriesGet

> Array&lt;ApiV1AdminConfigCategoriesGet200ResponseInner&gt; apiV1AdminConfigCategoriesGet()

List salon categories

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminConfigCategoriesGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  try {
    const data = await api.apiV1AdminConfigCategoriesGet();
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

[**Array&lt;ApiV1AdminConfigCategoriesGet200ResponseInner&gt;**](ApiV1AdminConfigCategoriesGet200ResponseInner.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Categories list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminConfigCategoriesIdDelete

> DeletedResponse apiV1AdminConfigCategoriesIdDelete(id)

Delete a salon category

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminConfigCategoriesIdDeleteRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string | Category identifier
    id: id_example,
  } satisfies ApiV1AdminConfigCategoriesIdDeleteRequest;

  try {
    const data = await api.apiV1AdminConfigCategoriesIdDelete(body);
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
| **id** | `string` | Category identifier | [Defaults to `undefined`] |

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Deleted category |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminConfigCategoriesPost

> apiV1AdminConfigCategoriesPost(apiV1AdminConfigCategoriesPostRequest)

Create or update a salon category

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminConfigCategoriesPostOperationRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // ApiV1AdminConfigCategoriesPostRequest
    apiV1AdminConfigCategoriesPostRequest: ...,
  } satisfies ApiV1AdminConfigCategoriesPostOperationRequest;

  try {
    const data = await api.apiV1AdminConfigCategoriesPost(body);
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
| **apiV1AdminConfigCategoriesPostRequest** | [ApiV1AdminConfigCategoriesPostRequest](ApiV1AdminConfigCategoriesPostRequest.md) |  | |

### Return type

`void` (Empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: Not defined


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Upserted category |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminConfigDocumentsGet

> Array&lt;ApiV1AdminConfigDocumentsGet200ResponseInner&gt; apiV1AdminConfigDocumentsGet()

List required documents

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminConfigDocumentsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  try {
    const data = await api.apiV1AdminConfigDocumentsGet();
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

[**Array&lt;ApiV1AdminConfigDocumentsGet200ResponseInner&gt;**](ApiV1AdminConfigDocumentsGet200ResponseInner.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Documents list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminConfigDocumentsIdDelete

> DeletedResponse apiV1AdminConfigDocumentsIdDelete(id)

Delete a required document

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminConfigDocumentsIdDeleteRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string | Document identifier
    id: id_example,
  } satisfies ApiV1AdminConfigDocumentsIdDeleteRequest;

  try {
    const data = await api.apiV1AdminConfigDocumentsIdDelete(body);
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
| **id** | `string` | Document identifier | [Defaults to `undefined`] |

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Deleted document |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminConfigDocumentsPost

> apiV1AdminConfigDocumentsPost(apiV1AdminConfigDocumentsPostRequest)

Create or update a required document

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminConfigDocumentsPostOperationRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // ApiV1AdminConfigDocumentsPostRequest
    apiV1AdminConfigDocumentsPostRequest: ...,
  } satisfies ApiV1AdminConfigDocumentsPostOperationRequest;

  try {
    const data = await api.apiV1AdminConfigDocumentsPost(body);
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
| **apiV1AdminConfigDocumentsPostRequest** | [ApiV1AdminConfigDocumentsPostRequest](ApiV1AdminConfigDocumentsPostRequest.md) |  | |

### Return type

`void` (Empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: Not defined


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Upserted document |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminConfigSettingsGet

> Array&lt;ApiV1AdminConfigSettingsGet200ResponseInner&gt; apiV1AdminConfigSettingsGet(group)

List all platform settings

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminConfigSettingsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string (optional)
    group: group_example,
  } satisfies ApiV1AdminConfigSettingsGetRequest;

  try {
    const data = await api.apiV1AdminConfigSettingsGet(body);
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
| **group** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**Array&lt;ApiV1AdminConfigSettingsGet200ResponseInner&gt;**](ApiV1AdminConfigSettingsGet200ResponseInner.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Settings list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminConfigSettingsKeyPatch

> UpdatedResponse apiV1AdminConfigSettingsKeyPatch(key, apiV1AdminConfigSettingsKeyPatchRequest)

Update a platform setting

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminConfigSettingsKeyPatchOperationRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string | Setting key
    key: key_example,
    // ApiV1AdminConfigSettingsKeyPatchRequest
    apiV1AdminConfigSettingsKeyPatchRequest: ...,
  } satisfies ApiV1AdminConfigSettingsKeyPatchOperationRequest;

  try {
    const data = await api.apiV1AdminConfigSettingsKeyPatch(body);
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
| **key** | `string` | Setting key | [Defaults to `undefined`] |
| **apiV1AdminConfigSettingsKeyPatchRequest** | [ApiV1AdminConfigSettingsKeyPatchRequest](ApiV1AdminConfigSettingsKeyPatchRequest.md) |  | |

### Return type

[**UpdatedResponse**](UpdatedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated setting |  -  |

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


## apiV1AdminMediaMediaIdApprovePost

> ApiV1AdminMediaMediaIdApprovePost200Response apiV1AdminMediaMediaIdApprovePost(mediaId, apiV1AdminMediaMediaIdApprovePostRequest)

Approve a media asset

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminMediaMediaIdApprovePostOperationRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string | Media identifier
    mediaId: mediaId_example,
    // ApiV1AdminMediaMediaIdApprovePostRequest (optional)
    apiV1AdminMediaMediaIdApprovePostRequest: ...,
  } satisfies ApiV1AdminMediaMediaIdApprovePostOperationRequest;

  try {
    const data = await api.apiV1AdminMediaMediaIdApprovePost(body);
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
| **mediaId** | `string` | Media identifier | [Defaults to `undefined`] |
| **apiV1AdminMediaMediaIdApprovePostRequest** | [ApiV1AdminMediaMediaIdApprovePostRequest](ApiV1AdminMediaMediaIdApprovePostRequest.md) |  | [Optional] |

### Return type

[**ApiV1AdminMediaMediaIdApprovePost200Response**](ApiV1AdminMediaMediaIdApprovePost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Approved |  -  |
| **404** | Media not found |  -  |
| **409** | Already approved |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminMediaMediaIdRejectPost

> ApiV1AdminMediaMediaIdRejectPost200Response apiV1AdminMediaMediaIdRejectPost(mediaId, apiV1AdminMediaMediaIdRejectPostRequest)

Reject a media asset

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminMediaMediaIdRejectPostOperationRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string | Media identifier
    mediaId: mediaId_example,
    // ApiV1AdminMediaMediaIdRejectPostRequest
    apiV1AdminMediaMediaIdRejectPostRequest: ...,
  } satisfies ApiV1AdminMediaMediaIdRejectPostOperationRequest;

  try {
    const data = await api.apiV1AdminMediaMediaIdRejectPost(body);
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
| **mediaId** | `string` | Media identifier | [Defaults to `undefined`] |
| **apiV1AdminMediaMediaIdRejectPostRequest** | [ApiV1AdminMediaMediaIdRejectPostRequest](ApiV1AdminMediaMediaIdRejectPostRequest.md) |  | |

### Return type

[**ApiV1AdminMediaMediaIdRejectPost200Response**](ApiV1AdminMediaMediaIdRejectPost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Rejected |  -  |
| **404** | Media not found |  -  |
| **409** | Already rejected |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminMediaMediaIdSignedViewUrlPost

> ApiV1AdminMediaMediaIdSignedViewUrlPost200Response apiV1AdminMediaMediaIdSignedViewUrlPost(mediaId)

Get a signed URL to preview a media asset

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminMediaMediaIdSignedViewUrlPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string | Media identifier
    mediaId: mediaId_example,
  } satisfies ApiV1AdminMediaMediaIdSignedViewUrlPostRequest;

  try {
    const data = await api.apiV1AdminMediaMediaIdSignedViewUrlPost(body);
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
| **mediaId** | `string` | Media identifier | [Defaults to `undefined`] |

### Return type

[**ApiV1AdminMediaMediaIdSignedViewUrlPost200Response**](ApiV1AdminMediaMediaIdSignedViewUrlPost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Signed URL |  -  |
| **404** | Media not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminMediaPendingGet

> ApiV1AdminMediaPendingGet200Response apiV1AdminMediaPendingGet(page, pageSize)

List media pending review

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminMediaPendingGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // string (optional)
    page: page_example,
    // string (optional)
    pageSize: pageSize_example,
  } satisfies ApiV1AdminMediaPendingGetRequest;

  try {
    const data = await api.apiV1AdminMediaPendingGet(body);
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
| **page** | `string` |  | [Optional] [Defaults to `undefined`] |
| **pageSize** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ApiV1AdminMediaPendingGet200Response**](ApiV1AdminMediaPendingGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Pending media list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AdminSalonsGet

> ApiV1AdminSalonsGet200Response apiV1AdminSalonsGet(search, status)

List all salons with optional filters

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminSalonsGetRequest } from '';

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
    status: status_example,
  } satisfies ApiV1AdminSalonsGetRequest;

  try {
    const data = await api.apiV1AdminSalonsGet(body);
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
| **status** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ApiV1AdminSalonsGet200Response**](ApiV1AdminSalonsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Salons list |  -  |

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


## apiV1AdminSalonsPost

> ApiV1AdminSalonsPost201Response apiV1AdminSalonsPost(apiV1AdminSalonsPostRequest)

Create a salon manually

### Example

```ts
import {
  Configuration,
  AdminApi,
} from '';
import type { ApiV1AdminSalonsPostOperationRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AdminApi(config);

  const body = {
    // ApiV1AdminSalonsPostRequest
    apiV1AdminSalonsPostRequest: ...,
  } satisfies ApiV1AdminSalonsPostOperationRequest;

  try {
    const data = await api.apiV1AdminSalonsPost(body);
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
| **apiV1AdminSalonsPostRequest** | [ApiV1AdminSalonsPostRequest](ApiV1AdminSalonsPostRequest.md) |  | |

### Return type

[**ApiV1AdminSalonsPost201Response**](ApiV1AdminSalonsPost201Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Created salon |  -  |

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

