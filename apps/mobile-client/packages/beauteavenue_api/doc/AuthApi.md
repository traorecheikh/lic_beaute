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
[**apiV1AuthOtpEmailRequestPost**](AuthApi.md#apiv1authotpemailrequestpost) | **POST** /api/v1/auth/otp/email/request | Request an OTP code via email
[**apiV1AuthOtpEmailVerifyPost**](AuthApi.md#apiv1authotpemailverifypost) | **POST** /api/v1/auth/otp/email/verify | Verify email OTP and create/login client
[**apiV1AuthOtpRequestPost**](AuthApi.md#apiv1authotprequestpost) | **POST** /api/v1/auth/otp/request | Request an OTP code
[**apiV1AuthOtpVerifyPost**](AuthApi.md#apiv1authotpverifypost) | **POST** /api/v1/auth/otp/verify | Verify OTP
[**apiV1AuthRefreshPost**](AuthApi.md#apiv1authrefreshpost) | **POST** /api/v1/auth/refresh | Refresh access token
[**apiV1AuthRegisterPost**](AuthApi.md#apiv1authregisterpost) | **POST** /api/v1/auth/register | Register client or salon owner
[**apiV1MeAddressesAddressIdDelete**](AuthApi.md#apiv1meaddressesaddressiddelete) | **DELETE** /api/v1/me/addresses/{addressId} | Delete a saved address
[**apiV1MeAddressesAddressIdPatch**](AuthApi.md#apiv1meaddressesaddressidpatch) | **PATCH** /api/v1/me/addresses/{addressId} | Update a saved address
[**apiV1MeAddressesGet**](AuthApi.md#apiv1meaddressesget) | **GET** /api/v1/me/addresses | List saved addresses
[**apiV1MeAddressesPost**](AuthApi.md#apiv1meaddressespost) | **POST** /api/v1/me/addresses | Create a saved address
[**apiV1MeBenefitsGet**](AuthApi.md#apiv1mebenefitsget) | **GET** /api/v1/me/benefits | List client memberships and packages
[**apiV1MeDelete**](AuthApi.md#apiv1medelete) | **DELETE** /api/v1/me | Delete current user account (GDPR right to erasure)
[**apiV1MeGet**](AuthApi.md#apiv1meget) | **GET** /api/v1/me | Current user
[**apiV1MePatch**](AuthApi.md#apiv1mepatch) | **PATCH** /api/v1/me | Update current user
[**apiV1MePaymentMethodsGet**](AuthApi.md#apiv1mepaymentmethodsget) | **GET** /api/v1/me/payment-methods | List saved payment methods
[**apiV1MePaymentMethodsPaymentMethodIdDefaultPost**](AuthApi.md#apiv1mepaymentmethodspaymentmethodiddefaultpost) | **POST** /api/v1/me/payment-methods/{paymentMethodId}/default | Set the default saved payment method
[**apiV1MePaymentMethodsPaymentMethodIdDelete**](AuthApi.md#apiv1mepaymentmethodspaymentmethodiddelete) | **DELETE** /api/v1/me/payment-methods/{paymentMethodId} | Delete a saved payment method
[**apiV1MePaymentMethodsPaymentMethodIdPatch**](AuthApi.md#apiv1mepaymentmethodspaymentmethodidpatch) | **PATCH** /api/v1/me/payment-methods/{paymentMethodId} | Update a saved payment method
[**apiV1MePaymentMethodsPost**](AuthApi.md#apiv1mepaymentmethodspost) | **POST** /api/v1/me/payment-methods | Create a saved payment method
[**apiV1MeVouchersGet**](AuthApi.md#apiv1mevouchersget) | **GET** /api/v1/me/vouchers | List redeemed vouchers
[**apiV1MeVouchersRedeemPost**](AuthApi.md#apiv1mevouchersredeempost) | **POST** /api/v1/me/vouchers/redeem | Redeem a voucher code
[**apiV1MetadataProfileOptionsGet**](AuthApi.md#apiv1metadataprofileoptionsget) | **GET** /api/v1/metadata/profile-options | Profile dropdown and preference options


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

# **apiV1AuthOtpEmailRequestPost**
> EmailOtpAcceptedResponse apiV1AuthOtpEmailRequestPost(emailOtpRequestInput)

Request an OTP code via email

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final EmailOtpRequestInput emailOtpRequestInput = ; // EmailOtpRequestInput | 

try {
    final response = api.apiV1AuthOtpEmailRequestPost(emailOtpRequestInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1AuthOtpEmailRequestPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **emailOtpRequestInput** | [**EmailOtpRequestInput**](EmailOtpRequestInput.md)|  | 

### Return type

[**EmailOtpAcceptedResponse**](EmailOtpAcceptedResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AuthOtpEmailVerifyPost**
> AuthSession apiV1AuthOtpEmailVerifyPost(emailOtpVerifyInput)

Verify email OTP and create/login client

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final EmailOtpVerifyInput emailOtpVerifyInput = ; // EmailOtpVerifyInput | 

try {
    final response = api.apiV1AuthOtpEmailVerifyPost(emailOtpVerifyInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1AuthOtpEmailVerifyPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **emailOtpVerifyInput** | [**EmailOtpVerifyInput**](EmailOtpVerifyInput.md)|  | 

### Return type

[**AuthSession**](AuthSession.md)

### Authorization

No authorization required

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

# **apiV1MeAddressesAddressIdDelete**
> DeletedResponse apiV1MeAddressesAddressIdDelete(addressId)

Delete a saved address

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final String addressId = addressId_example; // String | Address identifier

try {
    final response = api.apiV1MeAddressesAddressIdDelete(addressId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MeAddressesAddressIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addressId** | **String**| Address identifier | 

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MeAddressesAddressIdPatch**
> UpdatedResponse apiV1MeAddressesAddressIdPatch(addressId, apiV1MeAddressesAddressIdPatchRequest)

Update a saved address

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final String addressId = addressId_example; // String | Address identifier
final ApiV1MeAddressesAddressIdPatchRequest apiV1MeAddressesAddressIdPatchRequest = ; // ApiV1MeAddressesAddressIdPatchRequest | 

try {
    final response = api.apiV1MeAddressesAddressIdPatch(addressId, apiV1MeAddressesAddressIdPatchRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MeAddressesAddressIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addressId** | **String**| Address identifier | 
 **apiV1MeAddressesAddressIdPatchRequest** | [**ApiV1MeAddressesAddressIdPatchRequest**](ApiV1MeAddressesAddressIdPatchRequest.md)|  | 

### Return type

[**UpdatedResponse**](UpdatedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MeAddressesGet**
> ApiV1MeAddressesGet200Response apiV1MeAddressesGet()

List saved addresses

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();

try {
    final response = api.apiV1MeAddressesGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MeAddressesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1MeAddressesGet200Response**](ApiV1MeAddressesGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MeAddressesPost**
> ApiV1MeAddressesGet200ResponseItemsInner apiV1MeAddressesPost(apiV1MeAddressesPostRequest)

Create a saved address

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final ApiV1MeAddressesPostRequest apiV1MeAddressesPostRequest = ; // ApiV1MeAddressesPostRequest | 

try {
    final response = api.apiV1MeAddressesPost(apiV1MeAddressesPostRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MeAddressesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiV1MeAddressesPostRequest** | [**ApiV1MeAddressesPostRequest**](ApiV1MeAddressesPostRequest.md)|  | 

### Return type

[**ApiV1MeAddressesGet200ResponseItemsInner**](ApiV1MeAddressesGet200ResponseItemsInner.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MeBenefitsGet**
> ApiV1MeBenefitsGet200Response apiV1MeBenefitsGet()

List client memberships and packages

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();

try {
    final response = api.apiV1MeBenefitsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MeBenefitsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1MeBenefitsGet200Response**](ApiV1MeBenefitsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MeDelete**
> DeletedResponse apiV1MeDelete()

Delete current user account (GDPR right to erasure)

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();

try {
    final response = api.apiV1MeDelete();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MeDelete: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
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

# **apiV1MePaymentMethodsGet**
> ApiV1MePaymentMethodsGet200Response apiV1MePaymentMethodsGet()

List saved payment methods

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();

try {
    final response = api.apiV1MePaymentMethodsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MePaymentMethodsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1MePaymentMethodsGet200Response**](ApiV1MePaymentMethodsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MePaymentMethodsPaymentMethodIdDefaultPost**
> ClientPaymentMethod apiV1MePaymentMethodsPaymentMethodIdDefaultPost(paymentMethodId)

Set the default saved payment method

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final String paymentMethodId = paymentMethodId_example; // String | Payment method identifier

try {
    final response = api.apiV1MePaymentMethodsPaymentMethodIdDefaultPost(paymentMethodId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MePaymentMethodsPaymentMethodIdDefaultPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentMethodId** | **String**| Payment method identifier | 

### Return type

[**ClientPaymentMethod**](ClientPaymentMethod.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MePaymentMethodsPaymentMethodIdDelete**
> DeletedResponse apiV1MePaymentMethodsPaymentMethodIdDelete(paymentMethodId)

Delete a saved payment method

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final String paymentMethodId = paymentMethodId_example; // String | Payment method identifier

try {
    final response = api.apiV1MePaymentMethodsPaymentMethodIdDelete(paymentMethodId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MePaymentMethodsPaymentMethodIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentMethodId** | **String**| Payment method identifier | 

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MePaymentMethodsPaymentMethodIdPatch**
> ClientPaymentMethod apiV1MePaymentMethodsPaymentMethodIdPatch(paymentMethodId, clientPaymentMethodUpdateInput)

Update a saved payment method

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final String paymentMethodId = paymentMethodId_example; // String | Payment method identifier
final ClientPaymentMethodUpdateInput clientPaymentMethodUpdateInput = ; // ClientPaymentMethodUpdateInput | 

try {
    final response = api.apiV1MePaymentMethodsPaymentMethodIdPatch(paymentMethodId, clientPaymentMethodUpdateInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MePaymentMethodsPaymentMethodIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentMethodId** | **String**| Payment method identifier | 
 **clientPaymentMethodUpdateInput** | [**ClientPaymentMethodUpdateInput**](ClientPaymentMethodUpdateInput.md)|  | 

### Return type

[**ClientPaymentMethod**](ClientPaymentMethod.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MePaymentMethodsPost**
> ClientPaymentMethod apiV1MePaymentMethodsPost(clientPaymentMethodCreateInput)

Create a saved payment method

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final ClientPaymentMethodCreateInput clientPaymentMethodCreateInput = ; // ClientPaymentMethodCreateInput | 

try {
    final response = api.apiV1MePaymentMethodsPost(clientPaymentMethodCreateInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MePaymentMethodsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **clientPaymentMethodCreateInput** | [**ClientPaymentMethodCreateInput**](ClientPaymentMethodCreateInput.md)|  | 

### Return type

[**ClientPaymentMethod**](ClientPaymentMethod.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MeVouchersGet**
> ApiV1MeVouchersGet200Response apiV1MeVouchersGet()

List redeemed vouchers

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();

try {
    final response = api.apiV1MeVouchersGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MeVouchersGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ApiV1MeVouchersGet200Response**](ApiV1MeVouchersGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MeVouchersRedeemPost**
> ClientVoucher apiV1MeVouchersRedeemPost(redeemVoucherInput)

Redeem a voucher code

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();
final RedeemVoucherInput redeemVoucherInput = ; // RedeemVoucherInput | 

try {
    final response = api.apiV1MeVouchersRedeemPost(redeemVoucherInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MeVouchersRedeemPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **redeemVoucherInput** | [**RedeemVoucherInput**](RedeemVoucherInput.md)|  | 

### Return type

[**ClientVoucher**](ClientVoucher.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1MetadataProfileOptionsGet**
> ProfileOptions apiV1MetadataProfileOptionsGet()

Profile dropdown and preference options

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAuthApi();

try {
    final response = api.apiV1MetadataProfileOptionsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AuthApi->apiV1MetadataProfileOptionsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ProfileOptions**](ProfileOptions.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

