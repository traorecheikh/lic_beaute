//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_audit_summary.g.dart';

/// AdminAuditSummary
///
/// Properties:
/// * [id] 
/// * [action] 
/// * [summary] 
/// * [entityType] 
/// * [entityId] 
/// * [actorName] 
/// * [createdAt] 
/// * [severity] 
@BuiltValue()
abstract class AdminAuditSummary implements Built<AdminAuditSummary, AdminAuditSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'action')
  String get action;

  @BuiltValueField(wireName: r'summary')
  String get summary;

  @BuiltValueField(wireName: r'entityType')
  String get entityType;

  @BuiltValueField(wireName: r'entityId')
  String get entityId;

  @BuiltValueField(wireName: r'actorName')
  String get actorName;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'severity')
  AdminAuditSummarySeverityEnum get severity;
  // enum severityEnum {  info,  warning,  critical,  };

  AdminAuditSummary._();

  factory AdminAuditSummary([void updates(AdminAuditSummaryBuilder b)]) = _$AdminAuditSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAuditSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAuditSummary> get serializer => _$AdminAuditSummarySerializer();
}

class _$AdminAuditSummarySerializer implements PrimitiveSerializer<AdminAuditSummary> {
  @override
  final Iterable<Type> types = const [AdminAuditSummary, _$AdminAuditSummary];

  @override
  final String wireName = r'AdminAuditSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAuditSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(String),
    );
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(String),
    );
    yield r'entityType';
    yield serializers.serialize(
      object.entityType,
      specifiedType: const FullType(String),
    );
    yield r'entityId';
    yield serializers.serialize(
      object.entityId,
      specifiedType: const FullType(String),
    );
    yield r'actorName';
    yield serializers.serialize(
      object.actorName,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(AdminAuditSummarySeverityEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAuditSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminAuditSummaryBuilder result,
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
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.action = valueDes;
          break;
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.summary = valueDes;
          break;
        case r'entityType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.entityType = valueDes;
          break;
        case r'entityId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.entityId = valueDes;
          break;
        case r'actorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actorName = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'severity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminAuditSummarySeverityEnum),
          ) as AdminAuditSummarySeverityEnum;
          result.severity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAuditSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAuditSummaryBuilder();
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

class AdminAuditSummarySeverityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'info')
  static const AdminAuditSummarySeverityEnum info = _$adminAuditSummarySeverityEnum_info;
  @BuiltValueEnumConst(wireName: r'warning')
  static const AdminAuditSummarySeverityEnum warning = _$adminAuditSummarySeverityEnum_warning;
  @BuiltValueEnumConst(wireName: r'critical')
  static const AdminAuditSummarySeverityEnum critical = _$adminAuditSummarySeverityEnum_critical;

  static Serializer<AdminAuditSummarySeverityEnum> get serializer => _$adminAuditSummarySeverityEnumSerializer;

  const AdminAuditSummarySeverityEnum._(String name): super(name);

  static BuiltSet<AdminAuditSummarySeverityEnum> get values => _$adminAuditSummarySeverityEnumValues;
  static AdminAuditSummarySeverityEnum valueOf(String name) => _$adminAuditSummarySeverityEnumValueOf(name);
}

