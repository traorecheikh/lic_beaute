// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_payment_method_create_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ClientPaymentMethodCreateInputProviderEnum
    _$clientPaymentMethodCreateInputProviderEnum_intech =
    const ClientPaymentMethodCreateInputProviderEnum._('intech');

ClientPaymentMethodCreateInputProviderEnum
    _$clientPaymentMethodCreateInputProviderEnumValueOf(String name) {
  switch (name) {
    case 'intech':
      return _$clientPaymentMethodCreateInputProviderEnum_intech;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClientPaymentMethodCreateInputProviderEnum>
    _$clientPaymentMethodCreateInputProviderEnumValues = BuiltSet<
        ClientPaymentMethodCreateInputProviderEnum>(const <ClientPaymentMethodCreateInputProviderEnum>[
  _$clientPaymentMethodCreateInputProviderEnum_intech,
]);

Serializer<ClientPaymentMethodCreateInputProviderEnum>
    _$clientPaymentMethodCreateInputProviderEnumSerializer =
    _$ClientPaymentMethodCreateInputProviderEnumSerializer();

class _$ClientPaymentMethodCreateInputProviderEnumSerializer
    implements PrimitiveSerializer<ClientPaymentMethodCreateInputProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'intech': 'intech',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'intech': 'intech',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ClientPaymentMethodCreateInputProviderEnum
  ];
  @override
  final String wireName = 'ClientPaymentMethodCreateInputProviderEnum';

  @override
  Object serialize(Serializers serializers,
          ClientPaymentMethodCreateInputProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClientPaymentMethodCreateInputProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClientPaymentMethodCreateInputProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ClientPaymentMethodCreateInput extends ClientPaymentMethodCreateInput {
  @override
  final ClientPaymentMethodCreateInputProviderEnum provider;
  @override
  final String phoneNumber;
  @override
  final String? label;

  factory _$ClientPaymentMethodCreateInput(
          [void Function(ClientPaymentMethodCreateInputBuilder)? updates]) =>
      (ClientPaymentMethodCreateInputBuilder()..update(updates))._build();

  _$ClientPaymentMethodCreateInput._(
      {required this.provider, required this.phoneNumber, this.label})
      : super._();
  @override
  ClientPaymentMethodCreateInput rebuild(
          void Function(ClientPaymentMethodCreateInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClientPaymentMethodCreateInputBuilder toBuilder() =>
      ClientPaymentMethodCreateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClientPaymentMethodCreateInput &&
        provider == other.provider &&
        phoneNumber == other.phoneNumber &&
        label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClientPaymentMethodCreateInput')
          ..add('provider', provider)
          ..add('phoneNumber', phoneNumber)
          ..add('label', label))
        .toString();
  }
}

class ClientPaymentMethodCreateInputBuilder
    implements
        Builder<ClientPaymentMethodCreateInput,
            ClientPaymentMethodCreateInputBuilder> {
  _$ClientPaymentMethodCreateInput? _$v;

  ClientPaymentMethodCreateInputProviderEnum? _provider;
  ClientPaymentMethodCreateInputProviderEnum? get provider => _$this._provider;
  set provider(ClientPaymentMethodCreateInputProviderEnum? provider) =>
      _$this._provider = provider;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ClientPaymentMethodCreateInputBuilder() {
    ClientPaymentMethodCreateInput._defaults(this);
  }

  ClientPaymentMethodCreateInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _provider = $v.provider;
      _phoneNumber = $v.phoneNumber;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClientPaymentMethodCreateInput other) {
    _$v = other as _$ClientPaymentMethodCreateInput;
  }

  @override
  void update(void Function(ClientPaymentMethodCreateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClientPaymentMethodCreateInput build() => _build();

  _$ClientPaymentMethodCreateInput _build() {
    final _$result = _$v ??
        _$ClientPaymentMethodCreateInput._(
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'ClientPaymentMethodCreateInput', 'provider'),
          phoneNumber: BuiltValueNullFieldError.checkNotNull(
              phoneNumber, r'ClientPaymentMethodCreateInput', 'phoneNumber'),
          label: label,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
