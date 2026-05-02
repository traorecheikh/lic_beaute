# BookingsApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1BookingsGet**](BookingsApi.md#apiv1bookingsget) | **GET** /api/v1/bookings | List bookings |
| [**apiV1BookingsPost**](BookingsApi.md#apiv1bookingspost) | **POST** /api/v1/bookings | Create booking |



## apiV1BookingsGet

> BookingSummaryListResponse apiV1BookingsGet()

List bookings

### Example

```ts
import {
  Configuration,
  BookingsApi,
} from '';
import type { ApiV1BookingsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BookingsApi(config);

  try {
    const data = await api.apiV1BookingsGet();
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

[**BookingSummaryListResponse**](BookingSummaryListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Booking list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1BookingsPost

> BookingSummary apiV1BookingsPost(bookingCreateInput)

Create booking

### Example

```ts
import {
  Configuration,
  BookingsApi,
} from '';
import type { ApiV1BookingsPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BookingsApi(config);

  const body = {
    // BookingCreateInput
    bookingCreateInput: ...,
  } satisfies ApiV1BookingsPostRequest;

  try {
    const data = await api.apiV1BookingsPost(body);
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
| **bookingCreateInput** | [BookingCreateInput](BookingCreateInput.md) |  | |

### Return type

[**BookingSummary**](BookingSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Created booking |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

