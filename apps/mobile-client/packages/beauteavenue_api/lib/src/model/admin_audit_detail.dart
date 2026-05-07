//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/admin_audit_detail_related_links_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_audit_detail.g.dart';

/// AdminAuditDetail
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
/// * [payloadJson] 
/// * [relatedLinks] 
@BuiltValue()
abstract class AdminAuditDetail implements Built<AdminAuditDetail, AdminAuditDetailBuilder> {
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
  AdminAuditDetailSeverityEnum get severity;
  // enum severityEnum {  info,  warning,  critical,  };

  @BuiltValueField(wireName: r'payloadJson')
  String get payloadJson;

  @BuiltValueField(wireName: r'relatedLinks')
  BuiltList<AdminAuditDetailRelatedLinksInner> get relatedLinks;

  AdminAuditDetail._();

  factory AdminAuditDetail([void updates(AdminAuditDetailBuilder b)]) = _$AdminAuditDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAuditDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAuditDetail> get serializer => _$AdminAuditDetailSerializer();
}

class _$AdminAuditDetailSerializer implements PrimitiveSerializer<AdminAuditDetail> {
  @override
  final Iterable<Type> types = const [AdminAuditDetail, _$AdminAuditDetail];

  @override
  final String wireName = r'AdminAuditDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAuditDetail object, {
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
      specifiedType: const FullType(AdminAuditDetailSeverityEnum),
    );
    yield r'payloadJson';
    yield serializers.serialize(
      object.payloadJson,
      specifiedType: const FullType(String),
    );
    yield r'relatedLinks';
    yield serializers.serialize(
      object.relatedLinks,
      specifiedType: const FullType(BuiltList, [FullType(AdminAuditDetailRelatedLinksInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAuditDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminAuditDetailBuilder result,
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
            specifiedType: const FullType(AdminAuditDetailSeverityEnum),
          ) as AdminAuditDetailSeverityEnum;
          result.severity = valueDes;
          break;
        case r'payloadJson':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.payloadJson = valueDes;
          break;
        case r'relatedLinks':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminAuditDetailRelatedLinksInner)]),
          ) as BuiltList<AdminAuditDetailRelatedLinksInner>;
          result.relatedLinks.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAuditDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAuditDetailBuilder();
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

class AdminAuditDetailSeverityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'info')
  static const AdminAuditDetailSeverityEnum info = _$adminAuditDetailSeverityEnum_info;
  @BuiltValueEnumConst(wireName: r'warning')
  static const AdminAuditDetailSeverityEnum warning = _$adminAuditDetailSeverityEnum_warning;
  @BuiltValueEnumConst(wireName: r'critical')
  static const AdminAuditDetailSeverityEnum critical = _$adminAuditDetailSeverityEnum_critical;

  static Serializer<AdminAuditDetailSeverityEnum> get serializer => _$adminAuditDetailSeverityEnumSerializer;

  const AdminAuditDetailSeverityEnum._(String name): super(name);

  static BuiltSet<AdminAuditDetailSeverityEnum> get values => _$adminAuditDetailSeverityEnumValues;
  static AdminAuditDetailSeverityEnum valueOf(String name) => _$adminAuditDetailSeverityEnumValueOf(name);
}

