// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_initiate_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentInitiateResponse extends PaymentInitiateResponse {
  @override
  final String paymentId;
  @override
  final String redirectUrl;
  @override
  final DateTime expiresAt;

  factory _$PaymentInitiateResponse(
          [void Function(PaymentInitiateResponseBuilder)? updates]) =>
      (PaymentInitiateResponseBuilder()..update(updates))._build();

  _$PaymentInitiateResponse._(
      {required this.paymentId,
      required this.redirectUrl,
      required this.expiresAt})
      : super._();
  @override
  PaymentInitiateResponse rebuild(
          void Function(PaymentInitiateResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentInitiateResponseBuilder toBuilder() =>
      PaymentInitiateResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentInitiateResponse &&
        paymentId == other.paymentId &&
        redirectUrl == other.redirectUrl &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jc(_$hash, redirectUrl.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentInitiateResponse')
          ..add('paymentId', paymentId)
          ..add('redirectUrl', redirectUrl)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class PaymentInitiateResponseBuilder
    implements
        Builder<PaymentInitiateResponse, PaymentInitiateResponseBuilder> {
  _$PaymentInitiateResponse? _$v;

  String? _paymentId;
  String? get paymentId => _$this._paymentId;
  set paymentId(String? paymentId) => _$this._paymentId = paymentId;

  String? _redirectUrl;
  String? get redirectUrl => _$this._redirectUrl;
  set redirectUrl(String? redirectUrl) => _$this._redirectUrl = redirectUrl;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  PaymentInitiateResponseBuilder() {
    PaymentInitiateResponse._defaults(this);
  }

  PaymentInitiateResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentId = $v.paymentId;
      _redirectUrl = $v.redirectUrl;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentInitiateResponse other) {
    _$v = other as _$PaymentInitiateResponse;
  }

  @override
  void update(void Function(PaymentInitiateResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentInitiateResponse build() => _build();

  _$PaymentInitiateResponse _build() {
    final _$result = _$v ??
        _$PaymentInitiateResponse._(
          paymentId: BuiltValueNullFieldError.checkNotNull(
              paymentId, r'PaymentInitiateResponse', 'paymentId'),
          redirectUrl: BuiltValueNullFieldError.checkNotNull(
              redirectUrl, r'PaymentInitiateResponse', 'redirectUrl'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'PaymentInitiateResponse', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
