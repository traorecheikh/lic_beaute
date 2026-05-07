# beauteavenue_api.api.FavoritesApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1FavoritesGet**](FavoritesApi.md#apiv1favoritesget) | **GET** /api/v1/favorites | List client favorites
[**apiV1FavoritesSalonIdDelete**](FavoritesApi.md#apiv1favoritessaloniddelete) | **DELETE** /api/v1/favorites/{salonId} | Remove salon from favorites
[**apiV1FavoritesSalonIdPost**](FavoritesApi.md#apiv1favoritessalonidpost) | **POST** /api/v1/favorites/{salonId} | Add salon to favorites


# **apiV1FavoritesGet**
> FavoriteListResponse apiV1FavoritesGet()

List client favorites

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getFavoritesApi();

try {
    final response = api.apiV1FavoritesGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling FavoritesApi->apiV1FavoritesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**FavoriteListResponse**](FavoriteListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1FavoritesSalonIdDelete**
> DeletedResponse apiV1FavoritesSalonIdDelete(salonId)

Remove salon from favorites

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getFavoritesApi();
final String salonId = salonId_example; // String | Salon identifier

try {
    final response = api.apiV1FavoritesSalonIdDelete(salonId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling FavoritesApi->apiV1FavoritesSalonIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **salonId** | **String**| Salon identifier | 

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1FavoritesSalonIdPost**
> FavoriteItem apiV1FavoritesSalonIdPost(salonId)

Add salon to favorites

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getFavoritesApi();
final String salonId = salonId_example; // String | Salon identifier

try {
    final response = api.apiV1FavoritesSalonIdPost(salonId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling FavoritesApi->apiV1FavoritesSalonIdPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **salonId** | **String**| Salon identifier | 

### Return type

[**FavoriteItem**](FavoriteItem.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

