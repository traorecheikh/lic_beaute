// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_salon_queue_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSalonQueueResponse extends AdminSalonQueueResponse {
  @override
  final BuiltList<ApiV1AdminSalonsGet200ResponseItemsInner> items;
  @override
  final int total;

  factory _$AdminSalonQueueResponse(
          [void Function(AdminSalonQueueResponseBuilder)? updates]) =>
      (AdminSalonQueueResponseBuilder()..update(updates))._build();

  _$AdminSalonQueueResponse._({required this.items, required this.total})
      : super._();
  @override
  AdminSalonQueueResponse rebuild(
          void Function(AdminSalonQueueResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSalonQueueResponseBuilder toBuilder() =>
      AdminSalonQueueResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSalonQueueResponse &&
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
    return (newBuiltValueToStringHelper(r'AdminSalonQueueResponse')
          ..add('items', items)
          ..add('total', total))
        .toString();
  }
}

class AdminSalonQueueResponseBuilder
    implements
        Builder<AdminSalonQueueResponse, AdminSalonQueueResponseBuilder> {
  _$AdminSalonQueueResponse? _$v;

  ListBuilder<ApiV1AdminSalonsGet200ResponseItemsInner>? _items;
  ListBuilder<ApiV1AdminSalonsGet200ResponseItemsInner> get items =>
      _$this._items ??= ListBuilder<ApiV1AdminSalonsGet200ResponseItemsInner>();
  set items(ListBuilder<ApiV1AdminSalonsGet200ResponseItemsInner>? items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  AdminSalonQueueResponseBuilder() {
    AdminSalonQueueResponse._defaults(this);
  }

  AdminSalonQueueResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSalonQueueResponse other) {
    _$v = other as _$AdminSalonQueueResponse;
  }

  @override
  void update(void Function(AdminSalonQueueResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSalonQueueResponse build() => _build();

  _$AdminSalonQueueResponse _build() {
    _$AdminSalonQueueResponse _$result;
    try {
      _$result = _$v ??
          _$AdminSalonQueueResponse._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'AdminSalonQueueResponse', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminSalonQueueResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
