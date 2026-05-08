//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_media_pending_get200_response_items_inner.g.dart';

/// ApiV1AdminMediaPendingGet200ResponseItemsInner
///
/// Properties:
/// * [id] 
/// * [salonId] 
/// * [uploadedBy] 
/// * [objectKey] 
/// * [mimeType] 
/// * [sizeBytes] 
/// * [purpose] 
/// * [uploadStatus] 
/// * [reviewStatus] 
/// * [originalFilename] 
/// * [createdAt] 
@BuiltValue()
abstract class ApiV1AdminMediaPendingGet200ResponseItemsInner implements Built<ApiV1AdminMediaPendingGet200ResponseItemsInner, ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'salonId')
  String get salonId;

  @BuiltValueField(wireName: r'uploadedBy')
  String get uploadedBy;

  @BuiltValueField(wireName: r'objectKey')
  String get objectKey;

  @BuiltValueField(wireName: r'mimeType')
  String get mimeType;

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  @BuiltValueField(wireName: r'purpose')
  String get purpose;

  @BuiltValueField(wireName: r'uploadStatus')
  String get uploadStatus;

  @BuiltValueField(wireName: r'reviewStatus')
  String get reviewStatus;

  @BuiltValueField(wireName: r'originalFilename')
  String get originalFilename;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  ApiV1AdminMediaPendingGet200ResponseItemsInner._();

  factory ApiV1AdminMediaPendingGet200ResponseItemsInner([void updates(ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder b)]) = _$ApiV1AdminMediaPendingGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminMediaPendingGet200ResponseItemsInner> get serializer => _$ApiV1AdminMediaPendingGet200ResponseItemsInnerSerializer();
}

class _$ApiV1AdminMediaPendingGet200ResponseItemsInnerSerializer implements PrimitiveSerializer<ApiV1AdminMediaPendingGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [ApiV1AdminMediaPendingGet200ResponseItemsInner, _$ApiV1AdminMediaPendingGet200ResponseItemsInner];

  @override
  final String wireName = r'ApiV1AdminMediaPendingGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminMediaPendingGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'salonId';
    yield serializers.serialize(
      object.salonId,
      specifiedType: const FullType(String),
    );
    yield r'uploadedBy';
    yield serializers.serialize(
      object.uploadedBy,
      specifiedType: const FullType(String),
    );
    yield r'objectKey';
    yield serializers.serialize(
      object.objectKey,
      specifiedType: const FullType(String),
    );
    yield r'mimeType';
    yield serializers.serialize(
      object.mimeType,
      specifiedType: const FullType(String),
    );
    yield r'sizeBytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
    );
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(String),
    );
    yield r'uploadStatus';
    yield serializers.serialize(
      object.uploadStatus,
      specifiedType: const FullType(String),
    );
    yield r'reviewStatus';
    yield serializers.serialize(
      object.reviewStatus,
      specifiedType: const FullType(String),
    );
    yield r'originalFilename';
    yield serializers.serialize(
      object.originalFilename,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminMediaPendingGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder result,
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
        case r'salonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salonId = valueDes;
          break;
        case r'uploadedBy':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uploadedBy = valueDes;
          break;
        case r'objectKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.objectKey = valueDes;
          break;
        case r'mimeType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mimeType = valueDes;
          break;
        case r'sizeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sizeBytes = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.purpose = valueDes;
          break;
        case r'uploadStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uploadStatus = valueDes;
          break;
        case r'reviewStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reviewStatus = valueDes;
          break;
        case r'originalFilename':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.originalFilename = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminMediaPendingGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminMediaPendingGet200ResponseItemsInnerBuilder();
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

