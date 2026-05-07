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


# **apiV1MediaMediaIdCompletePost**
> ApiV1MediaMediaIdCompletePost200Response apiV1MediaMediaIdCompletePost(mediaId)

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

[**ApiV1MediaMediaIdCompletePost200Response**](ApiV1MediaMediaIdCompletePost200Response.md)

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

