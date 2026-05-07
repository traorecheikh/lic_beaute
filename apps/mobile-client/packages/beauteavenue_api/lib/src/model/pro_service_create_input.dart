//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_service_create_input.g.dart';

/// ProServiceCreateInput
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
abstract class ProServiceCreateInput implements Built<ProServiceCreateInput, ProServiceCreateInputBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String? get category;

  @BuiltValueField(wireName: r'durationMinutes')
  int get durationMinutes;

  @BuiltValueField(wireName: r'priceXof')
  int get priceXof;

  @BuiltValueField(wireName: r'depositMode')
  ProServiceCreateInputDepositModeEnum get depositMode;
  // enum depositModeEnum {  none,  fixed,  percent,  };

  @BuiltValueField(wireName: r'depositAmountXof')
  int? get depositAmountXof;

  @BuiltValueField(wireName: r'depositPercent')
  int? get depositPercent;

  ProServiceCreateInput._();

  factory ProServiceCreateInput([void updates(ProServiceCreateInputBuilder b)]) = _$ProServiceCreateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProServiceCreateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProServiceCreateInput> get serializer => _$ProServiceCreateInputSerializer();
}

class _$ProServiceCreateInputSerializer implements PrimitiveSerializer<ProServiceCreateInput> {
  @override
  final Iterable<Type> types = const [ProServiceCreateInput, _$ProServiceCreateInput];

  @override
  final String wireName = r'ProServiceCreateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProServiceCreateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.category != null) {
      yield r'category';
      yield serializers.serialize(
        object.category,
        specifiedType: const FullType(String),
      );
    }
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
      specifiedType: const FullType(ProServiceCreateInputDepositModeEnum),
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
    ProServiceCreateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProServiceCreateInputBuilder result,
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
            specifiedType: const FullType(ProServiceCreateInputDepositModeEnum),
          ) as ProServiceCreateInputDepositModeEnum;
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
  ProServiceCreateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProServiceCreateInputBuilder();
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

class ProServiceCreateInputDepositModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'none')
  static const ProServiceCreateInputDepositModeEnum none = _$proServiceCreateInputDepositModeEnum_none;
  @BuiltValueEnumConst(wireName: r'fixed')
  static const ProServiceCreateInputDepositModeEnum fixed = _$proServiceCreateInputDepositModeEnum_fixed;
  @BuiltValueEnumConst(wireName: r'percent')
  static const ProServiceCreateInputDepositModeEnum percent = _$proServiceCreateInputDepositModeEnum_percent;

  static Serializer<ProServiceCreateInputDepositModeEnum> get serializer => _$proServiceCreateInputDepositModeEnumSerializer;

  const ProServiceCreateInputDepositModeEnum._(String name): super(name);

  static BuiltSet<ProServiceCreateInputDepositModeEnum> get values => _$proServiceCreateInputDepositModeEnumValues;
  static ProServiceCreateInputDepositModeEnum valueOf(String name) => _$proServiceCreateInputDepositModeEnumValueOf(name);
}

