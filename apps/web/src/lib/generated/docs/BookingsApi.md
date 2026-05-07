# BookingsApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1BookingsBookingIdCancelPost**](BookingsApi.md#apiv1bookingsbookingidcancelpost) | **POST** /api/v1/bookings/{bookingId}/cancel | Cancel a booking |
| [**apiV1BookingsBookingIdGet**](BookingsApi.md#apiv1bookingsbookingidget) | **GET** /api/v1/bookings/{bookingId} | Get booking detail |
| [**apiV1BookingsBookingIdReschedulePost**](BookingsApi.md#apiv1bookingsbookingidreschedulepost) | **POST** /api/v1/bookings/{bookingId}/reschedule | Reschedule a booking |
| [**apiV1BookingsBookingIdReviewPost**](BookingsApi.md#apiv1bookingsbookingidreviewpostoperation) | **POST** /api/v1/bookings/{bookingId}/review | Submit a review for a completed booking |
| [**apiV1BookingsGet**](BookingsApi.md#apiv1bookingsget) | **GET** /api/v1/bookings | List bookings |
| [**apiV1BookingsPost**](BookingsApi.md#apiv1bookingspost) | **POST** /api/v1/bookings | Create booking |



## apiV1BookingsBookingIdCancelPost

> BookingSummary apiV1BookingsBookingIdCancelPost(bookingId)

Cancel a booking

### Example

```ts
import {
  Configuration,
  BookingsApi,
} from '';
import type { ApiV1BookingsBookingIdCancelPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BookingsApi(config);

  const body = {
    // string | Booking identifier
    bookingId: bookingId_example,
  } satisfies ApiV1BookingsBookingIdCancelPostRequest;

  try {
    const data = await api.apiV1BookingsBookingIdCancelPost(body);
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
| **bookingId** | `string` | Booking identifier | [Defaults to `undefined`] |

### Return type

[**BookingSummary**](BookingSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Cancelled booking |  -  |
| **404** | Booking not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1BookingsBookingIdGet

> BookingSummary apiV1BookingsBookingIdGet(bookingId)

Get booking detail

### Example

```ts
import {
  Configuration,
  BookingsApi,
} from '';
import type { ApiV1BookingsBookingIdGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BookingsApi(config);

  const body = {
    // string | Booking identifier
    bookingId: bookingId_example,
  } satisfies ApiV1BookingsBookingIdGetRequest;

  try {
    const data = await api.apiV1BookingsBookingIdGet(body);
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
| **bookingId** | `string` | Booking identifier | [Defaults to `undefined`] |

### Return type

[**BookingSummary**](BookingSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Booking detail |  -  |
| **404** | Booking not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1BookingsBookingIdReschedulePost

> BookingSummary apiV1BookingsBookingIdReschedulePost(bookingId, bookingRescheduleInput)

Reschedule a booking

### Example

```ts
import {
  Configuration,
  BookingsApi,
} from '';
import type { ApiV1BookingsBookingIdReschedulePostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BookingsApi(config);

  const body = {
    // string | Booking identifier
    bookingId: bookingId_example,
    // BookingRescheduleInput
    bookingRescheduleInput: ...,
  } satisfies ApiV1BookingsBookingIdReschedulePostRequest;

  try {
    const data = await api.apiV1BookingsBookingIdReschedulePost(body);
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
| **bookingId** | `string` | Booking identifier | [Defaults to `undefined`] |
| **bookingRescheduleInput** | [BookingRescheduleInput](BookingRescheduleInput.md) |  | |

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
| **200** | Rescheduled booking |  -  |
| **404** | Booking not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1BookingsBookingIdReviewPost

> ApiV1BookingsBookingIdReviewPost201Response apiV1BookingsBookingIdReviewPost(bookingId, apiV1BookingsBookingIdReviewPostRequest)

Submit a review for a completed booking

### Example

```ts
import {
  Configuration,
  BookingsApi,
} from '';
import type { ApiV1BookingsBookingIdReviewPostOperationRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BookingsApi(config);

  const body = {
    // string | Booking identifier
    bookingId: bookingId_example,
    // ApiV1BookingsBookingIdReviewPostRequest
    apiV1BookingsBookingIdReviewPostRequest: ...,
  } satisfies ApiV1BookingsBookingIdReviewPostOperationRequest;

  try {
    const data = await api.apiV1BookingsBookingIdReviewPost(body);
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
| **bookingId** | `string` | Booking identifier | [Defaults to `undefined`] |
| **apiV1BookingsBookingIdReviewPostRequest** | [ApiV1BookingsBookingIdReviewPostRequest](ApiV1BookingsBookingIdReviewPostRequest.md) |  | |

### Return type

[**ApiV1BookingsBookingIdReviewPost201Response**](ApiV1BookingsBookingIdReviewPost201Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Review created |  -  |
| **404** | Booking not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


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

