// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_subscription_update_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProSubscriptionUpdateInput extends ProSubscriptionUpdateInput {
  @override
  final bool? autoRenew;
  @override
  final ProSubscriptionUpdateInputBillingMethod? billingMethod;

  factory _$ProSubscriptionUpdateInput(
          [void Function(ProSubscriptionUpdateInputBuilder)? updates]) =>
      (ProSubscriptionUpdateInputBuilder()..update(updates))._build();

  _$ProSubscriptionUpdateInput._({this.autoRenew, this.billingMethod})
      : super._();
  @override
  ProSubscriptionUpdateInput rebuild(
          void Function(ProSubscriptionUpdateInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProSubscriptionUpdateInputBuilder toBuilder() =>
      ProSubscriptionUpdateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProSubscriptionUpdateInput &&
        autoRenew == other.autoRenew &&
        billingMethod == other.billingMethod;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, autoRenew.hashCode);
    _$hash = $jc(_$hash, billingMethod.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProSubscriptionUpdateInput')
          ..add('autoRenew', autoRenew)
          ..add('billingMethod', billingMethod))
        .toString();
  }
}

class ProSubscriptionUpdateInputBuilder
    implements
        Builder<ProSubscriptionUpdateInput, ProSubscriptionUpdateInputBuilder> {
  _$ProSubscriptionUpdateInput? _$v;

  bool? _autoRenew;
  bool? get autoRenew => _$this._autoRenew;
  set autoRenew(bool? autoRenew) => _$this._autoRenew = autoRenew;

  ProSubscriptionUpdateInputBillingMethodBuilder? _billingMethod;
  ProSubscriptionUpdateInputBillingMethodBuilder get billingMethod =>
      _$this._billingMethod ??=
          ProSubscriptionUpdateInputBillingMethodBuilder();
  set billingMethod(
          ProSubscriptionUpdateInputBillingMethodBuilder? billingMethod) =>
      _$this._billingMethod = billingMethod;

  ProSubscriptionUpdateInputBuilder() {
    ProSubscriptionUpdateInput._defaults(this);
  }

  ProSubscriptionUpdateInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _autoRenew = $v.autoRenew;
      _billingMethod = $v.billingMethod?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProSubscriptionUpdateInput other) {
    _$v = other as _$ProSubscriptionUpdateInput;
  }

  @override
  void update(void Function(ProSubscriptionUpdateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProSubscriptionUpdateInput build() => _build();

  _$ProSubscriptionUpdateInput _build() {
    _$ProSubscriptionUpdateInput _$result;
    try {
      _$result = _$v ??
          _$ProSubscriptionUpdateInput._(
            autoRenew: autoRenew,
            billingMethod: _billingMethod?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'billingMethod';
        _billingMethod?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProSubscriptionUpdateInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
