//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/register_input_any_of1.dart';
import 'package:beauteavenue_api/src/model/register_input_any_of.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/any_of.dart';

part 'register_input.g.dart';

/// RegisterInput
///
/// Properties:
/// * [type]
/// * [fullName]
/// * [email]
/// * [phone]
/// * [password]
/// * [salon]
/// * [services]
/// * [hours]
@BuiltValue()
abstract class RegisterInput
    implements Built<RegisterInput, RegisterInputBuilder> {
  /// Any Of [RegisterInputAnyOf], [RegisterInputAnyOf1]
  AnyOf get anyOf;

  RegisterInput._();

  factory RegisterInput([void updates(RegisterInputBuilder b)]) =
      _$RegisterInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterInput> get serializer =>
      _$RegisterInputSerializer();
}

class _$RegisterInputSerializer implements PrimitiveSerializer<RegisterInput> {
  @override
  final Iterable<Type> types = const [RegisterInput, _$RegisterInput];

  @override
  final String wireName = r'RegisterInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterInput object) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    RegisterInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final anyOf = object.anyOf;
    return serializers.serialize(anyOf,
        specifiedType: FullType(
            AnyOf, anyOf.valueTypes.map((type) => FullType(type)).toList()))!;
  }

  @override
  RegisterInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterInputBuilder();
    Object? anyOfDataSrc;
    final targetType = const FullType(AnyOf, [
      FullType(RegisterInputAnyOf),
      FullType(RegisterInputAnyOf1),
    ]);
    anyOfDataSrc = serialized;
    result.anyOf = serializers.deserialize(anyOfDataSrc,
        specifiedType: targetType) as AnyOf;
    return result.build();
  }
}

class RegisterInputTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'client')
  static const RegisterInputTypeEnum client = _$registerInputTypeEnum_client;
  @BuiltValueEnumConst(wireName: r'salon_owner')
  static const RegisterInputTypeEnum salonOwner =
      _$registerInputTypeEnum_salonOwner;

  static Serializer<RegisterInputTypeEnum> get serializer =>
      _$registerInputTypeEnumSerializer;

  const RegisterInputTypeEnum._(String name) : super(name);

  static BuiltSet<RegisterInputTypeEnum> get values =>
      _$registerInputTypeEnumValues;
  static RegisterInputTypeEnum valueOf(String name) =>
      _$registerInputTypeEnumValueOf(name);
}
