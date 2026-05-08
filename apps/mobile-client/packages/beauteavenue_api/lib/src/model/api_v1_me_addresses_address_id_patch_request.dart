//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_me_addresses_address_id_patch_request.g.dart';

/// ApiV1MeAddressesAddressIdPatchRequest
///
/// Properties:
/// * [label] 
/// * [street] 
/// * [city] 
/// * [isDefault] 
@BuiltValue()
abstract class ApiV1MeAddressesAddressIdPatchRequest implements Built<ApiV1MeAddressesAddressIdPatchRequest, ApiV1MeAddressesAddressIdPatchRequestBuilder> {
  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'street')
  String? get street;

  @BuiltValueField(wireName: r'city')
  String? get city;

  @BuiltValueField(wireName: r'isDefault')
  bool? get isDefault;

  ApiV1MeAddressesAddressIdPatchRequest._();

  factory ApiV1MeAddressesAddressIdPatchRequest([void updates(ApiV1MeAddressesAddressIdPatchRequestBuilder b)]) = _$ApiV1MeAddressesAddressIdPatchRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MeAddressesAddressIdPatchRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MeAddressesAddressIdPatchRequest> get serializer => _$ApiV1MeAddressesAddressIdPatchRequestSerializer();
}

class _$ApiV1MeAddressesAddressIdPatchRequestSerializer implements PrimitiveSerializer<ApiV1MeAddressesAddressIdPatchRequest> {
  @override
  final Iterable<Type> types = const [ApiV1MeAddressesAddressIdPatchRequest, _$ApiV1MeAddressesAddressIdPatchRequest];

  @override
  final String wireName = r'ApiV1MeAddressesAddressIdPatchRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MeAddressesAddressIdPatchRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType(String),
      );
    }
    if (object.street != null) {
      yield r'street';
      yield serializers.serialize(
        object.street,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.city != null) {
      yield r'city';
      yield serializers.serialize(
        object.city,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.isDefault != null) {
      yield r'isDefault';
      yield serializers.serialize(
        object.isDefault,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1MeAddressesAddressIdPatchRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MeAddressesAddressIdPatchRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'street':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.street = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.city = valueDes;
          break;
        case r'isDefault':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isDefault = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1MeAddressesAddressIdPatchRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MeAddressesAddressIdPatchRequestBuilder();
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

