// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_webhook_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaymentWebhookBody extends PaymentWebhookBody {
  @override
  final String? idFromGu;
  @override
  final String? idFromClient;
  @override
  final String? code;
  @override
  final String? status;
  @override
  final PaymentWebhookBodyAmount? amount;
  @override
  final PaymentWebhookBodyAmount? amountWithoutFees;
  @override
  final String? serviceCode;
  @override
  final String? infoHash;
  @override
  final String? secureHash;

  factory _$PaymentWebhookBody(
          [void Function(PaymentWebhookBodyBuilder)? updates]) =>
      (PaymentWebhookBodyBuilder()..update(updates))._build();

  _$PaymentWebhookBody._(
      {this.idFromGu,
      this.idFromClient,
      this.code,
      this.status,
      this.amount,
      this.amountWithoutFees,
      this.serviceCode,
      this.infoHash,
      this.secureHash})
      : super._();
  @override
  PaymentWebhookBody rebuild(
          void Function(PaymentWebhookBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentWebhookBodyBuilder toBuilder() =>
      PaymentWebhookBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentWebhookBody &&
        idFromGu == other.idFromGu &&
        idFromClient == other.idFromClient &&
        code == other.code &&
        status == other.status &&
        amount == other.amount &&
        amountWithoutFees == other.amountWithoutFees &&
        serviceCode == other.serviceCode &&
        infoHash == other.infoHash &&
        secureHash == other.secureHash;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, idFromGu.hashCode);
    _$hash = $jc(_$hash, idFromClient.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, amountWithoutFees.hashCode);
    _$hash = $jc(_$hash, serviceCode.hashCode);
    _$hash = $jc(_$hash, infoHash.hashCode);
    _$hash = $jc(_$hash, secureHash.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentWebhookBody')
          ..add('idFromGu', idFromGu)
          ..add('idFromClient', idFromClient)
          ..add('code', code)
          ..add('status', status)
          ..add('amount', amount)
          ..add('amountWithoutFees', amountWithoutFees)
          ..add('serviceCode', serviceCode)
          ..add('infoHash', infoHash)
          ..add('secureHash', secureHash))
        .toString();
  }
}

class PaymentWebhookBodyBuilder
    implements Builder<PaymentWebhookBody, PaymentWebhookBodyBuilder> {
  _$PaymentWebhookBody? _$v;

  String? _idFromGu;
  String? get idFromGu => _$this._idFromGu;
  set idFromGu(String? idFromGu) => _$this._idFromGu = idFromGu;

  String? _idFromClient;
  String? get idFromClient => _$this._idFromClient;
  set idFromClient(String? idFromClient) => _$this._idFromClient = idFromClient;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  PaymentWebhookBodyAmountBuilder? _amount;
  PaymentWebhookBodyAmountBuilder get amount =>
      _$this._amount ??= PaymentWebhookBodyAmountBuilder();
  set amount(PaymentWebhookBodyAmountBuilder? amount) =>
      _$this._amount = amount;

  PaymentWebhookBodyAmountBuilder? _amountWithoutFees;
  PaymentWebhookBodyAmountBuilder get amountWithoutFees =>
      _$this._amountWithoutFees ??= PaymentWebhookBodyAmountBuilder();
  set amountWithoutFees(PaymentWebhookBodyAmountBuilder? amountWithoutFees) =>
      _$this._amountWithoutFees = amountWithoutFees;

  String? _serviceCode;
  String? get serviceCode => _$this._serviceCode;
  set serviceCode(String? serviceCode) => _$this._serviceCode = serviceCode;

  String? _infoHash;
  String? get infoHash => _$this._infoHash;
  set infoHash(String? infoHash) => _$this._infoHash = infoHash;

  String? _secureHash;
  String? get secureHash => _$this._secureHash;
  set secureHash(String? secureHash) => _$this._secureHash = secureHash;

  PaymentWebhookBodyBuilder() {
    PaymentWebhookBody._defaults(this);
  }

  PaymentWebhookBodyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _idFromGu = $v.idFromGu;
      _idFromClient = $v.idFromClient;
      _code = $v.code;
      _status = $v.status;
      _amount = $v.amount?.toBuilder();
      _amountWithoutFees = $v.amountWithoutFees?.toBuilder();
      _serviceCode = $v.serviceCode;
      _infoHash = $v.infoHash;
      _secureHash = $v.secureHash;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentWebhookBody other) {
    _$v = other as _$PaymentWebhookBody;
  }

  @override
  void update(void Function(PaymentWebhookBodyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentWebhookBody build() => _build();

  _$PaymentWebhookBody _build() {
    _$PaymentWebhookBody _$result;
    try {
      _$result = _$v ??
          _$PaymentWebhookBody._(
            idFromGu: idFromGu,
            idFromClient: idFromClient,
            code: code,
            status: status,
            amount: _amount?.build(),
            amountWithoutFees: _amountWithoutFees?.build(),
            serviceCode: serviceCode,
            infoHash: infoHash,
            secureHash: secureHash,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'amount';
        _amount?.build();
        _$failedField = 'amountWithoutFees';
        _amountWithoutFees?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PaymentWebhookBody', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
