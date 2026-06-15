# beauteavenue_api.api.SalonsApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1SalonsGet**](SalonsApi.md#apiv1salonsget) | **GET** /api/v1/salons | List salons
[**apiV1SalonsIdGet**](SalonsApi.md#apiv1salonsidget) | **GET** /api/v1/salons/{id} | Salon details


# **apiV1SalonsGet**
> SalonSummaryListResponse apiV1SalonsGet(city, category, search, page, pageSize, lat, lng, sort)

List salons

Deprecated. Use GET /api/v1/search/salons for search, and the sort-specific feed endpoints for discovery. This endpoint is kept for backward compatibility with non-search catalog feeds only.

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getSalonsApi();
final String city = city_example; // String | 
final String category = category_example; // String | 
final String search = search_example; // String | 
final String page = page_example; // String | 
final String pageSize = pageSize_example; // String | 
final num lat = 8.14; // num | 
final num lng = 8.14; // num | 
final String sort = sort_example; // String | 

try {
    final response = api.apiV1SalonsGet(city, category, search, page, pageSize, lat, lng, sort);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SalonsApi->apiV1SalonsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **city** | **String**|  | [optional] 
 **category** | **String**|  | [optional] 
 **search** | **String**|  | [optional] 
 **page** | **String**|  | [optional] 
 **pageSize** | **String**|  | [optional] 
 **lat** | **num**|  | [optional] 
 **lng** | **num**|  | [optional] 
 **sort** | **String**|  | [optional] 

### Return type

[**SalonSummaryListResponse**](SalonSummaryListResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SalonsIdGet**
> SalonDetail apiV1SalonsIdGet(id)

Salon details

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getSalonsApi();
final String id = id_example; // String | Salon identifier

try {
    final response = api.apiV1SalonsIdGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SalonsApi->apiV1SalonsIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Salon identifier | 

### Return type

[**SalonDetail**](SalonDetail.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

