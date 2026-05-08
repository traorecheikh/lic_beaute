//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/api_v1_config_pricing_get200_response_standard.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_config_pricing_get200_response.g.dart';

/// ApiV1ConfigPricingGet200Response
///
/// Properties:
/// * [standard] 
/// * [premium] 
/// * [commissionPercent] 
@BuiltValue()
abstract class ApiV1ConfigPricingGet200Response implements Built<ApiV1ConfigPricingGet200Response, ApiV1ConfigPricingGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'standard')
  ApiV1ConfigPricingGet200ResponseStandard get standard;

  @BuiltValueField(wireName: r'premium')
  ApiV1ConfigPricingGet200ResponseStandard get premium;

  @BuiltValueField(wireName: r'commissionPercent')
  num get commissionPercent;

  ApiV1ConfigPricingGet200Response._();

  factory ApiV1ConfigPricingGet200Response([void updates(ApiV1ConfigPricingGet200ResponseBuilder b)]) = _$ApiV1ConfigPricingGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1ConfigPricingGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1ConfigPricingGet200Response> get serializer => _$ApiV1ConfigPricingGet200ResponseSerializer();
}

class _$ApiV1ConfigPricingGet200ResponseSerializer implements PrimitiveSerializer<ApiV1ConfigPricingGet200Response> {
  @override
  final Iterable<Type> types = const [ApiV1ConfigPricingGet200Response, _$ApiV1ConfigPricingGet200Response];

  @override
  final String wireName = r'ApiV1ConfigPricingGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1ConfigPricingGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'standard';
    yield serializers.serialize(
      object.standard,
      specifiedType: const FullType(ApiV1ConfigPricingGet200ResponseStandard),
    );
    yield r'premium';
    yield serializers.serialize(
      object.premium,
      specifiedType: const FullType(ApiV1ConfigPricingGet200ResponseStandard),
    );
    yield r'commissionPercent';
    yield serializers.serialize(
      object.commissionPercent,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1ConfigPricingGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1ConfigPricingGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'standard':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1ConfigPricingGet200ResponseStandard),
          ) as ApiV1ConfigPricingGet200ResponseStandard;
          result.standard.replace(valueDes);
          break;
        case r'premium':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ApiV1ConfigPricingGet200ResponseStandard),
          ) as ApiV1ConfigPricingGet200ResponseStandard;
          result.premium.replace(valueDes);
          break;
        case r'commissionPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.commissionPercent = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1ConfigPricingGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1ConfigPricingGet200ResponseBuilder();
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

