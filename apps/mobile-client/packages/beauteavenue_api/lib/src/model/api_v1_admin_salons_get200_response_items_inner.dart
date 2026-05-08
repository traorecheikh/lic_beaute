//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_salons_get200_response_items_inner.g.dart';

/// ApiV1AdminSalonsGet200ResponseItemsInner
///
/// Properties:
/// * [id] 
/// * [salonName] 
/// * [category] 
/// * [city] 
/// * [ownerName] 
/// * [submittedAt] 
/// * [approvalStatus] 
/// * [subscriptionIntentTier] 
/// * [missingEvidence] 
/// * [latestAdminNote] 
@BuiltValue()
abstract class ApiV1AdminSalonsGet200ResponseItemsInner implements Built<ApiV1AdminSalonsGet200ResponseItemsInner, ApiV1AdminSalonsGet200ResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'salonName')
  String get salonName;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'ownerName')
  String get ownerName;

  @BuiltValueField(wireName: r'submittedAt')
  DateTime get submittedAt;

  @BuiltValueField(wireName: r'approvalStatus')
  ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum get approvalStatus;
  // enum approvalStatusEnum {  pending_review,  needs_info,  approved,  rejected,  };

  @BuiltValueField(wireName: r'subscriptionIntentTier')
  ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum get subscriptionIntentTier;
  // enum subscriptionIntentTierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'missingEvidence')
  BuiltList<String> get missingEvidence;

  @BuiltValueField(wireName: r'latestAdminNote')
  String? get latestAdminNote;

  ApiV1AdminSalonsGet200ResponseItemsInner._();

  factory ApiV1AdminSalonsGet200ResponseItemsInner([void updates(ApiV1AdminSalonsGet200ResponseItemsInnerBuilder b)]) = _$ApiV1AdminSalonsGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminSalonsGet200ResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminSalonsGet200ResponseItemsInner> get serializer => _$ApiV1AdminSalonsGet200ResponseItemsInnerSerializer();
}

class _$ApiV1AdminSalonsGet200ResponseItemsInnerSerializer implements PrimitiveSerializer<ApiV1AdminSalonsGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [ApiV1AdminSalonsGet200ResponseItemsInner, _$ApiV1AdminSalonsGet200ResponseItemsInner];

  @override
  final String wireName = r'ApiV1AdminSalonsGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminSalonsGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'salonName';
    yield serializers.serialize(
      object.salonName,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'ownerName';
    yield serializers.serialize(
      object.ownerName,
      specifiedType: const FullType(String),
    );
    yield r'submittedAt';
    yield serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'approvalStatus';
    yield serializers.serialize(
      object.approvalStatus,
      specifiedType: const FullType(ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum),
    );
    yield r'subscriptionIntentTier';
    yield serializers.serialize(
      object.subscriptionIntentTier,
      specifiedType: const FullType(ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum),
    );
    yield r'missingEvidence';
    yield serializers.serialize(
      object.missingEvidence,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'latestAdminNote';
    yield object.latestAdminNote == null ? null : serializers.serialize(
      object.latestAdminNote,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminSalonsGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminSalonsGet200ResponseItemsInnerBuilder result,
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
        case r'salonName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salonName = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'ownerName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.ownerName = valueDes;
          break;
        case r'submittedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.submittedAt = valueDes;
          break;
        case r'approvalStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum),
          ) as ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum;
          result.approvalStatus = valueDes;
          break;
        case r'subscriptionIntentTier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum),
          ) as ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum;
          result.subscriptionIntentTier = valueDes;
          break;
        case r'missingEvidence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.missingEvidence.replace(valueDes);
          break;
        case r'latestAdminNote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.latestAdminNote = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminSalonsGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminSalonsGet200ResponseItemsInnerBuilder();
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

class ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending_review')
  static const ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum pendingReview = _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_pendingReview;
  @BuiltValueEnumConst(wireName: r'needs_info')
  static const ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum needsInfo = _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_needsInfo;
  @BuiltValueEnumConst(wireName: r'approved')
  static const ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum approved = _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_approved;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum rejected = _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_rejected;

  static Serializer<ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum> get serializer => _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnumSerializer;

  const ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum._(String name): super(name);

  static BuiltSet<ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum> get values => _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnumValues;
  static ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum valueOf(String name) => _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnumValueOf(name);
}

class ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum standard = _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum premium = _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum_premium;

  static Serializer<ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum> get serializer => _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnumSerializer;

  const ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum._(String name): super(name);

  static BuiltSet<ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum> get values => _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnumValues;
  static ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum valueOf(String name) => _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnumValueOf(name);
}

