# FavoritesApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1FavoritesGet**](FavoritesApi.md#apiv1favoritesget) | **GET** /api/v1/favorites | List client favorites |
| [**apiV1FavoritesSalonIdDelete**](FavoritesApi.md#apiv1favoritessaloniddelete) | **DELETE** /api/v1/favorites/{salonId} | Remove salon from favorites |
| [**apiV1FavoritesSalonIdPost**](FavoritesApi.md#apiv1favoritessalonidpost) | **POST** /api/v1/favorites/{salonId} | Add salon to favorites |



## apiV1FavoritesGet

> FavoriteListResponse apiV1FavoritesGet()

List client favorites

### Example

```ts
import {
  Configuration,
  FavoritesApi,
} from '';
import type { ApiV1FavoritesGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new FavoritesApi(config);

  try {
    const data = await api.apiV1FavoritesGet();
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

[**FavoriteListResponse**](FavoriteListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Favorite salons list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1FavoritesSalonIdDelete

> DeletedResponse apiV1FavoritesSalonIdDelete(salonId)

Remove salon from favorites

### Example

```ts
import {
  Configuration,
  FavoritesApi,
} from '';
import type { ApiV1FavoritesSalonIdDeleteRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new FavoritesApi(config);

  const body = {
    // string | Salon identifier
    salonId: salonId_example,
  } satisfies ApiV1FavoritesSalonIdDeleteRequest;

  try {
    const data = await api.apiV1FavoritesSalonIdDelete(body);
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

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Removed from favorites |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1FavoritesSalonIdPost

> FavoriteItem apiV1FavoritesSalonIdPost(salonId)

Add salon to favorites

### Example

```ts
import {
  Configuration,
  FavoritesApi,
} from '';
import type { ApiV1FavoritesSalonIdPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new FavoritesApi(config);

  const body = {
    // string | Salon identifier
    salonId: salonId_example,
  } satisfies ApiV1FavoritesSalonIdPostRequest;

  try {
    const data = await api.apiV1FavoritesSalonIdPost(body);
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

[**FavoriteItem**](FavoriteItem.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Added to favorites |  -  |
| **404** | Salon not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

