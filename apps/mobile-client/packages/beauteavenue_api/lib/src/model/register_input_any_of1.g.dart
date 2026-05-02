// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_input_any_of1.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RegisterInputAnyOf1TypeEnum _$registerInputAnyOf1TypeEnum_salonOwner =
    const RegisterInputAnyOf1TypeEnum._('salonOwner');

RegisterInputAnyOf1TypeEnum _$registerInputAnyOf1TypeEnumValueOf(String name) {
  switch (name) {
    case 'salonOwner':
      return _$registerInputAnyOf1TypeEnum_salonOwner;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RegisterInputAnyOf1TypeEnum>
    _$registerInputAnyOf1TypeEnumValues =
    BuiltSet<RegisterInputAnyOf1TypeEnum>(const <RegisterInputAnyOf1TypeEnum>[
  _$registerInputAnyOf1TypeEnum_salonOwner,
]);

Serializer<RegisterInputAnyOf1TypeEnum>
    _$registerInputAnyOf1TypeEnumSerializer =
    _$RegisterInputAnyOf1TypeEnumSerializer();

class _$RegisterInputAnyOf1TypeEnumSerializer
    implements PrimitiveSerializer<RegisterInputAnyOf1TypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'salonOwner': 'salon_owner',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'salon_owner': 'salonOwner',
  };

  @override
  final Iterable<Type> types = const <Type>[RegisterInputAnyOf1TypeEnum];
  @override
  final String wireName = 'RegisterInputAnyOf1TypeEnum';

  @override
  Object serialize(Serializers serializers, RegisterInputAnyOf1TypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RegisterInputAnyOf1TypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RegisterInputAnyOf1TypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RegisterInputAnyOf1 extends RegisterInputAnyOf1 {
  @override
  final RegisterInputAnyOf1TypeEnum type;
  @override
  final String fullName;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String password;
  @override
  final RegisterInputAnyOf1Salon salon;
  @override
  final BuiltList<RegisterInputAnyOf1ServicesInner> services;
  @override
  final BuiltList<RegisterInputAnyOf1HoursInner> hours;

  factory _$RegisterInputAnyOf1(
          [void Function(RegisterInputAnyOf1Builder)? updates]) =>
      (RegisterInputAnyOf1Builder()..update(updates))._build();

  _$RegisterInputAnyOf1._(
      {required this.type,
      required this.fullName,
      required this.email,
      required this.phone,
      required this.password,
      required this.salon,
      required this.services,
      required this.hours})
      : super._();
  @override
  RegisterInputAnyOf1 rebuild(
          void Function(RegisterInputAnyOf1Builder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterInputAnyOf1Builder toBuilder() =>
      RegisterInputAnyOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterInputAnyOf1 &&
        type == other.type &&
        fullName == other.fullName &&
        email == other.email &&
        phone == other.phone &&
        password == other.password &&
        salon == other.salon &&
        services == other.services &&
        hours == other.hours;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, salon.hashCode);
    _$hash = $jc(_$hash, services.hashCode);
    _$hash = $jc(_$hash, hours.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterInputAnyOf1')
          ..add('type', type)
          ..add('fullName', fullName)
          ..add('email', email)
          ..add('phone', phone)
          ..add('password', password)
          ..add('salon', salon)
          ..add('services', services)
          ..add('hours', hours))
        .toString();
  }
}

class RegisterInputAnyOf1Builder
    implements Builder<RegisterInputAnyOf1, RegisterInputAnyOf1Builder> {
  _$RegisterInputAnyOf1? _$v;

  RegisterInputAnyOf1TypeEnum? _type;
  RegisterInputAnyOf1TypeEnum? get type => _$this._type;
  set type(RegisterInputAnyOf1TypeEnum? type) => _$this._type = type;

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

  RegisterInputAnyOf1SalonBuilder? _salon;
  RegisterInputAnyOf1SalonBuilder get salon =>
      _$this._salon ??= RegisterInputAnyOf1SalonBuilder();
  set salon(RegisterInputAnyOf1SalonBuilder? salon) => _$this._salon = salon;

  ListBuilder<RegisterInputAnyOf1ServicesInner>? _services;
  ListBuilder<RegisterInputAnyOf1ServicesInner> get services =>
      _$this._services ??= ListBuilder<RegisterInputAnyOf1ServicesInner>();
  set services(ListBuilder<RegisterInputAnyOf1ServicesInner>? services) =>
      _$this._services = services;

  ListBuilder<RegisterInputAnyOf1HoursInner>? _hours;
  ListBuilder<RegisterInputAnyOf1HoursInner> get hours =>
      _$this._hours ??= ListBuilder<RegisterInputAnyOf1HoursInner>();
  set hours(ListBuilder<RegisterInputAnyOf1HoursInner>? hours) =>
      _$this._hours = hours;

  RegisterInputAnyOf1Builder() {
    RegisterInputAnyOf1._defaults(this);
  }

  RegisterInputAnyOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _fullName = $v.fullName;
      _email = $v.email;
      _phone = $v.phone;
      _password = $v.password;
      _salon = $v.salon.toBuilder();
      _services = $v.services.toBuilder();
      _hours = $v.hours.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterInputAnyOf1 other) {
    _$v = other as _$RegisterInputAnyOf1;
  }

  @override
  void update(void Function(RegisterInputAnyOf1Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterInputAnyOf1 build() => _build();

  _$RegisterInputAnyOf1 _build() {
    _$RegisterInputAnyOf1 _$result;
    try {
      _$result = _$v ??
          _$RegisterInputAnyOf1._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'RegisterInputAnyOf1', 'type'),
            fullName: BuiltValueNullFieldError.checkNotNull(
                fullName, r'RegisterInputAnyOf1', 'fullName'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'RegisterInputAnyOf1', 'email'),
            phone: BuiltValueNullFieldError.checkNotNull(
                phone, r'RegisterInputAnyOf1', 'phone'),
            password: BuiltValueNullFieldError.checkNotNull(
                password, r'RegisterInputAnyOf1', 'password'),
            salon: salon.build(),
            services: services.build(),
            hours: hours.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'salon';
        salon.build();
        _$failedField = 'services';
        services.build();
        _$failedField = 'hours';
        hours.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RegisterInputAnyOf1', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
