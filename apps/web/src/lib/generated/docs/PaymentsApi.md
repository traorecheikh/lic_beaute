# PaymentsApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1PaymentsDepositsInitiatePost**](PaymentsApi.md#apiv1paymentsdepositsinitiatepost) | **POST** /api/v1/payments/deposits/initiate | Initiate deposit payment for a booking |
| [**apiV1PaymentsPaymentIdGet**](PaymentsApi.md#apiv1paymentspaymentidget) | **GET** /api/v1/payments/{paymentId} | Get payment status |
| [**apiV1PaymentsPaymentIdReconcilePost**](PaymentsApi.md#apiv1paymentspaymentidreconcilepost) | **POST** /api/v1/payments/{paymentId}/reconcile | Manually reconcile a payment (admin or pro) |
| [**apiV1PaymentsPaymentIdRefundPost**](PaymentsApi.md#apiv1paymentspaymentidrefundpost) | **POST** /api/v1/payments/{paymentId}/refund | Refund a payment |
| [**apiV1PaymentsWebhooksIntechPost**](PaymentsApi.md#apiv1paymentswebhooksintechpost) | **POST** /api/v1/payments/webhooks/intech | Intech payment webhook callback |



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

> ApiV1PaymentsWebhooksIntechPost200Response apiV1PaymentsWebhooksIntechPost(paymentWebhookBody)

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

[**ApiV1PaymentsWebhooksIntechPost200Response**](ApiV1PaymentsWebhooksIntechPost200Response.md)

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

