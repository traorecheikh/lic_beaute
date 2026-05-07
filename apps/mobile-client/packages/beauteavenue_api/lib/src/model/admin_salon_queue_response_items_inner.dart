//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_salon_queue_response_items_inner.g.dart';

/// AdminSalonQueueResponseItemsInner
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
abstract class AdminSalonQueueResponseItemsInner implements Built<AdminSalonQueueResponseItemsInner, AdminSalonQueueResponseItemsInnerBuilder> {
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
  AdminSalonQueueResponseItemsInnerApprovalStatusEnum get approvalStatus;
  // enum approvalStatusEnum {  pending_review,  needs_info,  approved,  rejected,  };

  @BuiltValueField(wireName: r'subscriptionIntentTier')
  AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum get subscriptionIntentTier;
  // enum subscriptionIntentTierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'missingEvidence')
  BuiltList<String> get missingEvidence;

  @BuiltValueField(wireName: r'latestAdminNote')
  String? get latestAdminNote;

  AdminSalonQueueResponseItemsInner._();

  factory AdminSalonQueueResponseItemsInner([void updates(AdminSalonQueueResponseItemsInnerBuilder b)]) = _$AdminSalonQueueResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSalonQueueResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSalonQueueResponseItemsInner> get serializer => _$AdminSalonQueueResponseItemsInnerSerializer();
}

class _$AdminSalonQueueResponseItemsInnerSerializer implements PrimitiveSerializer<AdminSalonQueueResponseItemsInner> {
  @override
  final Iterable<Type> types = const [AdminSalonQueueResponseItemsInner, _$AdminSalonQueueResponseItemsInner];

  @override
  final String wireName = r'AdminSalonQueueResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSalonQueueResponseItemsInner object, {
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
      specifiedType: const FullType(AdminSalonQueueResponseItemsInnerApprovalStatusEnum),
    );
    yield r'subscriptionIntentTier';
    yield serializers.serialize(
      object.subscriptionIntentTier,
      specifiedType: const FullType(AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum),
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
    AdminSalonQueueResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSalonQueueResponseItemsInnerBuilder result,
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
            specifiedType: const FullType(AdminSalonQueueResponseItemsInnerApprovalStatusEnum),
          ) as AdminSalonQueueResponseItemsInnerApprovalStatusEnum;
          result.approvalStatus = valueDes;
          break;
        case r'subscriptionIntentTier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum),
          ) as AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum;
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
  AdminSalonQueueResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSalonQueueResponseItemsInnerBuilder();
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

class AdminSalonQueueResponseItemsInnerApprovalStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending_review')
  static const AdminSalonQueueResponseItemsInnerApprovalStatusEnum pendingReview = _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_pendingReview;
  @BuiltValueEnumConst(wireName: r'needs_info')
  static const AdminSalonQueueResponseItemsInnerApprovalStatusEnum needsInfo = _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_needsInfo;
  @BuiltValueEnumConst(wireName: r'approved')
  static const AdminSalonQueueResponseItemsInnerApprovalStatusEnum approved = _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_approved;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminSalonQueueResponseItemsInnerApprovalStatusEnum rejected = _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_rejected;

  static Serializer<AdminSalonQueueResponseItemsInnerApprovalStatusEnum> get serializer => _$adminSalonQueueResponseItemsInnerApprovalStatusEnumSerializer;

  const AdminSalonQueueResponseItemsInnerApprovalStatusEnum._(String name): super(name);

  static BuiltSet<AdminSalonQueueResponseItemsInnerApprovalStatusEnum> get values => _$adminSalonQueueResponseItemsInnerApprovalStatusEnumValues;
  static AdminSalonQueueResponseItemsInnerApprovalStatusEnum valueOf(String name) => _$adminSalonQueueResponseItemsInnerApprovalStatusEnumValueOf(name);
}

class AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum standard = _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum premium = _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum_premium;

  static Serializer<AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum> get serializer => _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnumSerializer;

  const AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum._(String name): super(name);

  static BuiltSet<AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum> get values => _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnumValues;
  static AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum valueOf(String name) => _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnumValueOf(name);
}

