//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/salon_detail_team_display.dart';
import 'package:beauteavenue_api/src/model/pro_salon_profile_hours_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_salon_profile.g.dart';

/// ProSalonProfile
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [category] 
/// * [logoUrl] 
/// * [description] 
/// * [city] 
/// * [address] 
/// * [neighborhood] 
/// * [latitude] 
/// * [longitude] 
/// * [phone] 
/// * [instagram] 
/// * [averageRating] 
/// * [reviewCount] 
/// * [subscriptionTier] 
/// * [isVisibleInMarketplace] 
/// * [canReceiveBookings] 
/// * [approvalStatus] 
/// * [teamDisplay] 
/// * [gallery] 
/// * [hours] 
@BuiltValue()
abstract class ProSalonProfile implements Built<ProSalonProfile, ProSalonProfileBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'logoUrl')
  String? get logoUrl;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'address')
  String get address;

  @BuiltValueField(wireName: r'neighborhood')
  String? get neighborhood;

  @BuiltValueField(wireName: r'latitude')
  num? get latitude;

  @BuiltValueField(wireName: r'longitude')
  num? get longitude;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'instagram')
  String? get instagram;

  @BuiltValueField(wireName: r'averageRating')
  num get averageRating;

  @BuiltValueField(wireName: r'reviewCount')
  int get reviewCount;

  @BuiltValueField(wireName: r'subscriptionTier')
  ProSalonProfileSubscriptionTierEnum get subscriptionTier;
  // enum subscriptionTierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'isVisibleInMarketplace')
  bool get isVisibleInMarketplace;

  @BuiltValueField(wireName: r'canReceiveBookings')
  bool get canReceiveBookings;

  @BuiltValueField(wireName: r'approvalStatus')
  ProSalonProfileApprovalStatusEnum get approvalStatus;
  // enum approvalStatusEnum {  pending_review,  needs_info,  approved,  rejected,  };

  @BuiltValueField(wireName: r'teamDisplay')
  SalonDetailTeamDisplay get teamDisplay;

  @BuiltValueField(wireName: r'gallery')
  BuiltList<String> get gallery;

  @BuiltValueField(wireName: r'hours')
  BuiltList<ProSalonProfileHoursInner> get hours;

  ProSalonProfile._();

  factory ProSalonProfile([void updates(ProSalonProfileBuilder b)]) = _$ProSalonProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProSalonProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProSalonProfile> get serializer => _$ProSalonProfileSerializer();
}

class _$ProSalonProfileSerializer implements PrimitiveSerializer<ProSalonProfile> {
  @override
  final Iterable<Type> types = const [ProSalonProfile, _$ProSalonProfile];

  @override
  final String wireName = r'ProSalonProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProSalonProfile object, {
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
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(String),
    );
    yield r'neighborhood';
    yield object.neighborhood == null ? null : serializers.serialize(
      object.neighborhood,
      specifiedType: const FullType.nullable(String),
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
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'instagram';
    yield object.instagram == null ? null : serializers.serialize(
      object.instagram,
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
    yield r'subscriptionTier';
    yield serializers.serialize(
      object.subscriptionTier,
      specifiedType: const FullType(ProSalonProfileSubscriptionTierEnum),
    );
    yield r'isVisibleInMarketplace';
    yield serializers.serialize(
      object.isVisibleInMarketplace,
      specifiedType: const FullType(bool),
    );
    yield r'canReceiveBookings';
    yield serializers.serialize(
      object.canReceiveBookings,
      specifiedType: const FullType(bool),
    );
    yield r'approvalStatus';
    yield serializers.serialize(
      object.approvalStatus,
      specifiedType: const FullType(ProSalonProfileApprovalStatusEnum),
    );
    yield r'teamDisplay';
    yield serializers.serialize(
      object.teamDisplay,
      specifiedType: const FullType(SalonDetailTeamDisplay),
    );
    yield r'gallery';
    yield serializers.serialize(
      object.gallery,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'hours';
    yield serializers.serialize(
      object.hours,
      specifiedType: const FullType(BuiltList, [FullType(ProSalonProfileHoursInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProSalonProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProSalonProfileBuilder result,
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
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
          break;
        case r'neighborhood':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.neighborhood = valueDes;
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
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'instagram':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.instagram = valueDes;
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
        case r'subscriptionTier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProSalonProfileSubscriptionTierEnum),
          ) as ProSalonProfileSubscriptionTierEnum;
          result.subscriptionTier = valueDes;
          break;
        case r'isVisibleInMarketplace':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isVisibleInMarketplace = valueDes;
          break;
        case r'canReceiveBookings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canReceiveBookings = valueDes;
          break;
        case r'approvalStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProSalonProfileApprovalStatusEnum),
          ) as ProSalonProfileApprovalStatusEnum;
          result.approvalStatus = valueDes;
          break;
        case r'teamDisplay':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SalonDetailTeamDisplay),
          ) as SalonDetailTeamDisplay;
          result.teamDisplay.replace(valueDes);
          break;
        case r'gallery':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.gallery.replace(valueDes);
          break;
        case r'hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProSalonProfileHoursInner)]),
          ) as BuiltList<ProSalonProfileHoursInner>;
          result.hours.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProSalonProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProSalonProfileBuilder();
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

class ProSalonProfileSubscriptionTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const ProSalonProfileSubscriptionTierEnum standard = _$proSalonProfileSubscriptionTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const ProSalonProfileSubscriptionTierEnum premium = _$proSalonProfileSubscriptionTierEnum_premium;

  static Serializer<ProSalonProfileSubscriptionTierEnum> get serializer => _$proSalonProfileSubscriptionTierEnumSerializer;

  const ProSalonProfileSubscriptionTierEnum._(String name): super(name);

  static BuiltSet<ProSalonProfileSubscriptionTierEnum> get values => _$proSalonProfileSubscriptionTierEnumValues;
  static ProSalonProfileSubscriptionTierEnum valueOf(String name) => _$proSalonProfileSubscriptionTierEnumValueOf(name);
}

class ProSalonProfileApprovalStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending_review')
  static const ProSalonProfileApprovalStatusEnum pendingReview = _$proSalonProfileApprovalStatusEnum_pendingReview;
  @BuiltValueEnumConst(wireName: r'needs_info')
  static const ProSalonProfileApprovalStatusEnum needsInfo = _$proSalonProfileApprovalStatusEnum_needsInfo;
  @BuiltValueEnumConst(wireName: r'approved')
  static const ProSalonProfileApprovalStatusEnum approved = _$proSalonProfileApprovalStatusEnum_approved;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const ProSalonProfileApprovalStatusEnum rejected = _$proSalonProfileApprovalStatusEnum_rejected;

  static Serializer<ProSalonProfileApprovalStatusEnum> get serializer => _$proSalonProfileApprovalStatusEnumSerializer;

  const ProSalonProfileApprovalStatusEnum._(String name): super(name);

  static BuiltSet<ProSalonProfileApprovalStatusEnum> get values => _$proSalonProfileApprovalStatusEnumValues;
  static ProSalonProfileApprovalStatusEnum valueOf(String name) => _$proSalonProfileApprovalStatusEnumValueOf(name);
}

