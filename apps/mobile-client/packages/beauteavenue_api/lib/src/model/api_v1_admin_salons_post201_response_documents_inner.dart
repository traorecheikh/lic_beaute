//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_salons_post201_response_documents_inner.g.dart';

/// ApiV1AdminSalonsPost201ResponseDocumentsInner
///
/// Properties:
/// * [label] 
/// * [status] 
/// * [note] 
/// * [fileUrl] 
@BuiltValue()
abstract class ApiV1AdminSalonsPost201ResponseDocumentsInner implements Built<ApiV1AdminSalonsPost201ResponseDocumentsInner, ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'status')
  ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum get status;
  // enum statusEnum {  received,  missing,  invalid,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'fileUrl')
  String? get fileUrl;

  ApiV1AdminSalonsPost201ResponseDocumentsInner._();

  factory ApiV1AdminSalonsPost201ResponseDocumentsInner([void updates(ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder b)]) = _$ApiV1AdminSalonsPost201ResponseDocumentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminSalonsPost201ResponseDocumentsInner> get serializer => _$ApiV1AdminSalonsPost201ResponseDocumentsInnerSerializer();
}

class _$ApiV1AdminSalonsPost201ResponseDocumentsInnerSerializer implements PrimitiveSerializer<ApiV1AdminSalonsPost201ResponseDocumentsInner> {
  @override
  final Iterable<Type> types = const [ApiV1AdminSalonsPost201ResponseDocumentsInner, _$ApiV1AdminSalonsPost201ResponseDocumentsInner];

  @override
  final String wireName = r'ApiV1AdminSalonsPost201ResponseDocumentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminSalonsPost201ResponseDocumentsInner object, {
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
      specifiedType: const FullType(ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum),
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
    ApiV1AdminSalonsPost201ResponseDocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder result,
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
            specifiedType: const FullType(ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum),
          ) as ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum;
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
  ApiV1AdminSalonsPost201ResponseDocumentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder();
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

class ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'received')
  static const ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum received = _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum_received;
  @BuiltValueEnumConst(wireName: r'missing')
  static const ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum missing = _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum_missing;
  @BuiltValueEnumConst(wireName: r'invalid')
  static const ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum invalid = _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum_invalid;

  static Serializer<ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum> get serializer => _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnumSerializer;

  const ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum._(String name): super(name);

  static BuiltSet<ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum> get values => _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnumValues;
  static ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum valueOf(String name) => _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnumValueOf(name);
}

