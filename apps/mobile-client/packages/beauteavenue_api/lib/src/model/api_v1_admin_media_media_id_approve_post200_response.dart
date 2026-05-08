//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_media_media_id_approve_post200_response.g.dart';

/// ApiV1AdminMediaMediaIdApprovePost200Response
///
/// Properties:
/// * [approved] 
/// * [publicUrl] 
@BuiltValue()
abstract class ApiV1AdminMediaMediaIdApprovePost200Response implements Built<ApiV1AdminMediaMediaIdApprovePost200Response, ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder> {
  @BuiltValueField(wireName: r'approved')
  bool get approved;

  @BuiltValueField(wireName: r'publicUrl')
  String? get publicUrl;

  ApiV1AdminMediaMediaIdApprovePost200Response._();

  factory ApiV1AdminMediaMediaIdApprovePost200Response([void updates(ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder b)]) = _$ApiV1AdminMediaMediaIdApprovePost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminMediaMediaIdApprovePost200Response> get serializer => _$ApiV1AdminMediaMediaIdApprovePost200ResponseSerializer();
}

class _$ApiV1AdminMediaMediaIdApprovePost200ResponseSerializer implements PrimitiveSerializer<ApiV1AdminMediaMediaIdApprovePost200Response> {
  @override
  final Iterable<Type> types = const [ApiV1AdminMediaMediaIdApprovePost200Response, _$ApiV1AdminMediaMediaIdApprovePost200Response];

  @override
  final String wireName = r'ApiV1AdminMediaMediaIdApprovePost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminMediaMediaIdApprovePost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'approved';
    yield serializers.serialize(
      object.approved,
      specifiedType: const FullType(bool),
    );
    yield r'publicUrl';
    yield object.publicUrl == null ? null : serializers.serialize(
      object.publicUrl,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminMediaMediaIdApprovePost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'approved':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.approved = valueDes;
          break;
        case r'publicUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminMediaMediaIdApprovePost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminMediaMediaIdApprovePost200ResponseBuilder();
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

