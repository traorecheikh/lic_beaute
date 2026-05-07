//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'booking_reschedule_input.g.dart';

/// BookingRescheduleInput
///
/// Properties:
/// * [startsAt] 
@BuiltValue()
abstract class BookingRescheduleInput implements Built<BookingRescheduleInput, BookingRescheduleInputBuilder> {
  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  BookingRescheduleInput._();

  factory BookingRescheduleInput([void updates(BookingRescheduleInputBuilder b)]) = _$BookingRescheduleInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BookingRescheduleInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BookingRescheduleInput> get serializer => _$BookingRescheduleInputSerializer();
}

class _$BookingRescheduleInputSerializer implements PrimitiveSerializer<BookingRescheduleInput> {
  @override
  final Iterable<Type> types = const [BookingRescheduleInput, _$BookingRescheduleInput];

  @override
  final String wireName = r'BookingRescheduleInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BookingRescheduleInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BookingRescheduleInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BookingRescheduleInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startsAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BookingRescheduleInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BookingRescheduleInputBuilder();
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

