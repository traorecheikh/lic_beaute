# NotificationsApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1NotificationsGet**](NotificationsApi.md#apiv1notificationsget) | **GET** /api/v1/notifications | List notifications |
| [**apiV1NotificationsIdReadPost**](NotificationsApi.md#apiv1notificationsidreadpost) | **POST** /api/v1/notifications/{id}/read | Mark one notification as read |
| [**apiV1NotificationsReadAllPost**](NotificationsApi.md#apiv1notificationsreadallpost) | **POST** /api/v1/notifications/read-all | Mark all notifications as read |



## apiV1NotificationsGet

> ApiV1NotificationsGet200Response apiV1NotificationsGet()

List notifications

### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '';
import type { ApiV1NotificationsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new NotificationsApi(config);

  try {
    const data = await api.apiV1NotificationsGet();
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

[**ApiV1NotificationsGet200Response**](ApiV1NotificationsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Notification list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1NotificationsIdReadPost

> ApiV1NotificationsIdReadPost200Response apiV1NotificationsIdReadPost(id)

Mark one notification as read

### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '';
import type { ApiV1NotificationsIdReadPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new NotificationsApi(config);

  const body = {
    // string | Notification identifier
    id: id_example,
  } satisfies ApiV1NotificationsIdReadPostRequest;

  try {
    const data = await api.apiV1NotificationsIdReadPost(body);
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
| **id** | `string` | Notification identifier | [Defaults to `undefined`] |

### Return type

[**ApiV1NotificationsIdReadPost200Response**](ApiV1NotificationsIdReadPost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Notification updated |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1NotificationsReadAllPost

> UpdatedResponse apiV1NotificationsReadAllPost()

Mark all notifications as read

### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '';
import type { ApiV1NotificationsReadAllPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new NotificationsApi(config);

  try {
    const data = await api.apiV1NotificationsReadAllPost();
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

[**UpdatedResponse**](UpdatedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Notifications updated |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

