// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_summary_list_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SalonSummaryListResponseItemsInnerSubscriptionTierEnum
    _$salonSummaryListResponseItemsInnerSubscriptionTierEnum_standard =
    const SalonSummaryListResponseItemsInnerSubscriptionTierEnum._('standard');
const SalonSummaryListResponseItemsInnerSubscriptionTierEnum
    _$salonSummaryListResponseItemsInnerSubscriptionTierEnum_premium =
    const SalonSummaryListResponseItemsInnerSubscriptionTierEnum._('premium');

SalonSummaryListResponseItemsInnerSubscriptionTierEnum
    _$salonSummaryListResponseItemsInnerSubscriptionTierEnumValueOf(
        String name) {
  switch (name) {
    case 'standard':
      return _$salonSummaryListResponseItemsInnerSubscriptionTierEnum_standard;
    case 'premium':
      return _$salonSummaryListResponseItemsInnerSubscriptionTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SalonSummaryListResponseItemsInnerSubscriptionTierEnum>
    _$salonSummaryListResponseItemsInnerSubscriptionTierEnumValues = BuiltSet<
        SalonSummaryListResponseItemsInnerSubscriptionTierEnum>(const <SalonSummaryListResponseItemsInnerSubscriptionTierEnum>[
  _$salonSummaryListResponseItemsInnerSubscriptionTierEnum_standard,
  _$salonSummaryListResponseItemsInnerSubscriptionTierEnum_premium,
]);

Serializer<SalonSummaryListResponseItemsInnerSubscriptionTierEnum>
    _$salonSummaryListResponseItemsInnerSubscriptionTierEnumSerializer =
    _$SalonSummaryListResponseItemsInnerSubscriptionTierEnumSerializer();

class _$SalonSummaryListResponseItemsInnerSubscriptionTierEnumSerializer
    implements
        PrimitiveSerializer<
            SalonSummaryListResponseItemsInnerSubscriptionTierEnum> {
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
    SalonSummaryListResponseItemsInnerSubscriptionTierEnum
  ];
  @override
  final String wireName =
      'SalonSummaryListResponseItemsInnerSubscriptionTierEnum';

  @override
  Object serialize(Serializers serializers,
          SalonSummaryListResponseItemsInnerSubscriptionTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SalonSummaryListResponseItemsInnerSubscriptionTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SalonSummaryListResponseItemsInnerSubscriptionTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SalonSummaryListResponseItemsInner
    extends SalonSummaryListResponseItemsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
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
  final SalonSummaryListResponseItemsInnerSubscriptionTierEnum subscriptionTier;
  @override
  final bool featured;

  factory _$SalonSummaryListResponseItemsInner(
          [void Function(SalonSummaryListResponseItemsInnerBuilder)?
              updates]) =>
      (SalonSummaryListResponseItemsInnerBuilder()..update(updates))._build();

  _$SalonSummaryListResponseItemsInner._(
      {required this.id,
      required this.name,
      required this.category,
      required this.city,
      this.neighborhood,
      required this.averageRating,
      this.latitude,
      this.longitude,
      required this.subscriptionTier,
      required this.featured})
      : super._();
  @override
  SalonSummaryListResponseItemsInner rebuild(
          void Function(SalonSummaryListResponseItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalonSummaryListResponseItemsInnerBuilder toBuilder() =>
      SalonSummaryListResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalonSummaryListResponseItemsInner &&
        id == other.id &&
        name == other.name &&
        category == other.category &&
        city == other.city &&
        neighborhood == other.neighborhood &&
        averageRating == other.averageRating &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        subscriptionTier == other.subscriptionTier &&
        featured == other.featured;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, neighborhood.hashCode);
    _$hash = $jc(_$hash, averageRating.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, subscriptionTier.hashCode);
    _$hash = $jc(_$hash, featured.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalonSummaryListResponseItemsInner')
          ..add('id', id)
          ..add('name', name)
          ..add('category', category)
          ..add('city', city)
          ..add('neighborhood', neighborhood)
          ..add('averageRating', averageRating)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('subscriptionTier', subscriptionTier)
          ..add('featured', featured))
        .toString();
  }
}

class SalonSummaryListResponseItemsInnerBuilder
    implements
        Builder<SalonSummaryListResponseItemsInner,
            SalonSummaryListResponseItemsInnerBuilder> {
  _$SalonSummaryListResponseItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

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

  SalonSummaryListResponseItemsInnerSubscriptionTierEnum? _subscriptionTier;
  SalonSummaryListResponseItemsInnerSubscriptionTierEnum?
      get subscriptionTier => _$this._subscriptionTier;
  set subscriptionTier(
          SalonSummaryListResponseItemsInnerSubscriptionTierEnum?
              subscriptionTier) =>
      _$this._subscriptionTier = subscriptionTier;

  bool? _featured;
  bool? get featured => _$this._featured;
  set featured(bool? featured) => _$this._featured = featured;

  SalonSummaryListResponseItemsInnerBuilder() {
    SalonSummaryListResponseItemsInner._defaults(this);
  }

  SalonSummaryListResponseItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _category = $v.category;
      _city = $v.city;
      _neighborhood = $v.neighborhood;
      _averageRating = $v.averageRating;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _subscriptionTier = $v.subscriptionTier;
      _featured = $v.featured;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalonSummaryListResponseItemsInner other) {
    _$v = other as _$SalonSummaryListResponseItemsInner;
  }

  @override
  void update(
      void Function(SalonSummaryListResponseItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalonSummaryListResponseItemsInner build() => _build();

  _$SalonSummaryListResponseItemsInner _build() {
    final _$result = _$v ??
        _$SalonSummaryListResponseItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'SalonSummaryListResponseItemsInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'SalonSummaryListResponseItemsInner', 'name'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'SalonSummaryListResponseItemsInner', 'category'),
          city: BuiltValueNullFieldError.checkNotNull(
              city, r'SalonSummaryListResponseItemsInner', 'city'),
          neighborhood: neighborhood,
          averageRating: BuiltValueNullFieldError.checkNotNull(averageRating,
              r'SalonSummaryListResponseItemsInner', 'averageRating'),
          latitude: latitude,
          longitude: longitude,
          subscriptionTier: BuiltValueNullFieldError.checkNotNull(
              subscriptionTier,
              r'SalonSummaryListResponseItemsInner',
              'subscriptionTier'),
          featured: BuiltValueNullFieldError.checkNotNull(
              featured, r'SalonSummaryListResponseItemsInner', 'featured'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
