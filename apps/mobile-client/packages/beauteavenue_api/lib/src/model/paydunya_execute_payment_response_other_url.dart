//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paydunya_execute_payment_response_other_url.g.dart';

/// PaydunyaExecutePaymentResponseOtherUrl
///
/// Properties:
/// * [omUrl] 
/// * [maxitUrl] 
@BuiltValue()
abstract class PaydunyaExecutePaymentResponseOtherUrl implements Built<PaydunyaExecutePaymentResponseOtherUrl, PaydunyaExecutePaymentResponseOtherUrlBuilder> {
  @BuiltValueField(wireName: r'om_url')
  String? get omUrl;

  @BuiltValueField(wireName: r'maxit_url')
  String? get maxitUrl;

  PaydunyaExecutePaymentResponseOtherUrl._();

  factory PaydunyaExecutePaymentResponseOtherUrl([void updates(PaydunyaExecutePaymentResponseOtherUrlBuilder b)]) = _$PaydunyaExecutePaymentResponseOtherUrl;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaydunyaExecutePaymentResponseOtherUrlBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaydunyaExecutePaymentResponseOtherUrl> get serializer => _$PaydunyaExecutePaymentResponseOtherUrlSerializer();
}

class _$PaydunyaExecutePaymentResponseOtherUrlSerializer implements PrimitiveSerializer<PaydunyaExecutePaymentResponseOtherUrl> {
  @override
  final Iterable<Type> types = const [PaydunyaExecutePaymentResponseOtherUrl, _$PaydunyaExecutePaymentResponseOtherUrl];

  @override
  final String wireName = r'PaydunyaExecutePaymentResponseOtherUrl';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaydunyaExecutePaymentResponseOtherUrl object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.omUrl != null) {
      yield r'om_url';
      yield serializers.serialize(
        object.omUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.maxitUrl != null) {
      yield r'maxit_url';
      yield serializers.serialize(
        object.maxitUrl,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PaydunyaExecutePaymentResponseOtherUrl object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaydunyaExecutePaymentResponseOtherUrlBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'om_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.omUrl = valueDes;
          break;
        case r'maxit_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.maxitUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaydunyaExecutePaymentResponseOtherUrl deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaydunyaExecutePaymentResponseOtherUrlBuilder();
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

