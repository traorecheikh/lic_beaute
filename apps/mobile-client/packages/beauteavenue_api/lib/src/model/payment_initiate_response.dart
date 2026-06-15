//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_initiate_response.g.dart';

/// PaymentInitiateResponse
///
/// Properties:
/// * [paymentId] 
/// * [redirectUrl] 
/// * [expiresAt] 
/// * [status] 
@BuiltValue()
abstract class PaymentInitiateResponse implements Built<PaymentInitiateResponse, PaymentInitiateResponseBuilder> {
  @BuiltValueField(wireName: r'paymentId')
  String get paymentId;

  @BuiltValueField(wireName: r'redirectUrl')
  String? get redirectUrl;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'status')
  PaymentInitiateResponseStatusEnum? get status;
  // enum statusEnum {  pending,  authorized,  succeeded,  failed,  refunded,  };

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
    yield object.redirectUrl == null ? null : serializers.serialize(
      object.redirectUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'expiresAt';
    yield object.expiresAt == null ? null : serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(PaymentInitiateResponseStatusEnum),
      );
    }
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.redirectUrl = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentInitiateResponseStatusEnum),
          ) as PaymentInitiateResponseStatusEnum;
          result.status = valueDes;
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

class PaymentInitiateResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending')
  static const PaymentInitiateResponseStatusEnum pending = _$paymentInitiateResponseStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'authorized')
  static const PaymentInitiateResponseStatusEnum authorized = _$paymentInitiateResponseStatusEnum_authorized;
  @BuiltValueEnumConst(wireName: r'succeeded')
  static const PaymentInitiateResponseStatusEnum succeeded = _$paymentInitiateResponseStatusEnum_succeeded;
  @BuiltValueEnumConst(wireName: r'failed')
  static const PaymentInitiateResponseStatusEnum failed = _$paymentInitiateResponseStatusEnum_failed;
  @BuiltValueEnumConst(wireName: r'refunded')
  static const PaymentInitiateResponseStatusEnum refunded = _$paymentInitiateResponseStatusEnum_refunded;

  static Serializer<PaymentInitiateResponseStatusEnum> get serializer => _$paymentInitiateResponseStatusEnumSerializer;

  const PaymentInitiateResponseStatusEnum._(String name): super(name);

  static BuiltSet<PaymentInitiateResponseStatusEnum> get values => _$paymentInitiateResponseStatusEnumValues;
  static PaymentInitiateResponseStatusEnum valueOf(String name) => _$paymentInitiateResponseStatusEnumValueOf(name);
}

