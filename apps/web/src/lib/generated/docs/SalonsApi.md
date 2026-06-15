# SalonsApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1SalonsGet**](SalonsApi.md#apiv1salonsget) | **GET** /api/v1/salons | List salons |
| [**apiV1SalonsIdGet**](SalonsApi.md#apiv1salonsidget) | **GET** /api/v1/salons/{id} | Salon details |



## apiV1SalonsGet

> SalonSummaryListResponse apiV1SalonsGet(city, category, search, page, pageSize, lat, lng, sort)

List salons

Deprecated. Use GET /api/v1/search/salons for search, and the sort-specific feed endpoints for discovery. This endpoint is kept for backward compatibility with non-search catalog feeds only.

### Example

```ts
import {
  Configuration,
  SalonsApi,
} from '';
import type { ApiV1SalonsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new SalonsApi();

  const body = {
    // string (optional)
    city: city_example,
    // string (optional)
    category: category_example,
    // string (optional)
    search: search_example,
    // string (optional)
    page: page_example,
    // string (optional)
    pageSize: pageSize_example,
    // number (optional)
    lat: 8.14,
    // number (optional)
    lng: 8.14,
    // 'nearby' | 'rating' | 'trending' (optional)
    sort: sort_example,
  } satisfies ApiV1SalonsGetRequest;

  try {
    const data = await api.apiV1SalonsGet(body);
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
| **city** | `string` |  | [Optional] [Defaults to `undefined`] |
| **category** | `string` |  | [Optional] [Defaults to `undefined`] |
| **search** | `string` |  | [Optional] [Defaults to `undefined`] |
| **page** | `string` |  | [Optional] [Defaults to `undefined`] |
| **pageSize** | `string` |  | [Optional] [Defaults to `undefined`] |
| **lat** | `number` |  | [Optional] [Defaults to `undefined`] |
| **lng** | `number` |  | [Optional] [Defaults to `undefined`] |
| **sort** | `nearby`, `rating`, `trending` |  | [Optional] [Defaults to `undefined`] [Enum: nearby, rating, trending] |

### Return type

[**SalonSummaryListResponse**](SalonSummaryListResponse.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Salon list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1SalonsIdGet

> SalonDetail apiV1SalonsIdGet(id)

Salon details

### Example

```ts
import {
  Configuration,
  SalonsApi,
} from '';
import type { ApiV1SalonsIdGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new SalonsApi();

  const body = {
    // string | Salon identifier
    id: id_example,
  } satisfies ApiV1SalonsIdGetRequest;

  try {
    const data = await api.apiV1SalonsIdGet(body);
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

### Return type

[**SalonDetail**](SalonDetail.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Salon detail |  -  |
| **404** | Not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

