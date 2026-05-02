//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'salon_summary.g.dart';

/// SalonSummary
///
/// Properties:
/// * [id]
/// * [name]
/// * [category]
/// * [logoUrl]
/// * [city]
/// * [neighborhood]
/// * [averageRating]
/// * [latitude]
/// * [longitude]
/// * [subscriptionTier]
/// * [featured]
/// * [isPrestige]
/// * [prestigeScore]
/// * [distanceKm]
@BuiltValue()
abstract class SalonSummary
    implements Built<SalonSummary, SalonSummaryBuilder> {
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

  @BuiltValueField(wireName: r'latitude')
  num? get latitude;

  @BuiltValueField(wireName: r'longitude')
  num? get longitude;

  @BuiltValueField(wireName: r'subscriptionTier')
  SalonSummarySubscriptionTierEnum get subscriptionTier;
  // enum subscriptionTierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'featured')
  bool get featured;

  @BuiltValueField(wireName: r'isPrestige')
  bool get isPrestige;

  @BuiltValueField(wireName: r'prestigeScore')
  num? get prestigeScore;

  @BuiltValueField(wireName: r'distanceKm')
  num? get distanceKm;

  SalonSummary._();

  factory SalonSummary([void updates(SalonSummaryBuilder b)]) = _$SalonSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SalonSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SalonSummary> get serializer => _$SalonSummarySerializer();
}

class _$SalonSummarySerializer implements PrimitiveSerializer<SalonSummary> {
  @override
  final Iterable<Type> types = const [SalonSummary, _$SalonSummary];

  @override
  final String wireName = r'SalonSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SalonSummary object, {
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
    yield object.logoUrl == null
        ? null
        : serializers.serialize(
            object.logoUrl,
            specifiedType: const FullType.nullable(String),
          );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'neighborhood';
    yield object.neighborhood == null
        ? null
        : serializers.serialize(
            object.neighborhood,
            specifiedType: const FullType.nullable(String),
          );
    yield r'averageRating';
    yield serializers.serialize(
      object.averageRating,
      specifiedType: const FullType(num),
    );
    yield r'latitude';
    yield object.latitude == null
        ? null
        : serializers.serialize(
            object.latitude,
            specifiedType: const FullType.nullable(num),
          );
    yield r'longitude';
    yield object.longitude == null
        ? null
        : serializers.serialize(
            object.longitude,
            specifiedType: const FullType.nullable(num),
          );
    yield r'subscriptionTier';
    yield serializers.serialize(
      object.subscriptionTier,
      specifiedType: const FullType(SalonSummarySubscriptionTierEnum),
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
    yield object.prestigeScore == null
        ? null
        : serializers.serialize(
            object.prestigeScore,
            specifiedType: const FullType.nullable(num),
          );
    yield r'distanceKm';
    yield object.distanceKm == null
        ? null
        : serializers.serialize(
            object.distanceKm,
            specifiedType: const FullType.nullable(num),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    SalonSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SalonSummaryBuilder result,
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
            specifiedType: const FullType(SalonSummarySubscriptionTierEnum),
          ) as SalonSummarySubscriptionTierEnum;
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
  SalonSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SalonSummaryBuilder();
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

class SalonSummarySubscriptionTierEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'standard')
  static const SalonSummarySubscriptionTierEnum standard =
      _$salonSummarySubscriptionTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const SalonSummarySubscriptionTierEnum premium =
      _$salonSummarySubscriptionTierEnum_premium;

  static Serializer<SalonSummarySubscriptionTierEnum> get serializer =>
      _$salonSummarySubscriptionTierEnumSerializer;

  const SalonSummarySubscriptionTierEnum._(String name) : super(name);

  static BuiltSet<SalonSummarySubscriptionTierEnum> get values =>
      _$salonSummarySubscriptionTierEnumValues;
  static SalonSummarySubscriptionTierEnum valueOf(String name) =>
      _$salonSummarySubscriptionTierEnumValueOf(name);
}
