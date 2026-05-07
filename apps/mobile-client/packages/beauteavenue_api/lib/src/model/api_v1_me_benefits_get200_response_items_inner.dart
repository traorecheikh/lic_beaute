//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_me_benefits_get200_response_items_inner.g.dart';

/// ApiV1MeBenefitsGet200ResponseItemsInner
///
/// Properties:
/// * [id] 
/// * [kind] 
/// * [name] 
/// * [status] 
/// * [remainingUses] 
/// * [expiresAt] 
/// * [billingDate] 
/// * [salonId] 
/// * [salonName] 
/// * [createdAt] 
@BuiltValue()
abstract class ApiV1MeBenefitsGet200ResponseItemsInner implements Built<ApiV1MeBenefitsGet200ResponseItemsInner, ApiV1MeBenefitsGet200ResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum get kind;
  // enum kindEnum {  membership,  package,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum get status;
  // enum statusEnum {  active,  paused,  expired,  exhausted,  cancelled,  };

  @BuiltValueField(wireName: r'remainingUses')
  int? get remainingUses;

  @BuiltValueField(wireName: r'expiresAt')
  String? get expiresAt;

  @BuiltValueField(wireName: r'billingDate')
  String? get billingDate;

  @BuiltValueField(wireName: r'salonId')
  String get salonId;

  @BuiltValueField(wireName: r'salonName')
  String get salonName;

  @BuiltValueField(wireName: r'createdAt')
  String get createdAt;

  ApiV1MeBenefitsGet200ResponseItemsInner._();

  factory ApiV1MeBenefitsGet200ResponseItemsInner([void updates(ApiV1MeBenefitsGet200ResponseItemsInnerBuilder b)]) = _$ApiV1MeBenefitsGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MeBenefitsGet200ResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MeBenefitsGet200ResponseItemsInner> get serializer => _$ApiV1MeBenefitsGet200ResponseItemsInnerSerializer();
}

class _$ApiV1MeBenefitsGet200ResponseItemsInnerSerializer implements PrimitiveSerializer<ApiV1MeBenefitsGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [ApiV1MeBenefitsGet200ResponseItemsInner, _$ApiV1MeBenefitsGet200ResponseItemsInner];

  @override
  final String wireName = r'ApiV1MeBenefitsGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MeBenefitsGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum),
    );
    yield r'remainingUses';
    yield object.remainingUses == null ? null : serializers.serialize(
      object.remainingUses,
      specifiedType: const FullType.nullable(int),
    );
    yield r'expiresAt';
    yield object.expiresAt == null ? null : serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'billingDate';
    yield object.billingDate == null ? null : serializers.serialize(
      object.billingDate,
      specifiedType: const FullType.nullable(String),
    );
    yield r'salonId';
    yield serializers.serialize(
      object.salonId,
      specifiedType: const FullType(String),
    );
    yield r'salonName';
    yield serializers.serialize(
      object.salonName,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MeBenefitsGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MeBenefitsGet200ResponseItemsInnerBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum),
          ) as ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum),
          ) as ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'remainingUses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.remainingUses = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'billingDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.billingDate = valueDes;
          break;
        case r'salonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salonId = valueDes;
          break;
        case r'salonName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salonName = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1MeBenefitsGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MeBenefitsGet200ResponseItemsInnerBuilder();
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

class ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'membership')
  static const ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum membership = _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnum_membership;
  @BuiltValueEnumConst(wireName: r'package')
  static const ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum package = _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnum_package;

  static Serializer<ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum> get serializer => _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnumSerializer;

  const ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum._(String name): super(name);

  static BuiltSet<ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum> get values => _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnumValues;
  static ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum valueOf(String name) => _$apiV1MeBenefitsGet200ResponseItemsInnerKindEnumValueOf(name);
}

class ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'active')
  static const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum active = _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'paused')
  static const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum paused = _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_paused;
  @BuiltValueEnumConst(wireName: r'expired')
  static const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum expired = _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_expired;
  @BuiltValueEnumConst(wireName: r'exhausted')
  static const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum exhausted = _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_exhausted;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum cancelled = _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnum_cancelled;

  static Serializer<ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum> get serializer => _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnumSerializer;

  const ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum> get values => _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnumValues;
  static ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum valueOf(String name) => _$apiV1MeBenefitsGet200ResponseItemsInnerStatusEnumValueOf(name);
}

