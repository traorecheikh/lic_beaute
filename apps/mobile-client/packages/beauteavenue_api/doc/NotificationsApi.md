# beauteavenue_api.api.NotificationsApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1NotificationsGet**](NotificationsApi.md#apiv1notificationsget) | **GET** /api/v1/notifications | List notifications
[**apiV1NotificationsIdReadPost**](NotificationsApi.md#apiv1notificationsidreadpost) | **POST** /api/v1/notifications/{id}/read | Mark one notification as read
[**apiV1NotificationsReadAllPost**](NotificationsApi.md#apiv1notificationsreadallpost) | **POST** /api/v1/notifications/read-all | Mark all notifications as read


# **apiV1NotificationsGet**
> ApiV1NotificationsGet200Response apiV1NotificationsGet()

List notifications

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getNotificationsApi();

try {
    final response = api.apiV1NotificationsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->apiV1NotificationsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1NotificationsGet200Response**](ApiV1NotificationsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1NotificationsIdReadPost**
> ApiV1NotificationsIdReadPost200Response apiV1NotificationsIdReadPost(id)

Mark one notification as read

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getNotificationsApi();
final String id = id_example; // String | Notification identifier

try {
    final response = api.apiV1NotificationsIdReadPost(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->apiV1NotificationsIdReadPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Notification identifier | 

### Return type

[**ApiV1NotificationsIdReadPost200Response**](ApiV1NotificationsIdReadPost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1NotificationsReadAllPost**
> UpdatedResponse apiV1NotificationsReadAllPost()

Mark all notifications as read

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getNotificationsApi();

try {
    final response = api.apiV1NotificationsReadAllPost();
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->apiV1NotificationsReadAllPost: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UpdatedResponse**](UpdatedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

