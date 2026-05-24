# PaymentsApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1PaymentsDepositsExecutePost**](PaymentsApi.md#apiv1paymentsdepositsexecutepost) | **POST** /api/v1/payments/deposits/execute | Execute a payment with a specific method (two-step flow) |
| [**apiV1PaymentsDepositsInitiatePost**](PaymentsApi.md#apiv1paymentsdepositsinitiatepost) | **POST** /api/v1/payments/deposits/initiate | Initiate deposit payment for a booking |
| [**apiV1PaymentsMethodsGet**](PaymentsApi.md#apiv1paymentsmethodsget) | **GET** /api/v1/payments/methods | Get available payment methods from the active provider |
| [**apiV1PaymentsPaymentIdGet**](PaymentsApi.md#apiv1paymentspaymentidget) | **GET** /api/v1/payments/{paymentId} | Get payment status |
| [**apiV1PaymentsPaymentIdReconcilePost**](PaymentsApi.md#apiv1paymentspaymentidreconcilepost) | **POST** /api/v1/payments/{paymentId}/reconcile | Manually reconcile a payment (admin or pro) |
| [**apiV1PaymentsPaymentIdRefundPost**](PaymentsApi.md#apiv1paymentspaymentidrefundpost) | **POST** /api/v1/payments/{paymentId}/refund | Refund a payment |
| [**apiV1PaymentsWebhooksIntechPost**](PaymentsApi.md#apiv1paymentswebhooksintechpost) | **POST** /api/v1/payments/webhooks/intech | Intech payment webhook callback |
| [**apiV1PaymentsWebhooksPaydunyaPost**](PaymentsApi.md#apiv1paymentswebhookspaydunyapost) | **POST** /api/v1/payments/webhooks/paydunya | PayDunya payment webhook callback |



## apiV1PaymentsDepositsExecutePost

> PaydunyaExecutePaymentResponse apiV1PaymentsDepositsExecutePost(paydunyaExecutePaymentInput)

Execute a payment with a specific method (two-step flow)

### Example

```ts
import {
  Configuration,
  PaymentsApi,
} from '';
import type { ApiV1PaymentsDepositsExecutePostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new PaymentsApi(config);

  const body = {
    // PaydunyaExecutePaymentInput
    paydunyaExecutePaymentInput: ...,
  } satisfies ApiV1PaymentsDepositsExecutePostRequest;

  try {
    const data = await api.apiV1PaymentsDepositsExecutePost(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **paydunyaExecutePaymentInput** | [PaydunyaExecutePaymentInput](PaydunyaExecutePaymentInput.md) |  | |

### Return type

[**PaydunyaExecutePaymentResponse**](PaydunyaExecutePaymentResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Payment execution result |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1PaymentsDepositsInitiatePost

> PaymentInitiateResponse apiV1PaymentsDepositsInitiatePost(paymentInitiateInput)

Initiate deposit payment for a booking

### Example

```ts
import {
  Configuration,
  PaymentsApi,
} from '';
import type { ApiV1PaymentsDepositsInitiatePostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new PaymentsApi(config);

  const body = {
    // PaymentInitiateInput
    paymentInitiateInput: ...,
  } satisfies ApiV1PaymentsDepositsInitiatePostRequest;

  try {
    const data = await api.apiV1PaymentsDepositsInitiatePost(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **paymentInitiateInput** | [PaymentInitiateInput](PaymentInitiateInput.md) |  | |

### Return type

[**PaymentInitiateResponse**](PaymentInitiateResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Payment initiation |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1PaymentsMethodsGet

> PaydunyaMethodListResponse apiV1PaymentsMethodsGet()

Get available payment methods from the active provider

### Example

```ts
import {
  Configuration,
  PaymentsApi,
} from '';
import type { ApiV1PaymentsMethodsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new PaymentsApi(config);

  try {
    const data = await api.apiV1PaymentsMethodsGet();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**PaydunyaMethodListResponse**](PaydunyaMethodListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Available payment methods |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1PaymentsPaymentIdGet

> PaymentStatusResponse apiV1PaymentsPaymentIdGet(paymentId)

Get payment status

### Example

```ts
import {
  Configuration,
  PaymentsApi,
} from '';
import type { ApiV1PaymentsPaymentIdGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new PaymentsApi(config);

  const body = {
    // string | Payment identifier
    paymentId: paymentId_example,
  } satisfies ApiV1PaymentsPaymentIdGetRequest;

  try {
    const data = await api.apiV1PaymentsPaymentIdGet(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **paymentId** | `string` | Payment identifier | [Defaults to `undefined`] |

### Return type

[**PaymentStatusResponse**](PaymentStatusResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Payment status |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1PaymentsPaymentIdReconcilePost

> PaymentReconcileResponse apiV1PaymentsPaymentIdReconcilePost(paymentId)

Manually reconcile a payment (admin or pro)

### Example

```ts
import {
  Configuration,
  PaymentsApi,
} from '';
import type { ApiV1PaymentsPaymentIdReconcilePostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new PaymentsApi(config);

  const body = {
    // string | Payment identifier
    paymentId: paymentId_example,
  } satisfies ApiV1PaymentsPaymentIdReconcilePostRequest;

  try {
    const data = await api.apiV1PaymentsPaymentIdReconcilePost(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **paymentId** | `string` | Payment identifier | [Defaults to `undefined`] |

### Return type

[**PaymentReconcileResponse**](PaymentReconcileResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Reconciled payment status |  -  |
| **404** | Payment not found |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1PaymentsPaymentIdRefundPost

> PaymentStatusResponse apiV1PaymentsPaymentIdRefundPost(paymentId)

Refund a payment

### Example

```ts
import {
  Configuration,
  PaymentsApi,
} from '';
import type { ApiV1PaymentsPaymentIdRefundPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new PaymentsApi(config);

  const body = {
    // string | Payment identifier
    paymentId: paymentId_example,
  } satisfies ApiV1PaymentsPaymentIdRefundPostRequest;

  try {
    const data = await api.apiV1PaymentsPaymentIdRefundPost(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **paymentId** | `string` | Payment identifier | [Defaults to `undefined`] |

### Return type

[**PaymentStatusResponse**](PaymentStatusResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Refund result |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1PaymentsWebhooksIntechPost

> ApiV1PaymentsWebhooksPaydunyaPost200Response apiV1PaymentsWebhooksIntechPost(paymentWebhookBody)

Intech payment webhook callback

### Example

```ts
import {
  Configuration,
  PaymentsApi,
} from '';
import type { ApiV1PaymentsWebhooksIntechPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new PaymentsApi();

  const body = {
    // PaymentWebhookBody
    paymentWebhookBody: ...,
  } satisfies ApiV1PaymentsWebhooksIntechPostRequest;

  try {
    const data = await api.apiV1PaymentsWebhooksIntechPost(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **paymentWebhookBody** | [PaymentWebhookBody](PaymentWebhookBody.md) |  | |

### Return type

[**ApiV1PaymentsWebhooksPaydunyaPost200Response**](ApiV1PaymentsWebhooksPaydunyaPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Webhook acknowledged |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1PaymentsWebhooksPaydunyaPost

> ApiV1PaymentsWebhooksPaydunyaPost200Response apiV1PaymentsWebhooksPaydunyaPost(paymentWebhookBody)

PayDunya payment webhook callback

### Example

```ts
import {
  Configuration,
  PaymentsApi,
} from '';
import type { ApiV1PaymentsWebhooksPaydunyaPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new PaymentsApi();

  const body = {
    // PaymentWebhookBody
    paymentWebhookBody: ...,
  } satisfies ApiV1PaymentsWebhooksPaydunyaPostRequest;

  try {
    const data = await api.apiV1PaymentsWebhooksPaydunyaPost(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **paymentWebhookBody** | [PaymentWebhookBody](PaymentWebhookBody.md) |  | |

### Return type

[**ApiV1PaymentsWebhooksPaydunyaPost200Response**](ApiV1PaymentsWebhooksPaydunyaPost200Response.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Webhook accepted |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

