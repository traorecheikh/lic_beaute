// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_summary_list_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAuditSummaryListResponse extends AdminAuditSummaryListResponse {
  @override
  final BuiltList<AdminAuditSummaryListResponseItemsInner> items;
  @override
  final int total;

  factory _$AdminAuditSummaryListResponse(
          [void Function(AdminAuditSummaryListResponseBuilder)? updates]) =>
      (AdminAuditSummaryListResponseBuilder()..update(updates))._build();

  _$AdminAuditSummaryListResponse._({required this.items, required this.total})
      : super._();
  @override
  AdminAuditSummaryListResponse rebuild(
          void Function(AdminAuditSummaryListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAuditSummaryListResponseBuilder toBuilder() =>
      AdminAuditSummaryListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAuditSummaryListResponse &&
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
    return (newBuiltValueToStringHelper(r'AdminAuditSummaryListResponse')
          ..add('items', items)
          ..add('total', total))
        .toString();
  }
}

class AdminAuditSummaryListResponseBuilder
    implements
        Builder<AdminAuditSummaryListResponse,
            AdminAuditSummaryListResponseBuilder> {
  _$AdminAuditSummaryListResponse? _$v;

  ListBuilder<AdminAuditSummaryListResponseItemsInner>? _items;
  ListBuilder<AdminAuditSummaryListResponseItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminAuditSummaryListResponseItemsInner>();
  set items(ListBuilder<AdminAuditSummaryListResponseItemsInner>? items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminAuditSummaryListResponseBuilder() {
    AdminAuditSummaryListResponse._defaults(this);
  }

  AdminAuditSummaryListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAuditSummaryListResponse other) {
    _$v = other as _$AdminAuditSummaryListResponse;
  }

  @override
  void update(void Function(AdminAuditSummaryListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAuditSummaryListResponse build() => _build();

  _$AdminAuditSummaryListResponse _build() {
    _$AdminAuditSummaryListResponse _$result;
    try {
      _$result = _$v ??
          _$AdminAuditSummaryListResponse._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminAuditSummaryListResponse', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminAuditSummaryListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
