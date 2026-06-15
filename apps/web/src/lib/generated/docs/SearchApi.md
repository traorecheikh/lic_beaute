# SearchApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1SearchEventsPost**](SearchApi.md#apiv1searcheventspost) | **POST** /api/v1/search/events | Track search interaction events for personalization |
| [**apiV1SearchSalonsGet**](SearchApi.md#apiv1searchsalonsget) | **GET** /api/v1/search/salons | Search salons with ranked results, facets, and discovery modules |
| [**apiV1SearchSuggestionsGet**](SearchApi.md#apiv1searchsuggestionsget) | **GET** /api/v1/search/suggestions | Get search suggestions and autocomplete |



## apiV1SearchEventsPost

> SearchEventsResponse apiV1SearchEventsPost(searchEventsRequest)

Track search interaction events for personalization

### Example

```ts
import {
  Configuration,
  SearchApi,
} from '';
import type { ApiV1SearchEventsPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new SearchApi();

  const body = {
    // SearchEventsRequest
    searchEventsRequest: ...,
  } satisfies ApiV1SearchEventsPostRequest;

  try {
    const data = await api.apiV1SearchEventsPost(body);
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
| **searchEventsRequest** | [SearchEventsRequest](SearchEventsRequest.md) |  | |

### Return type

[**SearchEventsResponse**](SearchEventsResponse.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Events accepted |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1SearchSalonsGet

> SearchSalonsResponse apiV1SearchSalonsGet(q, lat, lng, category, city, neighborhood, minPrice, maxPrice, openNow, bookableSoon, sort, cursor, limit)

Search salons with ranked results, facets, and discovery modules

### Example

```ts
import {
  Configuration,
  SearchApi,
} from '';
import type { ApiV1SearchSalonsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new SearchApi();

  const body = {
    // string
    q: q_example,
    // number (optional)
    lat: 8.14,
    // number (optional)
    lng: 8.14,
    // string (optional)
    category: category_example,
    // string (optional)
    city: city_example,
    // string (optional)
    neighborhood: neighborhood_example,
    // number (optional)
    minPrice: 56,
    // number (optional)
    maxPrice: 56,
    // boolean (optional)
    openNow: true,
    // boolean (optional)
    bookableSoon: true,
    // 'relevance' | 'nearby' | 'trending' | 'prestige' | 'price_asc' | 'price_desc' (optional)
    sort: sort_example,
    // string (optional)
    cursor: cursor_example,
    // number (optional)
    limit: 56,
  } satisfies ApiV1SearchSalonsGetRequest;

  try {
    const data = await api.apiV1SearchSalonsGet(body);
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
| **q** | `string` |  | [Defaults to `undefined`] |
| **lat** | `number` |  | [Optional] [Defaults to `undefined`] |
| **lng** | `number` |  | [Optional] [Defaults to `undefined`] |
| **category** | `string` |  | [Optional] [Defaults to `undefined`] |
| **city** | `string` |  | [Optional] [Defaults to `undefined`] |
| **neighborhood** | `string` |  | [Optional] [Defaults to `undefined`] |
| **minPrice** | `number` |  | [Optional] [Defaults to `undefined`] |
| **maxPrice** | `number` |  | [Optional] [Defaults to `undefined`] |
| **openNow** | `boolean` |  | [Optional] [Defaults to `undefined`] |
| **bookableSoon** | `boolean` |  | [Optional] [Defaults to `undefined`] |
| **sort** | `relevance`, `nearby`, `trending`, `prestige`, `price_asc`, `price_desc` |  | [Optional] [Defaults to `undefined`] [Enum: relevance, nearby, trending, prestige, price_asc, price_desc] |
| **cursor** | `string` |  | [Optional] [Defaults to `undefined`] |
| **limit** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**SearchSalonsResponse**](SearchSalonsResponse.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Search results with facets and modules |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1SearchSuggestionsGet

> SearchSuggestionsResponse apiV1SearchSuggestionsGet(q, lat, lng, category, city)

Get search suggestions and autocomplete

### Example

```ts
import {
  Configuration,
  SearchApi,
} from '';
import type { ApiV1SearchSuggestionsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new SearchApi();

  const body = {
    // string
    q: q_example,
    // number (optional)
    lat: 8.14,
    // number (optional)
    lng: 8.14,
    // string (optional)
    category: category_example,
    // string (optional)
    city: city_example,
  } satisfies ApiV1SearchSuggestionsGetRequest;

  try {
    const data = await api.apiV1SearchSuggestionsGet(body);
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
| **q** | `string` |  | [Defaults to `undefined`] |
| **lat** | `number` |  | [Optional] [Defaults to `undefined`] |
| **lng** | `number` |  | [Optional] [Defaults to `undefined`] |
| **category** | `string` |  | [Optional] [Defaults to `undefined`] |
| **city** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**SearchSuggestionsResponse**](SearchSuggestionsResponse.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Search suggestions |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

