// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_salons_salon_id_public_media_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1SalonsSalonIdPublicMediaGet200Response
    extends ApiV1SalonsSalonIdPublicMediaGet200Response {
  @override
  final BuiltList<ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner> items;

  factory _$ApiV1SalonsSalonIdPublicMediaGet200Response(
          [void Function(ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder)?
              updates]) =>
      (ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder()..update(updates))
          ._build();

  _$ApiV1SalonsSalonIdPublicMediaGet200Response._({required this.items})
      : super._();
  @override
  ApiV1SalonsSalonIdPublicMediaGet200Response rebuild(
          void Function(ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder toBuilder() =>
      ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1SalonsSalonIdPublicMediaGet200Response &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1SalonsSalonIdPublicMediaGet200Response')
          ..add('items', items))
        .toString();
  }
}

class ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder
    implements
        Builder<ApiV1SalonsSalonIdPublicMediaGet200Response,
            ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder> {
  _$ApiV1SalonsSalonIdPublicMediaGet200Response? _$v;

  ListBuilder<ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner>? _items;
  ListBuilder<ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner>
      get items => _$this._items ??=
          ListBuilder<ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner>();
  set items(
          ListBuilder<ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner>?
              items) =>
      _$this._items = items;

  ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder() {
    ApiV1SalonsSalonIdPublicMediaGet200Response._defaults(this);
  }

  ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1SalonsSalonIdPublicMediaGet200Response other) {
    _$v = other as _$ApiV1SalonsSalonIdPublicMediaGet200Response;
  }

  @override
  void update(
      void Function(ApiV1SalonsSalonIdPublicMediaGet200ResponseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1SalonsSalonIdPublicMediaGet200Response build() => _build();

  _$ApiV1SalonsSalonIdPublicMediaGet200Response _build() {
    _$ApiV1SalonsSalonIdPublicMediaGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiV1SalonsSalonIdPublicMediaGet200Response._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiV1SalonsSalonIdPublicMediaGet200Response',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
