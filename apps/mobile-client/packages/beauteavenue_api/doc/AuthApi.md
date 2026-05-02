# beauteavenue_api.api.AuthApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1AuthLoginPost**](AuthApi.md#apiv1authloginpost) | **POST** /api/v1/auth/login | Email login
[**apiV1AuthLogoutPost**](AuthApi.md#apiv1authlogoutpost) | **POST** /api/v1/auth/logout | Logout current session
[**apiV1AuthOtpRequestPost**](AuthApi.md#apiv1authotprequestpost) | **POST** /api/v1/auth/otp/request | Request an OTP code
[**apiV1AuthOtpVerifyPost**](AuthApi.md#apiv1authotpverifypost) | **POST** /api/v1/auth/otp/verify | Verify OTP
[**apiV1AuthRefreshPost**](AuthApi.md#apiv1authrefreshpost) | **POST** /api/v1/auth/refresh | Refresh access token
[**apiV1AuthRegisterPost**](AuthApi.md#apiv1authregisterpost) | **POST** /api/v1/auth/register | Register client or salon owner
[**apiV1MeGet**](AuthApi.md#apiv1meget) | **GET** /api/v1/me | Current user
[**apiV1MePatch**](AuthApi.md#apiv1mepatch) | **PATCH** /api/v1/me | Update current user


# **apiV1AuthLoginPost**
> AuthSession apiV1AuthLoginPost(emailLoginInput)

Email login

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final EmailLoginInput emailLoginInput = ; // EmailLoginInput | 

try {
    final response = api.apiV1AuthLoginPost(emailLoginInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1AuthLoginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **emailLoginInput** | [**EmailLoginInput**](EmailLoginInput.md)|  | 

### Return type

[**AuthSession**](AuthSession.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AuthLogoutPost**
> LogoutResponse apiV1AuthLogoutPost(refreshInput)

Logout current session

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final RefreshInput refreshInput = ; // RefreshInput | 

try {
    final response = api.apiV1AuthLogoutPost(refreshInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1AuthLogoutPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshInput** | [**RefreshInput**](RefreshInput.md)|  | [optional] 

### Return type

[**LogoutResponse**](LogoutResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AuthOtpRequestPost**
> OtpAcceptedResponse apiV1AuthOtpRequestPost(otpRequestInput)

Request an OTP code

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final OtpRequestInput otpRequestInput = ; // OtpRequestInput | 

try {
    final response = api.apiV1AuthOtpRequestPost(otpRequestInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1AuthOtpRequestPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **otpRequestInput** | [**OtpRequestInput**](OtpRequestInput.md)|  | 

### Return type

[**OtpAcceptedResponse**](OtpAcceptedResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AuthOtpVerifyPost**
> AuthSession apiV1AuthOtpVerifyPost(otpVerifyInput)

Verify OTP

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final OtpVerifyInput otpVerifyInput = ; // OtpVerifyInput | 

try {
    final response = api.apiV1AuthOtpVerifyPost(otpVerifyInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1AuthOtpVerifyPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **otpVerifyInput** | [**OtpVerifyInput**](OtpVerifyInput.md)|  | 

### Return type

[**AuthSession**](AuthSession.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AuthRefreshPost**
> AuthSession apiV1AuthRefreshPost(refreshInput)

Refresh access token

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final RefreshInput refreshInput = ; // RefreshInput | 

try {
    final response = api.apiV1AuthRefreshPost(refreshInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1AuthRefreshPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshInput** | [**RefreshInput**](RefreshInput.md)|  | 

### Return type

[**AuthSession**](AuthSession.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AuthRegisterPost**
> AuthSession apiV1AuthRegisterPost(registerInput)

Register client or salon owner

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final RegisterInput registerInput = ; // RegisterInput | 

try {
    final response = api.apiV1AuthRegisterPost(registerInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1AuthRegisterPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerInput** | [**RegisterInput**](RegisterInput.md)|  | 

### Return type

[**AuthSession**](AuthSession.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MeGet**
> CurrentUser apiV1MeGet()

Current user

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();

try {
    final response = api.apiV1MeGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MeGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CurrentUser**](CurrentUser.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MePatch**
> CurrentUser apiV1MePatch(updateMeInput)

Update current user

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final UpdateMeInput updateMeInput = ; // UpdateMeInput | 

try {
    final response = api.apiV1MePatch(updateMeInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MePatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateMeInput** | [**UpdateMeInput**](UpdateMeInput.md)|  | 

### Return type

[**CurrentUser**](CurrentUser.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

