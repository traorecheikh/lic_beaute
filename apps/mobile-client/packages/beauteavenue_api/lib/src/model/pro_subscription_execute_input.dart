//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_subscription_execute_input.g.dart';

/// ProSubscriptionExecuteInput
///
/// Properties:
/// * [method] 
/// * [details] 
@BuiltValue()
abstract class ProSubscriptionExecuteInput implements Built<ProSubscriptionExecuteInput, ProSubscriptionExecuteInputBuilder> {
  @BuiltValueField(wireName: r'method')
  String get method;

  @BuiltValueField(wireName: r'details')
  BuiltMap<String, JsonObject?>? get details;

  ProSubscriptionExecuteInput._();

  factory ProSubscriptionExecuteInput([void updates(ProSubscriptionExecuteInputBuilder b)]) = _$ProSubscriptionExecuteInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProSubscriptionExecuteInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProSubscriptionExecuteInput> get serializer => _$ProSubscriptionExecuteInputSerializer();
}

class _$ProSubscriptionExecuteInputSerializer implements PrimitiveSerializer<ProSubscriptionExecuteInput> {
  @override
  final Iterable<Type> types = const [ProSubscriptionExecuteInput, _$ProSubscriptionExecuteInput];

  @override
  final String wireName = r'ProSubscriptionExecuteInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProSubscriptionExecuteInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(String),
    );
    if (object.details != null) {
      yield r'details';
      yield serializers.serialize(
        object.details,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProSubscriptionExecuteInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProSubscriptionExecuteInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.method = valueDes;
          break;
        case r'details':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.details.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProSubscriptionExecuteInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProSubscriptionExecuteInputBuilder();
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

