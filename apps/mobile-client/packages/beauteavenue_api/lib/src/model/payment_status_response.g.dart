// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_status_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentStatusResponseStatusEnum
    _$paymentStatusResponseStatusEnum_pending =
    const PaymentStatusResponseStatusEnum._('pending');
const PaymentStatusResponseStatusEnum
    _$paymentStatusResponseStatusEnum_authorized =
    const PaymentStatusResponseStatusEnum._('authorized');
const PaymentStatusResponseStatusEnum
    _$paymentStatusResponseStatusEnum_succeeded =
    const PaymentStatusResponseStatusEnum._('succeeded');
const PaymentStatusResponseStatusEnum _$paymentStatusResponseStatusEnum_failed =
    const PaymentStatusResponseStatusEnum._('failed');
const PaymentStatusResponseStatusEnum
    _$paymentStatusResponseStatusEnum_refunded =
    const PaymentStatusResponseStatusEnum._('refunded');

PaymentStatusResponseStatusEnum _$paymentStatusResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'pending':
      return _$paymentStatusResponseStatusEnum_pending;
    case 'authorized':
      return _$paymentStatusResponseStatusEnum_authorized;
    case 'succeeded':
      return _$paymentStatusResponseStatusEnum_succeeded;
    case 'failed':
      return _$paymentStatusResponseStatusEnum_failed;
    case 'refunded':
      return _$paymentStatusResponseStatusEnum_refunded;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentStatusResponseStatusEnum>
    _$paymentStatusResponseStatusEnumValues = BuiltSet<
        PaymentStatusResponseStatusEnum>(const <PaymentStatusResponseStatusEnum>[
  _$paymentStatusResponseStatusEnum_pending,
  _$paymentStatusResponseStatusEnum_authorized,
  _$paymentStatusResponseStatusEnum_succeeded,
  _$paymentStatusResponseStatusEnum_failed,
  _$paymentStatusResponseStatusEnum_refunded,
]);

const PaymentStatusResponseProviderEnum
    _$paymentStatusResponseProviderEnum_intech =
    const PaymentStatusResponseProviderEnum._('intech');

PaymentStatusResponseProviderEnum _$paymentStatusResponseProviderEnumValueOf(
    String name) {
  switch (name) {
    case 'intech':
      return _$paymentStatusResponseProviderEnum_intech;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentStatusResponseProviderEnum>
    _$paymentStatusResponseProviderEnumValues = BuiltSet<
        PaymentStatusResponseProviderEnum>(const <PaymentStatusResponseProviderEnum>[
  _$paymentStatusResponseProviderEnum_intech,
]);

Serializer<PaymentStatusResponseStatusEnum>
    _$paymentStatusResponseStatusEnumSerializer =
    _$PaymentStatusResponseStatusEnumSerializer();
Serializer<PaymentStatusResponseProviderEnum>
    _$paymentStatusResponseProviderEnumSerializer =
    _$PaymentStatusResponseProviderEnumSerializer();

class _$PaymentStatusResponseStatusEnumSerializer
    implements PrimitiveSerializer<PaymentStatusResponseStatusEnum> {
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
  final Iterable<Type> types = const <Type>[PaymentStatusResponseStatusEnum];
  @override
  final String wireName = 'PaymentStatusResponseStatusEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentStatusResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentStatusResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentStatusResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentStatusResponseProviderEnumSerializer
    implements PrimitiveSerializer<PaymentStatusResponseProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'intech': 'intech',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'intech': 'intech',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentStatusResponseProviderEnum];
  @override
  final String wireName = 'PaymentStatusResponseProviderEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentStatusResponseProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentStatusResponseProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentStatusResponseProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentStatusResponse extends PaymentStatusResponse {
  @override
  final String id;
  @override
  final PaymentStatusResponseStatusEnum status;
  @override
  final num amountXof;
  @override
  final PaymentStatusResponseProviderEnum provider;
  @override
  final String? providerTxId;
  @override
  final DateTime createdAt;

  factory _$PaymentStatusResponse(
          [void Function(PaymentStatusResponseBuilder)? updates]) =>
      (PaymentStatusResponseBuilder()..update(updates))._build();

  _$PaymentStatusResponse._(
      {required this.id,
      required this.status,
      required this.amountXof,
      required this.provider,
      this.providerTxId,
      required this.createdAt})
      : super._();
  @override
  PaymentStatusResponse rebuild(
          void Function(PaymentStatusResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentStatusResponseBuilder toBuilder() =>
      PaymentStatusResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentStatusResponse &&
        id == other.id &&
        status == other.status &&
        amountXof == other.amountXof &&
        provider == other.provider &&
        providerTxId == other.providerTxId &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, amountXof.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, providerTxId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentStatusResponse')
          ..add('id', id)
          ..add('status', status)
          ..add('amountXof', amountXof)
          ..add('provider', provider)
          ..add('providerTxId', providerTxId)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class PaymentStatusResponseBuilder
    implements Builder<PaymentStatusResponse, PaymentStatusResponseBuilder> {
  _$PaymentStatusResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PaymentStatusResponseStatusEnum? _status;
  PaymentStatusResponseStatusEnum? get status => _$this._status;
  set status(PaymentStatusResponseStatusEnum? status) =>
      _$this._status = status;

  num? _amountXof;
  num? get amountXof => _$this._amountXof;
  set amountXof(num? amountXof) => _$this._amountXof = amountXof;

  PaymentStatusResponseProviderEnum? _provider;
  PaymentStatusResponseProviderEnum? get provider => _$this._provider;
  set provider(PaymentStatusResponseProviderEnum? provider) =>
      _$this._provider = provider;

  String? _providerTxId;
  String? get providerTxId => _$this._providerTxId;
  set providerTxId(String? providerTxId) => _$this._providerTxId = providerTxId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  PaymentStatusResponseBuilder() {
    PaymentStatusResponse._defaults(this);
  }

  PaymentStatusResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _amountXof = $v.amountXof;
      _provider = $v.provider;
      _providerTxId = $v.providerTxId;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentStatusResponse other) {
    _$v = other as _$PaymentStatusResponse;
  }

  @override
  void update(void Function(PaymentStatusResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentStatusResponse build() => _build();

  _$PaymentStatusResponse _build() {
    final _$result = _$v ??
        _$PaymentStatusResponse._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PaymentStatusResponse', 'id'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PaymentStatusResponse', 'status'),
          amountXof: BuiltValueNullFieldError.checkNotNull(
              amountXof, r'PaymentStatusResponse', 'amountXof'),
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'PaymentStatusResponse', 'provider'),
          providerTxId: providerTxId,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'PaymentStatusResponse', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
