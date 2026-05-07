//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_initiate_response.g.dart';

/// PaymentInitiateResponse
///
/// Properties:
/// * [paymentId] 
/// * [redirectUrl] 
/// * [expiresAt] 
@BuiltValue()
abstract class PaymentInitiateResponse implements Built<PaymentInitiateResponse, PaymentInitiateResponseBuilder> {
  @BuiltValueField(wireName: r'paymentId')
  String get paymentId;

  @BuiltValueField(wireName: r'redirectUrl')
  String get redirectUrl;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  PaymentInitiateResponse._();

  factory PaymentInitiateResponse([void updates(PaymentInitiateResponseBuilder b)]) = _$PaymentInitiateResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentInitiateResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentInitiateResponse> get serializer => _$PaymentInitiateResponseSerializer();
}

class _$PaymentInitiateResponseSerializer implements PrimitiveSerializer<PaymentInitiateResponse> {
  @override
  final Iterable<Type> types = const [PaymentInitiateResponse, _$PaymentInitiateResponse];

  @override
  final String wireName = r'PaymentInitiateResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentInitiateResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'paymentId';
    yield serializers.serialize(
      object.paymentId,
      specifiedType: const FullType(String),
    );
    yield r'redirectUrl';
    yield serializers.serialize(
      object.redirectUrl,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentInitiateResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentInitiateResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'paymentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.paymentId = valueDes;
          break;
        case r'redirectUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.redirectUrl = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentInitiateResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentInitiateResponseBuilder();
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

