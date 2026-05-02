// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SalonDetailSubscriptionTierEnum
    _$salonDetailSubscriptionTierEnum_standard =
    const SalonDetailSubscriptionTierEnum._('standard');
const SalonDetailSubscriptionTierEnum
    _$salonDetailSubscriptionTierEnum_premium =
    const SalonDetailSubscriptionTierEnum._('premium');

SalonDetailSubscriptionTierEnum _$salonDetailSubscriptionTierEnumValueOf(
    String name) {
  switch (name) {
    case 'standard':
      return _$salonDetailSubscriptionTierEnum_standard;
    case 'premium':
      return _$salonDetailSubscriptionTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SalonDetailSubscriptionTierEnum>
    _$salonDetailSubscriptionTierEnumValues = BuiltSet<
        SalonDetailSubscriptionTierEnum>(const <SalonDetailSubscriptionTierEnum>[
  _$salonDetailSubscriptionTierEnum_standard,
  _$salonDetailSubscriptionTierEnum_premium,
]);

Serializer<SalonDetailSubscriptionTierEnum>
    _$salonDetailSubscriptionTierEnumSerializer =
    _$SalonDetailSubscriptionTierEnumSerializer();

class _$SalonDetailSubscriptionTierEnumSerializer
    implements PrimitiveSerializer<SalonDetailSubscriptionTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'standard': 'standard',
    'premium': 'premium',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'standard': 'standard',
    'premium': 'premium',
  };

  @override
  final Iterable<Type> types = const <Type>[SalonDetailSubscriptionTierEnum];
  @override
  final String wireName = 'SalonDetailSubscriptionTierEnum';

  @override
  Object serialize(
          Serializers serializers, SalonDetailSubscriptionTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SalonDetailSubscriptionTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SalonDetailSubscriptionTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SalonDetail extends SalonDetail {
  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final String? logoUrl;
  @override
  final String city;
  @override
  final String? neighborhood;
  @override
  final num averageRating;
  @override
  final num? latitude;
  @override
  final num? longitude;
  @override
  final SalonDetailSubscriptionTierEnum subscriptionTier;
  @override
  final bool featured;
  @override
  final bool isPrestige;
  @override
  final num? prestigeScore;
  @override
  final num? distanceKm;
  @override
  final String description;
  @override
  final String address;
  @override
  final BuiltList<String> gallery;
  @override
  final BuiltList<SalonDetailServicesInner> services;
  @override
  final SalonDetailTeamDisplay teamDisplay;
  @override
  final BuiltList<SalonDetailStaffInner> staff;

  factory _$SalonDetail([void Function(SalonDetailBuilder)? updates]) =>
      (SalonDetailBuilder()..update(updates))._build();

  _$SalonDetail._(
      {required this.id,
      required this.name,
      required this.category,
      this.logoUrl,
      required this.city,
      this.neighborhood,
      required this.averageRating,
      this.latitude,
      this.longitude,
      required this.subscriptionTier,
      required this.featured,
      required this.isPrestige,
      this.prestigeScore,
      this.distanceKm,
      required this.description,
      required this.address,
      required this.gallery,
      required this.services,
      required this.teamDisplay,
      required this.staff})
      : super._();
  @override
  SalonDetail rebuild(void Function(SalonDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalonDetailBuilder toBuilder() => SalonDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalonDetail &&
        id == other.id &&
        name == other.name &&
        category == other.category &&
        logoUrl == other.logoUrl &&
        city == other.city &&
        neighborhood == other.neighborhood &&
        averageRating == other.averageRating &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        subscriptionTier == other.subscriptionTier &&
        featured == other.featured &&
        isPrestige == other.isPrestige &&
        prestigeScore == other.prestigeScore &&
        distanceKm == other.distanceKm &&
        description == other.description &&
        address == other.address &&
        gallery == other.gallery &&
        services == other.services &&
        teamDisplay == other.teamDisplay &&
        staff == other.staff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, neighborhood.hashCode);
    _$hash = $jc(_$hash, averageRating.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, subscriptionTier.hashCode);
    _$hash = $jc(_$hash, featured.hashCode);
    _$hash = $jc(_$hash, isPrestige.hashCode);
    _$hash = $jc(_$hash, prestigeScore.hashCode);
    _$hash = $jc(_$hash, distanceKm.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, gallery.hashCode);
    _$hash = $jc(_$hash, services.hashCode);
    _$hash = $jc(_$hash, teamDisplay.hashCode);
    _$hash = $jc(_$hash, staff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalonDetail')
          ..add('id', id)
          ..add('name', name)
          ..add('category', category)
          ..add('logoUrl', logoUrl)
          ..add('city', city)
          ..add('neighborhood', neighborhood)
          ..add('averageRating', averageRating)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('subscriptionTier', subscriptionTier)
          ..add('featured', featured)
          ..add('isPrestige', isPrestige)
          ..add('prestigeScore', prestigeScore)
          ..add('distanceKm', distanceKm)
          ..add('description', description)
          ..add('address', address)
          ..add('gallery', gallery)
          ..add('services', services)
          ..add('teamDisplay', teamDisplay)
          ..add('staff', staff))
        .toString();
  }
}

class SalonDetailBuilder implements Builder<SalonDetail, SalonDetailBuilder> {
  _$SalonDetail? _$v;

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

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _neighborhood;
  String? get neighborhood => _$this._neighborhood;
  set neighborhood(String? neighborhood) => _$this._neighborhood = neighborhood;

  num? _averageRating;
  num? get averageRating => _$this._averageRating;
  set averageRating(num? averageRating) =>
      _$this._averageRating = averageRating;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  SalonDetailSubscriptionTierEnum? _subscriptionTier;
  SalonDetailSubscriptionTierEnum? get subscriptionTier =>
      _$this._subscriptionTier;
  set subscriptionTier(SalonDetailSubscriptionTierEnum? subscriptionTier) =>
      _$this._subscriptionTier = subscriptionTier;

  bool? _featured;
  bool? get featured => _$this._featured;
  set featured(bool? featured) => _$this._featured = featured;

  bool? _isPrestige;
  bool? get isPrestige => _$this._isPrestige;
  set isPrestige(bool? isPrestige) => _$this._isPrestige = isPrestige;

  num? _prestigeScore;
  num? get prestigeScore => _$this._prestigeScore;
  set prestigeScore(num? prestigeScore) =>
      _$this._prestigeScore = prestigeScore;

  num? _distanceKm;
  num? get distanceKm => _$this._distanceKm;
  set distanceKm(num? distanceKm) => _$this._distanceKm = distanceKm;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  ListBuilder<String>? _gallery;
  ListBuilder<String> get gallery => _$this._gallery ??= ListBuilder<String>();
  set gallery(ListBuilder<String>? gallery) => _$this._gallery = gallery;

  ListBuilder<SalonDetailServicesInner>? _services;
  ListBuilder<SalonDetailServicesInner> get services =>
      _$this._services ??= ListBuilder<SalonDetailServicesInner>();
  set services(ListBuilder<SalonDetailServicesInner>? services) =>
      _$this._services = services;

  SalonDetailTeamDisplayBuilder? _teamDisplay;
  SalonDetailTeamDisplayBuilder get teamDisplay =>
      _$this._teamDisplay ??= SalonDetailTeamDisplayBuilder();
  set teamDisplay(SalonDetailTeamDisplayBuilder? teamDisplay) =>
      _$this._teamDisplay = teamDisplay;

  ListBuilder<SalonDetailStaffInner>? _staff;
  ListBuilder<SalonDetailStaffInner> get staff =>
      _$this._staff ??= ListBuilder<SalonDetailStaffInner>();
  set staff(ListBuilder<SalonDetailStaffInner>? staff) => _$this._staff = staff;

  SalonDetailBuilder() {
    SalonDetail._defaults(this);
  }

  SalonDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _category = $v.category;
      _logoUrl = $v.logoUrl;
      _city = $v.city;
      _neighborhood = $v.neighborhood;
      _averageRating = $v.averageRating;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _subscriptionTier = $v.subscriptionTier;
      _featured = $v.featured;
      _isPrestige = $v.isPrestige;
      _prestigeScore = $v.prestigeScore;
      _distanceKm = $v.distanceKm;
      _description = $v.description;
      _address = $v.address;
      _gallery = $v.gallery.toBuilder();
      _services = $v.services.toBuilder();
      _teamDisplay = $v.teamDisplay.toBuilder();
      _staff = $v.staff.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalonDetail other) {
    _$v = other as _$SalonDetail;
  }

  @override
  void update(void Function(SalonDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalonDetail build() => _build();

  _$SalonDetail _build() {
    _$SalonDetail _$result;
    try {
      _$result = _$v ??
          _$SalonDetail._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'SalonDetail', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'SalonDetail', 'name'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'SalonDetail', 'category'),
            logoUrl: logoUrl,
            city: BuiltValueNullFieldError.checkNotNull(
                city, r'SalonDetail', 'city'),
            neighborhood: neighborhood,
            averageRating: BuiltValueNullFieldError.checkNotNull(
                averageRating, r'SalonDetail', 'averageRating'),
            latitude: latitude,
            longitude: longitude,
            subscriptionTier: BuiltValueNullFieldError.checkNotNull(
                subscriptionTier, r'SalonDetail', 'subscriptionTier'),
            featured: BuiltValueNullFieldError.checkNotNull(
                featured, r'SalonDetail', 'featured'),
            isPrestige: BuiltValueNullFieldError.checkNotNull(
                isPrestige, r'SalonDetail', 'isPrestige'),
            prestigeScore: prestigeScore,
            distanceKm: distanceKm,
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'SalonDetail', 'description'),
            address: BuiltValueNullFieldError.checkNotNull(
                address, r'SalonDetail', 'address'),
            gallery: gallery.build(),
            services: services.build(),
            teamDisplay: teamDisplay.build(),
            staff: staff.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'gallery';
        gallery.build();
        _$failedField = 'services';
        services.build();
        _$failedField = 'teamDisplay';
        teamDisplay.build();
        _$failedField = 'staff';
        staff.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SalonDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
