//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/salon_detail_services_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/salon_detail_staff_inner.dart';
import 'package:beauteavenue_api/src/model/salon_detail_team_display.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'salon_detail.g.dart';

/// SalonDetail
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
/// * [description] 
/// * [address] 
/// * [gallery] 
/// * [services] 
/// * [teamDisplay] 
/// * [staff] 
@BuiltValue()
abstract class SalonDetail implements Built<SalonDetail, SalonDetailBuilder> {
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
  SalonDetailSubscriptionTierEnum get subscriptionTier;
  // enum subscriptionTierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'featured')
  bool get featured;

  @BuiltValueField(wireName: r'isPrestige')
  bool get isPrestige;

  @BuiltValueField(wireName: r'prestigeScore')
  num? get prestigeScore;

  @BuiltValueField(wireName: r'distanceKm')
  num? get distanceKm;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'address')
  String get address;

  @BuiltValueField(wireName: r'gallery')
  BuiltList<String> get gallery;

  @BuiltValueField(wireName: r'services')
  BuiltList<SalonDetailServicesInner> get services;

  @BuiltValueField(wireName: r'teamDisplay')
  SalonDetailTeamDisplay get teamDisplay;

  @BuiltValueField(wireName: r'staff')
  BuiltList<SalonDetailStaffInner> get staff;

  SalonDetail._();

  factory SalonDetail([void updates(SalonDetailBuilder b)]) = _$SalonDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SalonDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SalonDetail> get serializer => _$SalonDetailSerializer();
}

class _$SalonDetailSerializer implements PrimitiveSerializer<SalonDetail> {
  @override
  final Iterable<Type> types = const [SalonDetail, _$SalonDetail];

  @override
  final String wireName = r'SalonDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SalonDetail object, {
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
      specifiedType: const FullType(SalonDetailSubscriptionTierEnum),
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
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(String),
    );
    yield r'gallery';
    yield serializers.serialize(
      object.gallery,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'services';
    yield serializers.serialize(
      object.services,
      specifiedType: const FullType(BuiltList, [FullType(SalonDetailServicesInner)]),
    );
    yield r'teamDisplay';
    yield serializers.serialize(
      object.teamDisplay,
      specifiedType: const FullType(SalonDetailTeamDisplay),
    );
    yield r'staff';
    yield serializers.serialize(
      object.staff,
      specifiedType: const FullType(BuiltList, [FullType(SalonDetailStaffInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SalonDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SalonDetailBuilder result,
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
            specifiedType: const FullType(SalonDetailSubscriptionTierEnum),
          ) as SalonDetailSubscriptionTierEnum;
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
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
          break;
        case r'gallery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.gallery.replace(valueDes);
          break;
        case r'services':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SalonDetailServicesInner)]),
          ) as BuiltList<SalonDetailServicesInner>;
          result.services.replace(valueDes);
          break;
        case r'teamDisplay':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SalonDetailTeamDisplay),
          ) as SalonDetailTeamDisplay;
          result.teamDisplay.replace(valueDes);
          break;
        case r'staff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SalonDetailStaffInner)]),
          ) as BuiltList<SalonDetailStaffInner>;
          result.staff.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SalonDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SalonDetailBuilder();
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

class SalonDetailSubscriptionTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const SalonDetailSubscriptionTierEnum standard = _$salonDetailSubscriptionTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const SalonDetailSubscriptionTierEnum premium = _$salonDetailSubscriptionTierEnum_premium;

  static Serializer<SalonDetailSubscriptionTierEnum> get serializer => _$salonDetailSubscriptionTierEnumSerializer;

  const SalonDetailSubscriptionTierEnum._(String name): super(name);

  static BuiltSet<SalonDetailSubscriptionTierEnum> get values => _$salonDetailSubscriptionTierEnumValues;
  static SalonDetailSubscriptionTierEnum valueOf(String name) => _$salonDetailSubscriptionTierEnumValueOf(name);
}

