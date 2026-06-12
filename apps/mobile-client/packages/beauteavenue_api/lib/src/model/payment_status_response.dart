//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_status_response.g.dart';

/// PaymentStatusResponse
///
/// Properties:
/// * [id] 
/// * [status] 
/// * [amountXof] 
/// * [provider] 
/// * [providerTxId] 
/// * [createdAt] 
@BuiltValue()
abstract class PaymentStatusResponse implements Built<PaymentStatusResponse, PaymentStatusResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  PaymentStatusResponseStatusEnum get status;
  // enum statusEnum {  pending,  authorized,  succeeded,  failed,  refunded,  };

  @BuiltValueField(wireName: r'amountXof')
  num get amountXof;

  @BuiltValueField(wireName: r'provider')
  PaymentStatusResponseProviderEnum get provider;
  // enum providerEnum {  paydunya,  manual,  };

  @BuiltValueField(wireName: r'providerTxId')
  String? get providerTxId;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  PaymentStatusResponse._();

  factory PaymentStatusResponse([void updates(PaymentStatusResponseBuilder b)]) = _$PaymentStatusResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentStatusResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentStatusResponse> get serializer => _$PaymentStatusResponseSerializer();
}

class _$PaymentStatusResponseSerializer implements PrimitiveSerializer<PaymentStatusResponse> {
  @override
  final Iterable<Type> types = const [PaymentStatusResponse, _$PaymentStatusResponse];

  @override
  final String wireName = r'PaymentStatusResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentStatusResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PaymentStatusResponseStatusEnum),
    );
    yield r'amountXof';
    yield serializers.serialize(
      object.amountXof,
      specifiedType: const FullType(num),
    );
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(PaymentStatusResponseProviderEnum),
    );
    yield r'providerTxId';
    yield object.providerTxId == null ? null : serializers.serialize(
      object.providerTxId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentStatusResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentStatusResponseBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentStatusResponseStatusEnum),
          ) as PaymentStatusResponseStatusEnum;
          result.status = valueDes;
          break;
        case r'amountXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.amountXof = valueDes;
          break;
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentStatusResponseProviderEnum),
          ) as PaymentStatusResponseProviderEnum;
          result.provider = valueDes;
          break;
        case r'providerTxId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.providerTxId = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentStatusResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentStatusResponseBuilder();
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

class PaymentStatusResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending')
  static const PaymentStatusResponseStatusEnum pending = _$paymentStatusResponseStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'authorized')
  static const PaymentStatusResponseStatusEnum authorized = _$paymentStatusResponseStatusEnum_authorized;
  @BuiltValueEnumConst(wireName: r'succeeded')
  static const PaymentStatusResponseStatusEnum succeeded = _$paymentStatusResponseStatusEnum_succeeded;
  @BuiltValueEnumConst(wireName: r'failed')
  static const PaymentStatusResponseStatusEnum failed = _$paymentStatusResponseStatusEnum_failed;
  @BuiltValueEnumConst(wireName: r'refunded')
  static const PaymentStatusResponseStatusEnum refunded = _$paymentStatusResponseStatusEnum_refunded;

  static Serializer<PaymentStatusResponseStatusEnum> get serializer => _$paymentStatusResponseStatusEnumSerializer;

  const PaymentStatusResponseStatusEnum._(String name): super(name);

  static BuiltSet<PaymentStatusResponseStatusEnum> get values => _$paymentStatusResponseStatusEnumValues;
  static PaymentStatusResponseStatusEnum valueOf(String name) => _$paymentStatusResponseStatusEnumValueOf(name);
}

class PaymentStatusResponseProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'paydunya')
  static const PaymentStatusResponseProviderEnum paydunya = _$paymentStatusResponseProviderEnum_paydunya;
  @BuiltValueEnumConst(wireName: r'manual')
  static const PaymentStatusResponseProviderEnum manual = _$paymentStatusResponseProviderEnum_manual;

  static Serializer<PaymentStatusResponseProviderEnum> get serializer => _$paymentStatusResponseProviderEnumSerializer;

  const PaymentStatusResponseProviderEnum._(String name): super(name);

  static BuiltSet<PaymentStatusResponseProviderEnum> get values => _$paymentStatusResponseProviderEnumValues;
  static PaymentStatusResponseProviderEnum valueOf(String name) => _$paymentStatusResponseProviderEnumValueOf(name);
}

