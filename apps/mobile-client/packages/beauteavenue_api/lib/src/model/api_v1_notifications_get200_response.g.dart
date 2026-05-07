// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_notifications_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1NotificationsGet200Response
    extends ApiV1NotificationsGet200Response {
  @override
  final BuiltList<ApiV1NotificationsGet200ResponseItemsInner> items;
  @override
  final int total;
  @override
  final int unreadCount;

  factory _$ApiV1NotificationsGet200Response(
          [void Function(ApiV1NotificationsGet200ResponseBuilder)? updates]) =>
      (ApiV1NotificationsGet200ResponseBuilder()..update(updates))._build();

  _$ApiV1NotificationsGet200Response._(
      {required this.items, required this.total, required this.unreadCount})
      : super._();
  @override
  ApiV1NotificationsGet200Response rebuild(
          void Function(ApiV1NotificationsGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1NotificationsGet200ResponseBuilder toBuilder() =>
      ApiV1NotificationsGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1NotificationsGet200Response &&
        items == other.items &&
        total == other.total &&
        unreadCount == other.unreadCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, unreadCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1NotificationsGet200Response')
          ..add('items', items)
          ..add('total', total)
          ..add('unreadCount', unreadCount))
        .toString();
  }
}

class ApiV1NotificationsGet200ResponseBuilder
    implements
        Builder<ApiV1NotificationsGet200Response,
            ApiV1NotificationsGet200ResponseBuilder> {
  _$ApiV1NotificationsGet200Response? _$v;

  ListBuilder<ApiV1NotificationsGet200ResponseItemsInner>? _items;
  ListBuilder<ApiV1NotificationsGet200ResponseItemsInner> get items =>
      _$this._items ??=
          ListBuilder<ApiV1NotificationsGet200ResponseItemsInner>();
  set items(ListBuilder<ApiV1NotificationsGet200ResponseItemsInner>? items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _unreadCount;
  int? get unreadCount => _$this._unreadCount;
  set unreadCount(int? unreadCount) => _$this._unreadCount = unreadCount;

  ApiV1NotificationsGet200ResponseBuilder() {
    ApiV1NotificationsGet200Response._defaults(this);
  }

  ApiV1NotificationsGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _unreadCount = $v.unreadCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1NotificationsGet200Response other) {
    _$v = other as _$ApiV1NotificationsGet200Response;
  }

  @override
  void update(void Function(ApiV1NotificationsGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1NotificationsGet200Response build() => _build();

  _$ApiV1NotificationsGet200Response _build() {
    _$ApiV1NotificationsGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiV1NotificationsGet200Response._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'ApiV1NotificationsGet200Response', 'total'),
            unreadCount: BuiltValueNullFieldError.checkNotNull(unreadCount,
                r'ApiV1NotificationsGet200Response', 'unreadCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiV1NotificationsGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
