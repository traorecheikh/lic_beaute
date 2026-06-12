//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'email_otp_request_input.g.dart';

/// EmailOtpRequestInput
///
/// Properties:
/// * [email] 
@BuiltValue()
abstract class EmailOtpRequestInput implements Built<EmailOtpRequestInput, EmailOtpRequestInputBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  EmailOtpRequestInput._();

  factory EmailOtpRequestInput([void updates(EmailOtpRequestInputBuilder b)]) = _$EmailOtpRequestInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmailOtpRequestInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmailOtpRequestInput> get serializer => _$EmailOtpRequestInputSerializer();
}

class _$EmailOtpRequestInputSerializer implements PrimitiveSerializer<EmailOtpRequestInput> {
  @override
  final Iterable<Type> types = const [EmailOtpRequestInput, _$EmailOtpRequestInput];

  @override
  final String wireName = r'EmailOtpRequestInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmailOtpRequestInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmailOtpRequestInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmailOtpRequestInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmailOtpRequestInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmailOtpRequestInputBuilder();
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

