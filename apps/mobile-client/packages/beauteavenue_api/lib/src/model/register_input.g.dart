// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RegisterInputTypeEnum _$registerInputTypeEnum_client =
    const RegisterInputTypeEnum._('client');
const RegisterInputTypeEnum _$registerInputTypeEnum_salonOwner =
    const RegisterInputTypeEnum._('salonOwner');

RegisterInputTypeEnum _$registerInputTypeEnumValueOf(String name) {
  switch (name) {
    case 'client':
      return _$registerInputTypeEnum_client;
    case 'salonOwner':
      return _$registerInputTypeEnum_salonOwner;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RegisterInputTypeEnum> _$registerInputTypeEnumValues =
    BuiltSet<RegisterInputTypeEnum>(const <RegisterInputTypeEnum>[
  _$registerInputTypeEnum_client,
  _$registerInputTypeEnum_salonOwner,
]);

const RegisterInputSubscriptionIntentTierEnum
    _$registerInputSubscriptionIntentTierEnum_standard =
    const RegisterInputSubscriptionIntentTierEnum._('standard');
const RegisterInputSubscriptionIntentTierEnum
    _$registerInputSubscriptionIntentTierEnum_premium =
    const RegisterInputSubscriptionIntentTierEnum._('premium');

RegisterInputSubscriptionIntentTierEnum
    _$registerInputSubscriptionIntentTierEnumValueOf(String name) {
  switch (name) {
    case 'standard':
      return _$registerInputSubscriptionIntentTierEnum_standard;
    case 'premium':
      return _$registerInputSubscriptionIntentTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RegisterInputSubscriptionIntentTierEnum>
    _$registerInputSubscriptionIntentTierEnumValues = BuiltSet<
        RegisterInputSubscriptionIntentTierEnum>(const <RegisterInputSubscriptionIntentTierEnum>[
  _$registerInputSubscriptionIntentTierEnum_standard,
  _$registerInputSubscriptionIntentTierEnum_premium,
]);

Serializer<RegisterInputTypeEnum> _$registerInputTypeEnumSerializer =
    _$RegisterInputTypeEnumSerializer();
Serializer<RegisterInputSubscriptionIntentTierEnum>
    _$registerInputSubscriptionIntentTierEnumSerializer =
    _$RegisterInputSubscriptionIntentTierEnumSerializer();

class _$RegisterInputTypeEnumSerializer
    implements PrimitiveSerializer<RegisterInputTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'client': 'client',
    'salonOwner': 'salon_owner',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'client': 'client',
    'salon_owner': 'salonOwner',
  };

  @override
  final Iterable<Type> types = const <Type>[RegisterInputTypeEnum];
  @override
  final String wireName = 'RegisterInputTypeEnum';

  @override
  Object serialize(Serializers serializers, RegisterInputTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RegisterInputTypeEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RegisterInputTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RegisterInputSubscriptionIntentTierEnumSerializer
    implements PrimitiveSerializer<RegisterInputSubscriptionIntentTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'standard': 'standard',
    'premium': 'premium',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'standard': 'standard',
    'premium': 'premium',
  };

  @override
  final Iterable<Type> types = const <Type>[
    RegisterInputSubscriptionIntentTierEnum
  ];
  @override
  final String wireName = 'RegisterInputSubscriptionIntentTierEnum';

  @override
  Object serialize(Serializers serializers,
          RegisterInputSubscriptionIntentTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RegisterInputSubscriptionIntentTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RegisterInputSubscriptionIntentTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RegisterInput extends RegisterInput {
  @override
  final AnyOf anyOf;

  factory _$RegisterInput([void Function(RegisterInputBuilder)? updates]) =>
      (RegisterInputBuilder()..update(updates))._build();

  _$RegisterInput._({required this.anyOf}) : super._();
  @override
  RegisterInput rebuild(void Function(RegisterInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterInputBuilder toBuilder() => RegisterInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterInput && anyOf == other.anyOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, anyOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterInput')..add('anyOf', anyOf))
        .toString();
  }
}

class RegisterInputBuilder
    implements Builder<RegisterInput, RegisterInputBuilder> {
  _$RegisterInput? _$v;

  AnyOf? _anyOf;
  AnyOf? get anyOf => _$this._anyOf;
  set anyOf(AnyOf? anyOf) => _$this._anyOf = anyOf;

  RegisterInputBuilder() {
    RegisterInput._defaults(this);
  }

  RegisterInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _anyOf = $v.anyOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterInput other) {
    _$v = other as _$RegisterInput;
  }

  @override
  void update(void Function(RegisterInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterInput build() => _build();

  _$RegisterInput _build() {
    final _$result = _$v ??
        _$RegisterInput._(
          anyOf: BuiltValueNullFieldError.checkNotNull(
              anyOf, r'RegisterInput', 'anyOf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
