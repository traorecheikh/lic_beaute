//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_admin_salons_post201_response_owner.g.dart';

/// ApiV1AdminSalonsPost201ResponseOwner
///
/// Properties:
/// * [fullName] 
/// * [email] 
/// * [phone] 
@BuiltValue()
abstract class ApiV1AdminSalonsPost201ResponseOwner implements Built<ApiV1AdminSalonsPost201ResponseOwner, ApiV1AdminSalonsPost201ResponseOwnerBuilder> {
  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'phone')
  String get phone;

  ApiV1AdminSalonsPost201ResponseOwner._();

  factory ApiV1AdminSalonsPost201ResponseOwner([void updates(ApiV1AdminSalonsPost201ResponseOwnerBuilder b)]) = _$ApiV1AdminSalonsPost201ResponseOwner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1AdminSalonsPost201ResponseOwnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1AdminSalonsPost201ResponseOwner> get serializer => _$ApiV1AdminSalonsPost201ResponseOwnerSerializer();
}

class _$ApiV1AdminSalonsPost201ResponseOwnerSerializer implements PrimitiveSerializer<ApiV1AdminSalonsPost201ResponseOwner> {
  @override
  final Iterable<Type> types = const [ApiV1AdminSalonsPost201ResponseOwner, _$ApiV1AdminSalonsPost201ResponseOwner];

  @override
  final String wireName = r'ApiV1AdminSalonsPost201ResponseOwner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1AdminSalonsPost201ResponseOwner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiV1AdminSalonsPost201ResponseOwner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1AdminSalonsPost201ResponseOwnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fullName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiV1AdminSalonsPost201ResponseOwner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1AdminSalonsPost201ResponseOwnerBuilder();
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

