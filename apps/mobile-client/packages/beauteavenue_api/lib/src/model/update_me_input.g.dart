// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_me_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UpdateMeInputPreferredContactChannelEnum
    _$updateMeInputPreferredContactChannelEnum_phone =
    const UpdateMeInputPreferredContactChannelEnum._('phone');
const UpdateMeInputPreferredContactChannelEnum
    _$updateMeInputPreferredContactChannelEnum_sms =
    const UpdateMeInputPreferredContactChannelEnum._('sms');

UpdateMeInputPreferredContactChannelEnum
    _$updateMeInputPreferredContactChannelEnumValueOf(String name) {
  switch (name) {
    case 'phone':
      return _$updateMeInputPreferredContactChannelEnum_phone;
    case 'sms':
      return _$updateMeInputPreferredContactChannelEnum_sms;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UpdateMeInputPreferredContactChannelEnum>
    _$updateMeInputPreferredContactChannelEnumValues = BuiltSet<
        UpdateMeInputPreferredContactChannelEnum>(const <UpdateMeInputPreferredContactChannelEnum>[
  _$updateMeInputPreferredContactChannelEnum_phone,
  _$updateMeInputPreferredContactChannelEnum_sms,
]);

const UpdateMeInputPreferredLanguageEnum
    _$updateMeInputPreferredLanguageEnum_fr =
    const UpdateMeInputPreferredLanguageEnum._('fr');
const UpdateMeInputPreferredLanguageEnum
    _$updateMeInputPreferredLanguageEnum_en =
    const UpdateMeInputPreferredLanguageEnum._('en');

UpdateMeInputPreferredLanguageEnum _$updateMeInputPreferredLanguageEnumValueOf(
    String name) {
  switch (name) {
    case 'fr':
      return _$updateMeInputPreferredLanguageEnum_fr;
    case 'en':
      return _$updateMeInputPreferredLanguageEnum_en;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UpdateMeInputPreferredLanguageEnum>
    _$updateMeInputPreferredLanguageEnumValues = BuiltSet<
        UpdateMeInputPreferredLanguageEnum>(const <UpdateMeInputPreferredLanguageEnum>[
  _$updateMeInputPreferredLanguageEnum_fr,
  _$updateMeInputPreferredLanguageEnum_en,
]);

Serializer<UpdateMeInputPreferredContactChannelEnum>
    _$updateMeInputPreferredContactChannelEnumSerializer =
    _$UpdateMeInputPreferredContactChannelEnumSerializer();
Serializer<UpdateMeInputPreferredLanguageEnum>
    _$updateMeInputPreferredLanguageEnumSerializer =
    _$UpdateMeInputPreferredLanguageEnumSerializer();

class _$UpdateMeInputPreferredContactChannelEnumSerializer
    implements PrimitiveSerializer<UpdateMeInputPreferredContactChannelEnum> {
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
    UpdateMeInputPreferredContactChannelEnum
  ];
  @override
  final String wireName = 'UpdateMeInputPreferredContactChannelEnum';

  @override
  Object serialize(Serializers serializers,
          UpdateMeInputPreferredContactChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateMeInputPreferredContactChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateMeInputPreferredContactChannelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateMeInputPreferredLanguageEnumSerializer
    implements PrimitiveSerializer<UpdateMeInputPreferredLanguageEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'fr': 'fr',
    'en': 'en',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'fr': 'fr',
    'en': 'en',
  };

  @override
  final Iterable<Type> types = const <Type>[UpdateMeInputPreferredLanguageEnum];
  @override
  final String wireName = 'UpdateMeInputPreferredLanguageEnum';

  @override
  Object serialize(
          Serializers serializers, UpdateMeInputPreferredLanguageEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UpdateMeInputPreferredLanguageEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UpdateMeInputPreferredLanguageEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UpdateMeInput extends UpdateMeInput {
  @override
  final String? fullName;
  @override
  final String? city;
  @override
  final String? avatarMediaId;
  @override
  final UpdateMeInputPreferredContactChannelEnum? preferredContactChannel;
  @override
  final bool? pushOptIn;
  @override
  final bool? marketingOptIn;
  @override
  final UpdateMeInputPreferredLanguageEnum? preferredLanguage;
  @override
  final String? currentPassword;
  @override
  final String? newPassword;

  factory _$UpdateMeInput([void Function(UpdateMeInputBuilder)? updates]) =>
      (UpdateMeInputBuilder()..update(updates))._build();

  _$UpdateMeInput._(
      {this.fullName,
      this.city,
      this.avatarMediaId,
      this.preferredContactChannel,
      this.pushOptIn,
      this.marketingOptIn,
      this.preferredLanguage,
      this.currentPassword,
      this.newPassword})
      : super._();
  @override
  UpdateMeInput rebuild(void Function(UpdateMeInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateMeInputBuilder toBuilder() => UpdateMeInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateMeInput &&
        fullName == other.fullName &&
        city == other.city &&
        avatarMediaId == other.avatarMediaId &&
        preferredContactChannel == other.preferredContactChannel &&
        pushOptIn == other.pushOptIn &&
        marketingOptIn == other.marketingOptIn &&
        preferredLanguage == other.preferredLanguage &&
        currentPassword == other.currentPassword &&
        newPassword == other.newPassword;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, avatarMediaId.hashCode);
    _$hash = $jc(_$hash, preferredContactChannel.hashCode);
    _$hash = $jc(_$hash, pushOptIn.hashCode);
    _$hash = $jc(_$hash, marketingOptIn.hashCode);
    _$hash = $jc(_$hash, preferredLanguage.hashCode);
    _$hash = $jc(_$hash, currentPassword.hashCode);
    _$hash = $jc(_$hash, newPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateMeInput')
          ..add('fullName', fullName)
          ..add('city', city)
          ..add('avatarMediaId', avatarMediaId)
          ..add('preferredContactChannel', preferredContactChannel)
          ..add('pushOptIn', pushOptIn)
          ..add('marketingOptIn', marketingOptIn)
          ..add('preferredLanguage', preferredLanguage)
          ..add('currentPassword', currentPassword)
          ..add('newPassword', newPassword))
        .toString();
  }
}

class UpdateMeInputBuilder
    implements Builder<UpdateMeInput, UpdateMeInputBuilder> {
  _$UpdateMeInput? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _avatarMediaId;
  String? get avatarMediaId => _$this._avatarMediaId;
  set avatarMediaId(String? avatarMediaId) =>
      _$this._avatarMediaId = avatarMediaId;

  UpdateMeInputPreferredContactChannelEnum? _preferredContactChannel;
  UpdateMeInputPreferredContactChannelEnum? get preferredContactChannel =>
      _$this._preferredContactChannel;
  set preferredContactChannel(
          UpdateMeInputPreferredContactChannelEnum? preferredContactChannel) =>
      _$this._preferredContactChannel = preferredContactChannel;

  bool? _pushOptIn;
  bool? get pushOptIn => _$this._pushOptIn;
  set pushOptIn(bool? pushOptIn) => _$this._pushOptIn = pushOptIn;

  bool? _marketingOptIn;
  bool? get marketingOptIn => _$this._marketingOptIn;
  set marketingOptIn(bool? marketingOptIn) =>
      _$this._marketingOptIn = marketingOptIn;

  UpdateMeInputPreferredLanguageEnum? _preferredLanguage;
  UpdateMeInputPreferredLanguageEnum? get preferredLanguage =>
      _$this._preferredLanguage;
  set preferredLanguage(
          UpdateMeInputPreferredLanguageEnum? preferredLanguage) =>
      _$this._preferredLanguage = preferredLanguage;

  String? _currentPassword;
  String? get currentPassword => _$this._currentPassword;
  set currentPassword(String? currentPassword) =>
      _$this._currentPassword = currentPassword;

  String? _newPassword;
  String? get newPassword => _$this._newPassword;
  set newPassword(String? newPassword) => _$this._newPassword = newPassword;

  UpdateMeInputBuilder() {
    UpdateMeInput._defaults(this);
  }

  UpdateMeInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _city = $v.city;
      _avatarMediaId = $v.avatarMediaId;
      _preferredContactChannel = $v.preferredContactChannel;
      _pushOptIn = $v.pushOptIn;
      _marketingOptIn = $v.marketingOptIn;
      _preferredLanguage = $v.preferredLanguage;
      _currentPassword = $v.currentPassword;
      _newPassword = $v.newPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateMeInput other) {
    _$v = other as _$UpdateMeInput;
  }

  @override
  void update(void Function(UpdateMeInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateMeInput build() => _build();

  _$UpdateMeInput _build() {
    final _$result = _$v ??
        _$UpdateMeInput._(
          fullName: fullName,
          city: city,
          avatarMediaId: avatarMediaId,
          preferredContactChannel: preferredContactChannel,
          pushOptIn: pushOptIn,
          marketingOptIn: marketingOptIn,
          preferredLanguage: preferredLanguage,
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
