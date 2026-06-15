# beauteavenue_api.api.SearchApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1SearchEventsPost**](SearchApi.md#apiv1searcheventspost) | **POST** /api/v1/search/events | Track search interaction events for personalization
[**apiV1SearchSalonsGet**](SearchApi.md#apiv1searchsalonsget) | **GET** /api/v1/search/salons | Search salons with ranked results, facets, and discovery modules
[**apiV1SearchSuggestionsGet**](SearchApi.md#apiv1searchsuggestionsget) | **GET** /api/v1/search/suggestions | Get search suggestions and autocomplete


# **apiV1SearchEventsPost**
> SearchEventsResponse apiV1SearchEventsPost(searchEventsRequest)

Track search interaction events for personalization

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getSearchApi();
final SearchEventsRequest searchEventsRequest = ; // SearchEventsRequest | 

try {
    final response = api.apiV1SearchEventsPost(searchEventsRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->apiV1SearchEventsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **searchEventsRequest** | [**SearchEventsRequest**](SearchEventsRequest.md)|  | 

### Return type

[**SearchEventsResponse**](SearchEventsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SearchSalonsGet**
> SearchSalonsResponse apiV1SearchSalonsGet(q, lat, lng, category, city, neighborhood, minPrice, maxPrice, openNow, bookableSoon, sort, cursor, limit)

Search salons with ranked results, facets, and discovery modules

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getSearchApi();
final String q = q_example; // String | 
final num lat = 8.14; // num | 
final num lng = 8.14; // num | 
final String category = category_example; // String | 
final String city = city_example; // String | 
final String neighborhood = neighborhood_example; // String | 
final int minPrice = 56; // int | 
final int maxPrice = 56; // int | 
final bool openNow = true; // bool | 
final bool bookableSoon = true; // bool | 
final String sort = sort_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.apiV1SearchSalonsGet(q, lat, lng, category, city, neighborhood, minPrice, maxPrice, openNow, bookableSoon, sort, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->apiV1SearchSalonsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | 
 **lat** | **num**|  | [optional] 
 **lng** | **num**|  | [optional] 
 **category** | **String**|  | [optional] 
 **city** | **String**|  | [optional] 
 **neighborhood** | **String**|  | [optional] 
 **minPrice** | **int**|  | [optional] 
 **maxPrice** | **int**|  | [optional] 
 **openNow** | **bool**|  | [optional] 
 **bookableSoon** | **bool**|  | [optional] 
 **sort** | **String**|  | [optional] 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] 

### Return type

[**SearchSalonsResponse**](SearchSalonsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SearchSuggestionsGet**
> SearchSuggestionsResponse apiV1SearchSuggestionsGet(q, lat, lng, category, city)

Get search suggestions and autocomplete

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getSearchApi();
final String q = q_example; // String | 
final num lat = 8.14; // num | 
final num lng = 8.14; // num | 
final String category = category_example; // String | 
final String city = city_example; // String | 

try {
    final response = api.apiV1SearchSuggestionsGet(q, lat, lng, category, city);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->apiV1SearchSuggestionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | 
 **lat** | **num**|  | [optional] 
 **lng** | **num**|  | [optional] 
 **category** | **String**|  | [optional] 
 **city** | **String**|  | [optional] 

### Return type

[**SearchSuggestionsResponse**](SearchSuggestionsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

