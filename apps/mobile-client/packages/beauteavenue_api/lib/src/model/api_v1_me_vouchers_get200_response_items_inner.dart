//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_me_vouchers_get200_response_items_inner.g.dart';

/// ApiV1MeVouchersGet200ResponseItemsInner
///
/// Properties:
/// * [id] 
/// * [code] 
/// * [title] 
/// * [description] 
/// * [discountLabel] 
/// * [status] 
/// * [expiresAt] 
/// * [redeemedAt] 
/// * [usedAt] 
/// * [salonId] 
/// * [salonName] 
@BuiltValue()
abstract class ApiV1MeVouchersGet200ResponseItemsInner implements Built<ApiV1MeVouchersGet200ResponseItemsInner, ApiV1MeVouchersGet200ResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'discountLabel')
  String get discountLabel;

  @BuiltValueField(wireName: r'status')
  ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum get status;
  // enum statusEnum {  active,  used,  expired,  };

  @BuiltValueField(wireName: r'expiresAt')
  String? get expiresAt;

  @BuiltValueField(wireName: r'redeemedAt')
  String get redeemedAt;

  @BuiltValueField(wireName: r'usedAt')
  String? get usedAt;

  @BuiltValueField(wireName: r'salonId')
  String? get salonId;

  @BuiltValueField(wireName: r'salonName')
  String? get salonName;

  ApiV1MeVouchersGet200ResponseItemsInner._();

  factory ApiV1MeVouchersGet200ResponseItemsInner([void updates(ApiV1MeVouchersGet200ResponseItemsInnerBuilder b)]) = _$ApiV1MeVouchersGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MeVouchersGet200ResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MeVouchersGet200ResponseItemsInner> get serializer => _$ApiV1MeVouchersGet200ResponseItemsInnerSerializer();
}

class _$ApiV1MeVouchersGet200ResponseItemsInnerSerializer implements PrimitiveSerializer<ApiV1MeVouchersGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [ApiV1MeVouchersGet200ResponseItemsInner, _$ApiV1MeVouchersGet200ResponseItemsInner];

  @override
  final String wireName = r'ApiV1MeVouchersGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MeVouchersGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'discountLabel';
    yield serializers.serialize(
      object.discountLabel,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum),
    );
    yield r'expiresAt';
    yield object.expiresAt == null ? null : serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'redeemedAt';
    yield serializers.serialize(
      object.redeemedAt,
      specifiedType: const FullType(String),
    );
    yield r'usedAt';
    yield object.usedAt == null ? null : serializers.serialize(
      object.usedAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'salonId';
    yield object.salonId == null ? null : serializers.serialize(
      object.salonId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'salonName';
    yield object.salonName == null ? null : serializers.serialize(
      object.salonName,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MeVouchersGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MeVouchersGet200ResponseItemsInnerBuilder result,
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'discountLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.discountLabel = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum),
          ) as ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'redeemedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.redeemedAt = valueDes;
          break;
        case r'usedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.usedAt = valueDes;
          break;
        case r'salonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.salonId = valueDes;
          break;
        case r'salonName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.salonName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1MeVouchersGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MeVouchersGet200ResponseItemsInnerBuilder();
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

class ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'active')
  static const ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum active = _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'used')
  static const ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum used = _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnum_used;
  @BuiltValueEnumConst(wireName: r'expired')
  static const ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum expired = _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnum_expired;

  static Serializer<ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum> get serializer => _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnumSerializer;

  const ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum> get values => _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnumValues;
  static ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum valueOf(String name) => _$apiV1MeVouchersGet200ResponseItemsInnerStatusEnumValueOf(name);
}

