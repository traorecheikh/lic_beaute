//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_pro_vouchers_post201_response.g.dart';

/// ApiV1ProVouchersPost201Response
///
/// Properties:
/// * [id] 
/// * [code] 
/// * [title] 
/// * [description] 
/// * [discountLabel] 
/// * [expiresAt] 
/// * [maxRedemptions] 
@BuiltValue()
abstract class ApiV1ProVouchersPost201Response implements Built<ApiV1ProVouchersPost201Response, ApiV1ProVouchersPost201ResponseBuilder> {
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

  @BuiltValueField(wireName: r'expiresAt')
  String? get expiresAt;

  @BuiltValueField(wireName: r'maxRedemptions')
  int? get maxRedemptions;

  ApiV1ProVouchersPost201Response._();

  factory ApiV1ProVouchersPost201Response([void updates(ApiV1ProVouchersPost201ResponseBuilder b)]) = _$ApiV1ProVouchersPost201Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ProVouchersPost201ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ProVouchersPost201Response> get serializer => _$ApiV1ProVouchersPost201ResponseSerializer();
}

class _$ApiV1ProVouchersPost201ResponseSerializer implements PrimitiveSerializer<ApiV1ProVouchersPost201Response> {
  @override
  final Iterable<Type> types = const [ApiV1ProVouchersPost201Response, _$ApiV1ProVouchersPost201Response];

  @override
  final String wireName = r'ApiV1ProVouchersPost201Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ProVouchersPost201Response object, {
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
    yield r'expiresAt';
    yield object.expiresAt == null ? null : serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'maxRedemptions';
    yield object.maxRedemptions == null ? null : serializers.serialize(
      object.maxRedemptions,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ProVouchersPost201Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ProVouchersPost201ResponseBuilder result,
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
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'maxRedemptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxRedemptions = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1ProVouchersPost201Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ProVouchersPost201ResponseBuilder();
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

