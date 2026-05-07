// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_webhook_body_amount.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentWebhookBodyAmount extends PaymentWebhookBodyAmount {
  @override
  final AnyOf anyOf;

  factory _$PaymentWebhookBodyAmount(
          [void Function(PaymentWebhookBodyAmountBuilder)? updates]) =>
      (PaymentWebhookBodyAmountBuilder()..update(updates))._build();

  _$PaymentWebhookBodyAmount._({required this.anyOf}) : super._();
  @override
  PaymentWebhookBodyAmount rebuild(
          void Function(PaymentWebhookBodyAmountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentWebhookBodyAmountBuilder toBuilder() =>
      PaymentWebhookBodyAmountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentWebhookBodyAmount && anyOf == other.anyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentWebhookBodyAmount')
          ..add('anyOf', anyOf))
        .toString();
  }
}

class PaymentWebhookBodyAmountBuilder
    implements
        Builder<PaymentWebhookBodyAmount, PaymentWebhookBodyAmountBuilder> {
  _$PaymentWebhookBodyAmount? _$v;

  AnyOf? _anyOf;
  AnyOf? get anyOf => _$this._anyOf;
  set anyOf(AnyOf? anyOf) => _$this._anyOf = anyOf;

  PaymentWebhookBodyAmountBuilder() {
    PaymentWebhookBodyAmount._defaults(this);
  }

  PaymentWebhookBodyAmountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anyOf = $v.anyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentWebhookBodyAmount other) {
    _$v = other as _$PaymentWebhookBodyAmount;
  }

  @override
  void update(void Function(PaymentWebhookBodyAmountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentWebhookBodyAmount build() => _build();

  _$PaymentWebhookBodyAmount _build() {
    final _$result = _$v ??
        _$PaymentWebhookBodyAmount._(
          anyOf: BuiltValueNullFieldError.checkNotNull(
              anyOf, r'PaymentWebhookBodyAmount', 'anyOf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
