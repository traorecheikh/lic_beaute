//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'booking_create_input.g.dart';

/// BookingCreateInput
///
/// Properties:
/// * [salonId]
/// * [serviceId]
/// * [employeeId]
/// * [startsAt]
/// * [clientNote]
/// * [provider]
@BuiltValue()
abstract class BookingCreateInput
    implements Built<BookingCreateInput, BookingCreateInputBuilder> {
  @BuiltValueField(wireName: r'salonId')
  String get salonId;

  @BuiltValueField(wireName: r'serviceId')
  String get serviceId;

  @BuiltValueField(wireName: r'employeeId')
  String? get employeeId;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'clientNote')
  String? get clientNote;

  @BuiltValueField(wireName: r'provider')
  BookingCreateInputProviderEnum? get provider;
  // enum providerEnum {  wave,  orange_money,  };

  BookingCreateInput._();

  factory BookingCreateInput([void updates(BookingCreateInputBuilder b)]) =
      _$BookingCreateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BookingCreateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BookingCreateInput> get serializer =>
      _$BookingCreateInputSerializer();
}

class _$BookingCreateInputSerializer
    implements PrimitiveSerializer<BookingCreateInput> {
  @override
  final Iterable<Type> types = const [BookingCreateInput, _$BookingCreateInput];

  @override
  final String wireName = r'BookingCreateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BookingCreateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'salonId';
    yield serializers.serialize(
      object.salonId,
      specifiedType: const FullType(String),
    );
    yield r'serviceId';
    yield serializers.serialize(
      object.serviceId,
      specifiedType: const FullType(String),
    );
    if (object.employeeId != null) {
      yield r'employeeId';
      yield serializers.serialize(
        object.employeeId,
        specifiedType: const FullType(String),
      );
    }
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.clientNote != null) {
      yield r'clientNote';
      yield serializers.serialize(
        object.clientNote,
        specifiedType: const FullType(String),
      );
    }
    if (object.provider != null) {
      yield r'provider';
      yield serializers.serialize(
        object.provider,
        specifiedType: const FullType(BookingCreateInputProviderEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BookingCreateInput object, {
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
    required BookingCreateInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'salonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salonId = valueDes;
          break;
        case r'serviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.serviceId = valueDes;
          break;
        case r'employeeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.employeeId = valueDes;
          break;
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startsAt = valueDes;
          break;
        case r'clientNote':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientNote = valueDes;
          break;
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BookingCreateInputProviderEnum),
          ) as BookingCreateInputProviderEnum;
          result.provider = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BookingCreateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BookingCreateInputBuilder();
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

class BookingCreateInputProviderEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'wave')
  static const BookingCreateInputProviderEnum wave =
      _$bookingCreateInputProviderEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const BookingCreateInputProviderEnum orangeMoney =
      _$bookingCreateInputProviderEnum_orangeMoney;

  static Serializer<BookingCreateInputProviderEnum> get serializer =>
      _$bookingCreateInputProviderEnumSerializer;

  const BookingCreateInputProviderEnum._(String name) : super(name);

  static BuiltSet<BookingCreateInputProviderEnum> get values =>
      _$bookingCreateInputProviderEnumValues;
  static BookingCreateInputProviderEnum valueOf(String name) =>
      _$bookingCreateInputProviderEnumValueOf(name);
}
