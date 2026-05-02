# beauteavenue_api.api.AdminApi

## Load the API package
```dart
import 'package:beauteavenue_api/api.dart';
```

All URIs are relative to *http://localhost:3000*

Method | HTTP request | Description
------------- | ------------- | -------------
[**apiV1AdminAuditAuditIdGet**](AdminApi.md#apiv1adminauditauditidget) | **GET** /api/v1/admin/audit/{auditId} | Audit event detail
[**apiV1AdminAuditGet**](AdminApi.md#apiv1adminauditget) | **GET** /api/v1/admin/audit | List admin audit events
[**apiV1AdminDashboardGet**](AdminApi.md#apiv1admindashboardget) | **GET** /api/v1/admin/dashboard | Admin dashboard
[**apiV1AdminSalonsPendingGet**](AdminApi.md#apiv1adminsalonspendingget) | **GET** /api/v1/admin/salons/pending | List pending salon approvals
[**apiV1AdminSalonsSalonIdApprovePost**](AdminApi.md#apiv1adminsalonssalonidapprovepost) | **POST** /api/v1/admin/salons/{salonId}/approve | Approve salon listing
[**apiV1AdminSalonsSalonIdGet**](AdminApi.md#apiv1adminsalonssalonidget) | **GET** /api/v1/admin/salons/{salonId} | Salon approval detail
[**apiV1AdminSalonsSalonIdRejectPost**](AdminApi.md#apiv1adminsalonssalonidrejectpost) | **POST** /api/v1/admin/salons/{salonId}/reject | Reject salon listing
[**apiV1AdminSalonsSalonIdRequestInfoPost**](AdminApi.md#apiv1adminsalonssalonidrequestinfopost) | **POST** /api/v1/admin/salons/{salonId}/request-info | Request more information for salon listing
[**apiV1AdminSubscriptionsGet**](AdminApi.md#apiv1adminsubscriptionsget) | **GET** /api/v1/admin/subscriptions | List subscription lifecycles
[**apiV1AdminSubscriptionsSubscriptionIdGet**](AdminApi.md#apiv1adminsubscriptionssubscriptionidget) | **GET** /api/v1/admin/subscriptions/{subscriptionId} | Subscription detail
[**apiV1AdminSubscriptionsSubscriptionIdOverridePost**](AdminApi.md#apiv1adminsubscriptionssubscriptionidoverridepost) | **POST** /api/v1/admin/subscriptions/{subscriptionId}/override | Apply admin subscription override


# **apiV1AdminAuditAuditIdGet**
> AdminAuditDetail apiV1AdminAuditAuditIdGet(auditId)

Audit event detail

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String auditId = auditId_example; // String | Audit identifier

try {
    final response = api.apiV1AdminAuditAuditIdGet(auditId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminAuditAuditIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **auditId** | **String**| Audit identifier | 

### Return type

[**AdminAuditDetail**](AdminAuditDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminAuditGet**
> AdminAuditSummaryListResponse apiV1AdminAuditGet(actor, entityType, action)

List admin audit events

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String actor = actor_example; // String | 
final String entityType = entityType_example; // String | 
final String action = action_example; // String | 

try {
    final response = api.apiV1AdminAuditGet(actor, entityType, action);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminAuditGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actor** | **String**|  | [optional] 
 **entityType** | **String**|  | [optional] 
 **action** | **String**|  | [optional] 

### Return type

[**AdminAuditSummaryListResponse**](AdminAuditSummaryListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminDashboardGet**
> AdminDashboard apiV1AdminDashboardGet()

Admin dashboard

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();

try {
    final response = api.apiV1AdminDashboardGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminDashboardGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AdminDashboard**](AdminDashboard.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminSalonsPendingGet**
> AdminSalonQueueResponse apiV1AdminSalonsPendingGet(search, category, city, status)

List pending salon approvals

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String search = search_example; // String | 
final String category = category_example; // String | 
final String city = city_example; // String | 
final String status = status_example; // String | 

try {
    final response = api.apiV1AdminSalonsPendingGet(search, category, city, status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminSalonsPendingGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional] 
 **category** | **String**|  | [optional] 
 **city** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 

### Return type

[**AdminSalonQueueResponse**](AdminSalonQueueResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminSalonsSalonIdApprovePost**
> AdminSalonDetail apiV1AdminSalonsSalonIdApprovePost(salonId)

Approve salon listing

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String salonId = salonId_example; // String | Salon identifier

try {
    final response = api.apiV1AdminSalonsSalonIdApprovePost(salonId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminSalonsSalonIdApprovePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **salonId** | **String**| Salon identifier | 

### Return type

[**AdminSalonDetail**](AdminSalonDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminSalonsSalonIdGet**
> AdminSalonDetail apiV1AdminSalonsSalonIdGet(salonId)

Salon approval detail

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String salonId = salonId_example; // String | Salon identifier

try {
    final response = api.apiV1AdminSalonsSalonIdGet(salonId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminSalonsSalonIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **salonId** | **String**| Salon identifier | 

### Return type

[**AdminSalonDetail**](AdminSalonDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminSalonsSalonIdRejectPost**
> AdminSalonDetail apiV1AdminSalonsSalonIdRejectPost(salonId, adminSalonDecisionInput)

Reject salon listing

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String salonId = salonId_example; // String | Salon identifier
final AdminSalonDecisionInput adminSalonDecisionInput = ; // AdminSalonDecisionInput | 

try {
    final response = api.apiV1AdminSalonsSalonIdRejectPost(salonId, adminSalonDecisionInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminSalonsSalonIdRejectPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **salonId** | **String**| Salon identifier | 
 **adminSalonDecisionInput** | [**AdminSalonDecisionInput**](AdminSalonDecisionInput.md)|  | 

### Return type

[**AdminSalonDetail**](AdminSalonDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminSalonsSalonIdRequestInfoPost**
> AdminSalonDetail apiV1AdminSalonsSalonIdRequestInfoPost(salonId, adminSalonDecisionInput)

Request more information for salon listing

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String salonId = salonId_example; // String | Salon identifier
final AdminSalonDecisionInput adminSalonDecisionInput = ; // AdminSalonDecisionInput | 

try {
    final response = api.apiV1AdminSalonsSalonIdRequestInfoPost(salonId, adminSalonDecisionInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminSalonsSalonIdRequestInfoPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **salonId** | **String**| Salon identifier | 
 **adminSalonDecisionInput** | [**AdminSalonDecisionInput**](AdminSalonDecisionInput.md)|  | 

### Return type

[**AdminSalonDetail**](AdminSalonDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminSubscriptionsGet**
> AdminSubscriptionListResponse apiV1AdminSubscriptionsGet(search, tier, status)

List subscription lifecycles

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String search = search_example; // String | 
final String tier = tier_example; // String | 
final String status = status_example; // String | 

try {
    final response = api.apiV1AdminSubscriptionsGet(search, tier, status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminSubscriptionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional] 
 **tier** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 

### Return type

[**AdminSubscriptionListResponse**](AdminSubscriptionListResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminSubscriptionsSubscriptionIdGet**
> AdminSubscriptionDetail apiV1AdminSubscriptionsSubscriptionIdGet(subscriptionId)

Subscription detail

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String subscriptionId = subscriptionId_example; // String | Subscription identifier

try {
    final response = api.apiV1AdminSubscriptionsSubscriptionIdGet(subscriptionId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminSubscriptionsSubscriptionIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subscriptionId** | **String**| Subscription identifier | 

### Return type

[**AdminSubscriptionDetail**](AdminSubscriptionDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminSubscriptionsSubscriptionIdOverridePost**
> AdminSubscriptionDetail apiV1AdminSubscriptionsSubscriptionIdOverridePost(subscriptionId, adminSubscriptionOverrideInput)

Apply admin subscription override

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String subscriptionId = subscriptionId_example; // String | Subscription identifier
final AdminSubscriptionOverrideInput adminSubscriptionOverrideInput = ; // AdminSubscriptionOverrideInput | 

try {
    final response = api.apiV1AdminSubscriptionsSubscriptionIdOverridePost(subscriptionId, adminSubscriptionOverrideInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminSubscriptionsSubscriptionIdOverridePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subscriptionId** | **String**| Subscription identifier | 
 **adminSubscriptionOverrideInput** | [**AdminSubscriptionOverrideInput**](AdminSubscriptionOverrideInput.md)|  | 

### Return type

[**AdminSubscriptionDetail**](AdminSubscriptionDetail.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

