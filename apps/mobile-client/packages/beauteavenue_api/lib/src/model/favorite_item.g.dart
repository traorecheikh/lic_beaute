// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FavoriteItemSubscriptionTierEnum
    _$favoriteItemSubscriptionTierEnum_standard =
    const FavoriteItemSubscriptionTierEnum._('standard');
const FavoriteItemSubscriptionTierEnum
    _$favoriteItemSubscriptionTierEnum_premium =
    const FavoriteItemSubscriptionTierEnum._('premium');

FavoriteItemSubscriptionTierEnum _$favoriteItemSubscriptionTierEnumValueOf(
    String name) {
  switch (name) {
    case 'standard':
      return _$favoriteItemSubscriptionTierEnum_standard;
    case 'premium':
      return _$favoriteItemSubscriptionTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FavoriteItemSubscriptionTierEnum>
    _$favoriteItemSubscriptionTierEnumValues = BuiltSet<
        FavoriteItemSubscriptionTierEnum>(const <FavoriteItemSubscriptionTierEnum>[
  _$favoriteItemSubscriptionTierEnum_standard,
  _$favoriteItemSubscriptionTierEnum_premium,
]);

Serializer<FavoriteItemSubscriptionTierEnum>
    _$favoriteItemSubscriptionTierEnumSerializer =
    _$FavoriteItemSubscriptionTierEnumSerializer();

class _$FavoriteItemSubscriptionTierEnumSerializer
    implements PrimitiveSerializer<FavoriteItemSubscriptionTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'standard': 'standard',
    'premium': 'premium',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'standard': 'standard',
    'premium': 'premium',
  };

  @override
  final Iterable<Type> types = const <Type>[FavoriteItemSubscriptionTierEnum];
  @override
  final String wireName = 'FavoriteItemSubscriptionTierEnum';

  @override
  Object serialize(
          Serializers serializers, FavoriteItemSubscriptionTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FavoriteItemSubscriptionTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FavoriteItemSubscriptionTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FavoriteItem extends FavoriteItem {
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
  final int reviewCount;
  @override
  final num? latitude;
  @override
  final num? longitude;
  @override
  final FavoriteItemSubscriptionTierEnum subscriptionTier;
  @override
  final bool featured;
  @override
  final bool isPrestige;
  @override
  final num? prestigeScore;
  @override
  final num? distanceKm;

  factory _$FavoriteItem([void Function(FavoriteItemBuilder)? updates]) =>
      (FavoriteItemBuilder()..update(updates))._build();

  _$FavoriteItem._(
      {required this.id,
      required this.name,
      required this.category,
      this.logoUrl,
      required this.city,
      this.neighborhood,
      required this.averageRating,
      required this.reviewCount,
      this.latitude,
      this.longitude,
      required this.subscriptionTier,
      required this.featured,
      required this.isPrestige,
      this.prestigeScore,
      this.distanceKm})
      : super._();
  @override
  FavoriteItem rebuild(void Function(FavoriteItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FavoriteItemBuilder toBuilder() => FavoriteItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FavoriteItem &&
        id == other.id &&
        name == other.name &&
        category == other.category &&
        logoUrl == other.logoUrl &&
        city == other.city &&
        neighborhood == other.neighborhood &&
        averageRating == other.averageRating &&
        reviewCount == other.reviewCount &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        subscriptionTier == other.subscriptionTier &&
        featured == other.featured &&
        isPrestige == other.isPrestige &&
        prestigeScore == other.prestigeScore &&
        distanceKm == other.distanceKm;
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
    _$hash = $jc(_$hash, reviewCount.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, subscriptionTier.hashCode);
    _$hash = $jc(_$hash, featured.hashCode);
    _$hash = $jc(_$hash, isPrestige.hashCode);
    _$hash = $jc(_$hash, prestigeScore.hashCode);
    _$hash = $jc(_$hash, distanceKm.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FavoriteItem')
          ..add('id', id)
          ..add('name', name)
          ..add('category', category)
          ..add('logoUrl', logoUrl)
          ..add('city', city)
          ..add('neighborhood', neighborhood)
          ..add('averageRating', averageRating)
          ..add('reviewCount', reviewCount)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('subscriptionTier', subscriptionTier)
          ..add('featured', featured)
          ..add('isPrestige', isPrestige)
          ..add('prestigeScore', prestigeScore)
          ..add('distanceKm', distanceKm))
        .toString();
  }
}

class FavoriteItemBuilder
    implements Builder<FavoriteItem, FavoriteItemBuilder> {
  _$FavoriteItem? _$v;

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

  int? _reviewCount;
  int? get reviewCount => _$this._reviewCount;
  set reviewCount(int? reviewCount) => _$this._reviewCount = reviewCount;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  FavoriteItemSubscriptionTierEnum? _subscriptionTier;
  FavoriteItemSubscriptionTierEnum? get subscriptionTier =>
      _$this._subscriptionTier;
  set subscriptionTier(FavoriteItemSubscriptionTierEnum? subscriptionTier) =>
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

  FavoriteItemBuilder() {
    FavoriteItem._defaults(this);
  }

  FavoriteItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _category = $v.category;
      _logoUrl = $v.logoUrl;
      _city = $v.city;
      _neighborhood = $v.neighborhood;
      _averageRating = $v.averageRating;
      _reviewCount = $v.reviewCount;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _subscriptionTier = $v.subscriptionTier;
      _featured = $v.featured;
      _isPrestige = $v.isPrestige;
      _prestigeScore = $v.prestigeScore;
      _distanceKm = $v.distanceKm;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FavoriteItem other) {
    _$v = other as _$FavoriteItem;
  }

  @override
  void update(void Function(FavoriteItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FavoriteItem build() => _build();

  _$FavoriteItem _build() {
    final _$result = _$v ??
        _$FavoriteItem._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'FavoriteItem', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'FavoriteItem', 'name'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'FavoriteItem', 'category'),
          logoUrl: logoUrl,
          city: BuiltValueNullFieldError.checkNotNull(
              city, r'FavoriteItem', 'city'),
          neighborhood: neighborhood,
          averageRating: BuiltValueNullFieldError.checkNotNull(
              averageRating, r'FavoriteItem', 'averageRating'),
          reviewCount: BuiltValueNullFieldError.checkNotNull(
              reviewCount, r'FavoriteItem', 'reviewCount'),
          latitude: latitude,
          longitude: longitude,
          subscriptionTier: BuiltValueNullFieldError.checkNotNull(
              subscriptionTier, r'FavoriteItem', 'subscriptionTier'),
          featured: BuiltValueNullFieldError.checkNotNull(
              featured, r'FavoriteItem', 'featured'),
          isPrestige: BuiltValueNullFieldError.checkNotNull(
              isPrestige, r'FavoriteItem', 'isPrestige'),
          prestigeScore: prestigeScore,
          distanceKm: distanceKm,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
