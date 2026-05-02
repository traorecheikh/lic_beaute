//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'booking_summary.g.dart';

/// BookingSummary
///
/// Properties:
/// * [id]
/// * [salonId]
/// * [salonName]
/// * [serviceId]
/// * [serviceName]
/// * [startsAt]
/// * [endsAt]
/// * [status]
/// * [source_]
/// * [depositAmountXof]
/// * [depositPaymentStatus]
/// * [paymentProvider]
/// * [paymentId]
@BuiltValue()
abstract class BookingSummary
    implements Built<BookingSummary, BookingSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'salonId')
  String get salonId;

  @BuiltValueField(wireName: r'salonName')
  String get salonName;

  @BuiltValueField(wireName: r'serviceId')
  String get serviceId;

  @BuiltValueField(wireName: r'serviceName')
  String get serviceName;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  @BuiltValueField(wireName: r'status')
  BookingSummaryStatusEnum get status;
  // enum statusEnum {  pending,  confirmed,  in_progress,  completed,  cancelled,  };

  @BuiltValueField(wireName: r'source')
  String get source_;

  @BuiltValueField(wireName: r'depositAmountXof')
  num get depositAmountXof;

  @BuiltValueField(wireName: r'depositPaymentStatus')
  BookingSummaryDepositPaymentStatusEnum get depositPaymentStatus;
  // enum depositPaymentStatusEnum {  pending,  authorized,  succeeded,  failed,  refunded,  };

  @BuiltValueField(wireName: r'paymentProvider')
  BookingSummaryPaymentProviderEnum? get paymentProvider;
  // enum paymentProviderEnum {  wave,  orange_money,  };

  @BuiltValueField(wireName: r'paymentId')
  String? get paymentId;

  BookingSummary._();

  factory BookingSummary([void updates(BookingSummaryBuilder b)]) =
      _$BookingSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BookingSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BookingSummary> get serializer =>
      _$BookingSummarySerializer();
}

class _$BookingSummarySerializer
    implements PrimitiveSerializer<BookingSummary> {
  @override
  final Iterable<Type> types = const [BookingSummary, _$BookingSummary];

  @override
  final String wireName = r'BookingSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BookingSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'salonId';
    yield serializers.serialize(
      object.salonId,
      specifiedType: const FullType(String),
    );
    yield r'salonName';
    yield serializers.serialize(
      object.salonName,
      specifiedType: const FullType(String),
    );
    yield r'serviceId';
    yield serializers.serialize(
      object.serviceId,
      specifiedType: const FullType(String),
    );
    yield r'serviceName';
    yield serializers.serialize(
      object.serviceName,
      specifiedType: const FullType(String),
    );
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(BookingSummaryStatusEnum),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(String),
    );
    yield r'depositAmountXof';
    yield serializers.serialize(
      object.depositAmountXof,
      specifiedType: const FullType(num),
    );
    yield r'depositPaymentStatus';
    yield serializers.serialize(
      object.depositPaymentStatus,
      specifiedType: const FullType(BookingSummaryDepositPaymentStatusEnum),
    );
    yield r'paymentProvider';
    yield object.paymentProvider == null
        ? null
        : serializers.serialize(
            object.paymentProvider,
            specifiedType:
                const FullType.nullable(BookingSummaryPaymentProviderEnum),
          );
    yield r'paymentId';
    yield object.paymentId == null
        ? null
        : serializers.serialize(
            object.paymentId,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    BookingSummary object, {
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
    required BookingSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'salonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salonId = valueDes;
          break;
        case r'salonName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salonName = valueDes;
          break;
        case r'serviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.serviceId = valueDes;
          break;
        case r'serviceName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.serviceName = valueDes;
          break;
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startsAt = valueDes;
          break;
        case r'endsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.endsAt = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BookingSummaryStatusEnum),
          ) as BookingSummaryStatusEnum;
          result.status = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.source_ = valueDes;
          break;
        case r'depositAmountXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.depositAmountXof = valueDes;
          break;
        case r'depositPaymentStatus':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(BookingSummaryDepositPaymentStatusEnum),
          ) as BookingSummaryDepositPaymentStatusEnum;
          result.depositPaymentStatus = valueDes;
          break;
        case r'paymentProvider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType.nullable(BookingSummaryPaymentProviderEnum),
          ) as BookingSummaryPaymentProviderEnum?;
          if (valueDes == null) continue;
          result.paymentProvider = valueDes;
          break;
        case r'paymentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.paymentId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BookingSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BookingSummaryBuilder();
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

class BookingSummaryStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const BookingSummaryStatusEnum pending =
      _$bookingSummaryStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const BookingSummaryStatusEnum confirmed =
      _$bookingSummaryStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const BookingSummaryStatusEnum inProgress =
      _$bookingSummaryStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'completed')
  static const BookingSummaryStatusEnum completed =
      _$bookingSummaryStatusEnum_completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const BookingSummaryStatusEnum cancelled =
      _$bookingSummaryStatusEnum_cancelled;

  static Serializer<BookingSummaryStatusEnum> get serializer =>
      _$bookingSummaryStatusEnumSerializer;

  const BookingSummaryStatusEnum._(String name) : super(name);

  static BuiltSet<BookingSummaryStatusEnum> get values =>
      _$bookingSummaryStatusEnumValues;
  static BookingSummaryStatusEnum valueOf(String name) =>
      _$bookingSummaryStatusEnumValueOf(name);
}

class BookingSummaryDepositPaymentStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const BookingSummaryDepositPaymentStatusEnum pending =
      _$bookingSummaryDepositPaymentStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'authorized')
  static const BookingSummaryDepositPaymentStatusEnum authorized =
      _$bookingSummaryDepositPaymentStatusEnum_authorized;
  @BuiltValueEnumConst(wireName: r'succeeded')
  static const BookingSummaryDepositPaymentStatusEnum succeeded =
      _$bookingSummaryDepositPaymentStatusEnum_succeeded;
  @BuiltValueEnumConst(wireName: r'failed')
  static const BookingSummaryDepositPaymentStatusEnum failed =
      _$bookingSummaryDepositPaymentStatusEnum_failed;
  @BuiltValueEnumConst(wireName: r'refunded')
  static const BookingSummaryDepositPaymentStatusEnum refunded =
      _$bookingSummaryDepositPaymentStatusEnum_refunded;

  static Serializer<BookingSummaryDepositPaymentStatusEnum> get serializer =>
      _$bookingSummaryDepositPaymentStatusEnumSerializer;

  const BookingSummaryDepositPaymentStatusEnum._(String name) : super(name);

  static BuiltSet<BookingSummaryDepositPaymentStatusEnum> get values =>
      _$bookingSummaryDepositPaymentStatusEnumValues;
  static BookingSummaryDepositPaymentStatusEnum valueOf(String name) =>
      _$bookingSummaryDepositPaymentStatusEnumValueOf(name);
}

class BookingSummaryPaymentProviderEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'wave')
  static const BookingSummaryPaymentProviderEnum wave =
      _$bookingSummaryPaymentProviderEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const BookingSummaryPaymentProviderEnum orangeMoney =
      _$bookingSummaryPaymentProviderEnum_orangeMoney;

  static Serializer<BookingSummaryPaymentProviderEnum> get serializer =>
      _$bookingSummaryPaymentProviderEnumSerializer;

  const BookingSummaryPaymentProviderEnum._(String name) : super(name);

  static BuiltSet<BookingSummaryPaymentProviderEnum> get values =>
      _$bookingSummaryPaymentProviderEnumValues;
  static BookingSummaryPaymentProviderEnum valueOf(String name) =>
      _$bookingSummaryPaymentProviderEnumValueOf(name);
}
