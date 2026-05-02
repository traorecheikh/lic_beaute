//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_service.g.dart';

/// ProService
///
/// Properties:
/// * [id]
/// * [name]
/// * [category]
/// * [durationMinutes]
/// * [priceXof]
/// * [depositMode]
/// * [depositAmountXof]
/// * [depositPercent]
/// * [isActive]
/// * [displayOrder]
@BuiltValue()
abstract class ProService implements Built<ProService, ProServiceBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'durationMinutes')
  int get durationMinutes;

  @BuiltValueField(wireName: r'priceXof')
  int get priceXof;

  @BuiltValueField(wireName: r'depositMode')
  ProServiceDepositModeEnum get depositMode;
  // enum depositModeEnum {  none,  fixed,  percent,  };

  @BuiltValueField(wireName: r'depositAmountXof')
  int? get depositAmountXof;

  @BuiltValueField(wireName: r'depositPercent')
  int? get depositPercent;

  @BuiltValueField(wireName: r'isActive')
  bool get isActive;

  @BuiltValueField(wireName: r'displayOrder')
  int get displayOrder;

  ProService._();

  factory ProService([void updates(ProServiceBuilder b)]) = _$ProService;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProServiceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProService> get serializer => _$ProServiceSerializer();
}

class _$ProServiceSerializer implements PrimitiveSerializer<ProService> {
  @override
  final Iterable<Type> types = const [ProService, _$ProService];

  @override
  final String wireName = r'ProService';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProService object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
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
      specifiedType: const FullType(ProServiceDepositModeEnum),
    );
    yield r'depositAmountXof';
    yield object.depositAmountXof == null
        ? null
        : serializers.serialize(
            object.depositAmountXof,
            specifiedType: const FullType.nullable(int),
          );
    yield r'depositPercent';
    yield object.depositPercent == null
        ? null
        : serializers.serialize(
            object.depositPercent,
            specifiedType: const FullType.nullable(int),
          );
    yield r'isActive';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
    yield r'displayOrder';
    yield serializers.serialize(
      object.displayOrder,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProService object, {
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
    required ProServiceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
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
            specifiedType: const FullType(ProServiceDepositModeEnum),
          ) as ProServiceDepositModeEnum;
          result.depositMode = valueDes;
          break;
        case r'depositAmountXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.depositAmountXof = valueDes;
          break;
        case r'depositPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.depositPercent = valueDes;
          break;
        case r'isActive':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isActive = valueDes;
          break;
        case r'displayOrder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.displayOrder = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProService deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProServiceBuilder();
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

class ProServiceDepositModeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'none')
  static const ProServiceDepositModeEnum none =
      _$proServiceDepositModeEnum_none;
  @BuiltValueEnumConst(wireName: r'fixed')
  static const ProServiceDepositModeEnum fixed =
      _$proServiceDepositModeEnum_fixed;
  @BuiltValueEnumConst(wireName: r'percent')
  static const ProServiceDepositModeEnum percent =
      _$proServiceDepositModeEnum_percent;

  static Serializer<ProServiceDepositModeEnum> get serializer =>
      _$proServiceDepositModeEnumSerializer;

  const ProServiceDepositModeEnum._(String name) : super(name);

  static BuiltSet<ProServiceDepositModeEnum> get values =>
      _$proServiceDepositModeEnumValues;
  static ProServiceDepositModeEnum valueOf(String name) =>
      _$proServiceDepositModeEnumValueOf(name);
}
