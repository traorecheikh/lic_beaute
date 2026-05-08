# MediaApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1MediaMediaIdCompletePost**](MediaApi.md#apiv1mediamediaidcompletepost) | **POST** /api/v1/media/{mediaId}/complete | Confirm upload completed — triggers admin review |
| [**apiV1MediaMediaIdDelete**](MediaApi.md#apiv1mediamediaiddelete) | **DELETE** /api/v1/media/{mediaId} | Soft-delete a media asset |
| [**apiV1MediaMediaIdGet**](MediaApi.md#apiv1mediamediaidget) | **GET** /api/v1/media/{mediaId} | Retrieve media metadata |
| [**apiV1MediaUploadIntentPost**](MediaApi.md#apiv1mediauploadintentpostoperation) | **POST** /api/v1/media/upload-intent | Request a presigned PUT URL for direct R2 upload |
| [**apiV1SalonsSalonIdPublicMediaGet**](MediaApi.md#apiv1salonssalonidpublicmediaget) | **GET** /api/v1/salons/{salonId}/public-media | Get public media for a salon |



## apiV1MediaMediaIdCompletePost

> ApiV1MediaMediaIdCompletePost200Response apiV1MediaMediaIdCompletePost(mediaId)

Confirm upload completed — triggers admin review

### Example

```ts
import {
  Configuration,
  MediaApi,
} from '';
import type { ApiV1MediaMediaIdCompletePostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new MediaApi(config);

  const body = {
    // string | Media asset identifier
    mediaId: mediaId_example,
  } satisfies ApiV1MediaMediaIdCompletePostRequest;

  try {
    const data = await api.apiV1MediaMediaIdCompletePost(body);
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
| **mediaId** | `string` | Media asset identifier | [Defaults to `undefined`] |

### Return type

[**ApiV1MediaMediaIdCompletePost200Response**](ApiV1MediaMediaIdCompletePost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Upload confirmed |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MediaMediaIdDelete

> DeletedResponse apiV1MediaMediaIdDelete(mediaId)

Soft-delete a media asset

### Example

```ts
import {
  Configuration,
  MediaApi,
} from '';
import type { ApiV1MediaMediaIdDeleteRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new MediaApi(config);

  const body = {
    // string | Media identifier
    mediaId: mediaId_example,
  } satisfies ApiV1MediaMediaIdDeleteRequest;

  try {
    const data = await api.apiV1MediaMediaIdDelete(body);
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

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Deleted media |  -  |
| **404** | Media not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MediaMediaIdGet

> MediaAsset apiV1MediaMediaIdGet(mediaId)

Retrieve media metadata

### Example

```ts
import {
  Configuration,
  MediaApi,
} from '';
import type { ApiV1MediaMediaIdGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new MediaApi(config);

  const body = {
    // string | Media identifier
    mediaId: mediaId_example,
  } satisfies ApiV1MediaMediaIdGetRequest;

  try {
    const data = await api.apiV1MediaMediaIdGet(body);
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

[**MediaAsset**](MediaAsset.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Media metadata |  -  |
| **404** | Media not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MediaUploadIntentPost

> ApiV1MediaUploadIntentPost201Response apiV1MediaUploadIntentPost(apiV1MediaUploadIntentPostRequest)

Request a presigned PUT URL for direct R2 upload

### Example

```ts
import {
  Configuration,
  MediaApi,
} from '';
import type { ApiV1MediaUploadIntentPostOperationRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new MediaApi(config);

  const body = {
    // ApiV1MediaUploadIntentPostRequest
    apiV1MediaUploadIntentPostRequest: ...,
  } satisfies ApiV1MediaUploadIntentPostOperationRequest;

  try {
    const data = await api.apiV1MediaUploadIntentPost(body);
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
| **apiV1MediaUploadIntentPostRequest** | [ApiV1MediaUploadIntentPostRequest](ApiV1MediaUploadIntentPostRequest.md) |  | |

### Return type

[**ApiV1MediaUploadIntentPost201Response**](ApiV1MediaUploadIntentPost201Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Presigned upload intent |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1SalonsSalonIdPublicMediaGet

> ApiV1SalonsSalonIdPublicMediaGet200Response apiV1SalonsSalonIdPublicMediaGet(salonId)

Get public media for a salon

### Example

```ts
import {
  Configuration,
  MediaApi,
} from '';
import type { ApiV1SalonsSalonIdPublicMediaGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new MediaApi();

  const body = {
    // string | Salon identifier
    salonId: salonId_example,
  } satisfies ApiV1SalonsSalonIdPublicMediaGetRequest;

  try {
    const data = await api.apiV1SalonsSalonIdPublicMediaGet(body);
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

[**ApiV1SalonsSalonIdPublicMediaGet200Response**](ApiV1SalonsSalonIdPublicMediaGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Public media list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

