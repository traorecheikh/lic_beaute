//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_salon_detail_documents_inner.g.dart';

/// AdminSalonDetailDocumentsInner
///
/// Properties:
/// * [label] 
/// * [status] 
/// * [note] 
/// * [fileUrl] 
@BuiltValue()
abstract class AdminSalonDetailDocumentsInner implements Built<AdminSalonDetailDocumentsInner, AdminSalonDetailDocumentsInnerBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'status')
  AdminSalonDetailDocumentsInnerStatusEnum get status;
  // enum statusEnum {  received,  missing,  invalid,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'fileUrl')
  String? get fileUrl;

  AdminSalonDetailDocumentsInner._();

  factory AdminSalonDetailDocumentsInner([void updates(AdminSalonDetailDocumentsInnerBuilder b)]) = _$AdminSalonDetailDocumentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSalonDetailDocumentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSalonDetailDocumentsInner> get serializer => _$AdminSalonDetailDocumentsInnerSerializer();
}

class _$AdminSalonDetailDocumentsInnerSerializer implements PrimitiveSerializer<AdminSalonDetailDocumentsInner> {
  @override
  final Iterable<Type> types = const [AdminSalonDetailDocumentsInner, _$AdminSalonDetailDocumentsInner];

  @override
  final String wireName = r'AdminSalonDetailDocumentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSalonDetailDocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminSalonDetailDocumentsInnerStatusEnum),
    );
    yield r'note';
    yield object.note == null ? null : serializers.serialize(
      object.note,
      specifiedType: const FullType.nullable(String),
    );
    yield r'fileUrl';
    yield object.fileUrl == null ? null : serializers.serialize(
      object.fileUrl,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSalonDetailDocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSalonDetailDocumentsInnerBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSalonDetailDocumentsInnerStatusEnum),
          ) as AdminSalonDetailDocumentsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'fileUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fileUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSalonDetailDocumentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSalonDetailDocumentsInnerBuilder();
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

class AdminSalonDetailDocumentsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'received')
  static const AdminSalonDetailDocumentsInnerStatusEnum received = _$adminSalonDetailDocumentsInnerStatusEnum_received;
  @BuiltValueEnumConst(wireName: r'missing')
  static const AdminSalonDetailDocumentsInnerStatusEnum missing = _$adminSalonDetailDocumentsInnerStatusEnum_missing;
  @BuiltValueEnumConst(wireName: r'invalid')
  static const AdminSalonDetailDocumentsInnerStatusEnum invalid = _$adminSalonDetailDocumentsInnerStatusEnum_invalid;

  static Serializer<AdminSalonDetailDocumentsInnerStatusEnum> get serializer => _$adminSalonDetailDocumentsInnerStatusEnumSerializer;

  const AdminSalonDetailDocumentsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminSalonDetailDocumentsInnerStatusEnum> get values => _$adminSalonDetailDocumentsInnerStatusEnumValues;
  static AdminSalonDetailDocumentsInnerStatusEnum valueOf(String name) => _$adminSalonDetailDocumentsInnerStatusEnumValueOf(name);
}

