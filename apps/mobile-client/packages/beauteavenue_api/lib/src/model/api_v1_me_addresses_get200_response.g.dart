// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_me_addresses_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1MeAddressesGet200Response extends ApiV1MeAddressesGet200Response {
  @override
  final BuiltList<ApiV1MeAddressesGet200ResponseItemsInner> items;

  factory _$ApiV1MeAddressesGet200Response(
          [void Function(ApiV1MeAddressesGet200ResponseBuilder)? updates]) =>
      (ApiV1MeAddressesGet200ResponseBuilder()..update(updates))._build();

  _$ApiV1MeAddressesGet200Response._({required this.items}) : super._();
  @override
  ApiV1MeAddressesGet200Response rebuild(
          void Function(ApiV1MeAddressesGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1MeAddressesGet200ResponseBuilder toBuilder() =>
      ApiV1MeAddressesGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MeAddressesGet200Response && items == other.items;
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
    return (newBuiltValueToStringHelper(r'ApiV1MeAddressesGet200Response')
          ..add('items', items))
        .toString();
  }
}

class ApiV1MeAddressesGet200ResponseBuilder
    implements
        Builder<ApiV1MeAddressesGet200Response,
            ApiV1MeAddressesGet200ResponseBuilder> {
  _$ApiV1MeAddressesGet200Response? _$v;

  ListBuilder<ApiV1MeAddressesGet200ResponseItemsInner>? _items;
  ListBuilder<ApiV1MeAddressesGet200ResponseItemsInner> get items =>
      _$this._items ??= ListBuilder<ApiV1MeAddressesGet200ResponseItemsInner>();
  set items(ListBuilder<ApiV1MeAddressesGet200ResponseItemsInner>? items) =>
      _$this._items = items;

  ApiV1MeAddressesGet200ResponseBuilder() {
    ApiV1MeAddressesGet200Response._defaults(this);
  }

  ApiV1MeAddressesGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MeAddressesGet200Response other) {
    _$v = other as _$ApiV1MeAddressesGet200Response;
  }

  @override
  void update(void Function(ApiV1MeAddressesGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MeAddressesGet200Response build() => _build();

  _$ApiV1MeAddressesGet200Response _build() {
    _$ApiV1MeAddressesGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiV1MeAddressesGet200Response._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiV1MeAddressesGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
