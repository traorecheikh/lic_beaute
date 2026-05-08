//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_config_pricing_get200_response_standard.g.dart';

/// ApiV1ConfigPricingGet200ResponseStandard
///
/// Properties:
/// * [tier] 
/// * [priceXof] 
/// * [label] 
@BuiltValue()
abstract class ApiV1ConfigPricingGet200ResponseStandard implements Built<ApiV1ConfigPricingGet200ResponseStandard, ApiV1ConfigPricingGet200ResponseStandardBuilder> {
  @BuiltValueField(wireName: r'tier')
  String get tier;

  @BuiltValueField(wireName: r'priceXof')
  int get priceXof;

  @BuiltValueField(wireName: r'label')
  String get label;

  ApiV1ConfigPricingGet200ResponseStandard._();

  factory ApiV1ConfigPricingGet200ResponseStandard([void updates(ApiV1ConfigPricingGet200ResponseStandardBuilder b)]) = _$ApiV1ConfigPricingGet200ResponseStandard;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ConfigPricingGet200ResponseStandardBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ConfigPricingGet200ResponseStandard> get serializer => _$ApiV1ConfigPricingGet200ResponseStandardSerializer();
}

class _$ApiV1ConfigPricingGet200ResponseStandardSerializer implements PrimitiveSerializer<ApiV1ConfigPricingGet200ResponseStandard> {
  @override
  final Iterable<Type> types = const [ApiV1ConfigPricingGet200ResponseStandard, _$ApiV1ConfigPricingGet200ResponseStandard];

  @override
  final String wireName = r'ApiV1ConfigPricingGet200ResponseStandard';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ConfigPricingGet200ResponseStandard object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(String),
    );
    yield r'priceXof';
    yield serializers.serialize(
      object.priceXof,
      specifiedType: const FullType(int),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ConfigPricingGet200ResponseStandard object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ConfigPricingGet200ResponseStandardBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tier = valueDes;
          break;
        case r'priceXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.priceXof = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1ConfigPricingGet200ResponseStandard deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ConfigPricingGet200ResponseStandardBuilder();
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

