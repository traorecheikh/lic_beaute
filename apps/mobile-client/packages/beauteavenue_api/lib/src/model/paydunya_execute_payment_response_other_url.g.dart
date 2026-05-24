// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paydunya_execute_payment_response_other_url.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaydunyaExecutePaymentResponseOtherUrl
    extends PaydunyaExecutePaymentResponseOtherUrl {
  @override
  final String? omUrl;
  @override
  final String? maxitUrl;

  factory _$PaydunyaExecutePaymentResponseOtherUrl(
          [void Function(PaydunyaExecutePaymentResponseOtherUrlBuilder)?
              updates]) =>
      (PaydunyaExecutePaymentResponseOtherUrlBuilder()..update(updates))
          ._build();

  _$PaydunyaExecutePaymentResponseOtherUrl._({this.omUrl, this.maxitUrl})
      : super._();
  @override
  PaydunyaExecutePaymentResponseOtherUrl rebuild(
          void Function(PaydunyaExecutePaymentResponseOtherUrlBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaydunyaExecutePaymentResponseOtherUrlBuilder toBuilder() =>
      PaydunyaExecutePaymentResponseOtherUrlBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaydunyaExecutePaymentResponseOtherUrl &&
        omUrl == other.omUrl &&
        maxitUrl == other.maxitUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, omUrl.hashCode);
    _$hash = $jc(_$hash, maxitUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PaydunyaExecutePaymentResponseOtherUrl')
          ..add('omUrl', omUrl)
          ..add('maxitUrl', maxitUrl))
        .toString();
  }
}

class PaydunyaExecutePaymentResponseOtherUrlBuilder
    implements
        Builder<PaydunyaExecutePaymentResponseOtherUrl,
            PaydunyaExecutePaymentResponseOtherUrlBuilder> {
  _$PaydunyaExecutePaymentResponseOtherUrl? _$v;

  String? _omUrl;
  String? get omUrl => _$this._omUrl;
  set omUrl(String? omUrl) => _$this._omUrl = omUrl;

  String? _maxitUrl;
  String? get maxitUrl => _$this._maxitUrl;
  set maxitUrl(String? maxitUrl) => _$this._maxitUrl = maxitUrl;

  PaydunyaExecutePaymentResponseOtherUrlBuilder() {
    PaydunyaExecutePaymentResponseOtherUrl._defaults(this);
  }

  PaydunyaExecutePaymentResponseOtherUrlBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _omUrl = $v.omUrl;
      _maxitUrl = $v.maxitUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaydunyaExecutePaymentResponseOtherUrl other) {
    _$v = other as _$PaydunyaExecutePaymentResponseOtherUrl;
  }

  @override
  void update(
      void Function(PaydunyaExecutePaymentResponseOtherUrlBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaydunyaExecutePaymentResponseOtherUrl build() => _build();

  _$PaydunyaExecutePaymentResponseOtherUrl _build() {
    final _$result = _$v ??
        _$PaydunyaExecutePaymentResponseOtherUrl._(
          omUrl: omUrl,
          maxitUrl: maxitUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
