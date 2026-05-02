// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_salon_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProSalonProfileSubscriptionTierEnum
    _$proSalonProfileSubscriptionTierEnum_standard =
    const ProSalonProfileSubscriptionTierEnum._('standard');
const ProSalonProfileSubscriptionTierEnum
    _$proSalonProfileSubscriptionTierEnum_premium =
    const ProSalonProfileSubscriptionTierEnum._('premium');

ProSalonProfileSubscriptionTierEnum
    _$proSalonProfileSubscriptionTierEnumValueOf(String name) {
  switch (name) {
    case 'standard':
      return _$proSalonProfileSubscriptionTierEnum_standard;
    case 'premium':
      return _$proSalonProfileSubscriptionTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProSalonProfileSubscriptionTierEnum>
    _$proSalonProfileSubscriptionTierEnumValues = BuiltSet<
        ProSalonProfileSubscriptionTierEnum>(const <ProSalonProfileSubscriptionTierEnum>[
  _$proSalonProfileSubscriptionTierEnum_standard,
  _$proSalonProfileSubscriptionTierEnum_premium,
]);

Serializer<ProSalonProfileSubscriptionTierEnum>
    _$proSalonProfileSubscriptionTierEnumSerializer =
    _$ProSalonProfileSubscriptionTierEnumSerializer();

class _$ProSalonProfileSubscriptionTierEnumSerializer
    implements PrimitiveSerializer<ProSalonProfileSubscriptionTierEnum> {
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
    ProSalonProfileSubscriptionTierEnum
  ];
  @override
  final String wireName = 'ProSalonProfileSubscriptionTierEnum';

  @override
  Object serialize(
          Serializers serializers, ProSalonProfileSubscriptionTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProSalonProfileSubscriptionTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProSalonProfileSubscriptionTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProSalonProfile extends ProSalonProfile {
  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final String? logoUrl;
  @override
  final String description;
  @override
  final String city;
  @override
  final String address;
  @override
  final String? neighborhood;
  @override
  final num? latitude;
  @override
  final num? longitude;
  @override
  final String? phone;
  @override
  final String? instagram;
  @override
  final num averageRating;
  @override
  final ProSalonProfileSubscriptionTierEnum subscriptionTier;
  @override
  final bool isVisibleInMarketplace;
  @override
  final bool canReceiveBookings;
  @override
  final SalonDetailTeamDisplay teamDisplay;
  @override
  final BuiltList<String> gallery;
  @override
  final BuiltList<ProSalonProfileHoursInner> hours;

  factory _$ProSalonProfile([void Function(ProSalonProfileBuilder)? updates]) =>
      (ProSalonProfileBuilder()..update(updates))._build();

  _$ProSalonProfile._(
      {required this.id,
      required this.name,
      required this.category,
      this.logoUrl,
      required this.description,
      required this.city,
      required this.address,
      this.neighborhood,
      this.latitude,
      this.longitude,
      this.phone,
      this.instagram,
      required this.averageRating,
      required this.subscriptionTier,
      required this.isVisibleInMarketplace,
      required this.canReceiveBookings,
      required this.teamDisplay,
      required this.gallery,
      required this.hours})
      : super._();
  @override
  ProSalonProfile rebuild(void Function(ProSalonProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProSalonProfileBuilder toBuilder() => ProSalonProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProSalonProfile &&
        id == other.id &&
        name == other.name &&
        category == other.category &&
        logoUrl == other.logoUrl &&
        description == other.description &&
        city == other.city &&
        address == other.address &&
        neighborhood == other.neighborhood &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        phone == other.phone &&
        instagram == other.instagram &&
        averageRating == other.averageRating &&
        subscriptionTier == other.subscriptionTier &&
        isVisibleInMarketplace == other.isVisibleInMarketplace &&
        canReceiveBookings == other.canReceiveBookings &&
        teamDisplay == other.teamDisplay &&
        gallery == other.gallery &&
        hours == other.hours;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, neighborhood.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, instagram.hashCode);
    _$hash = $jc(_$hash, averageRating.hashCode);
    _$hash = $jc(_$hash, subscriptionTier.hashCode);
    _$hash = $jc(_$hash, isVisibleInMarketplace.hashCode);
    _$hash = $jc(_$hash, canReceiveBookings.hashCode);
    _$hash = $jc(_$hash, teamDisplay.hashCode);
    _$hash = $jc(_$hash, gallery.hashCode);
    _$hash = $jc(_$hash, hours.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProSalonProfile')
          ..add('id', id)
          ..add('name', name)
          ..add('category', category)
          ..add('logoUrl', logoUrl)
          ..add('description', description)
          ..add('city', city)
          ..add('address', address)
          ..add('neighborhood', neighborhood)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('phone', phone)
          ..add('instagram', instagram)
          ..add('averageRating', averageRating)
          ..add('subscriptionTier', subscriptionTier)
          ..add('isVisibleInMarketplace', isVisibleInMarketplace)
          ..add('canReceiveBookings', canReceiveBookings)
          ..add('teamDisplay', teamDisplay)
          ..add('gallery', gallery)
          ..add('hours', hours))
        .toString();
  }
}

class ProSalonProfileBuilder
    implements Builder<ProSalonProfile, ProSalonProfileBuilder> {
  _$ProSalonProfile? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _neighborhood;
  String? get neighborhood => _$this._neighborhood;
  set neighborhood(String? neighborhood) => _$this._neighborhood = neighborhood;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _instagram;
  String? get instagram => _$this._instagram;
  set instagram(String? instagram) => _$this._instagram = instagram;

  num? _averageRating;
  num? get averageRating => _$this._averageRating;
  set averageRating(num? averageRating) =>
      _$this._averageRating = averageRating;

  ProSalonProfileSubscriptionTierEnum? _subscriptionTier;
  ProSalonProfileSubscriptionTierEnum? get subscriptionTier =>
      _$this._subscriptionTier;
  set subscriptionTier(ProSalonProfileSubscriptionTierEnum? subscriptionTier) =>
      _$this._subscriptionTier = subscriptionTier;

  bool? _isVisibleInMarketplace;
  bool? get isVisibleInMarketplace => _$this._isVisibleInMarketplace;
  set isVisibleInMarketplace(bool? isVisibleInMarketplace) =>
      _$this._isVisibleInMarketplace = isVisibleInMarketplace;

  bool? _canReceiveBookings;
  bool? get canReceiveBookings => _$this._canReceiveBookings;
  set canReceiveBookings(bool? canReceiveBookings) =>
      _$this._canReceiveBookings = canReceiveBookings;

  SalonDetailTeamDisplayBuilder? _teamDisplay;
  SalonDetailTeamDisplayBuilder get teamDisplay =>
      _$this._teamDisplay ??= SalonDetailTeamDisplayBuilder();
  set teamDisplay(SalonDetailTeamDisplayBuilder? teamDisplay) =>
      _$this._teamDisplay = teamDisplay;

  ListBuilder<String>? _gallery;
  ListBuilder<String> get gallery => _$this._gallery ??= ListBuilder<String>();
  set gallery(ListBuilder<String>? gallery) => _$this._gallery = gallery;

  ListBuilder<ProSalonProfileHoursInner>? _hours;
  ListBuilder<ProSalonProfileHoursInner> get hours =>
      _$this._hours ??= ListBuilder<ProSalonProfileHoursInner>();
  set hours(ListBuilder<ProSalonProfileHoursInner>? hours) =>
      _$this._hours = hours;

  ProSalonProfileBuilder() {
    ProSalonProfile._defaults(this);
  }

  ProSalonProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _category = $v.category;
      _logoUrl = $v.logoUrl;
      _description = $v.description;
      _city = $v.city;
      _address = $v.address;
      _neighborhood = $v.neighborhood;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _phone = $v.phone;
      _instagram = $v.instagram;
      _averageRating = $v.averageRating;
      _subscriptionTier = $v.subscriptionTier;
      _isVisibleInMarketplace = $v.isVisibleInMarketplace;
      _canReceiveBookings = $v.canReceiveBookings;
      _teamDisplay = $v.teamDisplay.toBuilder();
      _gallery = $v.gallery.toBuilder();
      _hours = $v.hours.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProSalonProfile other) {
    _$v = other as _$ProSalonProfile;
  }

  @override
  void update(void Function(ProSalonProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProSalonProfile build() => _build();

  _$ProSalonProfile _build() {
    _$ProSalonProfile _$result;
    try {
      _$result = _$v ??
          _$ProSalonProfile._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProSalonProfile', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'ProSalonProfile', 'name'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'ProSalonProfile', 'category'),
            logoUrl: logoUrl,
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'ProSalonProfile', 'description'),
            city: BuiltValueNullFieldError.checkNotNull(
                city, r'ProSalonProfile', 'city'),
            address: BuiltValueNullFieldError.checkNotNull(
                address, r'ProSalonProfile', 'address'),
            neighborhood: neighborhood,
            latitude: latitude,
            longitude: longitude,
            phone: phone,
            instagram: instagram,
            averageRating: BuiltValueNullFieldError.checkNotNull(
                averageRating, r'ProSalonProfile', 'averageRating'),
            subscriptionTier: BuiltValueNullFieldError.checkNotNull(
                subscriptionTier, r'ProSalonProfile', 'subscriptionTier'),
            isVisibleInMarketplace: BuiltValueNullFieldError.checkNotNull(
                isVisibleInMarketplace,
                r'ProSalonProfile',
                'isVisibleInMarketplace'),
            canReceiveBookings: BuiltValueNullFieldError.checkNotNull(
                canReceiveBookings, r'ProSalonProfile', 'canReceiveBookings'),
            teamDisplay: teamDisplay.build(),
            gallery: gallery.build(),
            hours: hours.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'teamDisplay';
        teamDisplay.build();
        _$failedField = 'gallery';
        gallery.build();
        _$failedField = 'hours';
        hours.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProSalonProfile', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
