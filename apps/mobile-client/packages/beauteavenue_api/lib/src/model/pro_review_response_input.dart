//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_review_response_input.g.dart';

/// ProReviewResponseInput
///
/// Properties:
/// * [responseText] 
@BuiltValue()
abstract class ProReviewResponseInput implements Built<ProReviewResponseInput, ProReviewResponseInputBuilder> {
  @BuiltValueField(wireName: r'responseText')
  String get responseText;

  ProReviewResponseInput._();

  factory ProReviewResponseInput([void updates(ProReviewResponseInputBuilder b)]) = _$ProReviewResponseInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProReviewResponseInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProReviewResponseInput> get serializer => _$ProReviewResponseInputSerializer();
}

class _$ProReviewResponseInputSerializer implements PrimitiveSerializer<ProReviewResponseInput> {
  @override
  final Iterable<Type> types = const [ProReviewResponseInput, _$ProReviewResponseInput];

  @override
  final String wireName = r'ProReviewResponseInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProReviewResponseInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'responseText';
    yield serializers.serialize(
      object.responseText,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProReviewResponseInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProReviewResponseInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'responseText':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.responseText = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProReviewResponseInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProReviewResponseInputBuilder();
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

