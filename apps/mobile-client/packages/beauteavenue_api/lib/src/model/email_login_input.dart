//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'email_login_input.g.dart';

/// EmailLoginInput
///
/// Properties:
/// * [email]
/// * [password]
@BuiltValue()
abstract class EmailLoginInput
    implements Built<EmailLoginInput, EmailLoginInputBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'password')
  String get password;

  EmailLoginInput._();

  factory EmailLoginInput([void updates(EmailLoginInputBuilder b)]) =
      _$EmailLoginInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmailLoginInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmailLoginInput> get serializer =>
      _$EmailLoginInputSerializer();
}

class _$EmailLoginInputSerializer
    implements PrimitiveSerializer<EmailLoginInput> {
  @override
  final Iterable<Type> types = const [EmailLoginInput, _$EmailLoginInput];

  @override
  final String wireName = r'EmailLoginInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmailLoginInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmailLoginInput object, {
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
    required EmailLoginInputBuilder result,
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
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmailLoginInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmailLoginInputBuilder();
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
