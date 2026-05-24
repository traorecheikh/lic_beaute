//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/paydunya_method_list_response_methods_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paydunya_method_list_response.g.dart';

/// PaydunyaMethodListResponse
///
/// Properties:
/// * [methods] 
@BuiltValue()
abstract class PaydunyaMethodListResponse implements Built<PaydunyaMethodListResponse, PaydunyaMethodListResponseBuilder> {
  @BuiltValueField(wireName: r'methods')
  BuiltList<PaydunyaMethodListResponseMethodsInner> get methods;

  PaydunyaMethodListResponse._();

  factory PaydunyaMethodListResponse([void updates(PaydunyaMethodListResponseBuilder b)]) = _$PaydunyaMethodListResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaydunyaMethodListResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaydunyaMethodListResponse> get serializer => _$PaydunyaMethodListResponseSerializer();
}

class _$PaydunyaMethodListResponseSerializer implements PrimitiveSerializer<PaydunyaMethodListResponse> {
  @override
  final Iterable<Type> types = const [PaydunyaMethodListResponse, _$PaydunyaMethodListResponse];

  @override
  final String wireName = r'PaydunyaMethodListResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaydunyaMethodListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'methods';
    yield serializers.serialize(
      object.methods,
      specifiedType: const FullType(BuiltList, [FullType(PaydunyaMethodListResponseMethodsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaydunyaMethodListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaydunyaMethodListResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'methods':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PaydunyaMethodListResponseMethodsInner)]),
          ) as BuiltList<PaydunyaMethodListResponseMethodsInner>;
          result.methods.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaydunyaMethodListResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaydunyaMethodListResponseBuilder();
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

