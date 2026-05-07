//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_audit_filters.g.dart';

/// AdminAuditFilters
///
/// Properties:
/// * [actor] 
/// * [entityType] 
/// * [action] 
@BuiltValue()
abstract class AdminAuditFilters implements Built<AdminAuditFilters, AdminAuditFiltersBuilder> {
  @BuiltValueField(wireName: r'actor')
  String? get actor;

  @BuiltValueField(wireName: r'entityType')
  String? get entityType;

  @BuiltValueField(wireName: r'action')
  String? get action;

  AdminAuditFilters._();

  factory AdminAuditFilters([void updates(AdminAuditFiltersBuilder b)]) = _$AdminAuditFilters;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAuditFiltersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAuditFilters> get serializer => _$AdminAuditFiltersSerializer();
}

class _$AdminAuditFiltersSerializer implements PrimitiveSerializer<AdminAuditFilters> {
  @override
  final Iterable<Type> types = const [AdminAuditFilters, _$AdminAuditFilters];

  @override
  final String wireName = r'AdminAuditFilters';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAuditFilters object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.actor != null) {
      yield r'actor';
      yield serializers.serialize(
        object.actor,
        specifiedType: const FullType(String),
      );
    }
    if (object.entityType != null) {
      yield r'entityType';
      yield serializers.serialize(
        object.entityType,
        specifiedType: const FullType(String),
      );
    }
    if (object.action != null) {
      yield r'action';
      yield serializers.serialize(
        object.action,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAuditFilters object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminAuditFiltersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'actor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actor = valueDes;
          break;
        case r'entityType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.entityType = valueDes;
          break;
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.action = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAuditFilters deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAuditFiltersBuilder();
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

