# beauteavenue_api.api.PushApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1PushTokensPost**](PushApi.md#apiv1pushtokenspost) | **POST** /api/v1/push-tokens | Register a push notification token
[**apiV1PushTokensTokenIdDelete**](PushApi.md#apiv1pushtokenstokeniddelete) | **DELETE** /api/v1/push-tokens/{tokenId} | Revoke a push notification token


# **apiV1PushTokensPost**
> ApiV1PushTokensPost201Response apiV1PushTokensPost(pushTokenInput)

Register a push notification token

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getPushApi();
final PushTokenInput pushTokenInput = ; // PushTokenInput | 

try {
    final response = api.apiV1PushTokensPost(pushTokenInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PushApi->apiV1PushTokensPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pushTokenInput** | [**PushTokenInput**](PushTokenInput.md)|  | 

### Return type

[**ApiV1PushTokensPost201Response**](ApiV1PushTokensPost201Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1PushTokensTokenIdDelete**
> DeletedResponse apiV1PushTokensTokenIdDelete(tokenId)

Revoke a push notification token

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getPushApi();
final String tokenId = tokenId_example; // String | Push token identifier

try {
    final response = api.apiV1PushTokensTokenIdDelete(tokenId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PushApi->apiV1PushTokensTokenIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tokenId** | **String**| Push token identifier | 

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

