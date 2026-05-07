//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_input_any_of.g.dart';

/// RegisterInputAnyOf
///
/// Properties:
/// * [type] 
/// * [fullName] 
/// * [email] 
/// * [phone] 
/// * [password] 
@BuiltValue()
abstract class RegisterInputAnyOf implements Built<RegisterInputAnyOf, RegisterInputAnyOfBuilder> {
  @BuiltValueField(wireName: r'type')
  RegisterInputAnyOfTypeEnum get type;
  // enum typeEnum {  client,  };

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'password')
  String get password;

  RegisterInputAnyOf._();

  factory RegisterInputAnyOf([void updates(RegisterInputAnyOfBuilder b)]) = _$RegisterInputAnyOf;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterInputAnyOfBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterInputAnyOf> get serializer => _$RegisterInputAnyOfSerializer();
}

class _$RegisterInputAnyOfSerializer implements PrimitiveSerializer<RegisterInputAnyOf> {
  @override
  final Iterable<Type> types = const [RegisterInputAnyOf, _$RegisterInputAnyOf];

  @override
  final String wireName = r'RegisterInputAnyOf';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterInputAnyOf object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(RegisterInputAnyOfTypeEnum),
    );
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    if (object.email != null) {
      yield r'email';
      yield serializers.serialize(
        object.email,
        specifiedType: const FullType(String),
      );
    }
    if (object.phone != null) {
      yield r'phone';
      yield serializers.serialize(
        object.phone,
        specifiedType: const FullType(String),
      );
    }
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterInputAnyOf object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterInputAnyOfBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegisterInputAnyOfTypeEnum),
          ) as RegisterInputAnyOfTypeEnum;
          result.type = valueDes;
          break;
        case r'fullName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
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
  RegisterInputAnyOf deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterInputAnyOfBuilder();
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

class RegisterInputAnyOfTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'client')
  static const RegisterInputAnyOfTypeEnum client = _$registerInputAnyOfTypeEnum_client;

  static Serializer<RegisterInputAnyOfTypeEnum> get serializer => _$registerInputAnyOfTypeEnumSerializer;

  const RegisterInputAnyOfTypeEnum._(String name): super(name);

  static BuiltSet<RegisterInputAnyOfTypeEnum> get values => _$registerInputAnyOfTypeEnumValues;
  static RegisterInputAnyOfTypeEnum valueOf(String name) => _$registerInputAnyOfTypeEnumValueOf(name);
}

