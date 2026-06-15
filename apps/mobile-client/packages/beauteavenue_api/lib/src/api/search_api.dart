//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:beauteavenue_api/src/api_util.dart';
import 'package:beauteavenue_api/src/model/search_events_request.dart';
import 'package:beauteavenue_api/src/model/search_events_response.dart';
import 'package:beauteavenue_api/src/model/search_salons_response.dart';
import 'package:beauteavenue_api/src/model/search_suggestions_response.dart';

class SearchApi {

  final Dio _dio;

  final Serializers _serializers;

  const SearchApi(this._dio, this._serializers);

  /// Track search interaction events for personalization
  /// 
  ///
  /// Parameters:
  /// * [searchEventsRequest] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SearchEventsResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SearchEventsResponse>> apiV1SearchEventsPost({ 
    required SearchEventsRequest searchEventsRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/search/events';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(SearchEventsRequest);
      _bodyData = _serializers.serialize(searchEventsRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    SearchEventsResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(SearchEventsResponse),
      ) as SearchEventsResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SearchEventsResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Search salons with ranked results, facets, and discovery modules
  /// 
  ///
  /// Parameters:
  /// * [q] 
  /// * [lat] 
  /// * [lng] 
  /// * [category] 
  /// * [city] 
  /// * [neighborhood] 
  /// * [minPrice] 
  /// * [maxPrice] 
  /// * [openNow] 
  /// * [bookableSoon] 
  /// * [sort] 
  /// * [cursor] 
  /// * [limit] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SearchSalonsResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SearchSalonsResponse>> apiV1SearchSalonsGet({ 
    required String q,
    num? lat,
    num? lng,
    String? category,
    String? city,
    String? neighborhood,
    int? minPrice,
    int? maxPrice,
    bool? openNow,
    bool? bookableSoon,
    String? sort,
    String? cursor,
    int? limit,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/search/salons';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      r'q': encodeQueryParameter(_serializers, q, const FullType(String)),
      if (lat != null) r'lat': encodeQueryParameter(_serializers, lat, const FullType(num)),
      if (lng != null) r'lng': encodeQueryParameter(_serializers, lng, const FullType(num)),
      if (category != null) r'category': encodeQueryParameter(_serializers, category, const FullType(String)),
      if (city != null) r'city': encodeQueryParameter(_serializers, city, const FullType(String)),
      if (neighborhood != null) r'neighborhood': encodeQueryParameter(_serializers, neighborhood, const FullType(String)),
      if (minPrice != null) r'minPrice': encodeQueryParameter(_serializers, minPrice, const FullType(int)),
      if (maxPrice != null) r'maxPrice': encodeQueryParameter(_serializers, maxPrice, const FullType(int)),
      if (openNow != null) r'openNow': encodeQueryParameter(_serializers, openNow, const FullType(bool)),
      if (bookableSoon != null) r'bookableSoon': encodeQueryParameter(_serializers, bookableSoon, const FullType(bool)),
      if (sort != null) r'sort': encodeQueryParameter(_serializers, sort, const FullType(String)),
      if (cursor != null) r'cursor': encodeQueryParameter(_serializers, cursor, const FullType(String)),
      if (limit != null) r'limit': encodeQueryParameter(_serializers, limit, const FullType(int)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    SearchSalonsResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(SearchSalonsResponse),
      ) as SearchSalonsResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SearchSalonsResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// Get search suggestions and autocomplete
  /// 
  ///
  /// Parameters:
  /// * [q] 
  /// * [lat] 
  /// * [lng] 
  /// * [category] 
  /// * [city] 
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SearchSuggestionsResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SearchSuggestionsResponse>> apiV1SearchSuggestionsGet({ 
    required String q,
    num? lat,
    num? lng,
    String? category,
    String? city,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/api/v1/search/suggestions';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      r'q': encodeQueryParameter(_serializers, q, const FullType(String)),
      if (lat != null) r'lat': encodeQueryParameter(_serializers, lat, const FullType(num)),
      if (lng != null) r'lng': encodeQueryParameter(_serializers, lng, const FullType(num)),
      if (category != null) r'category': encodeQueryParameter(_serializers, category, const FullType(String)),
      if (city != null) r'city': encodeQueryParameter(_serializers, city, const FullType(String)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    SearchSuggestionsResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(SearchSuggestionsResponse),
      ) as SearchSuggestionsResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SearchSuggestionsResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

}
