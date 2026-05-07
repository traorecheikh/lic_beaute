# beauteavenue_api.api.BookingsApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1BookingsBookingIdCancelPost**](BookingsApi.md#apiv1bookingsbookingidcancelpost) | **POST** /api/v1/bookings/{bookingId}/cancel | Cancel a booking
[**apiV1BookingsBookingIdGet**](BookingsApi.md#apiv1bookingsbookingidget) | **GET** /api/v1/bookings/{bookingId} | Get booking detail
[**apiV1BookingsBookingIdReschedulePost**](BookingsApi.md#apiv1bookingsbookingidreschedulepost) | **POST** /api/v1/bookings/{bookingId}/reschedule | Reschedule a booking
[**apiV1BookingsBookingIdReviewPost**](BookingsApi.md#apiv1bookingsbookingidreviewpost) | **POST** /api/v1/bookings/{bookingId}/review | Submit a review for a completed booking
[**apiV1BookingsGet**](BookingsApi.md#apiv1bookingsget) | **GET** /api/v1/bookings | List bookings
[**apiV1BookingsPost**](BookingsApi.md#apiv1bookingspost) | **POST** /api/v1/bookings | Create booking


# **apiV1BookingsBookingIdCancelPost**
> BookingSummary apiV1BookingsBookingIdCancelPost(bookingId)

Cancel a booking

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getBookingsApi();
final String bookingId = bookingId_example; // String | Booking identifier

try {
    final response = api.apiV1BookingsBookingIdCancelPost(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BookingsApi->apiV1BookingsBookingIdCancelPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**| Booking identifier | 

### Return type

[**BookingSummary**](BookingSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1BookingsBookingIdGet**
> BookingSummary apiV1BookingsBookingIdGet(bookingId)

Get booking detail

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getBookingsApi();
final String bookingId = bookingId_example; // String | Booking identifier

try {
    final response = api.apiV1BookingsBookingIdGet(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BookingsApi->apiV1BookingsBookingIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**| Booking identifier | 

### Return type

[**BookingSummary**](BookingSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1BookingsBookingIdReschedulePost**
> BookingSummary apiV1BookingsBookingIdReschedulePost(bookingId, bookingRescheduleInput)

Reschedule a booking

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getBookingsApi();
final String bookingId = bookingId_example; // String | Booking identifier
final BookingRescheduleInput bookingRescheduleInput = ; // BookingRescheduleInput | 

try {
    final response = api.apiV1BookingsBookingIdReschedulePost(bookingId, bookingRescheduleInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BookingsApi->apiV1BookingsBookingIdReschedulePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**| Booking identifier | 
 **bookingRescheduleInput** | [**BookingRescheduleInput**](BookingRescheduleInput.md)|  | 

### Return type

[**BookingSummary**](BookingSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1BookingsBookingIdReviewPost**
> ApiV1BookingsBookingIdReviewPost201Response apiV1BookingsBookingIdReviewPost(bookingId, apiV1BookingsBookingIdReviewPostRequest)

Submit a review for a completed booking

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getBookingsApi();
final String bookingId = bookingId_example; // String | Booking identifier
final ApiV1BookingsBookingIdReviewPostRequest apiV1BookingsBookingIdReviewPostRequest = ; // ApiV1BookingsBookingIdReviewPostRequest | 

try {
    final response = api.apiV1BookingsBookingIdReviewPost(bookingId, apiV1BookingsBookingIdReviewPostRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BookingsApi->apiV1BookingsBookingIdReviewPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**| Booking identifier | 
 **apiV1BookingsBookingIdReviewPostRequest** | [**ApiV1BookingsBookingIdReviewPostRequest**](ApiV1BookingsBookingIdReviewPostRequest.md)|  | 

### Return type

[**ApiV1BookingsBookingIdReviewPost201Response**](ApiV1BookingsBookingIdReviewPost201Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1BookingsGet**
> BookingSummaryListResponse apiV1BookingsGet()

List bookings

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getBookingsApi();

try {
    final response = api.apiV1BookingsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling BookingsApi->apiV1BookingsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BookingSummaryListResponse**](BookingSummaryListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1BookingsPost**
> BookingSummary apiV1BookingsPost(bookingCreateInput)

Create booking

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getBookingsApi();
final BookingCreateInput bookingCreateInput = ; // BookingCreateInput | 

try {
    final response = api.apiV1BookingsPost(bookingCreateInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BookingsApi->apiV1BookingsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingCreateInput** | [**BookingCreateInput**](BookingCreateInput.md)|  | 

### Return type

[**BookingSummary**](BookingSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

