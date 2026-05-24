//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'paydunya_method_list_response_methods_inner.g.dart';

/// PaydunyaMethodListResponseMethodsInner
///
/// Properties:
/// * [code] 
/// * [country] 
/// * [label] 
/// * [enabled] 
@BuiltValue()
abstract class PaydunyaMethodListResponseMethodsInner implements Built<PaydunyaMethodListResponseMethodsInner, PaydunyaMethodListResponseMethodsInnerBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'country')
  String get country;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  PaydunyaMethodListResponseMethodsInner._();

  factory PaydunyaMethodListResponseMethodsInner([void updates(PaydunyaMethodListResponseMethodsInnerBuilder b)]) = _$PaydunyaMethodListResponseMethodsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaydunyaMethodListResponseMethodsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaydunyaMethodListResponseMethodsInner> get serializer => _$PaydunyaMethodListResponseMethodsInnerSerializer();
}

class _$PaydunyaMethodListResponseMethodsInnerSerializer implements PrimitiveSerializer<PaydunyaMethodListResponseMethodsInner> {
  @override
  final Iterable<Type> types = const [PaydunyaMethodListResponseMethodsInner, _$PaydunyaMethodListResponseMethodsInner];

  @override
  final String wireName = r'PaydunyaMethodListResponseMethodsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaydunyaMethodListResponseMethodsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'country';
    yield serializers.serialize(
      object.country,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PaydunyaMethodListResponseMethodsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaydunyaMethodListResponseMethodsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'country':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.country = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PaydunyaMethodListResponseMethodsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaydunyaMethodListResponseMethodsInnerBuilder();
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

