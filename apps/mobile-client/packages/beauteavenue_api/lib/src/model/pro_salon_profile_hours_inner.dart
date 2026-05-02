//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_salon_profile_hours_inner.g.dart';

/// ProSalonProfileHoursInner
///
/// Properties:
/// * [dayOfWeek]
/// * [isOpen]
/// * [opensAt]
/// * [closesAt]
@BuiltValue()
abstract class ProSalonProfileHoursInner
    implements
        Built<ProSalonProfileHoursInner, ProSalonProfileHoursInnerBuilder> {
  @BuiltValueField(wireName: r'dayOfWeek')
  int get dayOfWeek;

  @BuiltValueField(wireName: r'isOpen')
  bool get isOpen;

  @BuiltValueField(wireName: r'opensAt')
  String? get opensAt;

  @BuiltValueField(wireName: r'closesAt')
  String? get closesAt;

  ProSalonProfileHoursInner._();

  factory ProSalonProfileHoursInner(
          [void updates(ProSalonProfileHoursInnerBuilder b)]) =
      _$ProSalonProfileHoursInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProSalonProfileHoursInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProSalonProfileHoursInner> get serializer =>
      _$ProSalonProfileHoursInnerSerializer();
}

class _$ProSalonProfileHoursInnerSerializer
    implements PrimitiveSerializer<ProSalonProfileHoursInner> {
  @override
  final Iterable<Type> types = const [
    ProSalonProfileHoursInner,
    _$ProSalonProfileHoursInner
  ];

  @override
  final String wireName = r'ProSalonProfileHoursInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProSalonProfileHoursInner object, {
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
    yield r'opensAt';
    yield object.opensAt == null
        ? null
        : serializers.serialize(
            object.opensAt,
            specifiedType: const FullType.nullable(String),
          );
    yield r'closesAt';
    yield object.closesAt == null
        ? null
        : serializers.serialize(
            object.closesAt,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProSalonProfileHoursInner object, {
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
    required ProSalonProfileHoursInnerBuilder result,
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.opensAt = valueDes;
          break;
        case r'closesAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  ProSalonProfileHoursInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProSalonProfileHoursInnerBuilder();
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
