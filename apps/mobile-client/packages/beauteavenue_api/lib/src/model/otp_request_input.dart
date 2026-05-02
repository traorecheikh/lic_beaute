//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'otp_request_input.g.dart';

/// OtpRequestInput
///
/// Properties:
/// * [phone]
@BuiltValue()
abstract class OtpRequestInput
    implements Built<OtpRequestInput, OtpRequestInputBuilder> {
  @BuiltValueField(wireName: r'phone')
  String get phone;

  OtpRequestInput._();

  factory OtpRequestInput([void updates(OtpRequestInputBuilder b)]) =
      _$OtpRequestInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OtpRequestInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OtpRequestInput> get serializer =>
      _$OtpRequestInputSerializer();
}

class _$OtpRequestInputSerializer
    implements PrimitiveSerializer<OtpRequestInput> {
  @override
  final Iterable<Type> types = const [OtpRequestInput, _$OtpRequestInput];

  @override
  final String wireName = r'OtpRequestInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OtpRequestInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OtpRequestInput object, {
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
    required OtpRequestInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OtpRequestInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OtpRequestInputBuilder();
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
