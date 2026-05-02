//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_checkout_details_line_items_inner.g.dart';

/// ProCheckoutDetailsLineItemsInner
///
/// Properties:
/// * [name]
/// * [amountXof]
@BuiltValue()
abstract class ProCheckoutDetailsLineItemsInner
    implements
        Built<ProCheckoutDetailsLineItemsInner,
            ProCheckoutDetailsLineItemsInnerBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'amountXof')
  int get amountXof;

  ProCheckoutDetailsLineItemsInner._();

  factory ProCheckoutDetailsLineItemsInner(
          [void updates(ProCheckoutDetailsLineItemsInnerBuilder b)]) =
      _$ProCheckoutDetailsLineItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProCheckoutDetailsLineItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProCheckoutDetailsLineItemsInner> get serializer =>
      _$ProCheckoutDetailsLineItemsInnerSerializer();
}

class _$ProCheckoutDetailsLineItemsInnerSerializer
    implements PrimitiveSerializer<ProCheckoutDetailsLineItemsInner> {
  @override
  final Iterable<Type> types = const [
    ProCheckoutDetailsLineItemsInner,
    _$ProCheckoutDetailsLineItemsInner
  ];

  @override
  final String wireName = r'ProCheckoutDetailsLineItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProCheckoutDetailsLineItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'amountXof';
    yield serializers.serialize(
      object.amountXof,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProCheckoutDetailsLineItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProCheckoutDetailsLineItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'amountXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountXof = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProCheckoutDetailsLineItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProCheckoutDetailsLineItemsInnerBuilder();
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
