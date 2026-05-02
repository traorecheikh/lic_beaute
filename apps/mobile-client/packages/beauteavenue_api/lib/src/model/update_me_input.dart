//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_me_input.g.dart';

/// UpdateMeInput
///
/// Properties:
/// * [fullName]
@BuiltValue()
abstract class UpdateMeInput
    implements Built<UpdateMeInput, UpdateMeInputBuilder> {
  @BuiltValueField(wireName: r'fullName')
  String? get fullName;

  UpdateMeInput._();

  factory UpdateMeInput([void updates(UpdateMeInputBuilder b)]) =
      _$UpdateMeInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateMeInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateMeInput> get serializer =>
      _$UpdateMeInputSerializer();
}

class _$UpdateMeInputSerializer implements PrimitiveSerializer<UpdateMeInput> {
  @override
  final Iterable<Type> types = const [UpdateMeInput, _$UpdateMeInput];

  @override
  final String wireName = r'UpdateMeInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateMeInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.fullName != null) {
      yield r'fullName';
      yield serializers.serialize(
        object.fullName,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateMeInput object, {
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
    required UpdateMeInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fullName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateMeInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateMeInputBuilder();
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
