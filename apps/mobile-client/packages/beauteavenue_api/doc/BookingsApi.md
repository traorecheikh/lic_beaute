# beauteavenue_api.api.BookingsApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1BookingsGet**](BookingsApi.md#apiv1bookingsget) | **GET** /api/v1/bookings | List bookings
[**apiV1BookingsPost**](BookingsApi.md#apiv1bookingspost) | **POST** /api/v1/bookings | Create booking


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

