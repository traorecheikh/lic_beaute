// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_media_pending_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminMediaPendingGet200Response
    extends ApiV1AdminMediaPendingGet200Response {
  @override
  final BuiltList<ApiV1AdminMediaPendingGet200ResponseItemsInner> items;
  @override
  final int total;
  @override
  final int page;
  @override
  final int pageSize;

  factory _$ApiV1AdminMediaPendingGet200Response(
          [void Function(ApiV1AdminMediaPendingGet200ResponseBuilder)?
              updates]) =>
      (ApiV1AdminMediaPendingGet200ResponseBuilder()..update(updates))._build();

  _$ApiV1AdminMediaPendingGet200Response._(
      {required this.items,
      required this.total,
      required this.page,
      required this.pageSize})
      : super._();
  @override
  ApiV1AdminMediaPendingGet200Response rebuild(
          void Function(ApiV1AdminMediaPendingGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminMediaPendingGet200ResponseBuilder toBuilder() =>
      ApiV1AdminMediaPendingGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminMediaPendingGet200Response &&
        items == other.items &&
        total == other.total &&
        page == other.page &&
        pageSize == other.pageSize;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, pageSize.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1AdminMediaPendingGet200Response')
          ..add('items', items)
          ..add('total', total)
          ..add('page', page)
          ..add('pageSize', pageSize))
        .toString();
  }
}

class ApiV1AdminMediaPendingGet200ResponseBuilder
    implements
        Builder<ApiV1AdminMediaPendingGet200Response,
            ApiV1AdminMediaPendingGet200ResponseBuilder> {
  _$ApiV1AdminMediaPendingGet200Response? _$v;

  ListBuilder<ApiV1AdminMediaPendingGet200ResponseItemsInner>? _items;
  ListBuilder<ApiV1AdminMediaPendingGet200ResponseItemsInner> get items =>
      _$this._items ??=
          ListBuilder<ApiV1AdminMediaPendingGet200ResponseItemsInner>();
  set items(
          ListBuilder<ApiV1AdminMediaPendingGet200ResponseItemsInner>? items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _pageSize;
  int? get pageSize => _$this._pageSize;
  set pageSize(int? pageSize) => _$this._pageSize = pageSize;

  ApiV1AdminMediaPendingGet200ResponseBuilder() {
    ApiV1AdminMediaPendingGet200Response._defaults(this);
  }

  ApiV1AdminMediaPendingGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _page = $v.page;
      _pageSize = $v.pageSize;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminMediaPendingGet200Response other) {
    _$v = other as _$ApiV1AdminMediaPendingGet200Response;
  }

  @override
  void update(
      void Function(ApiV1AdminMediaPendingGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminMediaPendingGet200Response build() => _build();

  _$ApiV1AdminMediaPendingGet200Response _build() {
    _$ApiV1AdminMediaPendingGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiV1AdminMediaPendingGet200Response._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'ApiV1AdminMediaPendingGet200Response', 'total'),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'ApiV1AdminMediaPendingGet200Response', 'page'),
            pageSize: BuiltValueNullFieldError.checkNotNull(
                pageSize, r'ApiV1AdminMediaPendingGet200Response', 'pageSize'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiV1AdminMediaPendingGet200Response',
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
