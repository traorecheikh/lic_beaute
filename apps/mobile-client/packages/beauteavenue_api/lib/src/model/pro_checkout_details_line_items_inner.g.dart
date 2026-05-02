// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_checkout_details_line_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProCheckoutDetailsLineItemsInner
    extends ProCheckoutDetailsLineItemsInner {
  @override
  final String name;
  @override
  final int amountXof;

  factory _$ProCheckoutDetailsLineItemsInner(
          [void Function(ProCheckoutDetailsLineItemsInnerBuilder)? updates]) =>
      (ProCheckoutDetailsLineItemsInnerBuilder()..update(updates))._build();

  _$ProCheckoutDetailsLineItemsInner._(
      {required this.name, required this.amountXof})
      : super._();
  @override
  ProCheckoutDetailsLineItemsInner rebuild(
          void Function(ProCheckoutDetailsLineItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProCheckoutDetailsLineItemsInnerBuilder toBuilder() =>
      ProCheckoutDetailsLineItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProCheckoutDetailsLineItemsInner &&
        name == other.name &&
        amountXof == other.amountXof;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, amountXof.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProCheckoutDetailsLineItemsInner')
          ..add('name', name)
          ..add('amountXof', amountXof))
        .toString();
  }
}

class ProCheckoutDetailsLineItemsInnerBuilder
    implements
        Builder<ProCheckoutDetailsLineItemsInner,
            ProCheckoutDetailsLineItemsInnerBuilder> {
  _$ProCheckoutDetailsLineItemsInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _amountXof;
  int? get amountXof => _$this._amountXof;
  set amountXof(int? amountXof) => _$this._amountXof = amountXof;

  ProCheckoutDetailsLineItemsInnerBuilder() {
    ProCheckoutDetailsLineItemsInner._defaults(this);
  }

  ProCheckoutDetailsLineItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _amountXof = $v.amountXof;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProCheckoutDetailsLineItemsInner other) {
    _$v = other as _$ProCheckoutDetailsLineItemsInner;
  }

  @override
  void update(void Function(ProCheckoutDetailsLineItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProCheckoutDetailsLineItemsInner build() => _build();

  _$ProCheckoutDetailsLineItemsInner _build() {
    final _$result = _$v ??
        _$ProCheckoutDetailsLineItemsInner._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ProCheckoutDetailsLineItemsInner', 'name'),
          amountXof: BuiltValueNullFieldError.checkNotNull(
              amountXof, r'ProCheckoutDetailsLineItemsInner', 'amountXof'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
