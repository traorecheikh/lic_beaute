# beauteavenue_api.api.MediaApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1MediaMediaIdCompletePost**](MediaApi.md#apiv1mediamediaidcompletepost) | **POST** /api/v1/media/{mediaId}/complete | Confirm upload completed — triggers admin review
[**apiV1MediaMediaIdDelete**](MediaApi.md#apiv1mediamediaiddelete) | **DELETE** /api/v1/media/{mediaId} | Soft-delete a media asset
[**apiV1MediaMediaIdGet**](MediaApi.md#apiv1mediamediaidget) | **GET** /api/v1/media/{mediaId} | Retrieve media metadata
[**apiV1MediaUploadIntentPost**](MediaApi.md#apiv1mediauploadintentpost) | **POST** /api/v1/media/upload-intent | Request a presigned PUT URL for direct R2 upload
[**apiV1MediaUploadPost**](MediaApi.md#apiv1mediauploadpost) | **POST** /api/v1/media/upload | Upload media through API (adapter-aware: local/noop/r2)
[**apiV1SalonsSalonIdPublicMediaGet**](MediaApi.md#apiv1salonssalonidpublicmediaget) | **GET** /api/v1/salons/{salonId}/public-media | Get public media for a salon


# **apiV1MediaMediaIdCompletePost**
> ApiV1MediaUploadPost201Response apiV1MediaMediaIdCompletePost(mediaId)

Confirm upload completed — triggers admin review

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getMediaApi();
final String mediaId = mediaId_example; // String | Media asset identifier

try {
    final response = api.apiV1MediaMediaIdCompletePost(mediaId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MediaApi->apiV1MediaMediaIdCompletePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mediaId** | **String**| Media asset identifier | 

### Return type

[**ApiV1MediaUploadPost201Response**](ApiV1MediaUploadPost201Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MediaMediaIdDelete**
> DeletedResponse apiV1MediaMediaIdDelete(mediaId)

Soft-delete a media asset

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getMediaApi();
final String mediaId = mediaId_example; // String | Media identifier

try {
    final response = api.apiV1MediaMediaIdDelete(mediaId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MediaApi->apiV1MediaMediaIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mediaId** | **String**| Media identifier | 

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MediaMediaIdGet**
> MediaAsset apiV1MediaMediaIdGet(mediaId)

Retrieve media metadata

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getMediaApi();
final String mediaId = mediaId_example; // String | Media identifier

try {
    final response = api.apiV1MediaMediaIdGet(mediaId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MediaApi->apiV1MediaMediaIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mediaId** | **String**| Media identifier | 

### Return type

[**MediaAsset**](MediaAsset.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MediaUploadIntentPost**
> ApiV1MediaUploadIntentPost201Response apiV1MediaUploadIntentPost(apiV1MediaUploadIntentPostRequest)

Request a presigned PUT URL for direct R2 upload

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getMediaApi();
final ApiV1MediaUploadIntentPostRequest apiV1MediaUploadIntentPostRequest = ; // ApiV1MediaUploadIntentPostRequest | 

try {
    final response = api.apiV1MediaUploadIntentPost(apiV1MediaUploadIntentPostRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MediaApi->apiV1MediaUploadIntentPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiV1MediaUploadIntentPostRequest** | [**ApiV1MediaUploadIntentPostRequest**](ApiV1MediaUploadIntentPostRequest.md)|  | 

### Return type

[**ApiV1MediaUploadIntentPost201Response**](ApiV1MediaUploadIntentPost201Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MediaUploadPost**
> ApiV1MediaUploadPost201Response apiV1MediaUploadPost(purpose, file, salonId)

Upload media through API (adapter-aware: local/noop/r2)

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getMediaApi();
final String purpose = purpose_example; // String | 
final JsonObject file = ; // JsonObject | 
final String salonId = salonId_example; // String | 

try {
    final response = api.apiV1MediaUploadPost(purpose, file, salonId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MediaApi->apiV1MediaUploadPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **purpose** | **String**|  | 
 **file** | [**JsonObject**](JsonObject.md)|  | [optional] 
 **salonId** | **String**|  | [optional] 

### Return type

[**ApiV1MediaUploadPost201Response**](ApiV1MediaUploadPost201Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1SalonsSalonIdPublicMediaGet**
> ApiV1SalonsSalonIdPublicMediaGet200Response apiV1SalonsSalonIdPublicMediaGet(salonId)

Get public media for a salon

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getMediaApi();
final String salonId = salonId_example; // String | Salon identifier

try {
    final response = api.apiV1SalonsSalonIdPublicMediaGet(salonId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MediaApi->apiV1SalonsSalonIdPublicMediaGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **salonId** | **String**| Salon identifier | 

### Return type

[**ApiV1SalonsSalonIdPublicMediaGet200Response**](ApiV1SalonsSalonIdPublicMediaGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

