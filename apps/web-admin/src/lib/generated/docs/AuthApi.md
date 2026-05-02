# AuthApi

All URIs are relative to *http://localhost:3000*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**apiV1AuthLoginPost**](AuthApi.md#apiv1authloginpost) | **POST** /api/v1/auth/login | Email login |
| [**apiV1AuthLogoutPost**](AuthApi.md#apiv1authlogoutpost) | **POST** /api/v1/auth/logout | Logout current session |
| [**apiV1AuthOtpRequestPost**](AuthApi.md#apiv1authotprequestpost) | **POST** /api/v1/auth/otp/request | Request an OTP code |
| [**apiV1AuthOtpVerifyPost**](AuthApi.md#apiv1authotpverifypost) | **POST** /api/v1/auth/otp/verify | Verify OTP |
| [**apiV1AuthRefreshPost**](AuthApi.md#apiv1authrefreshpost) | **POST** /api/v1/auth/refresh | Refresh access token |
| [**apiV1AuthRegisterPost**](AuthApi.md#apiv1authregisterpost) | **POST** /api/v1/auth/register | Register client or salon owner |
| [**apiV1MeBenefitsGet**](AuthApi.md#apiv1mebenefitsget) | **GET** /api/v1/me/benefits | List client memberships and packages |
| [**apiV1MeGet**](AuthApi.md#apiv1meget) | **GET** /api/v1/me | Current user |
| [**apiV1MePatch**](AuthApi.md#apiv1mepatch) | **PATCH** /api/v1/me | Update current user |
| [**apiV1MePaymentMethodsGet**](AuthApi.md#apiv1mepaymentmethodsget) | **GET** /api/v1/me/payment-methods | List saved payment methods |
| [**apiV1MePaymentMethodsPaymentMethodIdDefaultPost**](AuthApi.md#apiv1mepaymentmethodspaymentmethodiddefaultpost) | **POST** /api/v1/me/payment-methods/{paymentMethodId}/default | Set the default saved payment method |
| [**apiV1MePaymentMethodsPaymentMethodIdDelete**](AuthApi.md#apiv1mepaymentmethodspaymentmethodiddelete) | **DELETE** /api/v1/me/payment-methods/{paymentMethodId} | Delete a saved payment method |
| [**apiV1MePaymentMethodsPaymentMethodIdPatch**](AuthApi.md#apiv1mepaymentmethodspaymentmethodidpatch) | **PATCH** /api/v1/me/payment-methods/{paymentMethodId} | Update a saved payment method |
| [**apiV1MePaymentMethodsPost**](AuthApi.md#apiv1mepaymentmethodspost) | **POST** /api/v1/me/payment-methods | Create a saved payment method |
| [**apiV1MeVouchersGet**](AuthApi.md#apiv1mevouchersget) | **GET** /api/v1/me/vouchers | List redeemed vouchers |
| [**apiV1MeVouchersRedeemPost**](AuthApi.md#apiv1mevouchersredeempost) | **POST** /api/v1/me/vouchers/redeem | Redeem a voucher code |
| [**apiV1MetadataProfileOptionsGet**](AuthApi.md#apiv1metadataprofileoptionsget) | **GET** /api/v1/metadata/profile-options | Profile dropdown and preference options |



## apiV1AuthLoginPost

> AuthSession apiV1AuthLoginPost(emailLoginInput)

Email login

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1AuthLoginPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new AuthApi();

  const body = {
    // EmailLoginInput
    emailLoginInput: ...,
  } satisfies ApiV1AuthLoginPostRequest;

  try {
    const data = await api.apiV1AuthLoginPost(body);
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
| **emailLoginInput** | [EmailLoginInput](EmailLoginInput.md) |  | |

### Return type

[**AuthSession**](AuthSession.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authenticated session |  -  |
| **401** | Invalid credentials |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AuthLogoutPost

> LogoutResponse apiV1AuthLogoutPost(refreshInput)

Logout current session

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1AuthLogoutPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthApi(config);

  const body = {
    // RefreshInput (optional)
    refreshInput: ...,
  } satisfies ApiV1AuthLogoutPostRequest;

  try {
    const data = await api.apiV1AuthLogoutPost(body);
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
| **refreshInput** | [RefreshInput](RefreshInput.md) |  | [Optional] |

### Return type

[**LogoutResponse**](LogoutResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Session revoked |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AuthOtpRequestPost

> OtpAcceptedResponse apiV1AuthOtpRequestPost(otpRequestInput)

Request an OTP code

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1AuthOtpRequestPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new AuthApi();

  const body = {
    // OtpRequestInput
    otpRequestInput: ...,
  } satisfies ApiV1AuthOtpRequestPostRequest;

  try {
    const data = await api.apiV1AuthOtpRequestPost(body);
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
| **otpRequestInput** | [OtpRequestInput](OtpRequestInput.md) |  | |

### Return type

[**OtpAcceptedResponse**](OtpAcceptedResponse.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **202** | OTP request accepted |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AuthOtpVerifyPost

> AuthSession apiV1AuthOtpVerifyPost(otpVerifyInput)

Verify OTP

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1AuthOtpVerifyPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new AuthApi();

  const body = {
    // OtpVerifyInput
    otpVerifyInput: ...,
  } satisfies ApiV1AuthOtpVerifyPostRequest;

  try {
    const data = await api.apiV1AuthOtpVerifyPost(body);
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
| **otpVerifyInput** | [OtpVerifyInput](OtpVerifyInput.md) |  | |

### Return type

[**AuthSession**](AuthSession.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authenticated session |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AuthRefreshPost

> AuthSession apiV1AuthRefreshPost(refreshInput)

Refresh access token

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1AuthRefreshPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new AuthApi();

  const body = {
    // RefreshInput
    refreshInput: ...,
  } satisfies ApiV1AuthRefreshPostRequest;

  try {
    const data = await api.apiV1AuthRefreshPost(body);
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
| **refreshInput** | [RefreshInput](RefreshInput.md) |  | |

### Return type

[**AuthSession**](AuthSession.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Refreshed session |  -  |
| **401** | Session expired |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1AuthRegisterPost

> AuthSession apiV1AuthRegisterPost(registerInput)

Register client or salon owner

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1AuthRegisterPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const api = new AuthApi();

  const body = {
    // RegisterInput
    registerInput: ...,
  } satisfies ApiV1AuthRegisterPostRequest;

  try {
    const data = await api.apiV1AuthRegisterPost(body);
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
| **registerInput** | [RegisterInput](RegisterInput.md) |  | |

### Return type

[**AuthSession**](AuthSession.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Authenticated session |  -  |
| **409** | Duplicate account |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MeBenefitsGet

> ApiV1MeBenefitsGet200Response apiV1MeBenefitsGet()

List client memberships and packages

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1MeBenefitsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthApi(config);

  try {
    const data = await api.apiV1MeBenefitsGet();
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

[**ApiV1MeBenefitsGet200Response**](ApiV1MeBenefitsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Benefits |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MeGet

> CurrentUser apiV1MeGet()

Current user

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1MeGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthApi(config);

  try {
    const data = await api.apiV1MeGet();
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

[**CurrentUser**](CurrentUser.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authenticated user |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MePatch

> CurrentUser apiV1MePatch(updateMeInput)

Update current user

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1MePatchRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthApi(config);

  const body = {
    // UpdateMeInput
    updateMeInput: ...,
  } satisfies ApiV1MePatchRequest;

  try {
    const data = await api.apiV1MePatch(body);
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
| **updateMeInput** | [UpdateMeInput](UpdateMeInput.md) |  | |

### Return type

[**CurrentUser**](CurrentUser.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated user |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MePaymentMethodsGet

> ApiV1MePaymentMethodsGet200Response apiV1MePaymentMethodsGet()

List saved payment methods

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1MePaymentMethodsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthApi(config);

  try {
    const data = await api.apiV1MePaymentMethodsGet();
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

[**ApiV1MePaymentMethodsGet200Response**](ApiV1MePaymentMethodsGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Payment methods |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MePaymentMethodsPaymentMethodIdDefaultPost

> ClientPaymentMethod apiV1MePaymentMethodsPaymentMethodIdDefaultPost(paymentMethodId)

Set the default saved payment method

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1MePaymentMethodsPaymentMethodIdDefaultPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthApi(config);

  const body = {
    // string | Payment method identifier
    paymentMethodId: paymentMethodId_example,
  } satisfies ApiV1MePaymentMethodsPaymentMethodIdDefaultPostRequest;

  try {
    const data = await api.apiV1MePaymentMethodsPaymentMethodIdDefaultPost(body);
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
| **paymentMethodId** | `string` | Payment method identifier | [Defaults to `undefined`] |

### Return type

[**ClientPaymentMethod**](ClientPaymentMethod.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Default payment method |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MePaymentMethodsPaymentMethodIdDelete

> DeletedResponse apiV1MePaymentMethodsPaymentMethodIdDelete(paymentMethodId)

Delete a saved payment method

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1MePaymentMethodsPaymentMethodIdDeleteRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthApi(config);

  const body = {
    // string | Payment method identifier
    paymentMethodId: paymentMethodId_example,
  } satisfies ApiV1MePaymentMethodsPaymentMethodIdDeleteRequest;

  try {
    const data = await api.apiV1MePaymentMethodsPaymentMethodIdDelete(body);
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
| **paymentMethodId** | `string` | Payment method identifier | [Defaults to `undefined`] |

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Deleted payment method |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MePaymentMethodsPaymentMethodIdPatch

> ClientPaymentMethod apiV1MePaymentMethodsPaymentMethodIdPatch(paymentMethodId, clientPaymentMethodUpdateInput)

Update a saved payment method

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1MePaymentMethodsPaymentMethodIdPatchRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthApi(config);

  const body = {
    // string | Payment method identifier
    paymentMethodId: paymentMethodId_example,
    // ClientPaymentMethodUpdateInput
    clientPaymentMethodUpdateInput: ...,
  } satisfies ApiV1MePaymentMethodsPaymentMethodIdPatchRequest;

  try {
    const data = await api.apiV1MePaymentMethodsPaymentMethodIdPatch(body);
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
| **paymentMethodId** | `string` | Payment method identifier | [Defaults to `undefined`] |
| **clientPaymentMethodUpdateInput** | [ClientPaymentMethodUpdateInput](ClientPaymentMethodUpdateInput.md) |  | |

### Return type

[**ClientPaymentMethod**](ClientPaymentMethod.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated payment method |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MePaymentMethodsPost

> ClientPaymentMethod apiV1MePaymentMethodsPost(clientPaymentMethodCreateInput)

Create a saved payment method

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1MePaymentMethodsPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthApi(config);

  const body = {
    // ClientPaymentMethodCreateInput
    clientPaymentMethodCreateInput: ...,
  } satisfies ApiV1MePaymentMethodsPostRequest;

  try {
    const data = await api.apiV1MePaymentMethodsPost(body);
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
| **clientPaymentMethodCreateInput** | [ClientPaymentMethodCreateInput](ClientPaymentMethodCreateInput.md) |  | |

### Return type

[**ClientPaymentMethod**](ClientPaymentMethod.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Created payment method |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MeVouchersGet

> ApiV1MeVouchersGet200Response apiV1MeVouchersGet()

List redeemed vouchers

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1MeVouchersGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthApi(config);

  try {
    const data = await api.apiV1MeVouchersGet();
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

[**ApiV1MeVouchersGet200Response**](ApiV1MeVouchersGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Vouchers |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MeVouchersRedeemPost

> ClientVoucher apiV1MeVouchersRedeemPost(redeemVoucherInput)

Redeem a voucher code

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1MeVouchersRedeemPostRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthApi(config);

  const body = {
    // RedeemVoucherInput
    redeemVoucherInput: ...,
  } satisfies ApiV1MeVouchersRedeemPostRequest;

  try {
    const data = await api.apiV1MeVouchersRedeemPost(body);
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
| **redeemVoucherInput** | [RedeemVoucherInput](RedeemVoucherInput.md) |  | |

### Return type

[**ClientVoucher**](ClientVoucher.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Redeemed voucher |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## apiV1MetadataProfileOptionsGet

> ProfileOptions apiV1MetadataProfileOptionsGet()

Profile dropdown and preference options

### Example

```ts
import {
  Configuration,
  AuthApi,
} from '';
import type { ApiV1MetadataProfileOptionsGetRequest } from '';

async function example() {
  console.log("🚀 Testing  SDK...");
  const config = new Configuration({ 
    // Configure HTTP bearer authorization: bearerAuth
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new AuthApi(config);

  try {
    const data = await api.apiV1MetadataProfileOptionsGet();
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

[**ProfileOptions**](ProfileOptions.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Profile options |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

