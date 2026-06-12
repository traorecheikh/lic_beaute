# beauteavenue_api.api.PaymentsApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1PaymentsDepositsExecutePost**](PaymentsApi.md#apiv1paymentsdepositsexecutepost) | **POST** /api/v1/payments/deposits/execute | Execute a payment with a specific method (two-step flow)
[**apiV1PaymentsDepositsInitiatePost**](PaymentsApi.md#apiv1paymentsdepositsinitiatepost) | **POST** /api/v1/payments/deposits/initiate | Initiate deposit payment for a booking
[**apiV1PaymentsMethodsGet**](PaymentsApi.md#apiv1paymentsmethodsget) | **GET** /api/v1/payments/methods | Get available payment methods from the active provider
[**apiV1PaymentsPaymentIdGet**](PaymentsApi.md#apiv1paymentspaymentidget) | **GET** /api/v1/payments/{paymentId} | Get payment status
[**apiV1PaymentsPaymentIdReconcilePost**](PaymentsApi.md#apiv1paymentspaymentidreconcilepost) | **POST** /api/v1/payments/{paymentId}/reconcile | Manually reconcile a payment (admin or pro)
[**apiV1PaymentsPaymentIdRefundPost**](PaymentsApi.md#apiv1paymentspaymentidrefundpost) | **POST** /api/v1/payments/{paymentId}/refund | Refund a payment
[**apiV1PaymentsWebhooksPaydunyaPost**](PaymentsApi.md#apiv1paymentswebhookspaydunyapost) | **POST** /api/v1/payments/webhooks/paydunya | PayDunya payment webhook callback


# **apiV1PaymentsDepositsExecutePost**
> PaydunyaExecutePaymentResponse apiV1PaymentsDepositsExecutePost(paydunyaExecutePaymentInput)

Execute a payment with a specific method (two-step flow)

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getPaymentsApi();
final PaydunyaExecutePaymentInput paydunyaExecutePaymentInput = ; // PaydunyaExecutePaymentInput | 

try {
    final response = api.apiV1PaymentsDepositsExecutePost(paydunyaExecutePaymentInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentsApi->apiV1PaymentsDepositsExecutePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paydunyaExecutePaymentInput** | [**PaydunyaExecutePaymentInput**](PaydunyaExecutePaymentInput.md)|  | 

### Return type

[**PaydunyaExecutePaymentResponse**](PaydunyaExecutePaymentResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1PaymentsDepositsInitiatePost**
> PaymentInitiateResponse apiV1PaymentsDepositsInitiatePost(paymentInitiateInput)

Initiate deposit payment for a booking

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getPaymentsApi();
final PaymentInitiateInput paymentInitiateInput = ; // PaymentInitiateInput | 

try {
    final response = api.apiV1PaymentsDepositsInitiatePost(paymentInitiateInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentsApi->apiV1PaymentsDepositsInitiatePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentInitiateInput** | [**PaymentInitiateInput**](PaymentInitiateInput.md)|  | 

### Return type

[**PaymentInitiateResponse**](PaymentInitiateResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1PaymentsMethodsGet**
> PaydunyaMethodListResponse apiV1PaymentsMethodsGet()

Get available payment methods from the active provider

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getPaymentsApi();

try {
    final response = api.apiV1PaymentsMethodsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentsApi->apiV1PaymentsMethodsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PaydunyaMethodListResponse**](PaydunyaMethodListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1PaymentsPaymentIdGet**
> PaymentStatusResponse apiV1PaymentsPaymentIdGet(paymentId)

Get payment status

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getPaymentsApi();
final String paymentId = paymentId_example; // String | Payment identifier

try {
    final response = api.apiV1PaymentsPaymentIdGet(paymentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentsApi->apiV1PaymentsPaymentIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentId** | **String**| Payment identifier | 

### Return type

[**PaymentStatusResponse**](PaymentStatusResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1PaymentsPaymentIdReconcilePost**
> PaymentReconcileResponse apiV1PaymentsPaymentIdReconcilePost(paymentId)

Manually reconcile a payment (admin or pro)

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getPaymentsApi();
final String paymentId = paymentId_example; // String | Payment identifier

try {
    final response = api.apiV1PaymentsPaymentIdReconcilePost(paymentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentsApi->apiV1PaymentsPaymentIdReconcilePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentId** | **String**| Payment identifier | 

### Return type

[**PaymentReconcileResponse**](PaymentReconcileResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1PaymentsPaymentIdRefundPost**
> PaymentStatusResponse apiV1PaymentsPaymentIdRefundPost(paymentId)

Refund a payment

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getPaymentsApi();
final String paymentId = paymentId_example; // String | Payment identifier

try {
    final response = api.apiV1PaymentsPaymentIdRefundPost(paymentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentsApi->apiV1PaymentsPaymentIdRefundPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentId** | **String**| Payment identifier | 

### Return type

[**PaymentStatusResponse**](PaymentStatusResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1PaymentsWebhooksPaydunyaPost**
> ApiV1PaymentsWebhooksPaydunyaPost200Response apiV1PaymentsWebhooksPaydunyaPost(paymentWebhookBody)

PayDunya payment webhook callback

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getPaymentsApi();
final PaymentWebhookBody paymentWebhookBody = ; // PaymentWebhookBody | 

try {
    final response = api.apiV1PaymentsWebhooksPaydunyaPost(paymentWebhookBody);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentsApi->apiV1PaymentsWebhooksPaydunyaPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentWebhookBody** | [**PaymentWebhookBody**](PaymentWebhookBody.md)|  | 

### Return type

[**ApiV1PaymentsWebhooksPaydunyaPost200Response**](ApiV1PaymentsWebhooksPaydunyaPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

