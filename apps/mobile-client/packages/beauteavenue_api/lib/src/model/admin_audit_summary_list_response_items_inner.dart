//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_audit_summary_list_response_items_inner.g.dart';

/// AdminAuditSummaryListResponseItemsInner
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
abstract class AdminAuditSummaryListResponseItemsInner
    implements
        Built<AdminAuditSummaryListResponseItemsInner,
            AdminAuditSummaryListResponseItemsInnerBuilder> {
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
  AdminAuditSummaryListResponseItemsInnerSeverityEnum get severity;
  // enum severityEnum {  info,  warning,  critical,  };

  AdminAuditSummaryListResponseItemsInner._();

  factory AdminAuditSummaryListResponseItemsInner(
          [void updates(AdminAuditSummaryListResponseItemsInnerBuilder b)]) =
      _$AdminAuditSummaryListResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAuditSummaryListResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAuditSummaryListResponseItemsInner> get serializer =>
      _$AdminAuditSummaryListResponseItemsInnerSerializer();
}

class _$AdminAuditSummaryListResponseItemsInnerSerializer
    implements PrimitiveSerializer<AdminAuditSummaryListResponseItemsInner> {
  @override
  final Iterable<Type> types = const [
    AdminAuditSummaryListResponseItemsInner,
    _$AdminAuditSummaryListResponseItemsInner
  ];

  @override
  final String wireName = r'AdminAuditSummaryListResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAuditSummaryListResponseItemsInner object, {
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
      specifiedType:
          const FullType(AdminAuditSummaryListResponseItemsInnerSeverityEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAuditSummaryListResponseItemsInner object, {
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
    required AdminAuditSummaryListResponseItemsInnerBuilder result,
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
            specifiedType: const FullType(
                AdminAuditSummaryListResponseItemsInnerSeverityEnum),
          ) as AdminAuditSummaryListResponseItemsInnerSeverityEnum;
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
  AdminAuditSummaryListResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAuditSummaryListResponseItemsInnerBuilder();
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

class AdminAuditSummaryListResponseItemsInnerSeverityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'info')
  static const AdminAuditSummaryListResponseItemsInnerSeverityEnum info =
      _$adminAuditSummaryListResponseItemsInnerSeverityEnum_info;
  @BuiltValueEnumConst(wireName: r'warning')
  static const AdminAuditSummaryListResponseItemsInnerSeverityEnum warning =
      _$adminAuditSummaryListResponseItemsInnerSeverityEnum_warning;
  @BuiltValueEnumConst(wireName: r'critical')
  static const AdminAuditSummaryListResponseItemsInnerSeverityEnum critical =
      _$adminAuditSummaryListResponseItemsInnerSeverityEnum_critical;

  static Serializer<AdminAuditSummaryListResponseItemsInnerSeverityEnum>
      get serializer =>
          _$adminAuditSummaryListResponseItemsInnerSeverityEnumSerializer;

  const AdminAuditSummaryListResponseItemsInnerSeverityEnum._(String name)
      : super(name);

  static BuiltSet<AdminAuditSummaryListResponseItemsInnerSeverityEnum>
      get values => _$adminAuditSummaryListResponseItemsInnerSeverityEnumValues;
  static AdminAuditSummaryListResponseItemsInnerSeverityEnum valueOf(
          String name) =>
      _$adminAuditSummaryListResponseItemsInnerSeverityEnumValueOf(name);
}
