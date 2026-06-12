// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_subscription_checkout_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProSubscriptionCheckoutResult extends ProSubscriptionCheckoutResult {
  @override
  final String? redirectUrl;
  @override
  final String? chargeId;
  @override
  final bool? resumed;
  @override
  final bool? downgradeScheduled;
  @override
  final DateTime? effectiveAt;

  factory _$ProSubscriptionCheckoutResult(
          [void Function(ProSubscriptionCheckoutResultBuilder)? updates]) =>
      (ProSubscriptionCheckoutResultBuilder()..update(updates))._build();

  _$ProSubscriptionCheckoutResult._(
      {this.redirectUrl,
      this.chargeId,
      this.resumed,
      this.downgradeScheduled,
      this.effectiveAt})
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
        chargeId == other.chargeId &&
        resumed == other.resumed &&
        downgradeScheduled == other.downgradeScheduled &&
        effectiveAt == other.effectiveAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, redirectUrl.hashCode);
    _$hash = $jc(_$hash, chargeId.hashCode);
    _$hash = $jc(_$hash, resumed.hashCode);
    _$hash = $jc(_$hash, downgradeScheduled.hashCode);
    _$hash = $jc(_$hash, effectiveAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProSubscriptionCheckoutResult')
          ..add('redirectUrl', redirectUrl)
          ..add('chargeId', chargeId)
          ..add('resumed', resumed)
          ..add('downgradeScheduled', downgradeScheduled)
          ..add('effectiveAt', effectiveAt))
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

  bool? _resumed;
  bool? get resumed => _$this._resumed;
  set resumed(bool? resumed) => _$this._resumed = resumed;

  bool? _downgradeScheduled;
  bool? get downgradeScheduled => _$this._downgradeScheduled;
  set downgradeScheduled(bool? downgradeScheduled) =>
      _$this._downgradeScheduled = downgradeScheduled;

  DateTime? _effectiveAt;
  DateTime? get effectiveAt => _$this._effectiveAt;
  set effectiveAt(DateTime? effectiveAt) => _$this._effectiveAt = effectiveAt;

  ProSubscriptionCheckoutResultBuilder() {
    ProSubscriptionCheckoutResult._defaults(this);
  }

  ProSubscriptionCheckoutResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _redirectUrl = $v.redirectUrl;
      _chargeId = $v.chargeId;
      _resumed = $v.resumed;
      _downgradeScheduled = $v.downgradeScheduled;
      _effectiveAt = $v.effectiveAt;
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
          redirectUrl: redirectUrl,
          chargeId: chargeId,
          resumed: resumed,
          downgradeScheduled: downgradeScheduled,
          effectiveAt: effectiveAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
