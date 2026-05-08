# CatalogApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1ConfigPricingGet**](CatalogApi.md#apiv1configpricingget) | **GET** /api/v1/config/pricing | Get subscription pricing tiers |
| [**apiV1SalonsIdAvailabilityGet**](CatalogApi.md#apiv1salonsidavailabilityget) | **GET** /api/v1/salons/{id}/availability | Get available booking slots |
| [**apiV1SalonsIdReviewsGet**](CatalogApi.md#apiv1salonsidreviewsget) | **GET** /api/v1/salons/{id}/reviews | List salon reviews |



## apiV1ConfigPricingGet

> ApiV1ConfigPricingGet200Response apiV1ConfigPricingGet()

Get subscription pricing tiers

### Example

```ts
import {
  Configuration,
  CatalogApi,
} from '';
import type { ApiV1ConfigPricingGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new CatalogApi();

  try {
    const data = await api.apiV1ConfigPricingGet();
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

[**ApiV1ConfigPricingGet200Response**](ApiV1ConfigPricingGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Pricing info |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1SalonsIdAvailabilityGet

> Array&lt;ApiV1SalonsIdAvailabilityGet200ResponseInner&gt; apiV1SalonsIdAvailabilityGet(id, date, serviceId, employeeId)

Get available booking slots

### Example

```ts
import {
  Configuration,
  CatalogApi,
} from '';
import type { ApiV1SalonsIdAvailabilityGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new CatalogApi();

  const body = {
    // string | Salon identifier
    id: id_example,
    // Date
    date: 2013-10-20,
    // string
    serviceId: serviceId_example,
    // string (optional)
    employeeId: employeeId_example,
  } satisfies ApiV1SalonsIdAvailabilityGetRequest;

  try {
    const data = await api.apiV1SalonsIdAvailabilityGet(body);
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
| **id** | `string` | Salon identifier | [Defaults to `undefined`] |
| **date** | `Date` |  | [Defaults to `undefined`] |
| **serviceId** | `string` |  | [Defaults to `undefined`] |
| **employeeId** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**Array&lt;ApiV1SalonsIdAvailabilityGet200ResponseInner&gt;**](ApiV1SalonsIdAvailabilityGet200ResponseInner.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Available slots |  -  |
| **404** | Salon not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1SalonsIdReviewsGet

> ApiV1SalonsIdReviewsGet200Response apiV1SalonsIdReviewsGet(id, page, pageSize)

List salon reviews

### Example

```ts
import {
  Configuration,
  CatalogApi,
} from '';
import type { ApiV1SalonsIdReviewsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new CatalogApi();

  const body = {
    // string | Salon identifier
    id: id_example,
    // string (optional)
    page: page_example,
    // string (optional)
    pageSize: pageSize_example,
  } satisfies ApiV1SalonsIdReviewsGetRequest;

  try {
    const data = await api.apiV1SalonsIdReviewsGet(body);
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
| **id** | `string` | Salon identifier | [Defaults to `undefined`] |
| **page** | `string` |  | [Optional] [Defaults to `undefined`] |
| **pageSize** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ApiV1SalonsIdReviewsGet200Response**](ApiV1SalonsIdReviewsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Reviews list |  -  |
| **404** | Salon not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

