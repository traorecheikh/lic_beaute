//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'salon_summary_list_response_items_inner.g.dart';

/// SalonSummaryListResponseItemsInner
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
abstract class SalonSummaryListResponseItemsInner implements Built<SalonSummaryListResponseItemsInner, SalonSummaryListResponseItemsInnerBuilder> {
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
  SalonSummaryListResponseItemsInnerSubscriptionTierEnum get subscriptionTier;
  // enum subscriptionTierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'featured')
  bool get featured;

  @BuiltValueField(wireName: r'isPrestige')
  bool get isPrestige;

  @BuiltValueField(wireName: r'prestigeScore')
  num? get prestigeScore;

  @BuiltValueField(wireName: r'distanceKm')
  num? get distanceKm;

  SalonSummaryListResponseItemsInner._();

  factory SalonSummaryListResponseItemsInner([void updates(SalonSummaryListResponseItemsInnerBuilder b)]) = _$SalonSummaryListResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SalonSummaryListResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SalonSummaryListResponseItemsInner> get serializer => _$SalonSummaryListResponseItemsInnerSerializer();
}

class _$SalonSummaryListResponseItemsInnerSerializer implements PrimitiveSerializer<SalonSummaryListResponseItemsInner> {
  @override
  final Iterable<Type> types = const [SalonSummaryListResponseItemsInner, _$SalonSummaryListResponseItemsInner];

  @override
  final String wireName = r'SalonSummaryListResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SalonSummaryListResponseItemsInner object, {
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
      specifiedType: const FullType(SalonSummaryListResponseItemsInnerSubscriptionTierEnum),
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
    SalonSummaryListResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SalonSummaryListResponseItemsInnerBuilder result,
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
            specifiedType: const FullType(SalonSummaryListResponseItemsInnerSubscriptionTierEnum),
          ) as SalonSummaryListResponseItemsInnerSubscriptionTierEnum;
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
  SalonSummaryListResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SalonSummaryListResponseItemsInnerBuilder();
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

class SalonSummaryListResponseItemsInnerSubscriptionTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const SalonSummaryListResponseItemsInnerSubscriptionTierEnum standard = _$salonSummaryListResponseItemsInnerSubscriptionTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const SalonSummaryListResponseItemsInnerSubscriptionTierEnum premium = _$salonSummaryListResponseItemsInnerSubscriptionTierEnum_premium;

  static Serializer<SalonSummaryListResponseItemsInnerSubscriptionTierEnum> get serializer => _$salonSummaryListResponseItemsInnerSubscriptionTierEnumSerializer;

  const SalonSummaryListResponseItemsInnerSubscriptionTierEnum._(String name): super(name);

  static BuiltSet<SalonSummaryListResponseItemsInnerSubscriptionTierEnum> get values => _$salonSummaryListResponseItemsInnerSubscriptionTierEnumValues;
  static SalonSummaryListResponseItemsInnerSubscriptionTierEnum valueOf(String name) => _$salonSummaryListResponseItemsInnerSubscriptionTierEnumValueOf(name);
}

