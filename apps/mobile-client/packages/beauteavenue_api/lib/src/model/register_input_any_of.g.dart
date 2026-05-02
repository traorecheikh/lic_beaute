// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_input_any_of.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RegisterInputAnyOfTypeEnum _$registerInputAnyOfTypeEnum_client =
    const RegisterInputAnyOfTypeEnum._('client');

RegisterInputAnyOfTypeEnum _$registerInputAnyOfTypeEnumValueOf(String name) {
  switch (name) {
    case 'client':
      return _$registerInputAnyOfTypeEnum_client;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RegisterInputAnyOfTypeEnum> _$registerInputAnyOfTypeEnumValues =
    BuiltSet<RegisterInputAnyOfTypeEnum>(const <RegisterInputAnyOfTypeEnum>[
  _$registerInputAnyOfTypeEnum_client,
]);

Serializer<RegisterInputAnyOfTypeEnum> _$registerInputAnyOfTypeEnumSerializer =
    _$RegisterInputAnyOfTypeEnumSerializer();

class _$RegisterInputAnyOfTypeEnumSerializer
    implements PrimitiveSerializer<RegisterInputAnyOfTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'client': 'client',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'client': 'client',
  };

  @override
  final Iterable<Type> types = const <Type>[RegisterInputAnyOfTypeEnum];
  @override
  final String wireName = 'RegisterInputAnyOfTypeEnum';

  @override
  Object serialize(Serializers serializers, RegisterInputAnyOfTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RegisterInputAnyOfTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RegisterInputAnyOfTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RegisterInputAnyOf extends RegisterInputAnyOf {
  @override
  final RegisterInputAnyOfTypeEnum type;
  @override
  final String fullName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String password;

  factory _$RegisterInputAnyOf(
          [void Function(RegisterInputAnyOfBuilder)? updates]) =>
      (RegisterInputAnyOfBuilder()..update(updates))._build();

  _$RegisterInputAnyOf._(
      {required this.type,
      required this.fullName,
      this.email,
      this.phone,
      required this.password})
      : super._();
  @override
  RegisterInputAnyOf rebuild(
          void Function(RegisterInputAnyOfBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterInputAnyOfBuilder toBuilder() =>
      RegisterInputAnyOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterInputAnyOf &&
        type == other.type &&
        fullName == other.fullName &&
        email == other.email &&
        phone == other.phone &&
        password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterInputAnyOf')
          ..add('type', type)
          ..add('fullName', fullName)
          ..add('email', email)
          ..add('phone', phone)
          ..add('password', password))
        .toString();
  }
}

class RegisterInputAnyOfBuilder
    implements Builder<RegisterInputAnyOf, RegisterInputAnyOfBuilder> {
  _$RegisterInputAnyOf? _$v;

  RegisterInputAnyOfTypeEnum? _type;
  RegisterInputAnyOfTypeEnum? get type => _$this._type;
  set type(RegisterInputAnyOfTypeEnum? type) => _$this._type = type;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  RegisterInputAnyOfBuilder() {
    RegisterInputAnyOf._defaults(this);
  }

  RegisterInputAnyOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _fullName = $v.fullName;
      _email = $v.email;
      _phone = $v.phone;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterInputAnyOf other) {
    _$v = other as _$RegisterInputAnyOf;
  }

  @override
  void update(void Function(RegisterInputAnyOfBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterInputAnyOf build() => _build();

  _$RegisterInputAnyOf _build() {
    final _$result = _$v ??
        _$RegisterInputAnyOf._(
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'RegisterInputAnyOf', 'type'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'RegisterInputAnyOf', 'fullName'),
          email: email,
          phone: phone,
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'RegisterInputAnyOf', 'password'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
