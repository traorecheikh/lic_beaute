// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_initiate_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PaymentInitiateInputProviderEnum
    _$paymentInitiateInputProviderEnum_intech =
    const PaymentInitiateInputProviderEnum._('intech');

PaymentInitiateInputProviderEnum _$paymentInitiateInputProviderEnumValueOf(
    String name) {
  switch (name) {
    case 'intech':
      return _$paymentInitiateInputProviderEnum_intech;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentInitiateInputProviderEnum>
    _$paymentInitiateInputProviderEnumValues = BuiltSet<
        PaymentInitiateInputProviderEnum>(const <PaymentInitiateInputProviderEnum>[
  _$paymentInitiateInputProviderEnum_intech,
]);

const PaymentInitiateInputChannelEnum _$paymentInitiateInputChannelEnum_wave =
    const PaymentInitiateInputChannelEnum._('wave');
const PaymentInitiateInputChannelEnum
    _$paymentInitiateInputChannelEnum_orangeMoney =
    const PaymentInitiateInputChannelEnum._('orangeMoney');
const PaymentInitiateInputChannelEnum
    _$paymentInitiateInputChannelEnum_freeMoney =
    const PaymentInitiateInputChannelEnum._('freeMoney');

PaymentInitiateInputChannelEnum _$paymentInitiateInputChannelEnumValueOf(
    String name) {
  switch (name) {
    case 'wave':
      return _$paymentInitiateInputChannelEnum_wave;
    case 'orangeMoney':
      return _$paymentInitiateInputChannelEnum_orangeMoney;
    case 'freeMoney':
      return _$paymentInitiateInputChannelEnum_freeMoney;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PaymentInitiateInputChannelEnum>
    _$paymentInitiateInputChannelEnumValues = BuiltSet<
        PaymentInitiateInputChannelEnum>(const <PaymentInitiateInputChannelEnum>[
  _$paymentInitiateInputChannelEnum_wave,
  _$paymentInitiateInputChannelEnum_orangeMoney,
  _$paymentInitiateInputChannelEnum_freeMoney,
]);

Serializer<PaymentInitiateInputProviderEnum>
    _$paymentInitiateInputProviderEnumSerializer =
    _$PaymentInitiateInputProviderEnumSerializer();
Serializer<PaymentInitiateInputChannelEnum>
    _$paymentInitiateInputChannelEnumSerializer =
    _$PaymentInitiateInputChannelEnumSerializer();

class _$PaymentInitiateInputProviderEnumSerializer
    implements PrimitiveSerializer<PaymentInitiateInputProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'intech': 'intech',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'intech': 'intech',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentInitiateInputProviderEnum];
  @override
  final String wireName = 'PaymentInitiateInputProviderEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentInitiateInputProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentInitiateInputProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentInitiateInputProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentInitiateInputChannelEnumSerializer
    implements PrimitiveSerializer<PaymentInitiateInputChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'wave': 'wave',
    'orangeMoney': 'orange_money',
    'freeMoney': 'free_money',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'wave': 'wave',
    'orange_money': 'orangeMoney',
    'free_money': 'freeMoney',
  };

  @override
  final Iterable<Type> types = const <Type>[PaymentInitiateInputChannelEnum];
  @override
  final String wireName = 'PaymentInitiateInputChannelEnum';

  @override
  Object serialize(
          Serializers serializers, PaymentInitiateInputChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PaymentInitiateInputChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PaymentInitiateInputChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PaymentInitiateInput extends PaymentInitiateInput {
  @override
  final String bookingId;
  @override
  final PaymentInitiateInputProviderEnum provider;
  @override
  final PaymentInitiateInputChannelEnum? channel;

  factory _$PaymentInitiateInput(
          [void Function(PaymentInitiateInputBuilder)? updates]) =>
      (PaymentInitiateInputBuilder()..update(updates))._build();

  _$PaymentInitiateInput._(
      {required this.bookingId, required this.provider, this.channel})
      : super._();
  @override
  PaymentInitiateInput rebuild(
          void Function(PaymentInitiateInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentInitiateInputBuilder toBuilder() =>
      PaymentInitiateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentInitiateInput &&
        bookingId == other.bookingId &&
        provider == other.provider &&
        channel == other.channel;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentInitiateInput')
          ..add('bookingId', bookingId)
          ..add('provider', provider)
          ..add('channel', channel))
        .toString();
  }
}

class PaymentInitiateInputBuilder
    implements Builder<PaymentInitiateInput, PaymentInitiateInputBuilder> {
  _$PaymentInitiateInput? _$v;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  PaymentInitiateInputProviderEnum? _provider;
  PaymentInitiateInputProviderEnum? get provider => _$this._provider;
  set provider(PaymentInitiateInputProviderEnum? provider) =>
      _$this._provider = provider;

  PaymentInitiateInputChannelEnum? _channel;
  PaymentInitiateInputChannelEnum? get channel => _$this._channel;
  set channel(PaymentInitiateInputChannelEnum? channel) =>
      _$this._channel = channel;

  PaymentInitiateInputBuilder() {
    PaymentInitiateInput._defaults(this);
  }

  PaymentInitiateInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingId = $v.bookingId;
      _provider = $v.provider;
      _channel = $v.channel;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentInitiateInput other) {
    _$v = other as _$PaymentInitiateInput;
  }

  @override
  void update(void Function(PaymentInitiateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentInitiateInput build() => _build();

  _$PaymentInitiateInput _build() {
    final _$result = _$v ??
        _$PaymentInitiateInput._(
          bookingId: BuiltValueNullFieldError.checkNotNull(
              bookingId, r'PaymentInitiateInput', 'bookingId'),
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'PaymentInitiateInput', 'provider'),
          channel: channel,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
