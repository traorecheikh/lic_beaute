// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_summary_list_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalonSummaryListResponse extends SalonSummaryListResponse {
  @override
  final BuiltList<SalonSummaryListResponseItemsInner> items;
  @override
  final int total;

  factory _$SalonSummaryListResponse(
          [void Function(SalonSummaryListResponseBuilder)? updates]) =>
      (SalonSummaryListResponseBuilder()..update(updates))._build();

  _$SalonSummaryListResponse._({required this.items, required this.total})
      : super._();
  @override
  SalonSummaryListResponse rebuild(
          void Function(SalonSummaryListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalonSummaryListResponseBuilder toBuilder() =>
      SalonSummaryListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalonSummaryListResponse &&
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
    return (newBuiltValueToStringHelper(r'SalonSummaryListResponse')
          ..add('items', items)
          ..add('total', total))
        .toString();
  }
}

class SalonSummaryListResponseBuilder
    implements
        Builder<SalonSummaryListResponse, SalonSummaryListResponseBuilder> {
  _$SalonSummaryListResponse? _$v;

  ListBuilder<SalonSummaryListResponseItemsInner>? _items;
  ListBuilder<SalonSummaryListResponseItemsInner> get items =>
      _$this._items ??= ListBuilder<SalonSummaryListResponseItemsInner>();
  set items(ListBuilder<SalonSummaryListResponseItemsInner>? items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  SalonSummaryListResponseBuilder() {
    SalonSummaryListResponse._defaults(this);
  }

  SalonSummaryListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalonSummaryListResponse other) {
    _$v = other as _$SalonSummaryListResponse;
  }

  @override
  void update(void Function(SalonSummaryListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalonSummaryListResponse build() => _build();

  _$SalonSummaryListResponse _build() {
    _$SalonSummaryListResponse _$result;
    try {
      _$result = _$v ??
          _$SalonSummaryListResponse._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'SalonSummaryListResponse', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SalonSummaryListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
