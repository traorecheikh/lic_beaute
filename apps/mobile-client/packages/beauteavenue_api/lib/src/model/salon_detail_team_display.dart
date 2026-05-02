//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'salon_detail_team_display.g.dart';

/// SalonDetailTeamDisplay
///
/// Properties:
/// * [showPhotos]
/// * [showDescriptions]
@BuiltValue()
abstract class SalonDetailTeamDisplay
    implements Built<SalonDetailTeamDisplay, SalonDetailTeamDisplayBuilder> {
  @BuiltValueField(wireName: r'showPhotos')
  bool get showPhotos;

  @BuiltValueField(wireName: r'showDescriptions')
  bool get showDescriptions;

  SalonDetailTeamDisplay._();

  factory SalonDetailTeamDisplay(
          [void updates(SalonDetailTeamDisplayBuilder b)]) =
      _$SalonDetailTeamDisplay;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SalonDetailTeamDisplayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SalonDetailTeamDisplay> get serializer =>
      _$SalonDetailTeamDisplaySerializer();
}

class _$SalonDetailTeamDisplaySerializer
    implements PrimitiveSerializer<SalonDetailTeamDisplay> {
  @override
  final Iterable<Type> types = const [
    SalonDetailTeamDisplay,
    _$SalonDetailTeamDisplay
  ];

  @override
  final String wireName = r'SalonDetailTeamDisplay';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SalonDetailTeamDisplay object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'showPhotos';
    yield serializers.serialize(
      object.showPhotos,
      specifiedType: const FullType(bool),
    );
    yield r'showDescriptions';
    yield serializers.serialize(
      object.showDescriptions,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SalonDetailTeamDisplay object, {
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
    required SalonDetailTeamDisplayBuilder result,
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
  SalonDetailTeamDisplay deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SalonDetailTeamDisplayBuilder();
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
