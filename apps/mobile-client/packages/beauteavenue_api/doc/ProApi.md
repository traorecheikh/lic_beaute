# beauteavenue_api.api.ProApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1ProAnalyticsGet**](ProApi.md#apiv1proanalyticsget) | **GET** /api/v1/pro/analytics | Get salon analytics
[**apiV1ProBlockedSlotsGet**](ProApi.md#apiv1problockedslotsget) | **GET** /api/v1/pro/blocked-slots | List blocked slots
[**apiV1ProBlockedSlotsPost**](ProApi.md#apiv1problockedslotspost) | **POST** /api/v1/pro/blocked-slots | Create blocked slot
[**apiV1ProBlockedSlotsSlotIdDelete**](ProApi.md#apiv1problockedslotsslotiddelete) | **DELETE** /api/v1/pro/blocked-slots/{slotId} | Delete blocked slot
[**apiV1ProBookingsBookingIdAcceptPost**](ProApi.md#apiv1probookingsbookingidacceptpost) | **POST** /api/v1/pro/bookings/{bookingId}/accept | Accept booking
[**apiV1ProBookingsBookingIdCompletePost**](ProApi.md#apiv1probookingsbookingidcompletepost) | **POST** /api/v1/pro/bookings/{bookingId}/complete | Complete booking
[**apiV1ProBookingsBookingIdGet**](ProApi.md#apiv1probookingsbookingidget) | **GET** /api/v1/pro/bookings/{bookingId} | Get booking detail
[**apiV1ProBookingsBookingIdRejectPost**](ProApi.md#apiv1probookingsbookingidrejectpost) | **POST** /api/v1/pro/bookings/{bookingId}/reject | Reject booking
[**apiV1ProBookingsBookingIdStartPost**](ProApi.md#apiv1probookingsbookingidstartpost) | **POST** /api/v1/pro/bookings/{bookingId}/start | Start booking
[**apiV1ProBookingsGet**](ProApi.md#apiv1probookingsget) | **GET** /api/v1/pro/bookings | List pro bookings
[**apiV1ProBookingsManualPost**](ProApi.md#apiv1probookingsmanualpost) | **POST** /api/v1/pro/bookings/manual | Create manual booking
[**apiV1ProCheckoutBookingIdCompletePost**](ProApi.md#apiv1procheckoutbookingidcompletepost) | **POST** /api/v1/pro/checkout/{bookingId}/complete | Complete checkout for a booking
[**apiV1ProCheckoutBookingIdGet**](ProApi.md#apiv1procheckoutbookingidget) | **GET** /api/v1/pro/checkout/{bookingId} | Get checkout details for a booking
[**apiV1ProClientsBenefitsPost**](ProApi.md#apiv1proclientsbenefitspost) | **POST** /api/v1/pro/clients/benefits | Assign a membership or package to a client
[**apiV1ProClientsClientIdGet**](ProApi.md#apiv1proclientsclientidget) | **GET** /api/v1/pro/clients/{clientId} | Get salon client detail
[**apiV1ProClientsGet**](ProApi.md#apiv1proclientsget) | **GET** /api/v1/pro/clients | List salon clients
[**apiV1ProDashboardGet**](ProApi.md#apiv1prodashboardget) | **GET** /api/v1/pro/dashboard | Salon operational dashboard
[**apiV1ProHoursGet**](ProApi.md#apiv1prohoursget) | **GET** /api/v1/pro/hours | List opening hours
[**apiV1ProHoursPut**](ProApi.md#apiv1prohoursput) | **PUT** /api/v1/pro/hours | Update opening hours
[**apiV1ProInvoicesGet**](ProApi.md#apiv1proinvoicesget) | **GET** /api/v1/pro/invoices | List subscription invoices
[**apiV1ProInvoicesInvoiceIdPdfGet**](ProApi.md#apiv1proinvoicesinvoiceidpdfget) | **GET** /api/v1/pro/invoices/{invoiceId}/pdf | Download subscription invoice PDF
[**apiV1ProPayoutsGet**](ProApi.md#apiv1propayoutsget) | **GET** /api/v1/pro/payouts | List settlement and payout events
[**apiV1ProReviewsGet**](ProApi.md#apiv1proreviewsget) | **GET** /api/v1/pro/reviews | List salon reviews
[**apiV1ProReviewsReviewIdResponsePost**](ProApi.md#apiv1proreviewsreviewidresponsepost) | **POST** /api/v1/pro/reviews/{reviewId}/response | Respond to a review
[**apiV1ProSalonGet**](ProApi.md#apiv1prosalonget) | **GET** /api/v1/pro/salon | Get owned salon profile
[**apiV1ProSalonPatch**](ProApi.md#apiv1prosalonpatch) | **PATCH** /api/v1/pro/salon | Update owned salon profile
[**apiV1ProServicesGet**](ProApi.md#apiv1proservicesget) | **GET** /api/v1/pro/services | List salon services
[**apiV1ProServicesPost**](ProApi.md#apiv1proservicespost) | **POST** /api/v1/pro/services | Create salon service
[**apiV1ProServicesServiceIdDelete**](ProApi.md#apiv1proservicesserviceiddelete) | **DELETE** /api/v1/pro/services/{serviceId} | Archive salon service
[**apiV1ProServicesServiceIdPatch**](ProApi.md#apiv1proservicesserviceidpatch) | **PATCH** /api/v1/pro/services/{serviceId} | Update salon service
[**apiV1ProStaffEmployeeIdDelete**](ProApi.md#apiv1prostaffemployeeiddelete) | **DELETE** /api/v1/pro/staff/{employeeId} | Archive salon staff
[**apiV1ProStaffEmployeeIdPatch**](ProApi.md#apiv1prostaffemployeeidpatch) | **PATCH** /api/v1/pro/staff/{employeeId} | Update salon staff
[**apiV1ProStaffGet**](ProApi.md#apiv1prostaffget) | **GET** /api/v1/pro/staff | List salon staff
[**apiV1ProStaffPost**](ProApi.md#apiv1prostaffpost) | **POST** /api/v1/pro/staff | Create salon staff
[**apiV1ProSubscriptionCheckoutPost**](ProApi.md#apiv1prosubscriptioncheckoutpost) | **POST** /api/v1/pro/subscription/checkout | Initiate premium subscription checkout
[**apiV1ProSubscriptionGet**](ProApi.md#apiv1prosubscriptionget) | **GET** /api/v1/pro/subscription | Get subscription details
[**apiV1ProSubscriptionPatch**](ProApi.md#apiv1prosubscriptionpatch) | **PATCH** /api/v1/pro/subscription | Update subscription settings
[**apiV1ProVouchersPost**](ProApi.md#apiv1provoucherspost) | **POST** /api/v1/pro/vouchers | Create a voucher code


# **apiV1ProAnalyticsGet**
> ProAnalytics apiV1ProAnalyticsGet(period)

Get salon analytics

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String period = period_example; // String | 

try {
    final response = api.apiV1ProAnalyticsGet(period);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProAnalyticsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **period** | **String**|  | [optional] 

### Return type

[**ProAnalytics**](ProAnalytics.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProBlockedSlotsGet**
> BuiltList<ProBlockedSlot> apiV1ProBlockedSlotsGet()

List blocked slots

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();

try {
    final response = api.apiV1ProBlockedSlotsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProBlockedSlotsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ProBlockedSlot&gt;**](ProBlockedSlot.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProBlockedSlotsPost**
> ProBlockedSlot apiV1ProBlockedSlotsPost(proBlockedSlotCreateInput)

Create blocked slot

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final ProBlockedSlotCreateInput proBlockedSlotCreateInput = ; // ProBlockedSlotCreateInput | 

try {
    final response = api.apiV1ProBlockedSlotsPost(proBlockedSlotCreateInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProBlockedSlotsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **proBlockedSlotCreateInput** | [**ProBlockedSlotCreateInput**](ProBlockedSlotCreateInput.md)|  | 

### Return type

[**ProBlockedSlot**](ProBlockedSlot.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProBlockedSlotsSlotIdDelete**
> DeletedResponse apiV1ProBlockedSlotsSlotIdDelete(slotId)

Delete blocked slot

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String slotId = slotId_example; // String | Blocked slot identifier

try {
    final response = api.apiV1ProBlockedSlotsSlotIdDelete(slotId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProBlockedSlotsSlotIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **slotId** | **String**| Blocked slot identifier | 

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProBookingsBookingIdAcceptPost**
> ProBookingStatusUpdate apiV1ProBookingsBookingIdAcceptPost(bookingId)

Accept booking

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String bookingId = bookingId_example; // String | Booking identifier

try {
    final response = api.apiV1ProBookingsBookingIdAcceptPost(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProBookingsBookingIdAcceptPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**| Booking identifier | 

### Return type

[**ProBookingStatusUpdate**](ProBookingStatusUpdate.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProBookingsBookingIdCompletePost**
> ProBookingStatusUpdate apiV1ProBookingsBookingIdCompletePost(bookingId)

Complete booking

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String bookingId = bookingId_example; // String | Booking identifier

try {
    final response = api.apiV1ProBookingsBookingIdCompletePost(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProBookingsBookingIdCompletePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**| Booking identifier | 

### Return type

[**ProBookingStatusUpdate**](ProBookingStatusUpdate.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProBookingsBookingIdGet**
> ProBookingFullDetail apiV1ProBookingsBookingIdGet(bookingId)

Get booking detail

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String bookingId = bookingId_example; // String | Booking identifier

try {
    final response = api.apiV1ProBookingsBookingIdGet(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProBookingsBookingIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**| Booking identifier | 

### Return type

[**ProBookingFullDetail**](ProBookingFullDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProBookingsBookingIdRejectPost**
> ProBookingStatusUpdate apiV1ProBookingsBookingIdRejectPost(bookingId)

Reject booking

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String bookingId = bookingId_example; // String | Booking identifier

try {
    final response = api.apiV1ProBookingsBookingIdRejectPost(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProBookingsBookingIdRejectPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**| Booking identifier | 

### Return type

[**ProBookingStatusUpdate**](ProBookingStatusUpdate.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProBookingsBookingIdStartPost**
> ProBookingStatusUpdate apiV1ProBookingsBookingIdStartPost(bookingId)

Start booking

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String bookingId = bookingId_example; // String | Booking identifier

try {
    final response = api.apiV1ProBookingsBookingIdStartPost(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProBookingsBookingIdStartPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**| Booking identifier | 

### Return type

[**ProBookingStatusUpdate**](ProBookingStatusUpdate.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProBookingsGet**
> BuiltList<ProBookingDetail> apiV1ProBookingsGet(status, date, page, pageSize)

List pro bookings

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String status = status_example; // String | 
final String date = date_example; // String | 
final int page = 56; // int | 
final int pageSize = 56; // int | 

try {
    final response = api.apiV1ProBookingsGet(status, date, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProBookingsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] 
 **date** | **String**|  | [optional] 
 **page** | **int**|  | [optional] 
 **pageSize** | **int**|  | [optional] 

### Return type

[**BuiltList&lt;ProBookingDetail&gt;**](ProBookingDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProBookingsManualPost**
> ProManualBookingCreated apiV1ProBookingsManualPost(proManualBookingInput)

Create manual booking

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final ProManualBookingInput proManualBookingInput = ; // ProManualBookingInput | 

try {
    final response = api.apiV1ProBookingsManualPost(proManualBookingInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProBookingsManualPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **proManualBookingInput** | [**ProManualBookingInput**](ProManualBookingInput.md)|  | 

### Return type

[**ProManualBookingCreated**](ProManualBookingCreated.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProCheckoutBookingIdCompletePost**
> ProCheckoutCompleteResult apiV1ProCheckoutBookingIdCompletePost(bookingId, proCheckoutCompleteInput)

Complete checkout for a booking

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String bookingId = bookingId_example; // String | Booking identifier
final ProCheckoutCompleteInput proCheckoutCompleteInput = ; // ProCheckoutCompleteInput | 

try {
    final response = api.apiV1ProCheckoutBookingIdCompletePost(bookingId, proCheckoutCompleteInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProCheckoutBookingIdCompletePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**| Booking identifier | 
 **proCheckoutCompleteInput** | [**ProCheckoutCompleteInput**](ProCheckoutCompleteInput.md)|  | 

### Return type

[**ProCheckoutCompleteResult**](ProCheckoutCompleteResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProCheckoutBookingIdGet**
> ProCheckoutDetails apiV1ProCheckoutBookingIdGet(bookingId)

Get checkout details for a booking

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String bookingId = bookingId_example; // String | Booking identifier

try {
    final response = api.apiV1ProCheckoutBookingIdGet(bookingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProCheckoutBookingIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **bookingId** | **String**| Booking identifier | 

### Return type

[**ProCheckoutDetails**](ProCheckoutDetails.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProClientsBenefitsPost**
> ClientBenefit apiV1ProClientsBenefitsPost(proClientBenefitCreateInput)

Assign a membership or package to a client

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final ProClientBenefitCreateInput proClientBenefitCreateInput = ; // ProClientBenefitCreateInput | 

try {
    final response = api.apiV1ProClientsBenefitsPost(proClientBenefitCreateInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProClientsBenefitsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **proClientBenefitCreateInput** | [**ProClientBenefitCreateInput**](ProClientBenefitCreateInput.md)|  | 

### Return type

[**ClientBenefit**](ClientBenefit.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProClientsClientIdGet**
> ProClientDetail apiV1ProClientsClientIdGet(clientId)

Get salon client detail

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String clientId = clientId_example; // String | Client identifier

try {
    final response = api.apiV1ProClientsClientIdGet(clientId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProClientsClientIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **clientId** | **String**| Client identifier | 

### Return type

[**ProClientDetail**](ProClientDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProClientsGet**
> BuiltList<ProClientSummary> apiV1ProClientsGet(search)

List salon clients

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String search = search_example; // String | 

try {
    final response = api.apiV1ProClientsGet(search);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProClientsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;ProClientSummary&gt;**](ProClientSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProDashboardGet**
> ProDashboard apiV1ProDashboardGet()

Salon operational dashboard

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();

try {
    final response = api.apiV1ProDashboardGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProDashboardGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ProDashboard**](ProDashboard.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProHoursGet**
> BuiltList<ProSalonHour> apiV1ProHoursGet()

List opening hours

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();

try {
    final response = api.apiV1ProHoursGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProHoursGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ProSalonHour&gt;**](ProSalonHour.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProHoursPut**
> UpdatedResponse apiV1ProHoursPut(proSalonProfileHoursInner)

Update opening hours

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final BuiltList<ProSalonProfileHoursInner> proSalonProfileHoursInner = ; // BuiltList<ProSalonProfileHoursInner> | 

try {
    final response = api.apiV1ProHoursPut(proSalonProfileHoursInner);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProHoursPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **proSalonProfileHoursInner** | [**BuiltList&lt;ProSalonProfileHoursInner&gt;**](ProSalonProfileHoursInner.md)|  | 

### Return type

[**UpdatedResponse**](UpdatedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProInvoicesGet**
> BuiltList<ProInvoice> apiV1ProInvoicesGet()

List subscription invoices

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();

try {
    final response = api.apiV1ProInvoicesGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProInvoicesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ProInvoice&gt;**](ProInvoice.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProInvoicesInvoiceIdPdfGet**
> Uint8List apiV1ProInvoicesInvoiceIdPdfGet(invoiceId)

Download subscription invoice PDF

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String invoiceId = invoiceId_example; // String | Invoice identifier

try {
    final response = api.apiV1ProInvoicesInvoiceIdPdfGet(invoiceId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProInvoicesInvoiceIdPdfGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **invoiceId** | **String**| Invoice identifier | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/pdf, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProPayoutsGet**
> BuiltList<ProPayoutEvent> apiV1ProPayoutsGet()

List settlement and payout events

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();

try {
    final response = api.apiV1ProPayoutsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProPayoutsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ProPayoutEvent&gt;**](ProPayoutEvent.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProReviewsGet**
> BuiltList<ProReview> apiV1ProReviewsGet()

List salon reviews

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();

try {
    final response = api.apiV1ProReviewsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProReviewsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ProReview&gt;**](ProReview.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProReviewsReviewIdResponsePost**
> UpdatedResponse apiV1ProReviewsReviewIdResponsePost(reviewId, proReviewResponseInput)

Respond to a review

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String reviewId = reviewId_example; // String | Review identifier
final ProReviewResponseInput proReviewResponseInput = ; // ProReviewResponseInput | 

try {
    final response = api.apiV1ProReviewsReviewIdResponsePost(reviewId, proReviewResponseInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProReviewsReviewIdResponsePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**| Review identifier | 
 **proReviewResponseInput** | [**ProReviewResponseInput**](ProReviewResponseInput.md)|  | 

### Return type

[**UpdatedResponse**](UpdatedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProSalonGet**
> ProSalonProfile apiV1ProSalonGet()

Get owned salon profile

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();

try {
    final response = api.apiV1ProSalonGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProSalonGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ProSalonProfile**](ProSalonProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProSalonPatch**
> ProSalonProfile apiV1ProSalonPatch(proSalonUpdateInput)

Update owned salon profile

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final ProSalonUpdateInput proSalonUpdateInput = ; // ProSalonUpdateInput | 

try {
    final response = api.apiV1ProSalonPatch(proSalonUpdateInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProSalonPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **proSalonUpdateInput** | [**ProSalonUpdateInput**](ProSalonUpdateInput.md)|  | 

### Return type

[**ProSalonProfile**](ProSalonProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProServicesGet**
> BuiltList<ProService> apiV1ProServicesGet()

List salon services

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();

try {
    final response = api.apiV1ProServicesGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProServicesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ProService&gt;**](ProService.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProServicesPost**
> ProService apiV1ProServicesPost(proServiceCreateInput)

Create salon service

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final ProServiceCreateInput proServiceCreateInput = ; // ProServiceCreateInput | 

try {
    final response = api.apiV1ProServicesPost(proServiceCreateInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProServicesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **proServiceCreateInput** | [**ProServiceCreateInput**](ProServiceCreateInput.md)|  | 

### Return type

[**ProService**](ProService.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProServicesServiceIdDelete**
> DeletedResponse apiV1ProServicesServiceIdDelete(serviceId)

Archive salon service

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String serviceId = serviceId_example; // String | Service identifier

try {
    final response = api.apiV1ProServicesServiceIdDelete(serviceId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProServicesServiceIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **serviceId** | **String**| Service identifier | 

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProServicesServiceIdPatch**
> ProService apiV1ProServicesServiceIdPatch(serviceId, proServiceUpdateInput)

Update salon service

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String serviceId = serviceId_example; // String | Service identifier
final ProServiceUpdateInput proServiceUpdateInput = ; // ProServiceUpdateInput | 

try {
    final response = api.apiV1ProServicesServiceIdPatch(serviceId, proServiceUpdateInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProServicesServiceIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **serviceId** | **String**| Service identifier | 
 **proServiceUpdateInput** | [**ProServiceUpdateInput**](ProServiceUpdateInput.md)|  | 

### Return type

[**ProService**](ProService.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProStaffEmployeeIdDelete**
> DeletedResponse apiV1ProStaffEmployeeIdDelete(employeeId)

Archive salon staff

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String employeeId = employeeId_example; // String | Employee identifier

try {
    final response = api.apiV1ProStaffEmployeeIdDelete(employeeId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProStaffEmployeeIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **employeeId** | **String**| Employee identifier | 

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProStaffEmployeeIdPatch**
> UpdatedResponse apiV1ProStaffEmployeeIdPatch(employeeId, proStaffUpdateInput)

Update salon staff

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final String employeeId = employeeId_example; // String | Employee identifier
final ProStaffUpdateInput proStaffUpdateInput = ; // ProStaffUpdateInput | 

try {
    final response = api.apiV1ProStaffEmployeeIdPatch(employeeId, proStaffUpdateInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProStaffEmployeeIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **employeeId** | **String**| Employee identifier | 
 **proStaffUpdateInput** | [**ProStaffUpdateInput**](ProStaffUpdateInput.md)|  | 

### Return type

[**UpdatedResponse**](UpdatedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProStaffGet**
> BuiltList<ProStaffMember> apiV1ProStaffGet()

List salon staff

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();

try {
    final response = api.apiV1ProStaffGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProStaffGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ProStaffMember&gt;**](ProStaffMember.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProStaffPost**
> ProStaffMember apiV1ProStaffPost(proStaffCreateInput)

Create salon staff

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final ProStaffCreateInput proStaffCreateInput = ; // ProStaffCreateInput | 

try {
    final response = api.apiV1ProStaffPost(proStaffCreateInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProStaffPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **proStaffCreateInput** | [**ProStaffCreateInput**](ProStaffCreateInput.md)|  | 

### Return type

[**ProStaffMember**](ProStaffMember.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProSubscriptionCheckoutPost**
> ProSubscriptionCheckoutResult apiV1ProSubscriptionCheckoutPost(proSubscriptionCheckoutInput)

Initiate premium subscription checkout

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final ProSubscriptionCheckoutInput proSubscriptionCheckoutInput = ; // ProSubscriptionCheckoutInput | 

try {
    final response = api.apiV1ProSubscriptionCheckoutPost(proSubscriptionCheckoutInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProSubscriptionCheckoutPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **proSubscriptionCheckoutInput** | [**ProSubscriptionCheckoutInput**](ProSubscriptionCheckoutInput.md)|  | 

### Return type

[**ProSubscriptionCheckoutResult**](ProSubscriptionCheckoutResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProSubscriptionGet**
> ProSubscription apiV1ProSubscriptionGet()

Get subscription details

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();

try {
    final response = api.apiV1ProSubscriptionGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProSubscriptionGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ProSubscription**](ProSubscription.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProSubscriptionPatch**
> UpdatedResponse apiV1ProSubscriptionPatch(proSubscriptionUpdateInput)

Update subscription settings

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final ProSubscriptionUpdateInput proSubscriptionUpdateInput = ; // ProSubscriptionUpdateInput | 

try {
    final response = api.apiV1ProSubscriptionPatch(proSubscriptionUpdateInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProSubscriptionPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **proSubscriptionUpdateInput** | [**ProSubscriptionUpdateInput**](ProSubscriptionUpdateInput.md)|  | 

### Return type

[**UpdatedResponse**](UpdatedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1ProVouchersPost**
> ApiV1ProVouchersPost201Response apiV1ProVouchersPost(proVoucherCreateInput)

Create a voucher code

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getProApi();
final ProVoucherCreateInput proVoucherCreateInput = ; // ProVoucherCreateInput | 

try {
    final response = api.apiV1ProVouchersPost(proVoucherCreateInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProApi->apiV1ProVouchersPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **proVoucherCreateInput** | [**ProVoucherCreateInput**](ProVoucherCreateInput.md)|  | 

### Return type

[**ApiV1ProVouchersPost201Response**](ApiV1ProVouchersPost201Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

