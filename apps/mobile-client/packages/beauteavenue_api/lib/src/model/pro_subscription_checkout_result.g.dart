// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_subscription_checkout_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProSubscriptionCheckoutResult extends ProSubscriptionCheckoutResult {
  @override
  final String redirectUrl;
  @override
  final String chargeId;

  factory _$ProSubscriptionCheckoutResult(
          [void Function(ProSubscriptionCheckoutResultBuilder)? updates]) =>
      (ProSubscriptionCheckoutResultBuilder()..update(updates))._build();

  _$ProSubscriptionCheckoutResult._(
      {required this.redirectUrl, required this.chargeId})
      : super._();
  @override
  ProSubscriptionCheckoutResult rebuild(
          void Function(ProSubscriptionCheckoutResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProSubscriptionCheckoutResultBuilder toBuilder() =>
      ProSubscriptionCheckoutResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProSubscriptionCheckoutResult &&
        redirectUrl == other.redirectUrl &&
        chargeId == other.chargeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, redirectUrl.hashCode);
    _$hash = $jc(_$hash, chargeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProSubscriptionCheckoutResult')
          ..add('redirectUrl', redirectUrl)
          ..add('chargeId', chargeId))
        .toString();
  }
}

class ProSubscriptionCheckoutResultBuilder
    implements
        Builder<ProSubscriptionCheckoutResult,
            ProSubscriptionCheckoutResultBuilder> {
  _$ProSubscriptionCheckoutResult? _$v;

  String? _redirectUrl;
  String? get redirectUrl => _$this._redirectUrl;
  set redirectUrl(String? redirectUrl) => _$this._redirectUrl = redirectUrl;

  String? _chargeId;
  String? get chargeId => _$this._chargeId;
  set chargeId(String? chargeId) => _$this._chargeId = chargeId;

  ProSubscriptionCheckoutResultBuilder() {
    ProSubscriptionCheckoutResult._defaults(this);
  }

  ProSubscriptionCheckoutResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _redirectUrl = $v.redirectUrl;
      _chargeId = $v.chargeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProSubscriptionCheckoutResult other) {
    _$v = other as _$ProSubscriptionCheckoutResult;
  }

  @override
  void update(void Function(ProSubscriptionCheckoutResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProSubscriptionCheckoutResult build() => _build();

  _$ProSubscriptionCheckoutResult _build() {
    final _$result = _$v ??
        _$ProSubscriptionCheckoutResult._(
          redirectUrl: BuiltValueNullFieldError.checkNotNull(
              redirectUrl, r'ProSubscriptionCheckoutResult', 'redirectUrl'),
          chargeId: BuiltValueNullFieldError.checkNotNull(
              chargeId, r'ProSubscriptionCheckoutResult', 'chargeId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
