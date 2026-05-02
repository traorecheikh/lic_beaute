//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'otp_accepted_response.g.dart';

/// OtpAcceptedResponse
///
/// Properties:
/// * [accepted]
/// * [channel]
/// * [destination]
@BuiltValue()
abstract class OtpAcceptedResponse
    implements Built<OtpAcceptedResponse, OtpAcceptedResponseBuilder> {
  @BuiltValueField(wireName: r'accepted')
  bool get accepted;

  @BuiltValueField(wireName: r'channel')
  String get channel;

  @BuiltValueField(wireName: r'destination')
  String get destination;

  OtpAcceptedResponse._();

  factory OtpAcceptedResponse([void updates(OtpAcceptedResponseBuilder b)]) =
      _$OtpAcceptedResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OtpAcceptedResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OtpAcceptedResponse> get serializer =>
      _$OtpAcceptedResponseSerializer();
}

class _$OtpAcceptedResponseSerializer
    implements PrimitiveSerializer<OtpAcceptedResponse> {
  @override
  final Iterable<Type> types = const [
    OtpAcceptedResponse,
    _$OtpAcceptedResponse
  ];

  @override
  final String wireName = r'OtpAcceptedResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OtpAcceptedResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accepted';
    yield serializers.serialize(
      object.accepted,
      specifiedType: const FullType(bool),
    );
    yield r'channel';
    yield serializers.serialize(
      object.channel,
      specifiedType: const FullType(String),
    );
    yield r'destination';
    yield serializers.serialize(
      object.destination,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OtpAcceptedResponse object, {
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
    required OtpAcceptedResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.accepted = valueDes;
          break;
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.channel = valueDes;
          break;
        case r'destination':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.destination = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OtpAcceptedResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OtpAcceptedResponseBuilder();
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
