# ProApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1ProAnalyticsGet**](ProApi.md#apiv1proanalyticsget) | **GET** /api/v1/pro/analytics | Get salon analytics |
| [**apiV1ProBlockedSlotsGet**](ProApi.md#apiv1problockedslotsget) | **GET** /api/v1/pro/blocked-slots | List blocked slots |
| [**apiV1ProBlockedSlotsPost**](ProApi.md#apiv1problockedslotspost) | **POST** /api/v1/pro/blocked-slots | Create blocked slot |
| [**apiV1ProBlockedSlotsSlotIdDelete**](ProApi.md#apiv1problockedslotsslotiddelete) | **DELETE** /api/v1/pro/blocked-slots/{slotId} | Delete blocked slot |
| [**apiV1ProBookingsBookingIdAcceptPost**](ProApi.md#apiv1probookingsbookingidacceptpost) | **POST** /api/v1/pro/bookings/{bookingId}/accept | Accept booking |
| [**apiV1ProBookingsBookingIdCompletePost**](ProApi.md#apiv1probookingsbookingidcompletepost) | **POST** /api/v1/pro/bookings/{bookingId}/complete | Complete booking |
| [**apiV1ProBookingsBookingIdGet**](ProApi.md#apiv1probookingsbookingidget) | **GET** /api/v1/pro/bookings/{bookingId} | Get booking detail |
| [**apiV1ProBookingsBookingIdRejectPost**](ProApi.md#apiv1probookingsbookingidrejectpost) | **POST** /api/v1/pro/bookings/{bookingId}/reject | Reject booking |
| [**apiV1ProBookingsBookingIdStartPost**](ProApi.md#apiv1probookingsbookingidstartpost) | **POST** /api/v1/pro/bookings/{bookingId}/start | Start booking |
| [**apiV1ProBookingsGet**](ProApi.md#apiv1probookingsget) | **GET** /api/v1/pro/bookings | List pro bookings |
| [**apiV1ProBookingsManualPost**](ProApi.md#apiv1probookingsmanualpost) | **POST** /api/v1/pro/bookings/manual | Create manual booking |
| [**apiV1ProCheckoutBookingIdCompletePost**](ProApi.md#apiv1procheckoutbookingidcompletepost) | **POST** /api/v1/pro/checkout/{bookingId}/complete | Complete checkout for a booking |
| [**apiV1ProCheckoutBookingIdGet**](ProApi.md#apiv1procheckoutbookingidget) | **GET** /api/v1/pro/checkout/{bookingId} | Get checkout details for a booking |
| [**apiV1ProClientsBenefitsPost**](ProApi.md#apiv1proclientsbenefitspost) | **POST** /api/v1/pro/clients/benefits | Assign a membership or package to a client |
| [**apiV1ProClientsClientIdGet**](ProApi.md#apiv1proclientsclientidget) | **GET** /api/v1/pro/clients/{clientId} | Get salon client detail |
| [**apiV1ProClientsGet**](ProApi.md#apiv1proclientsget) | **GET** /api/v1/pro/clients | List salon clients |
| [**apiV1ProDashboardGet**](ProApi.md#apiv1prodashboardget) | **GET** /api/v1/pro/dashboard | Salon operational dashboard |
| [**apiV1ProHoursGet**](ProApi.md#apiv1prohoursget) | **GET** /api/v1/pro/hours | List opening hours |
| [**apiV1ProHoursPut**](ProApi.md#apiv1prohoursput) | **PUT** /api/v1/pro/hours | Update opening hours |
| [**apiV1ProInvoicesGet**](ProApi.md#apiv1proinvoicesget) | **GET** /api/v1/pro/invoices | List subscription invoices |
| [**apiV1ProInvoicesInvoiceIdPdfGet**](ProApi.md#apiv1proinvoicesinvoiceidpdfget) | **GET** /api/v1/pro/invoices/{invoiceId}/pdf | Download subscription invoice PDF |
| [**apiV1ProPayoutsGet**](ProApi.md#apiv1propayoutsget) | **GET** /api/v1/pro/payouts | List settlement and payout events |
| [**apiV1ProReviewsGet**](ProApi.md#apiv1proreviewsget) | **GET** /api/v1/pro/reviews | List salon reviews |
| [**apiV1ProReviewsReviewIdResponsePost**](ProApi.md#apiv1proreviewsreviewidresponsepost) | **POST** /api/v1/pro/reviews/{reviewId}/response | Respond to a review |
| [**apiV1ProSalonGet**](ProApi.md#apiv1prosalonget) | **GET** /api/v1/pro/salon | Get owned salon profile |
| [**apiV1ProSalonPatch**](ProApi.md#apiv1prosalonpatch) | **PATCH** /api/v1/pro/salon | Update owned salon profile |
| [**apiV1ProServicesGet**](ProApi.md#apiv1proservicesget) | **GET** /api/v1/pro/services | List salon services |
| [**apiV1ProServicesPost**](ProApi.md#apiv1proservicespost) | **POST** /api/v1/pro/services | Create salon service |
| [**apiV1ProServicesServiceIdDelete**](ProApi.md#apiv1proservicesserviceiddelete) | **DELETE** /api/v1/pro/services/{serviceId} | Archive salon service |
| [**apiV1ProServicesServiceIdPatch**](ProApi.md#apiv1proservicesserviceidpatch) | **PATCH** /api/v1/pro/services/{serviceId} | Update salon service |
| [**apiV1ProStaffEmployeeIdDelete**](ProApi.md#apiv1prostaffemployeeiddelete) | **DELETE** /api/v1/pro/staff/{employeeId} | Archive salon staff |
| [**apiV1ProStaffEmployeeIdPatch**](ProApi.md#apiv1prostaffemployeeidpatch) | **PATCH** /api/v1/pro/staff/{employeeId} | Update salon staff |
| [**apiV1ProStaffGet**](ProApi.md#apiv1prostaffget) | **GET** /api/v1/pro/staff | List salon staff |
| [**apiV1ProStaffPost**](ProApi.md#apiv1prostaffpost) | **POST** /api/v1/pro/staff | Create salon staff |
| [**apiV1ProSubscriptionCheckoutPost**](ProApi.md#apiv1prosubscriptioncheckoutpost) | **POST** /api/v1/pro/subscription/checkout | Initiate premium subscription checkout |
| [**apiV1ProSubscriptionGet**](ProApi.md#apiv1prosubscriptionget) | **GET** /api/v1/pro/subscription | Get subscription details |
| [**apiV1ProSubscriptionPatch**](ProApi.md#apiv1prosubscriptionpatch) | **PATCH** /api/v1/pro/subscription | Update subscription settings |
| [**apiV1ProVouchersPost**](ProApi.md#apiv1provoucherspost) | **POST** /api/v1/pro/vouchers | Create a voucher code |



## apiV1ProAnalyticsGet

> ProAnalytics apiV1ProAnalyticsGet(period)

Get salon analytics

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProAnalyticsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string (optional)
    period: period_example,
  } satisfies ApiV1ProAnalyticsGetRequest;

  try {
    const data = await api.apiV1ProAnalyticsGet(body);
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
| **period** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ProAnalytics**](ProAnalytics.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Analytics snapshot |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProBlockedSlotsGet

> Array&lt;ProBlockedSlot&gt; apiV1ProBlockedSlotsGet()

List blocked slots

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProBlockedSlotsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  try {
    const data = await api.apiV1ProBlockedSlotsGet();
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

[**Array&lt;ProBlockedSlot&gt;**](ProBlockedSlot.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Blocked slot list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProBlockedSlotsPost

> ProBlockedSlot apiV1ProBlockedSlotsPost(proBlockedSlotCreateInput)

Create blocked slot

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProBlockedSlotsPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // ProBlockedSlotCreateInput
    proBlockedSlotCreateInput: ...,
  } satisfies ApiV1ProBlockedSlotsPostRequest;

  try {
    const data = await api.apiV1ProBlockedSlotsPost(body);
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
| **proBlockedSlotCreateInput** | [ProBlockedSlotCreateInput](ProBlockedSlotCreateInput.md) |  | |

### Return type

[**ProBlockedSlot**](ProBlockedSlot.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Created blocked slot |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProBlockedSlotsSlotIdDelete

> DeletedResponse apiV1ProBlockedSlotsSlotIdDelete(slotId)

Delete blocked slot

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProBlockedSlotsSlotIdDeleteRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Blocked slot identifier
    slotId: slotId_example,
  } satisfies ApiV1ProBlockedSlotsSlotIdDeleteRequest;

  try {
    const data = await api.apiV1ProBlockedSlotsSlotIdDelete(body);
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
| **slotId** | `string` | Blocked slot identifier | [Defaults to `undefined`] |

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
| **200** | Deletion result |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProBookingsBookingIdAcceptPost

> ProBookingStatusUpdate apiV1ProBookingsBookingIdAcceptPost(bookingId)

Accept booking

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProBookingsBookingIdAcceptPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Booking identifier
    bookingId: bookingId_example,
  } satisfies ApiV1ProBookingsBookingIdAcceptPostRequest;

  try {
    const data = await api.apiV1ProBookingsBookingIdAcceptPost(body);
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

[**ProBookingStatusUpdate**](ProBookingStatusUpdate.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated booking status |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProBookingsBookingIdCompletePost

> ProBookingStatusUpdate apiV1ProBookingsBookingIdCompletePost(bookingId)

Complete booking

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProBookingsBookingIdCompletePostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Booking identifier
    bookingId: bookingId_example,
  } satisfies ApiV1ProBookingsBookingIdCompletePostRequest;

  try {
    const data = await api.apiV1ProBookingsBookingIdCompletePost(body);
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

[**ProBookingStatusUpdate**](ProBookingStatusUpdate.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated booking status |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProBookingsBookingIdGet

> ProBookingFullDetail apiV1ProBookingsBookingIdGet(bookingId)

Get booking detail

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProBookingsBookingIdGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Booking identifier
    bookingId: bookingId_example,
  } satisfies ApiV1ProBookingsBookingIdGetRequest;

  try {
    const data = await api.apiV1ProBookingsBookingIdGet(body);
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

[**ProBookingFullDetail**](ProBookingFullDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Booking detail |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProBookingsBookingIdRejectPost

> ProBookingStatusUpdate apiV1ProBookingsBookingIdRejectPost(bookingId)

Reject booking

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProBookingsBookingIdRejectPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Booking identifier
    bookingId: bookingId_example,
  } satisfies ApiV1ProBookingsBookingIdRejectPostRequest;

  try {
    const data = await api.apiV1ProBookingsBookingIdRejectPost(body);
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

[**ProBookingStatusUpdate**](ProBookingStatusUpdate.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated booking status |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProBookingsBookingIdStartPost

> ProBookingStatusUpdate apiV1ProBookingsBookingIdStartPost(bookingId)

Start booking

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProBookingsBookingIdStartPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Booking identifier
    bookingId: bookingId_example,
  } satisfies ApiV1ProBookingsBookingIdStartPostRequest;

  try {
    const data = await api.apiV1ProBookingsBookingIdStartPost(body);
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

[**ProBookingStatusUpdate**](ProBookingStatusUpdate.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated booking status |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProBookingsGet

> Array&lt;ProBookingDetail&gt; apiV1ProBookingsGet(status, date, page, pageSize)

List pro bookings

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProBookingsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string (optional)
    status: status_example,
    // string (optional)
    date: date_example,
    // number (optional)
    page: 56,
    // number (optional)
    pageSize: 56,
  } satisfies ApiV1ProBookingsGetRequest;

  try {
    const data = await api.apiV1ProBookingsGet(body);
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
| **status** | `string` |  | [Optional] [Defaults to `undefined`] |
| **date** | `string` |  | [Optional] [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |
| **pageSize** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**Array&lt;ProBookingDetail&gt;**](ProBookingDetail.md)

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


## apiV1ProBookingsManualPost

> ProManualBookingCreated apiV1ProBookingsManualPost(proManualBookingInput)

Create manual booking

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProBookingsManualPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // ProManualBookingInput
    proManualBookingInput: ...,
  } satisfies ApiV1ProBookingsManualPostRequest;

  try {
    const data = await api.apiV1ProBookingsManualPost(body);
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
| **proManualBookingInput** | [ProManualBookingInput](ProManualBookingInput.md) |  | |

### Return type

[**ProManualBookingCreated**](ProManualBookingCreated.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Created manual booking |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProCheckoutBookingIdCompletePost

> ProCheckoutCompleteResult apiV1ProCheckoutBookingIdCompletePost(bookingId, proCheckoutCompleteInput)

Complete checkout for a booking

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProCheckoutBookingIdCompletePostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Booking identifier
    bookingId: bookingId_example,
    // ProCheckoutCompleteInput
    proCheckoutCompleteInput: ...,
  } satisfies ApiV1ProCheckoutBookingIdCompletePostRequest;

  try {
    const data = await api.apiV1ProCheckoutBookingIdCompletePost(body);
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
| **proCheckoutCompleteInput** | [ProCheckoutCompleteInput](ProCheckoutCompleteInput.md) |  | |

### Return type

[**ProCheckoutCompleteResult**](ProCheckoutCompleteResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Checkout result |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProCheckoutBookingIdGet

> ProCheckoutDetails apiV1ProCheckoutBookingIdGet(bookingId)

Get checkout details for a booking

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProCheckoutBookingIdGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Booking identifier
    bookingId: bookingId_example,
  } satisfies ApiV1ProCheckoutBookingIdGetRequest;

  try {
    const data = await api.apiV1ProCheckoutBookingIdGet(body);
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

[**ProCheckoutDetails**](ProCheckoutDetails.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Checkout details |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProClientsBenefitsPost

> ClientBenefit apiV1ProClientsBenefitsPost(proClientBenefitCreateInput)

Assign a membership or package to a client

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProClientsBenefitsPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // ProClientBenefitCreateInput
    proClientBenefitCreateInput: ...,
  } satisfies ApiV1ProClientsBenefitsPostRequest;

  try {
    const data = await api.apiV1ProClientsBenefitsPost(body);
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
| **proClientBenefitCreateInput** | [ProClientBenefitCreateInput](ProClientBenefitCreateInput.md) |  | |

### Return type

[**ClientBenefit**](ClientBenefit.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Created client benefit |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProClientsClientIdGet

> ProClientDetail apiV1ProClientsClientIdGet(clientId)

Get salon client detail

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProClientsClientIdGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Client identifier
    clientId: clientId_example,
  } satisfies ApiV1ProClientsClientIdGetRequest;

  try {
    const data = await api.apiV1ProClientsClientIdGet(body);
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
| **clientId** | `string` | Client identifier | [Defaults to `undefined`] |

### Return type

[**ProClientDetail**](ProClientDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Client detail |  -  |
| **404** | Client not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProClientsGet

> Array&lt;ProClientSummary&gt; apiV1ProClientsGet(search)

List salon clients

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProClientsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string (optional)
    search: search_example,
  } satisfies ApiV1ProClientsGetRequest;

  try {
    const data = await api.apiV1ProClientsGet(body);
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

### Return type

[**Array&lt;ProClientSummary&gt;**](ProClientSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Client list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProDashboardGet

> ProDashboard apiV1ProDashboardGet()

Salon operational dashboard

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProDashboardGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  try {
    const data = await api.apiV1ProDashboardGet();
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

[**ProDashboard**](ProDashboard.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Pro dashboard |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProHoursGet

> Array&lt;ProSalonHour&gt; apiV1ProHoursGet()

List opening hours

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProHoursGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  try {
    const data = await api.apiV1ProHoursGet();
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

[**Array&lt;ProSalonHour&gt;**](ProSalonHour.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Hours list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProHoursPut

> UpdatedResponse apiV1ProHoursPut(proSalonProfileHoursInner)

Update opening hours

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProHoursPutRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // Array<ProSalonProfileHoursInner>
    proSalonProfileHoursInner: ...,
  } satisfies ApiV1ProHoursPutRequest;

  try {
    const data = await api.apiV1ProHoursPut(body);
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
| **proSalonProfileHoursInner** | `Array<ProSalonProfileHoursInner>` |  | |

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
| **200** | Update result |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProInvoicesGet

> Array&lt;ProInvoice&gt; apiV1ProInvoicesGet()

List subscription invoices

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProInvoicesGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  try {
    const data = await api.apiV1ProInvoicesGet();
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

[**Array&lt;ProInvoice&gt;**](ProInvoice.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Invoice list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProInvoicesInvoiceIdPdfGet

> Blob apiV1ProInvoicesInvoiceIdPdfGet(invoiceId)

Download subscription invoice PDF

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProInvoicesInvoiceIdPdfGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Invoice identifier
    invoiceId: invoiceId_example,
  } satisfies ApiV1ProInvoicesInvoiceIdPdfGetRequest;

  try {
    const data = await api.apiV1ProInvoicesInvoiceIdPdfGet(body);
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
| **invoiceId** | `string` | Invoice identifier | [Defaults to `undefined`] |

### Return type

**Blob**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/pdf`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | PDF binary stream |  -  |
| **404** | Invoice not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProPayoutsGet

> Array&lt;ProPayoutEvent&gt; apiV1ProPayoutsGet()

List settlement and payout events

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProPayoutsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  try {
    const data = await api.apiV1ProPayoutsGet();
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

[**Array&lt;ProPayoutEvent&gt;**](ProPayoutEvent.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Payout events |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProReviewsGet

> Array&lt;ProReview&gt; apiV1ProReviewsGet()

List salon reviews

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProReviewsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  try {
    const data = await api.apiV1ProReviewsGet();
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

[**Array&lt;ProReview&gt;**](ProReview.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Review list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProReviewsReviewIdResponsePost

> UpdatedResponse apiV1ProReviewsReviewIdResponsePost(reviewId, proReviewResponseInput)

Respond to a review

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProReviewsReviewIdResponsePostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Review identifier
    reviewId: reviewId_example,
    // ProReviewResponseInput
    proReviewResponseInput: ...,
  } satisfies ApiV1ProReviewsReviewIdResponsePostRequest;

  try {
    const data = await api.apiV1ProReviewsReviewIdResponsePost(body);
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
| **reviewId** | `string` | Review identifier | [Defaults to `undefined`] |
| **proReviewResponseInput** | [ProReviewResponseInput](ProReviewResponseInput.md) |  | |

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
| **200** | Update result |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProSalonGet

> ProSalonProfile apiV1ProSalonGet()

Get owned salon profile

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProSalonGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  try {
    const data = await api.apiV1ProSalonGet();
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

[**ProSalonProfile**](ProSalonProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Salon profile |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProSalonPatch

> ProSalonProfile apiV1ProSalonPatch(proSalonUpdateInput)

Update owned salon profile

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProSalonPatchRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // ProSalonUpdateInput
    proSalonUpdateInput: ...,
  } satisfies ApiV1ProSalonPatchRequest;

  try {
    const data = await api.apiV1ProSalonPatch(body);
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
| **proSalonUpdateInput** | [ProSalonUpdateInput](ProSalonUpdateInput.md) |  | |

### Return type

[**ProSalonProfile**](ProSalonProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated salon profile |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProServicesGet

> Array&lt;ProService&gt; apiV1ProServicesGet()

List salon services

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProServicesGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  try {
    const data = await api.apiV1ProServicesGet();
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

[**Array&lt;ProService&gt;**](ProService.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Service list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProServicesPost

> ProService apiV1ProServicesPost(proServiceCreateInput)

Create salon service

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProServicesPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // ProServiceCreateInput
    proServiceCreateInput: ...,
  } satisfies ApiV1ProServicesPostRequest;

  try {
    const data = await api.apiV1ProServicesPost(body);
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
| **proServiceCreateInput** | [ProServiceCreateInput](ProServiceCreateInput.md) |  | |

### Return type

[**ProService**](ProService.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Created service |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProServicesServiceIdDelete

> DeletedResponse apiV1ProServicesServiceIdDelete(serviceId)

Archive salon service

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProServicesServiceIdDeleteRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Service identifier
    serviceId: serviceId_example,
  } satisfies ApiV1ProServicesServiceIdDeleteRequest;

  try {
    const data = await api.apiV1ProServicesServiceIdDelete(body);
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
| **serviceId** | `string` | Service identifier | [Defaults to `undefined`] |

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
| **200** | Deletion result |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProServicesServiceIdPatch

> ProService apiV1ProServicesServiceIdPatch(serviceId, proServiceUpdateInput)

Update salon service

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProServicesServiceIdPatchRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Service identifier
    serviceId: serviceId_example,
    // ProServiceUpdateInput
    proServiceUpdateInput: ...,
  } satisfies ApiV1ProServicesServiceIdPatchRequest;

  try {
    const data = await api.apiV1ProServicesServiceIdPatch(body);
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
| **serviceId** | `string` | Service identifier | [Defaults to `undefined`] |
| **proServiceUpdateInput** | [ProServiceUpdateInput](ProServiceUpdateInput.md) |  | |

### Return type

[**ProService**](ProService.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated service |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProStaffEmployeeIdDelete

> DeletedResponse apiV1ProStaffEmployeeIdDelete(employeeId)

Archive salon staff

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProStaffEmployeeIdDeleteRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Employee identifier
    employeeId: employeeId_example,
  } satisfies ApiV1ProStaffEmployeeIdDeleteRequest;

  try {
    const data = await api.apiV1ProStaffEmployeeIdDelete(body);
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
| **employeeId** | `string` | Employee identifier | [Defaults to `undefined`] |

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
| **200** | Deletion result |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProStaffEmployeeIdPatch

> UpdatedResponse apiV1ProStaffEmployeeIdPatch(employeeId, proStaffUpdateInput)

Update salon staff

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProStaffEmployeeIdPatchRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // string | Employee identifier
    employeeId: employeeId_example,
    // ProStaffUpdateInput
    proStaffUpdateInput: ...,
  } satisfies ApiV1ProStaffEmployeeIdPatchRequest;

  try {
    const data = await api.apiV1ProStaffEmployeeIdPatch(body);
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
| **employeeId** | `string` | Employee identifier | [Defaults to `undefined`] |
| **proStaffUpdateInput** | [ProStaffUpdateInput](ProStaffUpdateInput.md) |  | |

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
| **200** | Updated staff |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProStaffGet

> Array&lt;ProStaffMember&gt; apiV1ProStaffGet()

List salon staff

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProStaffGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  try {
    const data = await api.apiV1ProStaffGet();
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

[**Array&lt;ProStaffMember&gt;**](ProStaffMember.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Staff list |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProStaffPost

> ProStaffMember apiV1ProStaffPost(proStaffCreateInput)

Create salon staff

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProStaffPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // ProStaffCreateInput
    proStaffCreateInput: ...,
  } satisfies ApiV1ProStaffPostRequest;

  try {
    const data = await api.apiV1ProStaffPost(body);
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
| **proStaffCreateInput** | [ProStaffCreateInput](ProStaffCreateInput.md) |  | |

### Return type

[**ProStaffMember**](ProStaffMember.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Created staff |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProSubscriptionCheckoutPost

> ProSubscriptionCheckoutResult apiV1ProSubscriptionCheckoutPost(proSubscriptionCheckoutInput)

Initiate premium subscription checkout

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProSubscriptionCheckoutPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // ProSubscriptionCheckoutInput
    proSubscriptionCheckoutInput: ...,
  } satisfies ApiV1ProSubscriptionCheckoutPostRequest;

  try {
    const data = await api.apiV1ProSubscriptionCheckoutPost(body);
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
| **proSubscriptionCheckoutInput** | [ProSubscriptionCheckoutInput](ProSubscriptionCheckoutInput.md) |  | |

### Return type

[**ProSubscriptionCheckoutResult**](ProSubscriptionCheckoutResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Checkout initialization |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProSubscriptionGet

> ProSubscription apiV1ProSubscriptionGet()

Get subscription details

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProSubscriptionGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  try {
    const data = await api.apiV1ProSubscriptionGet();
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

[**ProSubscription**](ProSubscription.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Subscription details |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProSubscriptionPatch

> UpdatedResponse apiV1ProSubscriptionPatch(proSubscriptionUpdateInput)

Update subscription settings

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProSubscriptionPatchRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // ProSubscriptionUpdateInput
    proSubscriptionUpdateInput: ...,
  } satisfies ApiV1ProSubscriptionPatchRequest;

  try {
    const data = await api.apiV1ProSubscriptionPatch(body);
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
| **proSubscriptionUpdateInput** | [ProSubscriptionUpdateInput](ProSubscriptionUpdateInput.md) |  | |

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
| **200** | Update result |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1ProVouchersPost

> ApiV1ProVouchersPost201Response apiV1ProVouchersPost(proVoucherCreateInput)

Create a voucher code

### Example

```ts
import {
  Configuration,
  ProApi,
} from '';
import type { ApiV1ProVouchersPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new ProApi(config);

  const body = {
    // ProVoucherCreateInput
    proVoucherCreateInput: ...,
  } satisfies ApiV1ProVouchersPostRequest;

  try {
    const data = await api.apiV1ProVouchersPost(body);
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
| **proVoucherCreateInput** | [ProVoucherCreateInput](ProVoucherCreateInput.md) |  | |

### Return type

[**ApiV1ProVouchersPost201Response**](ApiV1ProVouchersPost201Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Created voucher |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

