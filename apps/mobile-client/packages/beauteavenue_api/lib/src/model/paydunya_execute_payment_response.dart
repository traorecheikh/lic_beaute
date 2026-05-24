//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/paydunya_execute_payment_response_other_url.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paydunya_execute_payment_response.g.dart';

/// PaydunyaExecutePaymentResponse
///
/// Properties:
/// * [success] 
/// * [status] 
/// * [providerTxId] 
/// * [message] 
/// * [url] 
/// * [otherUrl] 
/// * [data] 
@BuiltValue()
abstract class PaydunyaExecutePaymentResponse implements Built<PaydunyaExecutePaymentResponse, PaydunyaExecutePaymentResponseBuilder> {
  @BuiltValueField(wireName: r'success')
  bool get success;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'providerTxId')
  String? get providerTxId;

  @BuiltValueField(wireName: r'message')
  String? get message;

  @BuiltValueField(wireName: r'url')
  String? get url;

  @BuiltValueField(wireName: r'other_url')
  PaydunyaExecutePaymentResponseOtherUrl? get otherUrl;

  @BuiltValueField(wireName: r'data')
  BuiltMap<String, JsonObject?>? get data;

  PaydunyaExecutePaymentResponse._();

  factory PaydunyaExecutePaymentResponse([void updates(PaydunyaExecutePaymentResponseBuilder b)]) = _$PaydunyaExecutePaymentResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaydunyaExecutePaymentResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaydunyaExecutePaymentResponse> get serializer => _$PaydunyaExecutePaymentResponseSerializer();
}

class _$PaydunyaExecutePaymentResponseSerializer implements PrimitiveSerializer<PaydunyaExecutePaymentResponse> {
  @override
  final Iterable<Type> types = const [PaydunyaExecutePaymentResponse, _$PaydunyaExecutePaymentResponse];

  @override
  final String wireName = r'PaydunyaExecutePaymentResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaydunyaExecutePaymentResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'success';
    yield serializers.serialize(
      object.success,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'providerTxId';
    yield object.providerTxId == null ? null : serializers.serialize(
      object.providerTxId,
      specifiedType: const FullType.nullable(String),
    );
    if (object.message != null) {
      yield r'message';
      yield serializers.serialize(
        object.message,
        specifiedType: const FullType(String),
      );
    }
    if (object.url != null) {
      yield r'url';
      yield serializers.serialize(
        object.url,
        specifiedType: const FullType(String),
      );
    }
    if (object.otherUrl != null) {
      yield r'other_url';
      yield serializers.serialize(
        object.otherUrl,
        specifiedType: const FullType(PaydunyaExecutePaymentResponseOtherUrl),
      );
    }
    if (object.data != null) {
      yield r'data';
      yield serializers.serialize(
        object.data,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PaydunyaExecutePaymentResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaydunyaExecutePaymentResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'success':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.success = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'providerTxId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.providerTxId = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'other_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaydunyaExecutePaymentResponseOtherUrl),
          ) as PaydunyaExecutePaymentResponseOtherUrl;
          result.otherUrl.replace(valueDes);
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.data.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaydunyaExecutePaymentResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaydunyaExecutePaymentResponseBuilder();
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

