//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'otp_verify_input.g.dart';

/// OtpVerifyInput
///
/// Properties:
/// * [phone] 
/// * [code] 
@BuiltValue()
abstract class OtpVerifyInput implements Built<OtpVerifyInput, OtpVerifyInputBuilder> {
  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'code')
  String get code;

  OtpVerifyInput._();

  factory OtpVerifyInput([void updates(OtpVerifyInputBuilder b)]) = _$OtpVerifyInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OtpVerifyInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OtpVerifyInput> get serializer => _$OtpVerifyInputSerializer();
}

class _$OtpVerifyInputSerializer implements PrimitiveSerializer<OtpVerifyInput> {
  @override
  final Iterable<Type> types = const [OtpVerifyInput, _$OtpVerifyInput];

  @override
  final String wireName = r'OtpVerifyInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OtpVerifyInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OtpVerifyInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OtpVerifyInputBuilder result,
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OtpVerifyInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OtpVerifyInputBuilder();
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

