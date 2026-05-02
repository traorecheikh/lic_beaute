//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_salon_queue_item.g.dart';

/// AdminSalonQueueItem
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
abstract class AdminSalonQueueItem
    implements Built<AdminSalonQueueItem, AdminSalonQueueItemBuilder> {
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
  AdminSalonQueueItemApprovalStatusEnum get approvalStatus;
  // enum approvalStatusEnum {  pending_review,  needs_info,  approved,  rejected,  };

  @BuiltValueField(wireName: r'subscriptionIntentTier')
  AdminSalonQueueItemSubscriptionIntentTierEnum get subscriptionIntentTier;
  // enum subscriptionIntentTierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'missingEvidence')
  BuiltList<String> get missingEvidence;

  @BuiltValueField(wireName: r'latestAdminNote')
  String? get latestAdminNote;

  AdminSalonQueueItem._();

  factory AdminSalonQueueItem([void updates(AdminSalonQueueItemBuilder b)]) =
      _$AdminSalonQueueItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSalonQueueItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSalonQueueItem> get serializer =>
      _$AdminSalonQueueItemSerializer();
}

class _$AdminSalonQueueItemSerializer
    implements PrimitiveSerializer<AdminSalonQueueItem> {
  @override
  final Iterable<Type> types = const [
    AdminSalonQueueItem,
    _$AdminSalonQueueItem
  ];

  @override
  final String wireName = r'AdminSalonQueueItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSalonQueueItem object, {
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
      specifiedType: const FullType(AdminSalonQueueItemApprovalStatusEnum),
    );
    yield r'subscriptionIntentTier';
    yield serializers.serialize(
      object.subscriptionIntentTier,
      specifiedType:
          const FullType(AdminSalonQueueItemSubscriptionIntentTierEnum),
    );
    yield r'missingEvidence';
    yield serializers.serialize(
      object.missingEvidence,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'latestAdminNote';
    yield object.latestAdminNote == null
        ? null
        : serializers.serialize(
            object.latestAdminNote,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSalonQueueItem object, {
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
    required AdminSalonQueueItemBuilder result,
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
            specifiedType:
                const FullType(AdminSalonQueueItemApprovalStatusEnum),
          ) as AdminSalonQueueItemApprovalStatusEnum;
          result.approvalStatus = valueDes;
          break;
        case r'subscriptionIntentTier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(AdminSalonQueueItemSubscriptionIntentTierEnum),
          ) as AdminSalonQueueItemSubscriptionIntentTierEnum;
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
  AdminSalonQueueItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSalonQueueItemBuilder();
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

class AdminSalonQueueItemApprovalStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending_review')
  static const AdminSalonQueueItemApprovalStatusEnum pendingReview =
      _$adminSalonQueueItemApprovalStatusEnum_pendingReview;
  @BuiltValueEnumConst(wireName: r'needs_info')
  static const AdminSalonQueueItemApprovalStatusEnum needsInfo =
      _$adminSalonQueueItemApprovalStatusEnum_needsInfo;
  @BuiltValueEnumConst(wireName: r'approved')
  static const AdminSalonQueueItemApprovalStatusEnum approved =
      _$adminSalonQueueItemApprovalStatusEnum_approved;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminSalonQueueItemApprovalStatusEnum rejected =
      _$adminSalonQueueItemApprovalStatusEnum_rejected;

  static Serializer<AdminSalonQueueItemApprovalStatusEnum> get serializer =>
      _$adminSalonQueueItemApprovalStatusEnumSerializer;

  const AdminSalonQueueItemApprovalStatusEnum._(String name) : super(name);

  static BuiltSet<AdminSalonQueueItemApprovalStatusEnum> get values =>
      _$adminSalonQueueItemApprovalStatusEnumValues;
  static AdminSalonQueueItemApprovalStatusEnum valueOf(String name) =>
      _$adminSalonQueueItemApprovalStatusEnumValueOf(name);
}

class AdminSalonQueueItemSubscriptionIntentTierEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'standard')
  static const AdminSalonQueueItemSubscriptionIntentTierEnum standard =
      _$adminSalonQueueItemSubscriptionIntentTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const AdminSalonQueueItemSubscriptionIntentTierEnum premium =
      _$adminSalonQueueItemSubscriptionIntentTierEnum_premium;

  static Serializer<AdminSalonQueueItemSubscriptionIntentTierEnum>
      get serializer =>
          _$adminSalonQueueItemSubscriptionIntentTierEnumSerializer;

  const AdminSalonQueueItemSubscriptionIntentTierEnum._(String name)
      : super(name);

  static BuiltSet<AdminSalonQueueItemSubscriptionIntentTierEnum> get values =>
      _$adminSalonQueueItemSubscriptionIntentTierEnumValues;
  static AdminSalonQueueItemSubscriptionIntentTierEnum valueOf(String name) =>
      _$adminSalonQueueItemSubscriptionIntentTierEnumValueOf(name);
}
