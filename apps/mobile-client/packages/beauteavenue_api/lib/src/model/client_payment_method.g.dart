// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_payment_method.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ClientPaymentMethodProviderEnum _$clientPaymentMethodProviderEnum_intech =
    const ClientPaymentMethodProviderEnum._('intech');
const ClientPaymentMethodProviderEnum
    _$clientPaymentMethodProviderEnum_paydunya =
    const ClientPaymentMethodProviderEnum._('paydunya');
const ClientPaymentMethodProviderEnum _$clientPaymentMethodProviderEnum_manual =
    const ClientPaymentMethodProviderEnum._('manual');

ClientPaymentMethodProviderEnum _$clientPaymentMethodProviderEnumValueOf(
    String name) {
  switch (name) {
    case 'intech':
      return _$clientPaymentMethodProviderEnum_intech;
    case 'paydunya':
      return _$clientPaymentMethodProviderEnum_paydunya;
    case 'manual':
      return _$clientPaymentMethodProviderEnum_manual;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClientPaymentMethodProviderEnum>
    _$clientPaymentMethodProviderEnumValues = BuiltSet<
        ClientPaymentMethodProviderEnum>(const <ClientPaymentMethodProviderEnum>[
  _$clientPaymentMethodProviderEnum_intech,
  _$clientPaymentMethodProviderEnum_paydunya,
  _$clientPaymentMethodProviderEnum_manual,
]);

Serializer<ClientPaymentMethodProviderEnum>
    _$clientPaymentMethodProviderEnumSerializer =
    _$ClientPaymentMethodProviderEnumSerializer();

class _$ClientPaymentMethodProviderEnumSerializer
    implements PrimitiveSerializer<ClientPaymentMethodProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'intech': 'intech',
    'paydunya': 'paydunya',
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'intech': 'intech',
    'paydunya': 'paydunya',
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[ClientPaymentMethodProviderEnum];
  @override
  final String wireName = 'ClientPaymentMethodProviderEnum';

  @override
  Object serialize(
          Serializers serializers, ClientPaymentMethodProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClientPaymentMethodProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClientPaymentMethodProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ClientPaymentMethod extends ClientPaymentMethod {
  @override
  final String id;
  @override
  final ClientPaymentMethodProviderEnum provider;
  @override
  final String phoneNumber;
  @override
  final String? label;
  @override
  final bool isDefault;
  @override
  final String? lastUsedAt;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  factory _$ClientPaymentMethod(
          [void Function(ClientPaymentMethodBuilder)? updates]) =>
      (ClientPaymentMethodBuilder()..update(updates))._build();

  _$ClientPaymentMethod._(
      {required this.id,
      required this.provider,
      required this.phoneNumber,
      this.label,
      required this.isDefault,
      this.lastUsedAt,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  ClientPaymentMethod rebuild(
          void Function(ClientPaymentMethodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClientPaymentMethodBuilder toBuilder() =>
      ClientPaymentMethodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClientPaymentMethod &&
        id == other.id &&
        provider == other.provider &&
        phoneNumber == other.phoneNumber &&
        label == other.label &&
        isDefault == other.isDefault &&
        lastUsedAt == other.lastUsedAt &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, isDefault.hashCode);
    _$hash = $jc(_$hash, lastUsedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClientPaymentMethod')
          ..add('id', id)
          ..add('provider', provider)
          ..add('phoneNumber', phoneNumber)
          ..add('label', label)
          ..add('isDefault', isDefault)
          ..add('lastUsedAt', lastUsedAt)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ClientPaymentMethodBuilder
    implements Builder<ClientPaymentMethod, ClientPaymentMethodBuilder> {
  _$ClientPaymentMethod? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ClientPaymentMethodProviderEnum? _provider;
  ClientPaymentMethodProviderEnum? get provider => _$this._provider;
  set provider(ClientPaymentMethodProviderEnum? provider) =>
      _$this._provider = provider;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _isDefault;
  bool? get isDefault => _$this._isDefault;
  set isDefault(bool? isDefault) => _$this._isDefault = isDefault;

  String? _lastUsedAt;
  String? get lastUsedAt => _$this._lastUsedAt;
  set lastUsedAt(String? lastUsedAt) => _$this._lastUsedAt = lastUsedAt;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  ClientPaymentMethodBuilder() {
    ClientPaymentMethod._defaults(this);
  }

  ClientPaymentMethodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _provider = $v.provider;
      _phoneNumber = $v.phoneNumber;
      _label = $v.label;
      _isDefault = $v.isDefault;
      _lastUsedAt = $v.lastUsedAt;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClientPaymentMethod other) {
    _$v = other as _$ClientPaymentMethod;
  }

  @override
  void update(void Function(ClientPaymentMethodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClientPaymentMethod build() => _build();

  _$ClientPaymentMethod _build() {
    final _$result = _$v ??
        _$ClientPaymentMethod._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ClientPaymentMethod', 'id'),
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'ClientPaymentMethod', 'provider'),
          phoneNumber: BuiltValueNullFieldError.checkNotNull(
              phoneNumber, r'ClientPaymentMethod', 'phoneNumber'),
          label: label,
          isDefault: BuiltValueNullFieldError.checkNotNull(
              isDefault, r'ClientPaymentMethod', 'isDefault'),
          lastUsedAt: lastUsedAt,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'ClientPaymentMethod', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt, r'ClientPaymentMethod', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
