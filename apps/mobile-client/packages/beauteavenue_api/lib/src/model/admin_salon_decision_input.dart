//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_salon_decision_input.g.dart';

/// AdminSalonDecisionInput
///
/// Properties:
/// * [reason] 
@BuiltValue()
abstract class AdminSalonDecisionInput implements Built<AdminSalonDecisionInput, AdminSalonDecisionInputBuilder> {
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminSalonDecisionInput._();

  factory AdminSalonDecisionInput([void updates(AdminSalonDecisionInputBuilder b)]) = _$AdminSalonDecisionInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSalonDecisionInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSalonDecisionInput> get serializer => _$AdminSalonDecisionInputSerializer();
}

class _$AdminSalonDecisionInputSerializer implements PrimitiveSerializer<AdminSalonDecisionInput> {
  @override
  final Iterable<Type> types = const [AdminSalonDecisionInput, _$AdminSalonDecisionInput];

  @override
  final String wireName = r'AdminSalonDecisionInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSalonDecisionInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSalonDecisionInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSalonDecisionInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSalonDecisionInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSalonDecisionInputBuilder();
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

