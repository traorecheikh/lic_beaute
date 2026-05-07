// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_list_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FavoriteListResponse extends FavoriteListResponse {
  @override
  final BuiltList<SalonSummaryListResponseItemsInner> items;

  factory _$FavoriteListResponse(
          [void Function(FavoriteListResponseBuilder)? updates]) =>
      (FavoriteListResponseBuilder()..update(updates))._build();

  _$FavoriteListResponse._({required this.items}) : super._();
  @override
  FavoriteListResponse rebuild(
          void Function(FavoriteListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FavoriteListResponseBuilder toBuilder() =>
      FavoriteListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FavoriteListResponse && items == other.items;
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
    return (newBuiltValueToStringHelper(r'FavoriteListResponse')
          ..add('items', items))
        .toString();
  }
}

class FavoriteListResponseBuilder
    implements Builder<FavoriteListResponse, FavoriteListResponseBuilder> {
  _$FavoriteListResponse? _$v;

  ListBuilder<SalonSummaryListResponseItemsInner>? _items;
  ListBuilder<SalonSummaryListResponseItemsInner> get items =>
      _$this._items ??= ListBuilder<SalonSummaryListResponseItemsInner>();
  set items(ListBuilder<SalonSummaryListResponseItemsInner>? items) =>
      _$this._items = items;

  FavoriteListResponseBuilder() {
    FavoriteListResponse._defaults(this);
  }

  FavoriteListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FavoriteListResponse other) {
    _$v = other as _$FavoriteListResponse;
  }

  @override
  void update(void Function(FavoriteListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FavoriteListResponse build() => _build();

  _$FavoriteListResponse _build() {
    _$FavoriteListResponse _$result;
    try {
      _$result = _$v ??
          _$FavoriteListResponse._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'FavoriteListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
