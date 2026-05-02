//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_blocked_slot_create_input.g.dart';

/// ProBlockedSlotCreateInput
///
/// Properties:
/// * [startsAt]
/// * [endsAt]
/// * [reason]
/// * [scope]
/// * [employeeId]
@BuiltValue()
abstract class ProBlockedSlotCreateInput
    implements
        Built<ProBlockedSlotCreateInput, ProBlockedSlotCreateInputBuilder> {
  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'scope')
  ProBlockedSlotCreateInputScopeEnum? get scope;
  // enum scopeEnum {  salon,  employee,  };

  @BuiltValueField(wireName: r'employeeId')
  String? get employeeId;

  ProBlockedSlotCreateInput._();

  factory ProBlockedSlotCreateInput(
          [void updates(ProBlockedSlotCreateInputBuilder b)]) =
      _$ProBlockedSlotCreateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProBlockedSlotCreateInputBuilder b) =>
      b..scope = ProBlockedSlotCreateInputScopeEnum.valueOf('salon');

  @BuiltValueSerializer(custom: true)
  static Serializer<ProBlockedSlotCreateInput> get serializer =>
      _$ProBlockedSlotCreateInputSerializer();
}

class _$ProBlockedSlotCreateInputSerializer
    implements PrimitiveSerializer<ProBlockedSlotCreateInput> {
  @override
  final Iterable<Type> types = const [
    ProBlockedSlotCreateInput,
    _$ProBlockedSlotCreateInput
  ];

  @override
  final String wireName = r'ProBlockedSlotCreateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProBlockedSlotCreateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    if (object.scope != null) {
      yield r'scope';
      yield serializers.serialize(
        object.scope,
        specifiedType: const FullType(ProBlockedSlotCreateInputScopeEnum),
      );
    }
    if (object.employeeId != null) {
      yield r'employeeId';
      yield serializers.serialize(
        object.employeeId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProBlockedSlotCreateInput object, {
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
    required ProBlockedSlotCreateInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startsAt = valueDes;
          break;
        case r'endsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endsAt = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProBlockedSlotCreateInputScopeEnum),
          ) as ProBlockedSlotCreateInputScopeEnum;
          result.scope = valueDes;
          break;
        case r'employeeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.employeeId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProBlockedSlotCreateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProBlockedSlotCreateInputBuilder();
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

class ProBlockedSlotCreateInputScopeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'salon')
  static const ProBlockedSlotCreateInputScopeEnum salon =
      _$proBlockedSlotCreateInputScopeEnum_salon;
  @BuiltValueEnumConst(wireName: r'employee')
  static const ProBlockedSlotCreateInputScopeEnum employee =
      _$proBlockedSlotCreateInputScopeEnum_employee;

  static Serializer<ProBlockedSlotCreateInputScopeEnum> get serializer =>
      _$proBlockedSlotCreateInputScopeEnumSerializer;

  const ProBlockedSlotCreateInputScopeEnum._(String name) : super(name);

  static BuiltSet<ProBlockedSlotCreateInputScopeEnum> get values =>
      _$proBlockedSlotCreateInputScopeEnumValues;
  static ProBlockedSlotCreateInputScopeEnum valueOf(String name) =>
      _$proBlockedSlotCreateInputScopeEnumValueOf(name);
}
