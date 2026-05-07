//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_salon_detail_owner.g.dart';

/// AdminSalonDetailOwner
///
/// Properties:
/// * [fullName] 
/// * [email] 
/// * [phone] 
@BuiltValue()
abstract class AdminSalonDetailOwner implements Built<AdminSalonDetailOwner, AdminSalonDetailOwnerBuilder> {
  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'phone')
  String get phone;

  AdminSalonDetailOwner._();

  factory AdminSalonDetailOwner([void updates(AdminSalonDetailOwnerBuilder b)]) = _$AdminSalonDetailOwner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSalonDetailOwnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSalonDetailOwner> get serializer => _$AdminSalonDetailOwnerSerializer();
}

class _$AdminSalonDetailOwnerSerializer implements PrimitiveSerializer<AdminSalonDetailOwner> {
  @override
  final Iterable<Type> types = const [AdminSalonDetailOwner, _$AdminSalonDetailOwner];

  @override
  final String wireName = r'AdminSalonDetailOwner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSalonDetailOwner object, {
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
    AdminSalonDetailOwner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSalonDetailOwnerBuilder result,
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
  AdminSalonDetailOwner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSalonDetailOwnerBuilder();
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

