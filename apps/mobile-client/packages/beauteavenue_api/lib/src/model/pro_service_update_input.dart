//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_service_update_input.g.dart';

/// ProServiceUpdateInput
///
/// Properties:
/// * [name]
/// * [category]
/// * [durationMinutes]
/// * [priceXof]
/// * [depositMode]
/// * [depositAmountXof]
/// * [depositPercent]
@BuiltValue()
abstract class ProServiceUpdateInput
    implements Built<ProServiceUpdateInput, ProServiceUpdateInputBuilder> {
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'category')
  String? get category;

  @BuiltValueField(wireName: r'durationMinutes')
  int? get durationMinutes;

  @BuiltValueField(wireName: r'priceXof')
  int? get priceXof;

  @BuiltValueField(wireName: r'depositMode')
  ProServiceUpdateInputDepositModeEnum? get depositMode;
  // enum depositModeEnum {  none,  fixed,  percent,  };

  @BuiltValueField(wireName: r'depositAmountXof')
  int? get depositAmountXof;

  @BuiltValueField(wireName: r'depositPercent')
  int? get depositPercent;

  ProServiceUpdateInput._();

  factory ProServiceUpdateInput(
      [void updates(ProServiceUpdateInputBuilder b)]) = _$ProServiceUpdateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProServiceUpdateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProServiceUpdateInput> get serializer =>
      _$ProServiceUpdateInputSerializer();
}

class _$ProServiceUpdateInputSerializer
    implements PrimitiveSerializer<ProServiceUpdateInput> {
  @override
  final Iterable<Type> types = const [
    ProServiceUpdateInput,
    _$ProServiceUpdateInput
  ];

  @override
  final String wireName = r'ProServiceUpdateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProServiceUpdateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
        specifiedType: const FullType(String),
      );
    }
    if (object.category != null) {
      yield r'category';
      yield serializers.serialize(
        object.category,
        specifiedType: const FullType(String),
      );
    }
    if (object.durationMinutes != null) {
      yield r'durationMinutes';
      yield serializers.serialize(
        object.durationMinutes,
        specifiedType: const FullType(int),
      );
    }
    if (object.priceXof != null) {
      yield r'priceXof';
      yield serializers.serialize(
        object.priceXof,
        specifiedType: const FullType(int),
      );
    }
    if (object.depositMode != null) {
      yield r'depositMode';
      yield serializers.serialize(
        object.depositMode,
        specifiedType: const FullType(ProServiceUpdateInputDepositModeEnum),
      );
    }
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
    ProServiceUpdateInput object, {
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
    required ProServiceUpdateInputBuilder result,
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
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
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
            specifiedType: const FullType(ProServiceUpdateInputDepositModeEnum),
          ) as ProServiceUpdateInputDepositModeEnum;
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
  ProServiceUpdateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProServiceUpdateInputBuilder();
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

class ProServiceUpdateInputDepositModeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'none')
  static const ProServiceUpdateInputDepositModeEnum none =
      _$proServiceUpdateInputDepositModeEnum_none;
  @BuiltValueEnumConst(wireName: r'fixed')
  static const ProServiceUpdateInputDepositModeEnum fixed =
      _$proServiceUpdateInputDepositModeEnum_fixed;
  @BuiltValueEnumConst(wireName: r'percent')
  static const ProServiceUpdateInputDepositModeEnum percent =
      _$proServiceUpdateInputDepositModeEnum_percent;

  static Serializer<ProServiceUpdateInputDepositModeEnum> get serializer =>
      _$proServiceUpdateInputDepositModeEnumSerializer;

  const ProServiceUpdateInputDepositModeEnum._(String name) : super(name);

  static BuiltSet<ProServiceUpdateInputDepositModeEnum> get values =>
      _$proServiceUpdateInputDepositModeEnumValues;
  static ProServiceUpdateInputDepositModeEnum valueOf(String name) =>
      _$proServiceUpdateInputDepositModeEnumValueOf(name);
}
