//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/payment_webhook_body_amount.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_webhook_body.g.dart';

/// PaymentWebhookBody
///
/// Properties:
/// * [idFromGu] 
/// * [idFromClient] 
/// * [code] 
/// * [status] 
/// * [amount] 
/// * [amountWithoutFees] 
/// * [serviceCode] 
/// * [infoHash] 
/// * [secureHash] 
@BuiltValue()
abstract class PaymentWebhookBody implements Built<PaymentWebhookBody, PaymentWebhookBodyBuilder> {
  @BuiltValueField(wireName: r'idFromGu')
  String? get idFromGu;

  @BuiltValueField(wireName: r'idFromClient')
  String? get idFromClient;

  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'status')
  String? get status;

  @BuiltValueField(wireName: r'amount')
  PaymentWebhookBodyAmount? get amount;

  @BuiltValueField(wireName: r'amountWithoutFees')
  PaymentWebhookBodyAmount? get amountWithoutFees;

  @BuiltValueField(wireName: r'serviceCode')
  String? get serviceCode;

  @BuiltValueField(wireName: r'infoHash')
  String? get infoHash;

  @BuiltValueField(wireName: r'secureHash')
  String? get secureHash;

  PaymentWebhookBody._();

  factory PaymentWebhookBody([void updates(PaymentWebhookBodyBuilder b)]) = _$PaymentWebhookBody;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentWebhookBodyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentWebhookBody> get serializer => _$PaymentWebhookBodySerializer();
}

class _$PaymentWebhookBodySerializer implements PrimitiveSerializer<PaymentWebhookBody> {
  @override
  final Iterable<Type> types = const [PaymentWebhookBody, _$PaymentWebhookBody];

  @override
  final String wireName = r'PaymentWebhookBody';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentWebhookBody object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.idFromGu != null) {
      yield r'idFromGu';
      yield serializers.serialize(
        object.idFromGu,
        specifiedType: const FullType(String),
      );
    }
    if (object.idFromClient != null) {
      yield r'idFromClient';
      yield serializers.serialize(
        object.idFromClient,
        specifiedType: const FullType(String),
      );
    }
    if (object.code != null) {
      yield r'code';
      yield serializers.serialize(
        object.code,
        specifiedType: const FullType(String),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      );
    }
    if (object.amount != null) {
      yield r'amount';
      yield serializers.serialize(
        object.amount,
        specifiedType: const FullType(PaymentWebhookBodyAmount),
      );
    }
    if (object.amountWithoutFees != null) {
      yield r'amountWithoutFees';
      yield serializers.serialize(
        object.amountWithoutFees,
        specifiedType: const FullType(PaymentWebhookBodyAmount),
      );
    }
    if (object.serviceCode != null) {
      yield r'serviceCode';
      yield serializers.serialize(
        object.serviceCode,
        specifiedType: const FullType(String),
      );
    }
    if (object.infoHash != null) {
      yield r'infoHash';
      yield serializers.serialize(
        object.infoHash,
        specifiedType: const FullType(String),
      );
    }
    if (object.secureHash != null) {
      yield r'secureHash';
      yield serializers.serialize(
        object.secureHash,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentWebhookBody object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentWebhookBodyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'idFromGu':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idFromGu = valueDes;
          break;
        case r'idFromClient':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.idFromClient = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentWebhookBodyAmount),
          ) as PaymentWebhookBodyAmount;
          result.amount.replace(valueDes);
          break;
        case r'amountWithoutFees':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentWebhookBodyAmount),
          ) as PaymentWebhookBodyAmount;
          result.amountWithoutFees.replace(valueDes);
          break;
        case r'serviceCode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.serviceCode = valueDes;
          break;
        case r'infoHash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.infoHash = valueDes;
          break;
        case r'secureHash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.secureHash = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaymentWebhookBody deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentWebhookBodyBuilder();
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

