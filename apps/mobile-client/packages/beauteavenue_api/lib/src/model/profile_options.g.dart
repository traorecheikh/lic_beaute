// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_options.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProfileOptionsLanguagesEnum _$profileOptionsLanguagesEnum_fr =
    const ProfileOptionsLanguagesEnum._('fr');
const ProfileOptionsLanguagesEnum _$profileOptionsLanguagesEnum_en =
    const ProfileOptionsLanguagesEnum._('en');

ProfileOptionsLanguagesEnum _$profileOptionsLanguagesEnumValueOf(String name) {
  switch (name) {
    case 'fr':
      return _$profileOptionsLanguagesEnum_fr;
    case 'en':
      return _$profileOptionsLanguagesEnum_en;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProfileOptionsLanguagesEnum>
    _$profileOptionsLanguagesEnumValues =
    BuiltSet<ProfileOptionsLanguagesEnum>(const <ProfileOptionsLanguagesEnum>[
  _$profileOptionsLanguagesEnum_fr,
  _$profileOptionsLanguagesEnum_en,
]);

const ProfileOptionsContactChannelsEnum
    _$profileOptionsContactChannelsEnum_phone =
    const ProfileOptionsContactChannelsEnum._('phone');
const ProfileOptionsContactChannelsEnum
    _$profileOptionsContactChannelsEnum_sms =
    const ProfileOptionsContactChannelsEnum._('sms');

ProfileOptionsContactChannelsEnum _$profileOptionsContactChannelsEnumValueOf(
    String name) {
  switch (name) {
    case 'phone':
      return _$profileOptionsContactChannelsEnum_phone;
    case 'sms':
      return _$profileOptionsContactChannelsEnum_sms;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProfileOptionsContactChannelsEnum>
    _$profileOptionsContactChannelsEnumValues = BuiltSet<
        ProfileOptionsContactChannelsEnum>(const <ProfileOptionsContactChannelsEnum>[
  _$profileOptionsContactChannelsEnum_phone,
  _$profileOptionsContactChannelsEnum_sms,
]);

const ProfileOptionsPaymentProvidersEnum
    _$profileOptionsPaymentProvidersEnum_intech =
    const ProfileOptionsPaymentProvidersEnum._('intech');

ProfileOptionsPaymentProvidersEnum _$profileOptionsPaymentProvidersEnumValueOf(
    String name) {
  switch (name) {
    case 'intech':
      return _$profileOptionsPaymentProvidersEnum_intech;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProfileOptionsPaymentProvidersEnum>
    _$profileOptionsPaymentProvidersEnumValues = BuiltSet<
        ProfileOptionsPaymentProvidersEnum>(const <ProfileOptionsPaymentProvidersEnum>[
  _$profileOptionsPaymentProvidersEnum_intech,
]);

Serializer<ProfileOptionsLanguagesEnum>
    _$profileOptionsLanguagesEnumSerializer =
    _$ProfileOptionsLanguagesEnumSerializer();
Serializer<ProfileOptionsContactChannelsEnum>
    _$profileOptionsContactChannelsEnumSerializer =
    _$ProfileOptionsContactChannelsEnumSerializer();
Serializer<ProfileOptionsPaymentProvidersEnum>
    _$profileOptionsPaymentProvidersEnumSerializer =
    _$ProfileOptionsPaymentProvidersEnumSerializer();

class _$ProfileOptionsLanguagesEnumSerializer
    implements PrimitiveSerializer<ProfileOptionsLanguagesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'fr': 'fr',
    'en': 'en',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'fr': 'fr',
    'en': 'en',
  };

  @override
  final Iterable<Type> types = const <Type>[ProfileOptionsLanguagesEnum];
  @override
  final String wireName = 'ProfileOptionsLanguagesEnum';

  @override
  Object serialize(Serializers serializers, ProfileOptionsLanguagesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProfileOptionsLanguagesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProfileOptionsLanguagesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProfileOptionsContactChannelsEnumSerializer
    implements PrimitiveSerializer<ProfileOptionsContactChannelsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'phone': 'phone',
    'sms': 'sms',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'phone': 'phone',
    'sms': 'sms',
  };

  @override
  final Iterable<Type> types = const <Type>[ProfileOptionsContactChannelsEnum];
  @override
  final String wireName = 'ProfileOptionsContactChannelsEnum';

  @override
  Object serialize(
          Serializers serializers, ProfileOptionsContactChannelsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProfileOptionsContactChannelsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProfileOptionsContactChannelsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProfileOptionsPaymentProvidersEnumSerializer
    implements PrimitiveSerializer<ProfileOptionsPaymentProvidersEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'intech': 'intech',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'intech': 'intech',
  };

  @override
  final Iterable<Type> types = const <Type>[ProfileOptionsPaymentProvidersEnum];
  @override
  final String wireName = 'ProfileOptionsPaymentProvidersEnum';

  @override
  Object serialize(
          Serializers serializers, ProfileOptionsPaymentProvidersEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProfileOptionsPaymentProvidersEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProfileOptionsPaymentProvidersEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProfileOptions extends ProfileOptions {
  @override
  final BuiltList<String> cities;
  @override
  final BuiltList<ProfileOptionsLanguagesEnum> languages;
  @override
  final BuiltList<ProfileOptionsContactChannelsEnum> contactChannels;
  @override
  final BuiltList<ProfileOptionsPaymentProvidersEnum> paymentProviders;

  factory _$ProfileOptions([void Function(ProfileOptionsBuilder)? updates]) =>
      (ProfileOptionsBuilder()..update(updates))._build();

  _$ProfileOptions._(
      {required this.cities,
      required this.languages,
      required this.contactChannels,
      required this.paymentProviders})
      : super._();
  @override
  ProfileOptions rebuild(void Function(ProfileOptionsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProfileOptionsBuilder toBuilder() => ProfileOptionsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProfileOptions &&
        cities == other.cities &&
        languages == other.languages &&
        contactChannels == other.contactChannels &&
        paymentProviders == other.paymentProviders;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cities.hashCode);
    _$hash = $jc(_$hash, languages.hashCode);
    _$hash = $jc(_$hash, contactChannels.hashCode);
    _$hash = $jc(_$hash, paymentProviders.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProfileOptions')
          ..add('cities', cities)
          ..add('languages', languages)
          ..add('contactChannels', contactChannels)
          ..add('paymentProviders', paymentProviders))
        .toString();
  }
}

class ProfileOptionsBuilder
    implements Builder<ProfileOptions, ProfileOptionsBuilder> {
  _$ProfileOptions? _$v;

  ListBuilder<String>? _cities;
  ListBuilder<String> get cities => _$this._cities ??= ListBuilder<String>();
  set cities(ListBuilder<String>? cities) => _$this._cities = cities;

  ListBuilder<ProfileOptionsLanguagesEnum>? _languages;
  ListBuilder<ProfileOptionsLanguagesEnum> get languages =>
      _$this._languages ??= ListBuilder<ProfileOptionsLanguagesEnum>();
  set languages(ListBuilder<ProfileOptionsLanguagesEnum>? languages) =>
      _$this._languages = languages;

  ListBuilder<ProfileOptionsContactChannelsEnum>? _contactChannels;
  ListBuilder<ProfileOptionsContactChannelsEnum> get contactChannels =>
      _$this._contactChannels ??=
          ListBuilder<ProfileOptionsContactChannelsEnum>();
  set contactChannels(
          ListBuilder<ProfileOptionsContactChannelsEnum>? contactChannels) =>
      _$this._contactChannels = contactChannels;

  ListBuilder<ProfileOptionsPaymentProvidersEnum>? _paymentProviders;
  ListBuilder<ProfileOptionsPaymentProvidersEnum> get paymentProviders =>
      _$this._paymentProviders ??=
          ListBuilder<ProfileOptionsPaymentProvidersEnum>();
  set paymentProviders(
          ListBuilder<ProfileOptionsPaymentProvidersEnum>? paymentProviders) =>
      _$this._paymentProviders = paymentProviders;

  ProfileOptionsBuilder() {
    ProfileOptions._defaults(this);
  }

  ProfileOptionsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cities = $v.cities.toBuilder();
      _languages = $v.languages.toBuilder();
      _contactChannels = $v.contactChannels.toBuilder();
      _paymentProviders = $v.paymentProviders.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProfileOptions other) {
    _$v = other as _$ProfileOptions;
  }

  @override
  void update(void Function(ProfileOptionsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProfileOptions build() => _build();

  _$ProfileOptions _build() {
    _$ProfileOptions _$result;
    try {
      _$result = _$v ??
          _$ProfileOptions._(
            cities: cities.build(),
            languages: languages.build(),
            contactChannels: contactChannels.build(),
            paymentProviders: paymentProviders.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'cities';
        cities.build();
        _$failedField = 'languages';
        languages.build();
        _$failedField = 'contactChannels';
        contactChannels.build();
        _$failedField = 'paymentProviders';
        paymentProviders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProfileOptions', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
