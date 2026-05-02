//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'updated_response.g.dart';

/// UpdatedResponse
///
/// Properties:
/// * [updated]
@BuiltValue()
abstract class UpdatedResponse
    implements Built<UpdatedResponse, UpdatedResponseBuilder> {
  @BuiltValueField(wireName: r'updated')
  bool get updated;

  UpdatedResponse._();

  factory UpdatedResponse([void updates(UpdatedResponseBuilder b)]) =
      _$UpdatedResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdatedResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdatedResponse> get serializer =>
      _$UpdatedResponseSerializer();
}

class _$UpdatedResponseSerializer
    implements PrimitiveSerializer<UpdatedResponse> {
  @override
  final Iterable<Type> types = const [UpdatedResponse, _$UpdatedResponse];

  @override
  final String wireName = r'UpdatedResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdatedResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'updated';
    yield serializers.serialize(
      object.updated,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdatedResponse object, {
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
    required UpdatedResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'updated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.updated = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdatedResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdatedResponseBuilder();
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
