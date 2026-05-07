//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_blocked_slot.g.dart';

/// ProBlockedSlot
///
/// Properties:
/// * [id] 
/// * [startsAt] 
/// * [endsAt] 
/// * [reason] 
/// * [scope] 
/// * [employeeId] 
@BuiltValue()
abstract class ProBlockedSlot implements Built<ProBlockedSlot, ProBlockedSlotBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'scope')
  ProBlockedSlotScopeEnum get scope;
  // enum scopeEnum {  salon,  employee,  };

  @BuiltValueField(wireName: r'employeeId')
  String? get employeeId;

  ProBlockedSlot._();

  factory ProBlockedSlot([void updates(ProBlockedSlotBuilder b)]) = _$ProBlockedSlot;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProBlockedSlotBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProBlockedSlot> get serializer => _$ProBlockedSlotSerializer();
}

class _$ProBlockedSlotSerializer implements PrimitiveSerializer<ProBlockedSlot> {
  @override
  final Iterable<Type> types = const [ProBlockedSlot, _$ProBlockedSlot];

  @override
  final String wireName = r'ProBlockedSlot';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProBlockedSlot object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'scope';
    yield serializers.serialize(
      object.scope,
      specifiedType: const FullType(ProBlockedSlotScopeEnum),
    );
    yield r'employeeId';
    yield object.employeeId == null ? null : serializers.serialize(
      object.employeeId,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProBlockedSlot object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProBlockedSlotBuilder result,
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProBlockedSlotScopeEnum),
          ) as ProBlockedSlotScopeEnum;
          result.scope = valueDes;
          break;
        case r'employeeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  ProBlockedSlot deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProBlockedSlotBuilder();
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

class ProBlockedSlotScopeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'salon')
  static const ProBlockedSlotScopeEnum salon = _$proBlockedSlotScopeEnum_salon;
  @BuiltValueEnumConst(wireName: r'employee')
  static const ProBlockedSlotScopeEnum employee = _$proBlockedSlotScopeEnum_employee;

  static Serializer<ProBlockedSlotScopeEnum> get serializer => _$proBlockedSlotScopeEnumSerializer;

  const ProBlockedSlotScopeEnum._(String name): super(name);

  static BuiltSet<ProBlockedSlotScopeEnum> get values => _$proBlockedSlotScopeEnumValues;
  static ProBlockedSlotScopeEnum valueOf(String name) => _$proBlockedSlotScopeEnumValueOf(name);
}

