// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_subscription_list_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSubscriptionListResponse extends AdminSubscriptionListResponse {
  @override
  final AdminSubscriptionListResponseSummary summary;
  @override
  final BuiltList<AdminSubscriptionListResponseItemsInner> items;
  @override
  final int total;

  factory _$AdminSubscriptionListResponse(
          [void Function(AdminSubscriptionListResponseBuilder)? updates]) =>
      (AdminSubscriptionListResponseBuilder()..update(updates))._build();

  _$AdminSubscriptionListResponse._(
      {required this.summary, required this.items, required this.total})
      : super._();
  @override
  AdminSubscriptionListResponse rebuild(
          void Function(AdminSubscriptionListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSubscriptionListResponseBuilder toBuilder() =>
      AdminSubscriptionListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSubscriptionListResponse &&
        summary == other.summary &&
        items == other.items &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSubscriptionListResponse')
          ..add('summary', summary)
          ..add('items', items)
          ..add('total', total))
        .toString();
  }
}

class AdminSubscriptionListResponseBuilder
    implements
        Builder<AdminSubscriptionListResponse,
            AdminSubscriptionListResponseBuilder> {
  _$AdminSubscriptionListResponse? _$v;

  AdminSubscriptionListResponseSummaryBuilder? _summary;
  AdminSubscriptionListResponseSummaryBuilder get summary =>
      _$this._summary ??= AdminSubscriptionListResponseSummaryBuilder();
  set summary(AdminSubscriptionListResponseSummaryBuilder? summary) =>
      _$this._summary = summary;

  ListBuilder<AdminSubscriptionListResponseItemsInner>? _items;
  ListBuilder<AdminSubscriptionListResponseItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminSubscriptionListResponseItemsInner>();
  set items(ListBuilder<AdminSubscriptionListResponseItemsInner>? items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminSubscriptionListResponseBuilder() {
    AdminSubscriptionListResponse._defaults(this);
  }

  AdminSubscriptionListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _summary = $v.summary.toBuilder();
      _items = $v.items.toBuilder();
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSubscriptionListResponse other) {
    _$v = other as _$AdminSubscriptionListResponse;
  }

  @override
  void update(void Function(AdminSubscriptionListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSubscriptionListResponse build() => _build();

  _$AdminSubscriptionListResponse _build() {
    _$AdminSubscriptionListResponse _$result;
    try {
      _$result = _$v ??
          _$AdminSubscriptionListResponse._(
            summary: summary.build(),
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminSubscriptionListResponse', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'summary';
        summary.build();
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminSubscriptionListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
