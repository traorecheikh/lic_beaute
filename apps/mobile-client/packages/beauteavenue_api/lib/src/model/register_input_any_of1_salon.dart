//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_input_any_of1_salon.g.dart';

/// RegisterInputAnyOf1Salon
///
/// Properties:
/// * [name]
/// * [category]
/// * [city]
/// * [address]
/// * [description]
@BuiltValue()
abstract class RegisterInputAnyOf1Salon
    implements
        Built<RegisterInputAnyOf1Salon, RegisterInputAnyOf1SalonBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'city')
  String get city;

  @BuiltValueField(wireName: r'address')
  String get address;

  @BuiltValueField(wireName: r'description')
  String? get description;

  RegisterInputAnyOf1Salon._();

  factory RegisterInputAnyOf1Salon(
          [void updates(RegisterInputAnyOf1SalonBuilder b)]) =
      _$RegisterInputAnyOf1Salon;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterInputAnyOf1SalonBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterInputAnyOf1Salon> get serializer =>
      _$RegisterInputAnyOf1SalonSerializer();
}

class _$RegisterInputAnyOf1SalonSerializer
    implements PrimitiveSerializer<RegisterInputAnyOf1Salon> {
  @override
  final Iterable<Type> types = const [
    RegisterInputAnyOf1Salon,
    _$RegisterInputAnyOf1Salon
  ];

  @override
  final String wireName = r'RegisterInputAnyOf1Salon';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterInputAnyOf1Salon object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'city';
    yield serializers.serialize(
      object.city,
      specifiedType: const FullType(String),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(String),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterInputAnyOf1Salon object, {
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
    required RegisterInputAnyOf1SalonBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.address = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegisterInputAnyOf1Salon deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterInputAnyOf1SalonBuilder();
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
