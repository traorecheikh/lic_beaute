// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_summary_list_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BookingSummaryListResponse extends BookingSummaryListResponse {
  @override
  final BuiltList<BookingSummaryListResponseItemsInner> items;
  @override
  final int total;

  factory _$BookingSummaryListResponse(
          [void Function(BookingSummaryListResponseBuilder)? updates]) =>
      (BookingSummaryListResponseBuilder()..update(updates))._build();

  _$BookingSummaryListResponse._({required this.items, required this.total})
      : super._();
  @override
  BookingSummaryListResponse rebuild(
          void Function(BookingSummaryListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookingSummaryListResponseBuilder toBuilder() =>
      BookingSummaryListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookingSummaryListResponse &&
        items == other.items &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BookingSummaryListResponse')
          ..add('items', items)
          ..add('total', total))
        .toString();
  }
}

class BookingSummaryListResponseBuilder
    implements
        Builder<BookingSummaryListResponse, BookingSummaryListResponseBuilder> {
  _$BookingSummaryListResponse? _$v;

  ListBuilder<BookingSummaryListResponseItemsInner>? _items;
  ListBuilder<BookingSummaryListResponseItemsInner> get items =>
      _$this._items ??= ListBuilder<BookingSummaryListResponseItemsInner>();
  set items(ListBuilder<BookingSummaryListResponseItemsInner>? items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  BookingSummaryListResponseBuilder() {
    BookingSummaryListResponse._defaults(this);
  }

  BookingSummaryListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BookingSummaryListResponse other) {
    _$v = other as _$BookingSummaryListResponse;
  }

  @override
  void update(void Function(BookingSummaryListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookingSummaryListResponse build() => _build();

  _$BookingSummaryListResponse _build() {
    _$BookingSummaryListResponse _$result;
    try {
      _$result = _$v ??
          _$BookingSummaryListResponse._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'BookingSummaryListResponse', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BookingSummaryListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
