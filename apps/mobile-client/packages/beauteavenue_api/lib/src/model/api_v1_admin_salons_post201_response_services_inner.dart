//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_salons_post201_response_services_inner.g.dart';

/// ApiV1AdminSalonsPost201ResponseServicesInner
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [durationMinutes] 
/// * [priceXof] 
/// * [depositMode] 
/// * [depositAmountXof] 
/// * [depositPercent] 
@BuiltValue()
abstract class ApiV1AdminSalonsPost201ResponseServicesInner implements Built<ApiV1AdminSalonsPost201ResponseServicesInner, ApiV1AdminSalonsPost201ResponseServicesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'durationMinutes')
  int get durationMinutes;

  @BuiltValueField(wireName: r'priceXof')
  int get priceXof;

  @BuiltValueField(wireName: r'depositMode')
  ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum get depositMode;
  // enum depositModeEnum {  none,  fixed,  percent,  };

  @BuiltValueField(wireName: r'depositAmountXof')
  int? get depositAmountXof;

  @BuiltValueField(wireName: r'depositPercent')
  int? get depositPercent;

  ApiV1AdminSalonsPost201ResponseServicesInner._();

  factory ApiV1AdminSalonsPost201ResponseServicesInner([void updates(ApiV1AdminSalonsPost201ResponseServicesInnerBuilder b)]) = _$ApiV1AdminSalonsPost201ResponseServicesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminSalonsPost201ResponseServicesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminSalonsPost201ResponseServicesInner> get serializer => _$ApiV1AdminSalonsPost201ResponseServicesInnerSerializer();
}

class _$ApiV1AdminSalonsPost201ResponseServicesInnerSerializer implements PrimitiveSerializer<ApiV1AdminSalonsPost201ResponseServicesInner> {
  @override
  final Iterable<Type> types = const [ApiV1AdminSalonsPost201ResponseServicesInner, _$ApiV1AdminSalonsPost201ResponseServicesInner];

  @override
  final String wireName = r'ApiV1AdminSalonsPost201ResponseServicesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminSalonsPost201ResponseServicesInner object, {
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
      specifiedType: const FullType(ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum),
    );
    yield r'depositAmountXof';
    yield object.depositAmountXof == null ? null : serializers.serialize(
      object.depositAmountXof,
      specifiedType: const FullType.nullable(int),
    );
    yield r'depositPercent';
    yield object.depositPercent == null ? null : serializers.serialize(
      object.depositPercent,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminSalonsPost201ResponseServicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminSalonsPost201ResponseServicesInnerBuilder result,
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
            specifiedType: const FullType(ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum),
          ) as ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminSalonsPost201ResponseServicesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminSalonsPost201ResponseServicesInnerBuilder();
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

class ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'none')
  static const ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum none = _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum_none;
  @BuiltValueEnumConst(wireName: r'fixed')
  static const ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum fixed = _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum_fixed;
  @BuiltValueEnumConst(wireName: r'percent')
  static const ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum percent = _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum_percent;

  static Serializer<ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum> get serializer => _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnumSerializer;

  const ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum._(String name): super(name);

  static BuiltSet<ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum> get values => _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnumValues;
  static ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum valueOf(String name) => _$apiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnumValueOf(name);
}

