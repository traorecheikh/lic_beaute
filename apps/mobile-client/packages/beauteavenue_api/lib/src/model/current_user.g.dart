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

const CurrentUserPreferredContactChannelEnum
    _$currentUserPreferredContactChannelEnum_phone =
    const CurrentUserPreferredContactChannelEnum._('phone');
const CurrentUserPreferredContactChannelEnum
    _$currentUserPreferredContactChannelEnum_sms =
    const CurrentUserPreferredContactChannelEnum._('sms');

CurrentUserPreferredContactChannelEnum
    _$currentUserPreferredContactChannelEnumValueOf(String name) {
  switch (name) {
    case 'phone':
      return _$currentUserPreferredContactChannelEnum_phone;
    case 'sms':
      return _$currentUserPreferredContactChannelEnum_sms;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CurrentUserPreferredContactChannelEnum>
    _$currentUserPreferredContactChannelEnumValues = BuiltSet<
        CurrentUserPreferredContactChannelEnum>(const <CurrentUserPreferredContactChannelEnum>[
  _$currentUserPreferredContactChannelEnum_phone,
  _$currentUserPreferredContactChannelEnum_sms,
]);

const CurrentUserPreferredLanguageEnum _$currentUserPreferredLanguageEnum_fr =
    const CurrentUserPreferredLanguageEnum._('fr');
const CurrentUserPreferredLanguageEnum _$currentUserPreferredLanguageEnum_en =
    const CurrentUserPreferredLanguageEnum._('en');

CurrentUserPreferredLanguageEnum _$currentUserPreferredLanguageEnumValueOf(
    String name) {
  switch (name) {
    case 'fr':
      return _$currentUserPreferredLanguageEnum_fr;
    case 'en':
      return _$currentUserPreferredLanguageEnum_en;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CurrentUserPreferredLanguageEnum>
    _$currentUserPreferredLanguageEnumValues = BuiltSet<
        CurrentUserPreferredLanguageEnum>(const <CurrentUserPreferredLanguageEnum>[
  _$currentUserPreferredLanguageEnum_fr,
  _$currentUserPreferredLanguageEnum_en,
]);

Serializer<CurrentUserRoleEnum> _$currentUserRoleEnumSerializer =
    _$CurrentUserRoleEnumSerializer();
Serializer<CurrentUserPreferredContactChannelEnum>
    _$currentUserPreferredContactChannelEnumSerializer =
    _$CurrentUserPreferredContactChannelEnumSerializer();
Serializer<CurrentUserPreferredLanguageEnum>
    _$currentUserPreferredLanguageEnumSerializer =
    _$CurrentUserPreferredLanguageEnumSerializer();

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

class _$CurrentUserPreferredContactChannelEnumSerializer
    implements PrimitiveSerializer<CurrentUserPreferredContactChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'phone': 'phone',
    'sms': 'sms',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'phone': 'phone',
    'sms': 'sms',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CurrentUserPreferredContactChannelEnum
  ];
  @override
  final String wireName = 'CurrentUserPreferredContactChannelEnum';

  @override
  Object serialize(Serializers serializers,
          CurrentUserPreferredContactChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CurrentUserPreferredContactChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CurrentUserPreferredContactChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CurrentUserPreferredLanguageEnumSerializer
    implements PrimitiveSerializer<CurrentUserPreferredLanguageEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'fr': 'fr',
    'en': 'en',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'fr': 'fr',
    'en': 'en',
  };

  @override
  final Iterable<Type> types = const <Type>[CurrentUserPreferredLanguageEnum];
  @override
  final String wireName = 'CurrentUserPreferredLanguageEnum';

  @override
  Object serialize(
          Serializers serializers, CurrentUserPreferredLanguageEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CurrentUserPreferredLanguageEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CurrentUserPreferredLanguageEnum.valueOf(
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
  @override
  final String? city;
  @override
  final String? avatarUrl;
  @override
  final CurrentUserPreferredContactChannelEnum preferredContactChannel;
  @override
  final bool pushOptIn;
  @override
  final bool marketingOptIn;
  @override
  final CurrentUserPreferredLanguageEnum preferredLanguage;

  factory _$CurrentUser([void Function(CurrentUserBuilder)? updates]) =>
      (CurrentUserBuilder()..update(updates))._build();

  _$CurrentUser._(
      {required this.id,
      required this.fullName,
      this.email,
      this.phone,
      required this.role,
      this.salonId,
      this.city,
      this.avatarUrl,
      required this.preferredContactChannel,
      required this.pushOptIn,
      required this.marketingOptIn,
      required this.preferredLanguage})
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
        salonId == other.salonId &&
        city == other.city &&
        avatarUrl == other.avatarUrl &&
        preferredContactChannel == other.preferredContactChannel &&
        pushOptIn == other.pushOptIn &&
        marketingOptIn == other.marketingOptIn &&
        preferredLanguage == other.preferredLanguage;
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
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jc(_$hash, preferredContactChannel.hashCode);
    _$hash = $jc(_$hash, pushOptIn.hashCode);
    _$hash = $jc(_$hash, marketingOptIn.hashCode);
    _$hash = $jc(_$hash, preferredLanguage.hashCode);
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
          ..add('salonId', salonId)
          ..add('city', city)
          ..add('avatarUrl', avatarUrl)
          ..add('preferredContactChannel', preferredContactChannel)
          ..add('pushOptIn', pushOptIn)
          ..add('marketingOptIn', marketingOptIn)
          ..add('preferredLanguage', preferredLanguage))
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

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _avatarUrl;
  String? get avatarUrl => _$this._avatarUrl;
  set avatarUrl(String? avatarUrl) => _$this._avatarUrl = avatarUrl;

  CurrentUserPreferredContactChannelEnum? _preferredContactChannel;
  CurrentUserPreferredContactChannelEnum? get preferredContactChannel =>
      _$this._preferredContactChannel;
  set preferredContactChannel(
          CurrentUserPreferredContactChannelEnum? preferredContactChannel) =>
      _$this._preferredContactChannel = preferredContactChannel;

  bool? _pushOptIn;
  bool? get pushOptIn => _$this._pushOptIn;
  set pushOptIn(bool? pushOptIn) => _$this._pushOptIn = pushOptIn;

  bool? _marketingOptIn;
  bool? get marketingOptIn => _$this._marketingOptIn;
  set marketingOptIn(bool? marketingOptIn) =>
      _$this._marketingOptIn = marketingOptIn;

  CurrentUserPreferredLanguageEnum? _preferredLanguage;
  CurrentUserPreferredLanguageEnum? get preferredLanguage =>
      _$this._preferredLanguage;
  set preferredLanguage(CurrentUserPreferredLanguageEnum? preferredLanguage) =>
      _$this._preferredLanguage = preferredLanguage;

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
      _city = $v.city;
      _avatarUrl = $v.avatarUrl;
      _preferredContactChannel = $v.preferredContactChannel;
      _pushOptIn = $v.pushOptIn;
      _marketingOptIn = $v.marketingOptIn;
      _preferredLanguage = $v.preferredLanguage;
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
          city: city,
          avatarUrl: avatarUrl,
          preferredContactChannel: BuiltValueNullFieldError.checkNotNull(
              preferredContactChannel,
              r'CurrentUser',
              'preferredContactChannel'),
          pushOptIn: BuiltValueNullFieldError.checkNotNull(
              pushOptIn, r'CurrentUser', 'pushOptIn'),
          marketingOptIn: BuiltValueNullFieldError.checkNotNull(
              marketingOptIn, r'CurrentUser', 'marketingOptIn'),
          preferredLanguage: BuiltValueNullFieldError.checkNotNull(
              preferredLanguage, r'CurrentUser', 'preferredLanguage'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
