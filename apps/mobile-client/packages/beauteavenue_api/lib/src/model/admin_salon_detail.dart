//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/api_v1_admin_salons_post201_response_documents_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/api_v1_admin_salons_post201_response_owner.dart';
import 'package:beauteavenue_api/src/model/api_v1_admin_salons_post201_response_services_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_salon_detail.g.dart';

/// AdminSalonDetail
///
/// Properties:
/// * [id] 
/// * [subscriptionId] 
/// * [salonName] 
/// * [category] 
/// * [city] 
/// * [address] 
/// * [description] 
/// * [owner] 
/// * [approvalStatus] 
/// * [subscriptionIntentTier] 
/// * [submittedAt] 
/// * [missingEvidence] 
/// * [latestAdminNote] 
/// * [gallery] 
/// * [services] 
/// * [documents] 
@BuiltValue()
abstract class AdminSalonDetail implements Built<AdminSalonDetail, AdminSalonDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'subscriptionId')
  String? get subscriptionId;

  @BuiltValueField(wireName: r'salonName')
  String get salonName;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'address')
  String get address;

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'owner')
  ApiV1AdminSalonsPost201ResponseOwner get owner;

  @BuiltValueField(wireName: r'approvalStatus')
  AdminSalonDetailApprovalStatusEnum get approvalStatus;
  // enum approvalStatusEnum {  pending_review,  needs_info,  approved,  rejected,  };

  @BuiltValueField(wireName: r'subscriptionIntentTier')
  AdminSalonDetailSubscriptionIntentTierEnum get subscriptionIntentTier;
  // enum subscriptionIntentTierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'submittedAt')
  DateTime get submittedAt;

  @BuiltValueField(wireName: r'missingEvidence')
  BuiltList<String> get missingEvidence;

  @BuiltValueField(wireName: r'latestAdminNote')
  String? get latestAdminNote;

  @BuiltValueField(wireName: r'gallery')
  BuiltList<String> get gallery;

  @BuiltValueField(wireName: r'services')
  BuiltList<ApiV1AdminSalonsPost201ResponseServicesInner> get services;

  @BuiltValueField(wireName: r'documents')
  BuiltList<ApiV1AdminSalonsPost201ResponseDocumentsInner> get documents;

  AdminSalonDetail._();

  factory AdminSalonDetail([void updates(AdminSalonDetailBuilder b)]) = _$AdminSalonDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSalonDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSalonDetail> get serializer => _$AdminSalonDetailSerializer();
}

class _$AdminSalonDetailSerializer implements PrimitiveSerializer<AdminSalonDetail> {
  @override
  final Iterable<Type> types = const [AdminSalonDetail, _$AdminSalonDetail];

  @override
  final String wireName = r'AdminSalonDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSalonDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'subscriptionId';
    yield object.subscriptionId == null ? null : serializers.serialize(
      object.subscriptionId,
      specifiedType: const FullType.nullable(String),
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
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'owner';
    yield serializers.serialize(
      object.owner,
      specifiedType: const FullType(ApiV1AdminSalonsPost201ResponseOwner),
    );
    yield r'approvalStatus';
    yield serializers.serialize(
      object.approvalStatus,
      specifiedType: const FullType(AdminSalonDetailApprovalStatusEnum),
    );
    yield r'subscriptionIntentTier';
    yield serializers.serialize(
      object.subscriptionIntentTier,
      specifiedType: const FullType(AdminSalonDetailSubscriptionIntentTierEnum),
    );
    yield r'submittedAt';
    yield serializers.serialize(
      object.submittedAt,
      specifiedType: const FullType(DateTime),
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
    yield r'gallery';
    yield serializers.serialize(
      object.gallery,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'services';
    yield serializers.serialize(
      object.services,
      specifiedType: const FullType(BuiltList, [FullType(ApiV1AdminSalonsPost201ResponseServicesInner)]),
    );
    yield r'documents';
    yield serializers.serialize(
      object.documents,
      specifiedType: const FullType(BuiltList, [FullType(ApiV1AdminSalonsPost201ResponseDocumentsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSalonDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSalonDetailBuilder result,
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
        case r'subscriptionId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.subscriptionId = valueDes;
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
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'owner':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1AdminSalonsPost201ResponseOwner),
          ) as ApiV1AdminSalonsPost201ResponseOwner;
          result.owner.replace(valueDes);
          break;
        case r'approvalStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSalonDetailApprovalStatusEnum),
          ) as AdminSalonDetailApprovalStatusEnum;
          result.approvalStatus = valueDes;
          break;
        case r'subscriptionIntentTier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSalonDetailSubscriptionIntentTierEnum),
          ) as AdminSalonDetailSubscriptionIntentTierEnum;
          result.subscriptionIntentTier = valueDes;
          break;
        case r'submittedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.submittedAt = valueDes;
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
            specifiedType: const FullType(BuiltList, [FullType(ApiV1AdminSalonsPost201ResponseServicesInner)]),
          ) as BuiltList<ApiV1AdminSalonsPost201ResponseServicesInner>;
          result.services.replace(valueDes);
          break;
        case r'documents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ApiV1AdminSalonsPost201ResponseDocumentsInner)]),
          ) as BuiltList<ApiV1AdminSalonsPost201ResponseDocumentsInner>;
          result.documents.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSalonDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSalonDetailBuilder();
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

class AdminSalonDetailApprovalStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending_review')
  static const AdminSalonDetailApprovalStatusEnum pendingReview = _$adminSalonDetailApprovalStatusEnum_pendingReview;
  @BuiltValueEnumConst(wireName: r'needs_info')
  static const AdminSalonDetailApprovalStatusEnum needsInfo = _$adminSalonDetailApprovalStatusEnum_needsInfo;
  @BuiltValueEnumConst(wireName: r'approved')
  static const AdminSalonDetailApprovalStatusEnum approved = _$adminSalonDetailApprovalStatusEnum_approved;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminSalonDetailApprovalStatusEnum rejected = _$adminSalonDetailApprovalStatusEnum_rejected;

  static Serializer<AdminSalonDetailApprovalStatusEnum> get serializer => _$adminSalonDetailApprovalStatusEnumSerializer;

  const AdminSalonDetailApprovalStatusEnum._(String name): super(name);

  static BuiltSet<AdminSalonDetailApprovalStatusEnum> get values => _$adminSalonDetailApprovalStatusEnumValues;
  static AdminSalonDetailApprovalStatusEnum valueOf(String name) => _$adminSalonDetailApprovalStatusEnumValueOf(name);
}

class AdminSalonDetailSubscriptionIntentTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const AdminSalonDetailSubscriptionIntentTierEnum standard = _$adminSalonDetailSubscriptionIntentTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const AdminSalonDetailSubscriptionIntentTierEnum premium = _$adminSalonDetailSubscriptionIntentTierEnum_premium;

  static Serializer<AdminSalonDetailSubscriptionIntentTierEnum> get serializer => _$adminSalonDetailSubscriptionIntentTierEnumSerializer;

  const AdminSalonDetailSubscriptionIntentTierEnum._(String name): super(name);

  static BuiltSet<AdminSalonDetailSubscriptionIntentTierEnum> get values => _$adminSalonDetailSubscriptionIntentTierEnumValues;
  static AdminSalonDetailSubscriptionIntentTierEnum valueOf(String name) => _$adminSalonDetailSubscriptionIntentTierEnumValueOf(name);
}

