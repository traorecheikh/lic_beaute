# beauteavenue_api.api.CatalogApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1ConfigPricingGet**](CatalogApi.md#apiv1configpricingget) | **GET** /api/v1/config/pricing | Get subscription pricing tiers
[**apiV1SalonsIdAvailabilityGet**](CatalogApi.md#apiv1salonsidavailabilityget) | **GET** /api/v1/salons/{id}/availability | Get available booking slots
[**apiV1SalonsIdReviewsGet**](CatalogApi.md#apiv1salonsidreviewsget) | **GET** /api/v1/salons/{id}/reviews | List salon reviews


# **apiV1ConfigPricingGet**
> ApiV1ConfigPricingGet200Response apiV1ConfigPricingGet()

Get subscription pricing tiers

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getCatalogApi();

try {
    final response = api.apiV1ConfigPricingGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling CatalogApi->apiV1ConfigPricingGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1ConfigPricingGet200Response**](ApiV1ConfigPricingGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SalonsIdAvailabilityGet**
> BuiltList<ApiV1SalonsIdAvailabilityGet200ResponseInner> apiV1SalonsIdAvailabilityGet(id, date, serviceId, employeeId)

Get available booking slots

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getCatalogApi();
final String id = id_example; // String | Salon identifier
final Date date = 2013-10-20; // Date | 
final String serviceId = serviceId_example; // String | 
final String employeeId = employeeId_example; // String | 

try {
    final response = api.apiV1SalonsIdAvailabilityGet(id, date, serviceId, employeeId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CatalogApi->apiV1SalonsIdAvailabilityGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Salon identifier | 
 **date** | **Date**|  | 
 **serviceId** | **String**|  | 
 **employeeId** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;ApiV1SalonsIdAvailabilityGet200ResponseInner&gt;**](ApiV1SalonsIdAvailabilityGet200ResponseInner.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SalonsIdReviewsGet**
> ApiV1SalonsIdReviewsGet200Response apiV1SalonsIdReviewsGet(id, page, pageSize)

List salon reviews

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getCatalogApi();
final String id = id_example; // String | Salon identifier
final String page = page_example; // String | 
final String pageSize = pageSize_example; // String | 

try {
    final response = api.apiV1SalonsIdReviewsGet(id, page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CatalogApi->apiV1SalonsIdReviewsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Salon identifier | 
 **page** | **String**|  | [optional] 
 **pageSize** | **String**|  | [optional] 

### Return type

[**ApiV1SalonsIdReviewsGet200Response**](ApiV1SalonsIdReviewsGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

