//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_audit_detail_related_links_inner.g.dart';

/// AdminAuditDetailRelatedLinksInner
///
/// Properties:
/// * [label] 
/// * [href] 
@BuiltValue()
abstract class AdminAuditDetailRelatedLinksInner implements Built<AdminAuditDetailRelatedLinksInner, AdminAuditDetailRelatedLinksInnerBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'href')
  String get href;

  AdminAuditDetailRelatedLinksInner._();

  factory AdminAuditDetailRelatedLinksInner([void updates(AdminAuditDetailRelatedLinksInnerBuilder b)]) = _$AdminAuditDetailRelatedLinksInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAuditDetailRelatedLinksInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAuditDetailRelatedLinksInner> get serializer => _$AdminAuditDetailRelatedLinksInnerSerializer();
}

class _$AdminAuditDetailRelatedLinksInnerSerializer implements PrimitiveSerializer<AdminAuditDetailRelatedLinksInner> {
  @override
  final Iterable<Type> types = const [AdminAuditDetailRelatedLinksInner, _$AdminAuditDetailRelatedLinksInner];

  @override
  final String wireName = r'AdminAuditDetailRelatedLinksInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAuditDetailRelatedLinksInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'href';
    yield serializers.serialize(
      object.href,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAuditDetailRelatedLinksInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminAuditDetailRelatedLinksInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'href':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.href = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminAuditDetailRelatedLinksInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAuditDetailRelatedLinksInnerBuilder();
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

