// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_reconcile_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentReconcileResponseStatusEnum
    _$paymentReconcileResponseStatusEnum_pending =
    const PaymentReconcileResponseStatusEnum._('pending');
const PaymentReconcileResponseStatusEnum
    _$paymentReconcileResponseStatusEnum_authorized =
    const PaymentReconcileResponseStatusEnum._('authorized');
const PaymentReconcileResponseStatusEnum
    _$paymentReconcileResponseStatusEnum_succeeded =
    const PaymentReconcileResponseStatusEnum._('succeeded');
const PaymentReconcileResponseStatusEnum
    _$paymentReconcileResponseStatusEnum_failed =
    const PaymentReconcileResponseStatusEnum._('failed');
const PaymentReconcileResponseStatusEnum
    _$paymentReconcileResponseStatusEnum_refunded =
    const PaymentReconcileResponseStatusEnum._('refunded');

PaymentReconcileResponseStatusEnum _$paymentReconcileResponseStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'pending':
      return _$paymentReconcileResponseStatusEnum_pending;
    case 'authorized':
      return _$paymentReconcileResponseStatusEnum_authorized;
    case 'succeeded':
      return _$paymentReconcileResponseStatusEnum_succeeded;
    case 'failed':
      return _$paymentReconcileResponseStatusEnum_failed;
    case 'refunded':
      return _$paymentReconcileResponseStatusEnum_refunded;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentReconcileResponseStatusEnum>
    _$paymentReconcileResponseStatusEnumValues = BuiltSet<
        PaymentReconcileResponseStatusEnum>(const <PaymentReconcileResponseStatusEnum>[
  _$paymentReconcileResponseStatusEnum_pending,
  _$paymentReconcileResponseStatusEnum_authorized,
  _$paymentReconcileResponseStatusEnum_succeeded,
  _$paymentReconcileResponseStatusEnum_failed,
  _$paymentReconcileResponseStatusEnum_refunded,
]);

const PaymentReconcileResponseProviderEnum
    _$paymentReconcileResponseProviderEnum_intech =
    const PaymentReconcileResponseProviderEnum._('intech');

PaymentReconcileResponseProviderEnum
    _$paymentReconcileResponseProviderEnumValueOf(String name) {
  switch (name) {
    case 'intech':
      return _$paymentReconcileResponseProviderEnum_intech;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentReconcileResponseProviderEnum>
    _$paymentReconcileResponseProviderEnumValues = BuiltSet<
        PaymentReconcileResponseProviderEnum>(const <PaymentReconcileResponseProviderEnum>[
  _$paymentReconcileResponseProviderEnum_intech,
]);

Serializer<PaymentReconcileResponseStatusEnum>
    _$paymentReconcileResponseStatusEnumSerializer =
    _$PaymentReconcileResponseStatusEnumSerializer();
Serializer<PaymentReconcileResponseProviderEnum>
    _$paymentReconcileResponseProviderEnumSerializer =
    _$PaymentReconcileResponseProviderEnumSerializer();

class _$PaymentReconcileResponseStatusEnumSerializer
    implements PrimitiveSerializer<PaymentReconcileResponseStatusEnum> {
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
  final Iterable<Type> types = const <Type>[PaymentReconcileResponseStatusEnum];
  @override
  final String wireName = 'PaymentReconcileResponseStatusEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentReconcileResponseStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentReconcileResponseStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentReconcileResponseStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentReconcileResponseProviderEnumSerializer
    implements PrimitiveSerializer<PaymentReconcileResponseProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'intech': 'intech',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'intech': 'intech',
  };

  @override
  final Iterable<Type> types = const <Type>[
    PaymentReconcileResponseProviderEnum
  ];
  @override
  final String wireName = 'PaymentReconcileResponseProviderEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentReconcileResponseProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentReconcileResponseProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentReconcileResponseProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentReconcileResponse extends PaymentReconcileResponse {
  @override
  final String id;
  @override
  final PaymentReconcileResponseStatusEnum status;
  @override
  final num amountXof;
  @override
  final PaymentReconcileResponseProviderEnum provider;
  @override
  final String? providerTxId;
  @override
  final DateTime createdAt;

  factory _$PaymentReconcileResponse(
          [void Function(PaymentReconcileResponseBuilder)? updates]) =>
      (PaymentReconcileResponseBuilder()..update(updates))._build();

  _$PaymentReconcileResponse._(
      {required this.id,
      required this.status,
      required this.amountXof,
      required this.provider,
      this.providerTxId,
      required this.createdAt})
      : super._();
  @override
  PaymentReconcileResponse rebuild(
          void Function(PaymentReconcileResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentReconcileResponseBuilder toBuilder() =>
      PaymentReconcileResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentReconcileResponse &&
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
    return (newBuiltValueToStringHelper(r'PaymentReconcileResponse')
          ..add('id', id)
          ..add('status', status)
          ..add('amountXof', amountXof)
          ..add('provider', provider)
          ..add('providerTxId', providerTxId)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class PaymentReconcileResponseBuilder
    implements
        Builder<PaymentReconcileResponse, PaymentReconcileResponseBuilder> {
  _$PaymentReconcileResponse? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  PaymentReconcileResponseStatusEnum? _status;
  PaymentReconcileResponseStatusEnum? get status => _$this._status;
  set status(PaymentReconcileResponseStatusEnum? status) =>
      _$this._status = status;

  num? _amountXof;
  num? get amountXof => _$this._amountXof;
  set amountXof(num? amountXof) => _$this._amountXof = amountXof;

  PaymentReconcileResponseProviderEnum? _provider;
  PaymentReconcileResponseProviderEnum? get provider => _$this._provider;
  set provider(PaymentReconcileResponseProviderEnum? provider) =>
      _$this._provider = provider;

  String? _providerTxId;
  String? get providerTxId => _$this._providerTxId;
  set providerTxId(String? providerTxId) => _$this._providerTxId = providerTxId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  PaymentReconcileResponseBuilder() {
    PaymentReconcileResponse._defaults(this);
  }

  PaymentReconcileResponseBuilder get _$this {
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
  void replace(PaymentReconcileResponse other) {
    _$v = other as _$PaymentReconcileResponse;
  }

  @override
  void update(void Function(PaymentReconcileResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentReconcileResponse build() => _build();

  _$PaymentReconcileResponse _build() {
    final _$result = _$v ??
        _$PaymentReconcileResponse._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'PaymentReconcileResponse', 'id'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PaymentReconcileResponse', 'status'),
          amountXof: BuiltValueNullFieldError.checkNotNull(
              amountXof, r'PaymentReconcileResponse', 'amountXof'),
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'PaymentReconcileResponse', 'provider'),
          providerTxId: providerTxId,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'PaymentReconcileResponse', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
