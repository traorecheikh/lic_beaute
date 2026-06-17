//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'favorite_item.g.dart';

/// FavoriteItem
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [category] 
/// * [logoUrl] 
/// * [city] 
/// * [neighborhood] 
/// * [averageRating] 
/// * [reviewCount] 
/// * [latitude] 
/// * [longitude] 
/// * [subscriptionTier] 
/// * [featured] 
/// * [isPrestige] 
/// * [prestigeScore] 
/// * [distanceKm] 
@BuiltValue()
abstract class FavoriteItem implements Built<FavoriteItem, FavoriteItemBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'logoUrl')
  String? get logoUrl;

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'neighborhood')
  String? get neighborhood;

  @BuiltValueField(wireName: r'averageRating')
  num get averageRating;

  @BuiltValueField(wireName: r'reviewCount')
  int get reviewCount;

  @BuiltValueField(wireName: r'latitude')
  num? get latitude;

  @BuiltValueField(wireName: r'longitude')
  num? get longitude;

  @BuiltValueField(wireName: r'subscriptionTier')
  FavoriteItemSubscriptionTierEnum get subscriptionTier;
  // enum subscriptionTierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'featured')
  bool get featured;

  @BuiltValueField(wireName: r'isPrestige')
  bool get isPrestige;

  @BuiltValueField(wireName: r'prestigeScore')
  num? get prestigeScore;

  @BuiltValueField(wireName: r'distanceKm')
  num? get distanceKm;

  FavoriteItem._();

  factory FavoriteItem([void updates(FavoriteItemBuilder b)]) = _$FavoriteItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FavoriteItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FavoriteItem> get serializer => _$FavoriteItemSerializer();
}

class _$FavoriteItemSerializer implements PrimitiveSerializer<FavoriteItem> {
  @override
  final Iterable<Type> types = const [FavoriteItem, _$FavoriteItem];

  @override
  final String wireName = r'FavoriteItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FavoriteItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'logoUrl';
    yield object.logoUrl == null ? null : serializers.serialize(
      object.logoUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'neighborhood';
    yield object.neighborhood == null ? null : serializers.serialize(
      object.neighborhood,
      specifiedType: const FullType.nullable(String),
    );
    yield r'averageRating';
    yield serializers.serialize(
      object.averageRating,
      specifiedType: const FullType(num),
    );
    yield r'reviewCount';
    yield serializers.serialize(
      object.reviewCount,
      specifiedType: const FullType(int),
    );
    yield r'latitude';
    yield object.latitude == null ? null : serializers.serialize(
      object.latitude,
      specifiedType: const FullType.nullable(num),
    );
    yield r'longitude';
    yield object.longitude == null ? null : serializers.serialize(
      object.longitude,
      specifiedType: const FullType.nullable(num),
    );
    yield r'subscriptionTier';
    yield serializers.serialize(
      object.subscriptionTier,
      specifiedType: const FullType(FavoriteItemSubscriptionTierEnum),
    );
    yield r'featured';
    yield serializers.serialize(
      object.featured,
      specifiedType: const FullType(bool),
    );
    yield r'isPrestige';
    yield serializers.serialize(
      object.isPrestige,
      specifiedType: const FullType(bool),
    );
    yield r'prestigeScore';
    yield object.prestigeScore == null ? null : serializers.serialize(
      object.prestigeScore,
      specifiedType: const FullType.nullable(num),
    );
    yield r'distanceKm';
    yield object.distanceKm == null ? null : serializers.serialize(
      object.distanceKm,
      specifiedType: const FullType.nullable(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FavoriteItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FavoriteItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'logoUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoUrl = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'neighborhood':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.neighborhood = valueDes;
          break;
        case r'averageRating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.averageRating = valueDes;
          break;
        case r'reviewCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.reviewCount = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.longitude = valueDes;
          break;
        case r'subscriptionTier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FavoriteItemSubscriptionTierEnum),
          ) as FavoriteItemSubscriptionTierEnum;
          result.subscriptionTier = valueDes;
          break;
        case r'featured':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.featured = valueDes;
          break;
        case r'isPrestige':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isPrestige = valueDes;
          break;
        case r'prestigeScore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.prestigeScore = valueDes;
          break;
        case r'distanceKm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.distanceKm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FavoriteItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FavoriteItemBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class FavoriteItemSubscriptionTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const FavoriteItemSubscriptionTierEnum standard = _$favoriteItemSubscriptionTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const FavoriteItemSubscriptionTierEnum premium = _$favoriteItemSubscriptionTierEnum_premium;

  static Serializer<FavoriteItemSubscriptionTierEnum> get serializer => _$favoriteItemSubscriptionTierEnumSerializer;

  const FavoriteItemSubscriptionTierEnum._(String name): super(name);

  static BuiltSet<FavoriteItemSubscriptionTierEnum> get values => _$favoriteItemSubscriptionTierEnumValues;
  static FavoriteItemSubscriptionTierEnum valueOf(String name) => _$favoriteItemSubscriptionTierEnumValueOf(name);
}

