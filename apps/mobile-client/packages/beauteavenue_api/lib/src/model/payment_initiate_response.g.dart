// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_initiate_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentInitiateResponseStatusEnum
    _$paymentInitiateResponseStatusEnum_pending =
    const PaymentInitiateResponseStatusEnum._('pending');
const PaymentInitiateResponseStatusEnum
    _$paymentInitiateResponseStatusEnum_authorized =
    const PaymentInitiateResponseStatusEnum._('authorized');
const PaymentInitiateResponseStatusEnum
    _$paymentInitiateResponseStatusEnum_succeeded =
    const PaymentInitiateResponseStatusEnum._('succeeded');
const PaymentInitiateResponseStatusEnum
    _$paymentInitiateResponseStatusEnum_failed =
    const PaymentInitiateResponseStatusEnum._('failed');
const PaymentInitiateResponseStatusEnum
    _$paymentInitiateResponseStatusEnum_refunded =
    const PaymentInitiateResponseStatusEnum._('refunded');

PaymentInitiateResponseStatusEnum _$paymentInitiateResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'pending':
      return _$paymentInitiateResponseStatusEnum_pending;
    case 'authorized':
      return _$paymentInitiateResponseStatusEnum_authorized;
    case 'succeeded':
      return _$paymentInitiateResponseStatusEnum_succeeded;
    case 'failed':
      return _$paymentInitiateResponseStatusEnum_failed;
    case 'refunded':
      return _$paymentInitiateResponseStatusEnum_refunded;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentInitiateResponseStatusEnum>
    _$paymentInitiateResponseStatusEnumValues = BuiltSet<
        PaymentInitiateResponseStatusEnum>(const <PaymentInitiateResponseStatusEnum>[
  _$paymentInitiateResponseStatusEnum_pending,
  _$paymentInitiateResponseStatusEnum_authorized,
  _$paymentInitiateResponseStatusEnum_succeeded,
  _$paymentInitiateResponseStatusEnum_failed,
  _$paymentInitiateResponseStatusEnum_refunded,
]);

Serializer<PaymentInitiateResponseStatusEnum>
    _$paymentInitiateResponseStatusEnumSerializer =
    _$PaymentInitiateResponseStatusEnumSerializer();

class _$PaymentInitiateResponseStatusEnumSerializer
    implements PrimitiveSerializer<PaymentInitiateResponseStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'authorized': 'authorized',
    'succeeded': 'succeeded',
    'failed': 'failed',
    'refunded': 'refunded',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'authorized': 'authorized',
    'succeeded': 'succeeded',
    'failed': 'failed',
    'refunded': 'refunded',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentInitiateResponseStatusEnum];
  @override
  final String wireName = 'PaymentInitiateResponseStatusEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentInitiateResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentInitiateResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentInitiateResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentInitiateResponse extends PaymentInitiateResponse {
  @override
  final String paymentId;
  @override
  final String? redirectUrl;
  @override
  final DateTime? expiresAt;
  @override
  final PaymentInitiateResponseStatusEnum? status;

  factory _$PaymentInitiateResponse(
          [void Function(PaymentInitiateResponseBuilder)? updates]) =>
      (PaymentInitiateResponseBuilder()..update(updates))._build();

  _$PaymentInitiateResponse._(
      {required this.paymentId, this.redirectUrl, this.expiresAt, this.status})
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
        expiresAt == other.expiresAt &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jc(_$hash, redirectUrl.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentInitiateResponse')
          ..add('paymentId', paymentId)
          ..add('redirectUrl', redirectUrl)
          ..add('expiresAt', expiresAt)
          ..add('status', status))
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

  PaymentInitiateResponseStatusEnum? _status;
  PaymentInitiateResponseStatusEnum? get status => _$this._status;
  set status(PaymentInitiateResponseStatusEnum? status) =>
      _$this._status = status;

  PaymentInitiateResponseBuilder() {
    PaymentInitiateResponse._defaults(this);
  }

  PaymentInitiateResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentId = $v.paymentId;
      _redirectUrl = $v.redirectUrl;
      _expiresAt = $v.expiresAt;
      _status = $v.status;
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
          redirectUrl: redirectUrl,
          expiresAt: expiresAt,
          status: status,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
