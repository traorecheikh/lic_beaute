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

part 'api_v1_admin_salons_post201_response.g.dart';

/// ApiV1AdminSalonsPost201Response
///
/// Properties:
/// * [id] 
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
/// * [temporaryPassword] 
@BuiltValue()
abstract class ApiV1AdminSalonsPost201Response implements Built<ApiV1AdminSalonsPost201Response, ApiV1AdminSalonsPost201ResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

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
  ApiV1AdminSalonsPost201ResponseApprovalStatusEnum get approvalStatus;
  // enum approvalStatusEnum {  pending_review,  needs_info,  approved,  rejected,  };

  @BuiltValueField(wireName: r'subscriptionIntentTier')
  ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum get subscriptionIntentTier;
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

  @BuiltValueField(wireName: r'temporaryPassword')
  String? get temporaryPassword;

  ApiV1AdminSalonsPost201Response._();

  factory ApiV1AdminSalonsPost201Response([void updates(ApiV1AdminSalonsPost201ResponseBuilder b)]) = _$ApiV1AdminSalonsPost201Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminSalonsPost201ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminSalonsPost201Response> get serializer => _$ApiV1AdminSalonsPost201ResponseSerializer();
}

class _$ApiV1AdminSalonsPost201ResponseSerializer implements PrimitiveSerializer<ApiV1AdminSalonsPost201Response> {
  @override
  final Iterable<Type> types = const [ApiV1AdminSalonsPost201Response, _$ApiV1AdminSalonsPost201Response];

  @override
  final String wireName = r'ApiV1AdminSalonsPost201Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminSalonsPost201Response object, {
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
      specifiedType: const FullType(ApiV1AdminSalonsPost201ResponseApprovalStatusEnum),
    );
    yield r'subscriptionIntentTier';
    yield serializers.serialize(
      object.subscriptionIntentTier,
      specifiedType: const FullType(ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum),
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
    yield r'temporaryPassword';
    yield object.temporaryPassword == null ? null : serializers.serialize(
      object.temporaryPassword,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminSalonsPost201Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminSalonsPost201ResponseBuilder result,
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
            specifiedType: const FullType(ApiV1AdminSalonsPost201ResponseApprovalStatusEnum),
          ) as ApiV1AdminSalonsPost201ResponseApprovalStatusEnum;
          result.approvalStatus = valueDes;
          break;
        case r'subscriptionIntentTier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum),
          ) as ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum;
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
        case r'temporaryPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.temporaryPassword = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminSalonsPost201Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminSalonsPost201ResponseBuilder();
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

class ApiV1AdminSalonsPost201ResponseApprovalStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending_review')
  static const ApiV1AdminSalonsPost201ResponseApprovalStatusEnum pendingReview = _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_pendingReview;
  @BuiltValueEnumConst(wireName: r'needs_info')
  static const ApiV1AdminSalonsPost201ResponseApprovalStatusEnum needsInfo = _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_needsInfo;
  @BuiltValueEnumConst(wireName: r'approved')
  static const ApiV1AdminSalonsPost201ResponseApprovalStatusEnum approved = _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_approved;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const ApiV1AdminSalonsPost201ResponseApprovalStatusEnum rejected = _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_rejected;

  static Serializer<ApiV1AdminSalonsPost201ResponseApprovalStatusEnum> get serializer => _$apiV1AdminSalonsPost201ResponseApprovalStatusEnumSerializer;

  const ApiV1AdminSalonsPost201ResponseApprovalStatusEnum._(String name): super(name);

  static BuiltSet<ApiV1AdminSalonsPost201ResponseApprovalStatusEnum> get values => _$apiV1AdminSalonsPost201ResponseApprovalStatusEnumValues;
  static ApiV1AdminSalonsPost201ResponseApprovalStatusEnum valueOf(String name) => _$apiV1AdminSalonsPost201ResponseApprovalStatusEnumValueOf(name);
}

class ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum standard = _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum premium = _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum_premium;

  static Serializer<ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum> get serializer => _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnumSerializer;

  const ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum._(String name): super(name);

  static BuiltSet<ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum> get values => _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnumValues;
  static ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum valueOf(String name) => _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnumValueOf(name);
}

