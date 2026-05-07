# PushApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1PushTokensPost**](PushApi.md#apiv1pushtokenspost) | **POST** /api/v1/push-tokens | Register a push notification token |
| [**apiV1PushTokensTokenIdDelete**](PushApi.md#apiv1pushtokenstokeniddelete) | **DELETE** /api/v1/push-tokens/{tokenId} | Revoke a push notification token |



## apiV1PushTokensPost

> ApiV1PushTokensPost201Response apiV1PushTokensPost(pushTokenInput)

Register a push notification token

### Example

```ts
import {
  Configuration,
  PushApi,
} from '';
import type { ApiV1PushTokensPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new PushApi(config);

  const body = {
    // PushTokenInput
    pushTokenInput: ...,
  } satisfies ApiV1PushTokensPostRequest;

  try {
    const data = await api.apiV1PushTokensPost(body);
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
| **pushTokenInput** | [PushTokenInput](PushTokenInput.md) |  | |

### Return type

[**ApiV1PushTokensPost201Response**](ApiV1PushTokensPost201Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Registered push token |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1PushTokensTokenIdDelete

> DeletedResponse apiV1PushTokensTokenIdDelete(tokenId)

Revoke a push notification token

### Example

```ts
import {
  Configuration,
  PushApi,
} from '';
import type { ApiV1PushTokensTokenIdDeleteRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new PushApi(config);

  const body = {
    // string | Push token identifier
    tokenId: tokenId_example,
  } satisfies ApiV1PushTokensTokenIdDeleteRequest;

  try {
    const data = await api.apiV1PushTokensTokenIdDelete(body);
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
| **tokenId** | `string` | Push token identifier | [Defaults to `undefined`] |

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
| **200** | Revoked token |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

