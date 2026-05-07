//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_input_any_of1_hours_inner.g.dart';

/// RegisterInputAnyOf1HoursInner
///
/// Properties:
/// * [dayOfWeek] 
/// * [isOpen] 
/// * [opensAt] 
/// * [closesAt] 
@BuiltValue()
abstract class RegisterInputAnyOf1HoursInner implements Built<RegisterInputAnyOf1HoursInner, RegisterInputAnyOf1HoursInnerBuilder> {
  @BuiltValueField(wireName: r'dayOfWeek')
  int get dayOfWeek;

  @BuiltValueField(wireName: r'isOpen')
  bool get isOpen;

  @BuiltValueField(wireName: r'opensAt')
  String? get opensAt;

  @BuiltValueField(wireName: r'closesAt')
  String? get closesAt;

  RegisterInputAnyOf1HoursInner._();

  factory RegisterInputAnyOf1HoursInner([void updates(RegisterInputAnyOf1HoursInnerBuilder b)]) = _$RegisterInputAnyOf1HoursInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterInputAnyOf1HoursInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterInputAnyOf1HoursInner> get serializer => _$RegisterInputAnyOf1HoursInnerSerializer();
}

class _$RegisterInputAnyOf1HoursInnerSerializer implements PrimitiveSerializer<RegisterInputAnyOf1HoursInner> {
  @override
  final Iterable<Type> types = const [RegisterInputAnyOf1HoursInner, _$RegisterInputAnyOf1HoursInner];

  @override
  final String wireName = r'RegisterInputAnyOf1HoursInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterInputAnyOf1HoursInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'dayOfWeek';
    yield serializers.serialize(
      object.dayOfWeek,
      specifiedType: const FullType(int),
    );
    yield r'isOpen';
    yield serializers.serialize(
      object.isOpen,
      specifiedType: const FullType(bool),
    );
    if (object.opensAt != null) {
      yield r'opensAt';
      yield serializers.serialize(
        object.opensAt,
        specifiedType: const FullType(String),
      );
    }
    if (object.closesAt != null) {
      yield r'closesAt';
      yield serializers.serialize(
        object.closesAt,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterInputAnyOf1HoursInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterInputAnyOf1HoursInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'dayOfWeek':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.dayOfWeek = valueDes;
          break;
        case r'isOpen':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isOpen = valueDes;
          break;
        case r'opensAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.opensAt = valueDes;
          break;
        case r'closesAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.closesAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegisterInputAnyOf1HoursInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterInputAnyOf1HoursInnerBuilder();
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

