# beauteavenue_api.api.PaymentsApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1PaymentsDepositsInitiatePost**](PaymentsApi.md#apiv1paymentsdepositsinitiatepost) | **POST** /api/v1/payments/deposits/initiate | Initiate deposit payment for a booking
[**apiV1PaymentsPaymentIdGet**](PaymentsApi.md#apiv1paymentspaymentidget) | **GET** /api/v1/payments/{paymentId} | Get payment status
[**apiV1PaymentsPaymentIdReconcilePost**](PaymentsApi.md#apiv1paymentspaymentidreconcilepost) | **POST** /api/v1/payments/{paymentId}/reconcile | Manually reconcile a payment (admin or pro)
[**apiV1PaymentsPaymentIdRefundPost**](PaymentsApi.md#apiv1paymentspaymentidrefundpost) | **POST** /api/v1/payments/{paymentId}/refund | Refund a payment
[**apiV1PaymentsWebhooksIntechPost**](PaymentsApi.md#apiv1paymentswebhooksintechpost) | **POST** /api/v1/payments/webhooks/intech | Intech payment webhook callback
[**apiV1PaymentsWebhooksPaytechPost**](PaymentsApi.md#apiv1paymentswebhookspaytechpost) | **POST** /api/v1/payments/webhooks/paytech | PayTech payment webhook callback


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

# **apiV1PaymentsWebhooksIntechPost**
> ApiV1PaymentsWebhooksIntechPost200Response apiV1PaymentsWebhooksIntechPost(paymentWebhookBody)

Intech payment webhook callback

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getPaymentsApi();
final PaymentWebhookBody paymentWebhookBody = ; // PaymentWebhookBody | 

try {
    final response = api.apiV1PaymentsWebhooksIntechPost(paymentWebhookBody);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentsApi->apiV1PaymentsWebhooksIntechPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentWebhookBody** | [**PaymentWebhookBody**](PaymentWebhookBody.md)|  | 

### Return type

[**ApiV1PaymentsWebhooksIntechPost200Response**](ApiV1PaymentsWebhooksIntechPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1PaymentsWebhooksPaytechPost**
> ApiV1PaymentsWebhooksIntechPost200Response apiV1PaymentsWebhooksPaytechPost(paymentWebhookBody)

PayTech payment webhook callback

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getPaymentsApi();
final PaymentWebhookBody paymentWebhookBody = ; // PaymentWebhookBody | 

try {
    final response = api.apiV1PaymentsWebhooksPaytechPost(paymentWebhookBody);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentsApi->apiV1PaymentsWebhooksPaytechPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentWebhookBody** | [**PaymentWebhookBody**](PaymentWebhookBody.md)|  | 

### Return type

[**ApiV1PaymentsWebhooksIntechPost200Response**](ApiV1PaymentsWebhooksIntechPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

