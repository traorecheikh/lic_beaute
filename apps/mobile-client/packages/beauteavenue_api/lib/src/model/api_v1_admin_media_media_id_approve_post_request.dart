//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_media_media_id_approve_post_request.g.dart';

/// ApiV1AdminMediaMediaIdApprovePostRequest
///
/// Properties:
/// * [purpose] 
/// * [displayOrder] 
@BuiltValue()
abstract class ApiV1AdminMediaMediaIdApprovePostRequest implements Built<ApiV1AdminMediaMediaIdApprovePostRequest, ApiV1AdminMediaMediaIdApprovePostRequestBuilder> {
  @BuiltValueField(wireName: r'purpose')
  String? get purpose;

  @BuiltValueField(wireName: r'displayOrder')
  int? get displayOrder;

  ApiV1AdminMediaMediaIdApprovePostRequest._();

  factory ApiV1AdminMediaMediaIdApprovePostRequest([void updates(ApiV1AdminMediaMediaIdApprovePostRequestBuilder b)]) = _$ApiV1AdminMediaMediaIdApprovePostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminMediaMediaIdApprovePostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminMediaMediaIdApprovePostRequest> get serializer => _$ApiV1AdminMediaMediaIdApprovePostRequestSerializer();
}

class _$ApiV1AdminMediaMediaIdApprovePostRequestSerializer implements PrimitiveSerializer<ApiV1AdminMediaMediaIdApprovePostRequest> {
  @override
  final Iterable<Type> types = const [ApiV1AdminMediaMediaIdApprovePostRequest, _$ApiV1AdminMediaMediaIdApprovePostRequest];

  @override
  final String wireName = r'ApiV1AdminMediaMediaIdApprovePostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminMediaMediaIdApprovePostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.purpose != null) {
      yield r'purpose';
      yield serializers.serialize(
        object.purpose,
        specifiedType: const FullType(String),
      );
    }
    if (object.displayOrder != null) {
      yield r'displayOrder';
      yield serializers.serialize(
        object.displayOrder,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminMediaMediaIdApprovePostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminMediaMediaIdApprovePostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.purpose = valueDes;
          break;
        case r'displayOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.displayOrder = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminMediaMediaIdApprovePostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminMediaMediaIdApprovePostRequestBuilder();
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

