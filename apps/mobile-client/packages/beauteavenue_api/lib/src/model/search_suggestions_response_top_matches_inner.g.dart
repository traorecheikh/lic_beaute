// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_suggestions_response_top_matches_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum
    _$searchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum_standard =
    const SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum._(
        'standard');
const SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum
    _$searchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum_premium =
    const SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum._(
        'premium');

SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum
    _$searchSuggestionsResponseTopMatchesInnerSubscriptionTierEnumValueOf(
        String name) {
  switch (name) {
    case 'standard':
      return _$searchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum_standard;
    case 'premium':
      return _$searchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum>
    _$searchSuggestionsResponseTopMatchesInnerSubscriptionTierEnumValues =
    BuiltSet<
        SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum>(const <SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum>[
  _$searchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum_standard,
  _$searchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum_premium,
]);

const SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum
    _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_exact =
    const SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum._('exact');
const SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum
    _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_prefix =
    const SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum._('prefix');
const SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum
    _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_service =
    const SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum._('service');
const SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum
    _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_fuzzy =
    const SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum._('fuzzy');
const SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum
    _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_location =
    const SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum._('location');

SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum
    _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnumValueOf(
        String name) {
  switch (name) {
    case 'exact':
      return _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_exact;
    case 'prefix':
      return _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_prefix;
    case 'service':
      return _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_service;
    case 'fuzzy':
      return _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_fuzzy;
    case 'location':
      return _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_location;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum>
    _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnumValues = BuiltSet<
        SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum>(const <SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum>[
  _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_exact,
  _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_prefix,
  _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_service,
  _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_fuzzy,
  _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnum_location,
]);

Serializer<SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum>
    _$searchSuggestionsResponseTopMatchesInnerSubscriptionTierEnumSerializer =
    _$SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnumSerializer();
Serializer<SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum>
    _$searchSuggestionsResponseTopMatchesInnerMatchTypeEnumSerializer =
    _$SearchSuggestionsResponseTopMatchesInnerMatchTypeEnumSerializer();

class _$SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnumSerializer
    implements
        PrimitiveSerializer<
            SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum> {
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
    SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum
  ];
  @override
  final String wireName =
      'SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum';

  @override
  Object serialize(Serializers serializers,
          SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchSuggestionsResponseTopMatchesInnerMatchTypeEnumSerializer
    implements
        PrimitiveSerializer<
            SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'exact': 'exact',
    'prefix': 'prefix',
    'service': 'service',
    'fuzzy': 'fuzzy',
    'location': 'location',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'exact': 'exact',
    'prefix': 'prefix',
    'service': 'service',
    'fuzzy': 'fuzzy',
    'location': 'location',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum
  ];
  @override
  final String wireName =
      'SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum';

  @override
  Object serialize(Serializers serializers,
          SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchSuggestionsResponseTopMatchesInner
    extends SearchSuggestionsResponseTopMatchesInner {
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
  final SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum
      subscriptionTier;
  @override
  final bool featured;
  @override
  final bool isPrestige;
  @override
  final num? prestigeScore;
  @override
  final num? distanceKm;
  @override
  final SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum? matchType;
  @override
  final String? matchedService;
  @override
  final bool? isOpenNow;
  @override
  final num? minPriceXof;

  factory _$SearchSuggestionsResponseTopMatchesInner(
          [void Function(SearchSuggestionsResponseTopMatchesInnerBuilder)?
              updates]) =>
      (SearchSuggestionsResponseTopMatchesInnerBuilder()..update(updates))
          ._build();

  _$SearchSuggestionsResponseTopMatchesInner._(
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
      this.matchType,
      this.matchedService,
      this.isOpenNow,
      this.minPriceXof})
      : super._();
  @override
  SearchSuggestionsResponseTopMatchesInner rebuild(
          void Function(SearchSuggestionsResponseTopMatchesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchSuggestionsResponseTopMatchesInnerBuilder toBuilder() =>
      SearchSuggestionsResponseTopMatchesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchSuggestionsResponseTopMatchesInner &&
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
        matchType == other.matchType &&
        matchedService == other.matchedService &&
        isOpenNow == other.isOpenNow &&
        minPriceXof == other.minPriceXof;
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
    _$hash = $jc(_$hash, matchType.hashCode);
    _$hash = $jc(_$hash, matchedService.hashCode);
    _$hash = $jc(_$hash, isOpenNow.hashCode);
    _$hash = $jc(_$hash, minPriceXof.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'SearchSuggestionsResponseTopMatchesInner')
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
          ..add('matchType', matchType)
          ..add('matchedService', matchedService)
          ..add('isOpenNow', isOpenNow)
          ..add('minPriceXof', minPriceXof))
        .toString();
  }
}

class SearchSuggestionsResponseTopMatchesInnerBuilder
    implements
        Builder<SearchSuggestionsResponseTopMatchesInner,
            SearchSuggestionsResponseTopMatchesInnerBuilder> {
  _$SearchSuggestionsResponseTopMatchesInner? _$v;

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

  SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum?
      _subscriptionTier;
  SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum?
      get subscriptionTier => _$this._subscriptionTier;
  set subscriptionTier(
          SearchSuggestionsResponseTopMatchesInnerSubscriptionTierEnum?
              subscriptionTier) =>
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

  SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum? _matchType;
  SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum? get matchType =>
      _$this._matchType;
  set matchType(
          SearchSuggestionsResponseTopMatchesInnerMatchTypeEnum? matchType) =>
      _$this._matchType = matchType;

  String? _matchedService;
  String? get matchedService => _$this._matchedService;
  set matchedService(String? matchedService) =>
      _$this._matchedService = matchedService;

  bool? _isOpenNow;
  bool? get isOpenNow => _$this._isOpenNow;
  set isOpenNow(bool? isOpenNow) => _$this._isOpenNow = isOpenNow;

  num? _minPriceXof;
  num? get minPriceXof => _$this._minPriceXof;
  set minPriceXof(num? minPriceXof) => _$this._minPriceXof = minPriceXof;

  SearchSuggestionsResponseTopMatchesInnerBuilder() {
    SearchSuggestionsResponseTopMatchesInner._defaults(this);
  }

  SearchSuggestionsResponseTopMatchesInnerBuilder get _$this {
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
      _matchType = $v.matchType;
      _matchedService = $v.matchedService;
      _isOpenNow = $v.isOpenNow;
      _minPriceXof = $v.minPriceXof;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchSuggestionsResponseTopMatchesInner other) {
    _$v = other as _$SearchSuggestionsResponseTopMatchesInner;
  }

  @override
  void update(
      void Function(SearchSuggestionsResponseTopMatchesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchSuggestionsResponseTopMatchesInner build() => _build();

  _$SearchSuggestionsResponseTopMatchesInner _build() {
    final _$result = _$v ??
        _$SearchSuggestionsResponseTopMatchesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'SearchSuggestionsResponseTopMatchesInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'SearchSuggestionsResponseTopMatchesInner', 'name'),
          category: BuiltValueNullFieldError.checkNotNull(category,
              r'SearchSuggestionsResponseTopMatchesInner', 'category'),
          logoUrl: logoUrl,
          city: BuiltValueNullFieldError.checkNotNull(
              city, r'SearchSuggestionsResponseTopMatchesInner', 'city'),
          neighborhood: neighborhood,
          averageRating: BuiltValueNullFieldError.checkNotNull(averageRating,
              r'SearchSuggestionsResponseTopMatchesInner', 'averageRating'),
          latitude: latitude,
          longitude: longitude,
          subscriptionTier: BuiltValueNullFieldError.checkNotNull(
              subscriptionTier,
              r'SearchSuggestionsResponseTopMatchesInner',
              'subscriptionTier'),
          featured: BuiltValueNullFieldError.checkNotNull(featured,
              r'SearchSuggestionsResponseTopMatchesInner', 'featured'),
          isPrestige: BuiltValueNullFieldError.checkNotNull(isPrestige,
              r'SearchSuggestionsResponseTopMatchesInner', 'isPrestige'),
          prestigeScore: prestigeScore,
          distanceKm: distanceKm,
          matchType: matchType,
          matchedService: matchedService,
          isOpenNow: isOpenNow,
          minPriceXof: minPriceXof,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
