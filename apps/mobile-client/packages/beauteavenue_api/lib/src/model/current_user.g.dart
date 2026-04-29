// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CurrentUserRoleEnum _$currentUserRoleEnum_client =
    const CurrentUserRoleEnum._('client');
const CurrentUserRoleEnum _$currentUserRoleEnum_salonStaff =
    const CurrentUserRoleEnum._('salonStaff');
const CurrentUserRoleEnum _$currentUserRoleEnum_salonOwner =
    const CurrentUserRoleEnum._('salonOwner');
const CurrentUserRoleEnum _$currentUserRoleEnum_platformAdmin =
    const CurrentUserRoleEnum._('platformAdmin');

CurrentUserRoleEnum _$currentUserRoleEnumValueOf(String name) {
  switch (name) {
    case 'client':
      return _$currentUserRoleEnum_client;
    case 'salonStaff':
      return _$currentUserRoleEnum_salonStaff;
    case 'salonOwner':
      return _$currentUserRoleEnum_salonOwner;
    case 'platformAdmin':
      return _$currentUserRoleEnum_platformAdmin;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CurrentUserRoleEnum> _$currentUserRoleEnumValues =
    BuiltSet<CurrentUserRoleEnum>(const <CurrentUserRoleEnum>[
  _$currentUserRoleEnum_client,
  _$currentUserRoleEnum_salonStaff,
  _$currentUserRoleEnum_salonOwner,
  _$currentUserRoleEnum_platformAdmin,
]);

Serializer<CurrentUserRoleEnum> _$currentUserRoleEnumSerializer =
    _$CurrentUserRoleEnumSerializer();

class _$CurrentUserRoleEnumSerializer
    implements PrimitiveSerializer<CurrentUserRoleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'client': 'client',
    'salonStaff': 'salon_staff',
    'salonOwner': 'salon_owner',
    'platformAdmin': 'platform_admin',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'client': 'client',
    'salon_staff': 'salonStaff',
    'salon_owner': 'salonOwner',
    'platform_admin': 'platformAdmin',
  };

  @override
  final Iterable<Type> types = const <Type>[CurrentUserRoleEnum];
  @override
  final String wireName = 'CurrentUserRoleEnum';

  @override
  Object serialize(Serializers serializers, CurrentUserRoleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CurrentUserRoleEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CurrentUserRoleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CurrentUser extends CurrentUser {
  @override
  final String id;
  @override
  final String fullName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final CurrentUserRoleEnum role;
  @override
  final String? salonId;

  factory _$CurrentUser([void Function(CurrentUserBuilder)? updates]) =>
      (CurrentUserBuilder()..update(updates))._build();

  _$CurrentUser._(
      {required this.id,
      required this.fullName,
      this.email,
      this.phone,
      required this.role,
      this.salonId})
      : super._();
  @override
  CurrentUser rebuild(void Function(CurrentUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CurrentUserBuilder toBuilder() => CurrentUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CurrentUser &&
        id == other.id &&
        fullName == other.fullName &&
        email == other.email &&
        phone == other.phone &&
        role == other.role &&
        salonId == other.salonId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CurrentUser')
          ..add('id', id)
          ..add('fullName', fullName)
          ..add('email', email)
          ..add('phone', phone)
          ..add('role', role)
          ..add('salonId', salonId))
        .toString();
  }
}

class CurrentUserBuilder implements Builder<CurrentUser, CurrentUserBuilder> {
  _$CurrentUser? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  CurrentUserRoleEnum? _role;
  CurrentUserRoleEnum? get role => _$this._role;
  set role(CurrentUserRoleEnum? role) => _$this._role = role;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  CurrentUserBuilder() {
    CurrentUser._defaults(this);
  }

  CurrentUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _fullName = $v.fullName;
      _email = $v.email;
      _phone = $v.phone;
      _role = $v.role;
      _salonId = $v.salonId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CurrentUser other) {
    _$v = other as _$CurrentUser;
  }

  @override
  void update(void Function(CurrentUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CurrentUser build() => _build();

  _$CurrentUser _build() {
    final _$result = _$v ??
        _$CurrentUser._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'CurrentUser', 'id'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'CurrentUser', 'fullName'),
          email: email,
          phone: phone,
          role: BuiltValueNullFieldError.checkNotNull(
              role, r'CurrentUser', 'role'),
          salonId: salonId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
