//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_input_any_of1_services_inner.g.dart';

/// RegisterInputAnyOf1ServicesInner
///
/// Properties:
/// * [name] 
/// * [durationMinutes] 
/// * [priceXof] 
/// * [depositMode] 
/// * [depositAmountXof] 
/// * [depositPercent] 
@BuiltValue()
abstract class RegisterInputAnyOf1ServicesInner implements Built<RegisterInputAnyOf1ServicesInner, RegisterInputAnyOf1ServicesInnerBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'durationMinutes')
  int get durationMinutes;

  @BuiltValueField(wireName: r'priceXof')
  int get priceXof;

  @BuiltValueField(wireName: r'depositMode')
  RegisterInputAnyOf1ServicesInnerDepositModeEnum get depositMode;
  // enum depositModeEnum {  none,  fixed,  percent,  };

  @BuiltValueField(wireName: r'depositAmountXof')
  int? get depositAmountXof;

  @BuiltValueField(wireName: r'depositPercent')
  int? get depositPercent;

  RegisterInputAnyOf1ServicesInner._();

  factory RegisterInputAnyOf1ServicesInner([void updates(RegisterInputAnyOf1ServicesInnerBuilder b)]) = _$RegisterInputAnyOf1ServicesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterInputAnyOf1ServicesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterInputAnyOf1ServicesInner> get serializer => _$RegisterInputAnyOf1ServicesInnerSerializer();
}

class _$RegisterInputAnyOf1ServicesInnerSerializer implements PrimitiveSerializer<RegisterInputAnyOf1ServicesInner> {
  @override
  final Iterable<Type> types = const [RegisterInputAnyOf1ServicesInner, _$RegisterInputAnyOf1ServicesInner];

  @override
  final String wireName = r'RegisterInputAnyOf1ServicesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterInputAnyOf1ServicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'durationMinutes';
    yield serializers.serialize(
      object.durationMinutes,
      specifiedType: const FullType(int),
    );
    yield r'priceXof';
    yield serializers.serialize(
      object.priceXof,
      specifiedType: const FullType(int),
    );
    yield r'depositMode';
    yield serializers.serialize(
      object.depositMode,
      specifiedType: const FullType(RegisterInputAnyOf1ServicesInnerDepositModeEnum),
    );
    if (object.depositAmountXof != null) {
      yield r'depositAmountXof';
      yield serializers.serialize(
        object.depositAmountXof,
        specifiedType: const FullType(int),
      );
    }
    if (object.depositPercent != null) {
      yield r'depositPercent';
      yield serializers.serialize(
        object.depositPercent,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterInputAnyOf1ServicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterInputAnyOf1ServicesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'durationMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationMinutes = valueDes;
          break;
        case r'priceXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.priceXof = valueDes;
          break;
        case r'depositMode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegisterInputAnyOf1ServicesInnerDepositModeEnum),
          ) as RegisterInputAnyOf1ServicesInnerDepositModeEnum;
          result.depositMode = valueDes;
          break;
        case r'depositAmountXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.depositAmountXof = valueDes;
          break;
        case r'depositPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.depositPercent = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegisterInputAnyOf1ServicesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterInputAnyOf1ServicesInnerBuilder();
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

class RegisterInputAnyOf1ServicesInnerDepositModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'none')
  static const RegisterInputAnyOf1ServicesInnerDepositModeEnum none = _$registerInputAnyOf1ServicesInnerDepositModeEnum_none;
  @BuiltValueEnumConst(wireName: r'fixed')
  static const RegisterInputAnyOf1ServicesInnerDepositModeEnum fixed = _$registerInputAnyOf1ServicesInnerDepositModeEnum_fixed;
  @BuiltValueEnumConst(wireName: r'percent')
  static const RegisterInputAnyOf1ServicesInnerDepositModeEnum percent = _$registerInputAnyOf1ServicesInnerDepositModeEnum_percent;

  static Serializer<RegisterInputAnyOf1ServicesInnerDepositModeEnum> get serializer => _$registerInputAnyOf1ServicesInnerDepositModeEnumSerializer;

  const RegisterInputAnyOf1ServicesInnerDepositModeEnum._(String name): super(name);

  static BuiltSet<RegisterInputAnyOf1ServicesInnerDepositModeEnum> get values => _$registerInputAnyOf1ServicesInnerDepositModeEnumValues;
  static RegisterInputAnyOf1ServicesInnerDepositModeEnum valueOf(String name) => _$registerInputAnyOf1ServicesInnerDepositModeEnumValueOf(name);
}

