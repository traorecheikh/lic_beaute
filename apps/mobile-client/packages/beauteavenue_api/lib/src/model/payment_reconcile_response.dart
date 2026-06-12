//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_reconcile_response.g.dart';

/// PaymentReconcileResponse
///
/// Properties:
/// * [id] 
/// * [status] 
/// * [amountXof] 
/// * [provider] 
/// * [providerTxId] 
/// * [createdAt] 
@BuiltValue()
abstract class PaymentReconcileResponse implements Built<PaymentReconcileResponse, PaymentReconcileResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  PaymentReconcileResponseStatusEnum get status;
  // enum statusEnum {  pending,  authorized,  succeeded,  failed,  refunded,  };

  @BuiltValueField(wireName: r'amountXof')
  num get amountXof;

  @BuiltValueField(wireName: r'provider')
  PaymentReconcileResponseProviderEnum get provider;
  // enum providerEnum {  paydunya,  manual,  };

  @BuiltValueField(wireName: r'providerTxId')
  String? get providerTxId;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  PaymentReconcileResponse._();

  factory PaymentReconcileResponse([void updates(PaymentReconcileResponseBuilder b)]) = _$PaymentReconcileResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentReconcileResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentReconcileResponse> get serializer => _$PaymentReconcileResponseSerializer();
}

class _$PaymentReconcileResponseSerializer implements PrimitiveSerializer<PaymentReconcileResponse> {
  @override
  final Iterable<Type> types = const [PaymentReconcileResponse, _$PaymentReconcileResponse];

  @override
  final String wireName = r'PaymentReconcileResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentReconcileResponse object, {
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
      specifiedType: const FullType(PaymentReconcileResponseStatusEnum),
    );
    yield r'amountXof';
    yield serializers.serialize(
      object.amountXof,
      specifiedType: const FullType(num),
    );
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(PaymentReconcileResponseProviderEnum),
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
    PaymentReconcileResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentReconcileResponseBuilder result,
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
            specifiedType: const FullType(PaymentReconcileResponseStatusEnum),
          ) as PaymentReconcileResponseStatusEnum;
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
            specifiedType: const FullType(PaymentReconcileResponseProviderEnum),
          ) as PaymentReconcileResponseProviderEnum;
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
  PaymentReconcileResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentReconcileResponseBuilder();
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

class PaymentReconcileResponseStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending')
  static const PaymentReconcileResponseStatusEnum pending = _$paymentReconcileResponseStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'authorized')
  static const PaymentReconcileResponseStatusEnum authorized = _$paymentReconcileResponseStatusEnum_authorized;
  @BuiltValueEnumConst(wireName: r'succeeded')
  static const PaymentReconcileResponseStatusEnum succeeded = _$paymentReconcileResponseStatusEnum_succeeded;
  @BuiltValueEnumConst(wireName: r'failed')
  static const PaymentReconcileResponseStatusEnum failed = _$paymentReconcileResponseStatusEnum_failed;
  @BuiltValueEnumConst(wireName: r'refunded')
  static const PaymentReconcileResponseStatusEnum refunded = _$paymentReconcileResponseStatusEnum_refunded;

  static Serializer<PaymentReconcileResponseStatusEnum> get serializer => _$paymentReconcileResponseStatusEnumSerializer;

  const PaymentReconcileResponseStatusEnum._(String name): super(name);

  static BuiltSet<PaymentReconcileResponseStatusEnum> get values => _$paymentReconcileResponseStatusEnumValues;
  static PaymentReconcileResponseStatusEnum valueOf(String name) => _$paymentReconcileResponseStatusEnumValueOf(name);
}

class PaymentReconcileResponseProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'paydunya')
  static const PaymentReconcileResponseProviderEnum paydunya = _$paymentReconcileResponseProviderEnum_paydunya;
  @BuiltValueEnumConst(wireName: r'manual')
  static const PaymentReconcileResponseProviderEnum manual = _$paymentReconcileResponseProviderEnum_manual;

  static Serializer<PaymentReconcileResponseProviderEnum> get serializer => _$paymentReconcileResponseProviderEnumSerializer;

  const PaymentReconcileResponseProviderEnum._(String name): super(name);

  static BuiltSet<PaymentReconcileResponseProviderEnum> get values => _$paymentReconcileResponseProviderEnumValues;
  static PaymentReconcileResponseProviderEnum valueOf(String name) => _$paymentReconcileResponseProviderEnumValueOf(name);
}

