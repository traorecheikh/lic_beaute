//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/pro_checkout_details_line_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_checkout_complete_input.g.dart';

/// ProCheckoutCompleteInput
///
/// Properties:
/// * [paymentMethod] 
/// * [lineItems] 
/// * [discountXof] 
/// * [softpayMethod] 
@BuiltValue()
abstract class ProCheckoutCompleteInput implements Built<ProCheckoutCompleteInput, ProCheckoutCompleteInputBuilder> {
  @BuiltValueField(wireName: r'paymentMethod')
  ProCheckoutCompleteInputPaymentMethodEnum get paymentMethod;
  // enum paymentMethodEnum {  cash,  other,  };

  @BuiltValueField(wireName: r'lineItems')
  BuiltList<ProCheckoutDetailsLineItemsInner> get lineItems;

  @BuiltValueField(wireName: r'discountXof')
  int? get discountXof;

  @BuiltValueField(wireName: r'softpayMethod')
  String? get softpayMethod;

  ProCheckoutCompleteInput._();

  factory ProCheckoutCompleteInput([void updates(ProCheckoutCompleteInputBuilder b)]) = _$ProCheckoutCompleteInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProCheckoutCompleteInputBuilder b) => b
      ..discountXof = 0;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProCheckoutCompleteInput> get serializer => _$ProCheckoutCompleteInputSerializer();
}

class _$ProCheckoutCompleteInputSerializer implements PrimitiveSerializer<ProCheckoutCompleteInput> {
  @override
  final Iterable<Type> types = const [ProCheckoutCompleteInput, _$ProCheckoutCompleteInput];

  @override
  final String wireName = r'ProCheckoutCompleteInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProCheckoutCompleteInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'paymentMethod';
    yield serializers.serialize(
      object.paymentMethod,
      specifiedType: const FullType(ProCheckoutCompleteInputPaymentMethodEnum),
    );
    yield r'lineItems';
    yield serializers.serialize(
      object.lineItems,
      specifiedType: const FullType(BuiltList, [FullType(ProCheckoutDetailsLineItemsInner)]),
    );
    if (object.discountXof != null) {
      yield r'discountXof';
      yield serializers.serialize(
        object.discountXof,
        specifiedType: const FullType(int),
      );
    }
    if (object.softpayMethod != null) {
      yield r'softpayMethod';
      yield serializers.serialize(
        object.softpayMethod,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProCheckoutCompleteInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProCheckoutCompleteInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'paymentMethod':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProCheckoutCompleteInputPaymentMethodEnum),
          ) as ProCheckoutCompleteInputPaymentMethodEnum;
          result.paymentMethod = valueDes;
          break;
        case r'lineItems':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProCheckoutDetailsLineItemsInner)]),
          ) as BuiltList<ProCheckoutDetailsLineItemsInner>;
          result.lineItems.replace(valueDes);
          break;
        case r'discountXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.discountXof = valueDes;
          break;
        case r'softpayMethod':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.softpayMethod = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProCheckoutCompleteInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProCheckoutCompleteInputBuilder();
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

class ProCheckoutCompleteInputPaymentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'cash')
  static const ProCheckoutCompleteInputPaymentMethodEnum cash = _$proCheckoutCompleteInputPaymentMethodEnum_cash;
  @BuiltValueEnumConst(wireName: r'other')
  static const ProCheckoutCompleteInputPaymentMethodEnum other = _$proCheckoutCompleteInputPaymentMethodEnum_other;

  static Serializer<ProCheckoutCompleteInputPaymentMethodEnum> get serializer => _$proCheckoutCompleteInputPaymentMethodEnumSerializer;

  const ProCheckoutCompleteInputPaymentMethodEnum._(String name): super(name);

  static BuiltSet<ProCheckoutCompleteInputPaymentMethodEnum> get values => _$proCheckoutCompleteInputPaymentMethodEnumValues;
  static ProCheckoutCompleteInputPaymentMethodEnum valueOf(String name) => _$proCheckoutCompleteInputPaymentMethodEnumValueOf(name);
}

