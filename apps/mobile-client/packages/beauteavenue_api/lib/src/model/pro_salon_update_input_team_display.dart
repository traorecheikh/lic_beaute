//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_salon_update_input_team_display.g.dart';

/// ProSalonUpdateInputTeamDisplay
///
/// Properties:
/// * [showPhotos]
/// * [showDescriptions]
@BuiltValue()
abstract class ProSalonUpdateInputTeamDisplay
    implements
        Built<ProSalonUpdateInputTeamDisplay,
            ProSalonUpdateInputTeamDisplayBuilder> {
  @BuiltValueField(wireName: r'showPhotos')
  bool? get showPhotos;

  @BuiltValueField(wireName: r'showDescriptions')
  bool? get showDescriptions;

  ProSalonUpdateInputTeamDisplay._();

  factory ProSalonUpdateInputTeamDisplay(
          [void updates(ProSalonUpdateInputTeamDisplayBuilder b)]) =
      _$ProSalonUpdateInputTeamDisplay;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProSalonUpdateInputTeamDisplayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProSalonUpdateInputTeamDisplay> get serializer =>
      _$ProSalonUpdateInputTeamDisplaySerializer();
}

class _$ProSalonUpdateInputTeamDisplaySerializer
    implements PrimitiveSerializer<ProSalonUpdateInputTeamDisplay> {
  @override
  final Iterable<Type> types = const [
    ProSalonUpdateInputTeamDisplay,
    _$ProSalonUpdateInputTeamDisplay
  ];

  @override
  final String wireName = r'ProSalonUpdateInputTeamDisplay';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProSalonUpdateInputTeamDisplay object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.showPhotos != null) {
      yield r'showPhotos';
      yield serializers.serialize(
        object.showPhotos,
        specifiedType: const FullType(bool),
      );
    }
    if (object.showDescriptions != null) {
      yield r'showDescriptions';
      yield serializers.serialize(
        object.showDescriptions,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProSalonUpdateInputTeamDisplay object, {
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
    required ProSalonUpdateInputTeamDisplayBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'showPhotos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.showPhotos = valueDes;
          break;
        case r'showDescriptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.showDescriptions = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProSalonUpdateInputTeamDisplay deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProSalonUpdateInputTeamDisplayBuilder();
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
