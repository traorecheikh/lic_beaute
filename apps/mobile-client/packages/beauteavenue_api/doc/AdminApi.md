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
[**apiV1AdminConfigCategoriesGet**](AdminApi.md#apiv1adminconfigcategoriesget) | **GET** /api/v1/admin/config/categories | List salon categories
[**apiV1AdminConfigCategoriesIdDelete**](AdminApi.md#apiv1adminconfigcategoriesiddelete) | **DELETE** /api/v1/admin/config/categories/{id} | Delete a salon category
[**apiV1AdminConfigCategoriesPost**](AdminApi.md#apiv1adminconfigcategoriespost) | **POST** /api/v1/admin/config/categories | Create or update a salon category
[**apiV1AdminConfigDocumentsGet**](AdminApi.md#apiv1adminconfigdocumentsget) | **GET** /api/v1/admin/config/documents | List required documents
[**apiV1AdminConfigDocumentsIdDelete**](AdminApi.md#apiv1adminconfigdocumentsiddelete) | **DELETE** /api/v1/admin/config/documents/{id} | Delete a required document
[**apiV1AdminConfigDocumentsPost**](AdminApi.md#apiv1adminconfigdocumentspost) | **POST** /api/v1/admin/config/documents | Create or update a required document
[**apiV1AdminConfigSettingsGet**](AdminApi.md#apiv1adminconfigsettingsget) | **GET** /api/v1/admin/config/settings | List all platform settings
[**apiV1AdminConfigSettingsKeyPatch**](AdminApi.md#apiv1adminconfigsettingskeypatch) | **PATCH** /api/v1/admin/config/settings/{key} | Update a platform setting
[**apiV1AdminDashboardGet**](AdminApi.md#apiv1admindashboardget) | **GET** /api/v1/admin/dashboard | Admin dashboard
[**apiV1AdminMediaMediaIdApprovePost**](AdminApi.md#apiv1adminmediamediaidapprovepost) | **POST** /api/v1/admin/media/{mediaId}/approve | Approve a media asset
[**apiV1AdminMediaMediaIdRejectPost**](AdminApi.md#apiv1adminmediamediaidrejectpost) | **POST** /api/v1/admin/media/{mediaId}/reject | Reject a media asset
[**apiV1AdminMediaMediaIdSignedViewUrlPost**](AdminApi.md#apiv1adminmediamediaidsignedviewurlpost) | **POST** /api/v1/admin/media/{mediaId}/signed-view-url | Get a signed URL to preview a media asset
[**apiV1AdminMediaPendingGet**](AdminApi.md#apiv1adminmediapendingget) | **GET** /api/v1/admin/media/pending | List media pending review
[**apiV1AdminSalonsGet**](AdminApi.md#apiv1adminsalonsget) | **GET** /api/v1/admin/salons | List all salons with optional filters
[**apiV1AdminSalonsPendingGet**](AdminApi.md#apiv1adminsalonspendingget) | **GET** /api/v1/admin/salons/pending | List pending salon approvals
[**apiV1AdminSalonsPost**](AdminApi.md#apiv1adminsalonspost) | **POST** /api/v1/admin/salons | Create a salon manually
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

# **apiV1AdminConfigCategoriesGet**
> BuiltList<ApiV1AdminConfigCategoriesGet200ResponseInner> apiV1AdminConfigCategoriesGet()

List salon categories

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();

try {
    final response = api.apiV1AdminConfigCategoriesGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminConfigCategoriesGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ApiV1AdminConfigCategoriesGet200ResponseInner&gt;**](ApiV1AdminConfigCategoriesGet200ResponseInner.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminConfigCategoriesIdDelete**
> DeletedResponse apiV1AdminConfigCategoriesIdDelete(id)

Delete a salon category

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String id = id_example; // String | Category identifier

try {
    final response = api.apiV1AdminConfigCategoriesIdDelete(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminConfigCategoriesIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Category identifier | 

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminConfigCategoriesPost**
> apiV1AdminConfigCategoriesPost(apiV1AdminConfigCategoriesPostRequest)

Create or update a salon category

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final ApiV1AdminConfigCategoriesPostRequest apiV1AdminConfigCategoriesPostRequest = ; // ApiV1AdminConfigCategoriesPostRequest | 

try {
    api.apiV1AdminConfigCategoriesPost(apiV1AdminConfigCategoriesPostRequest);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminConfigCategoriesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiV1AdminConfigCategoriesPostRequest** | [**ApiV1AdminConfigCategoriesPostRequest**](ApiV1AdminConfigCategoriesPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminConfigDocumentsGet**
> BuiltList<ApiV1AdminConfigDocumentsGet200ResponseInner> apiV1AdminConfigDocumentsGet()

List required documents

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();

try {
    final response = api.apiV1AdminConfigDocumentsGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminConfigDocumentsGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;ApiV1AdminConfigDocumentsGet200ResponseInner&gt;**](ApiV1AdminConfigDocumentsGet200ResponseInner.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminConfigDocumentsIdDelete**
> DeletedResponse apiV1AdminConfigDocumentsIdDelete(id)

Delete a required document

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String id = id_example; // String | Document identifier

try {
    final response = api.apiV1AdminConfigDocumentsIdDelete(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminConfigDocumentsIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**| Document identifier | 

### Return type

[**DeletedResponse**](DeletedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminConfigDocumentsPost**
> apiV1AdminConfigDocumentsPost(apiV1AdminConfigDocumentsPostRequest)

Create or update a required document

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final ApiV1AdminConfigDocumentsPostRequest apiV1AdminConfigDocumentsPostRequest = ; // ApiV1AdminConfigDocumentsPostRequest | 

try {
    api.apiV1AdminConfigDocumentsPost(apiV1AdminConfigDocumentsPostRequest);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminConfigDocumentsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiV1AdminConfigDocumentsPostRequest** | [**ApiV1AdminConfigDocumentsPostRequest**](ApiV1AdminConfigDocumentsPostRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminConfigSettingsGet**
> BuiltList<ApiV1AdminConfigSettingsGet200ResponseInner> apiV1AdminConfigSettingsGet(group)

List all platform settings

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String group = group_example; // String | 

try {
    final response = api.apiV1AdminConfigSettingsGet(group);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminConfigSettingsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;ApiV1AdminConfigSettingsGet200ResponseInner&gt;**](ApiV1AdminConfigSettingsGet200ResponseInner.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminConfigSettingsKeyPatch**
> UpdatedResponse apiV1AdminConfigSettingsKeyPatch(key, apiV1AdminConfigSettingsKeyPatchRequest)

Update a platform setting

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String key = key_example; // String | Setting key
final ApiV1AdminConfigSettingsKeyPatchRequest apiV1AdminConfigSettingsKeyPatchRequest = ; // ApiV1AdminConfigSettingsKeyPatchRequest | 

try {
    final response = api.apiV1AdminConfigSettingsKeyPatch(key, apiV1AdminConfigSettingsKeyPatchRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminConfigSettingsKeyPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **String**| Setting key | 
 **apiV1AdminConfigSettingsKeyPatchRequest** | [**ApiV1AdminConfigSettingsKeyPatchRequest**](ApiV1AdminConfigSettingsKeyPatchRequest.md)|  | 

### Return type

[**UpdatedResponse**](UpdatedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
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

# **apiV1AdminMediaMediaIdApprovePost**
> ApiV1AdminMediaMediaIdApprovePost200Response apiV1AdminMediaMediaIdApprovePost(mediaId, apiV1AdminMediaMediaIdApprovePostRequest)

Approve a media asset

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String mediaId = mediaId_example; // String | Media identifier
final ApiV1AdminMediaMediaIdApprovePostRequest apiV1AdminMediaMediaIdApprovePostRequest = ; // ApiV1AdminMediaMediaIdApprovePostRequest | 

try {
    final response = api.apiV1AdminMediaMediaIdApprovePost(mediaId, apiV1AdminMediaMediaIdApprovePostRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminMediaMediaIdApprovePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mediaId** | **String**| Media identifier | 
 **apiV1AdminMediaMediaIdApprovePostRequest** | [**ApiV1AdminMediaMediaIdApprovePostRequest**](ApiV1AdminMediaMediaIdApprovePostRequest.md)|  | [optional] 

### Return type

[**ApiV1AdminMediaMediaIdApprovePost200Response**](ApiV1AdminMediaMediaIdApprovePost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminMediaMediaIdRejectPost**
> ApiV1AdminMediaMediaIdRejectPost200Response apiV1AdminMediaMediaIdRejectPost(mediaId, apiV1AdminMediaMediaIdRejectPostRequest)

Reject a media asset

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String mediaId = mediaId_example; // String | Media identifier
final ApiV1AdminMediaMediaIdRejectPostRequest apiV1AdminMediaMediaIdRejectPostRequest = ; // ApiV1AdminMediaMediaIdRejectPostRequest | 

try {
    final response = api.apiV1AdminMediaMediaIdRejectPost(mediaId, apiV1AdminMediaMediaIdRejectPostRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminMediaMediaIdRejectPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mediaId** | **String**| Media identifier | 
 **apiV1AdminMediaMediaIdRejectPostRequest** | [**ApiV1AdminMediaMediaIdRejectPostRequest**](ApiV1AdminMediaMediaIdRejectPostRequest.md)|  | 

### Return type

[**ApiV1AdminMediaMediaIdRejectPost200Response**](ApiV1AdminMediaMediaIdRejectPost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminMediaMediaIdSignedViewUrlPost**
> ApiV1AdminMediaMediaIdSignedViewUrlPost200Response apiV1AdminMediaMediaIdSignedViewUrlPost(mediaId)

Get a signed URL to preview a media asset

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String mediaId = mediaId_example; // String | Media identifier

try {
    final response = api.apiV1AdminMediaMediaIdSignedViewUrlPost(mediaId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminMediaMediaIdSignedViewUrlPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mediaId** | **String**| Media identifier | 

### Return type

[**ApiV1AdminMediaMediaIdSignedViewUrlPost200Response**](ApiV1AdminMediaMediaIdSignedViewUrlPost200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminMediaPendingGet**
> ApiV1AdminMediaPendingGet200Response apiV1AdminMediaPendingGet(page, pageSize)

List media pending review

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String page = page_example; // String | 
final String pageSize = pageSize_example; // String | 

try {
    final response = api.apiV1AdminMediaPendingGet(page, pageSize);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminMediaPendingGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **String**|  | [optional] 
 **pageSize** | **String**|  | [optional] 

### Return type

[**ApiV1AdminMediaPendingGet200Response**](ApiV1AdminMediaPendingGet200Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **apiV1AdminSalonsGet**
> ApiV1AdminSalonsGet200Response apiV1AdminSalonsGet(search, status)

List all salons with optional filters

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final String search = search_example; // String | 
final String status = status_example; // String | 

try {
    final response = api.apiV1AdminSalonsGet(search, status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminSalonsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional] 
 **status** | **String**|  | [optional] 

### Return type

[**ApiV1AdminSalonsGet200Response**](ApiV1AdminSalonsGet200Response.md)

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

# **apiV1AdminSalonsPost**
> ApiV1AdminSalonsPost201Response apiV1AdminSalonsPost(apiV1AdminSalonsPostRequest)

Create a salon manually

### Example
```dart
import 'package:beauteavenue_api/api.dart';

final api = BeauteavenueApi().getAdminApi();
final ApiV1AdminSalonsPostRequest apiV1AdminSalonsPostRequest = ; // ApiV1AdminSalonsPostRequest | 

try {
    final response = api.apiV1AdminSalonsPost(apiV1AdminSalonsPostRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminApi->apiV1AdminSalonsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **apiV1AdminSalonsPostRequest** | [**ApiV1AdminSalonsPostRequest**](ApiV1AdminSalonsPostRequest.md)|  | 

### Return type

[**ApiV1AdminSalonsPost201Response**](ApiV1AdminSalonsPost201Response.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
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

