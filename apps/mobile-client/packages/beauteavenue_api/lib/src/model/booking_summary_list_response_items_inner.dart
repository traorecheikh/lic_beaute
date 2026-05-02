//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'booking_summary_list_response_items_inner.g.dart';

/// BookingSummaryListResponseItemsInner
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
abstract class BookingSummaryListResponseItemsInner
    implements
        Built<BookingSummaryListResponseItemsInner,
            BookingSummaryListResponseItemsInnerBuilder> {
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
  BookingSummaryListResponseItemsInnerStatusEnum get status;
  // enum statusEnum {  pending,  confirmed,  in_progress,  completed,  cancelled,  };

  @BuiltValueField(wireName: r'source')
  String get source_;

  @BuiltValueField(wireName: r'depositAmountXof')
  num get depositAmountXof;

  @BuiltValueField(wireName: r'depositPaymentStatus')
  BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
      get depositPaymentStatus;
  // enum depositPaymentStatusEnum {  pending,  authorized,  succeeded,  failed,  refunded,  };

  @BuiltValueField(wireName: r'paymentProvider')
  BookingSummaryListResponseItemsInnerPaymentProviderEnum? get paymentProvider;
  // enum paymentProviderEnum {  wave,  orange_money,  };

  @BuiltValueField(wireName: r'paymentId')
  String? get paymentId;

  BookingSummaryListResponseItemsInner._();

  factory BookingSummaryListResponseItemsInner(
          [void updates(BookingSummaryListResponseItemsInnerBuilder b)]) =
      _$BookingSummaryListResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BookingSummaryListResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BookingSummaryListResponseItemsInner> get serializer =>
      _$BookingSummaryListResponseItemsInnerSerializer();
}

class _$BookingSummaryListResponseItemsInnerSerializer
    implements PrimitiveSerializer<BookingSummaryListResponseItemsInner> {
  @override
  final Iterable<Type> types = const [
    BookingSummaryListResponseItemsInner,
    _$BookingSummaryListResponseItemsInner
  ];

  @override
  final String wireName = r'BookingSummaryListResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BookingSummaryListResponseItemsInner object, {
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
      specifiedType:
          const FullType(BookingSummaryListResponseItemsInnerStatusEnum),
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
      specifiedType: const FullType(
          BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum),
    );
    yield r'paymentProvider';
    yield object.paymentProvider == null
        ? null
        : serializers.serialize(
            object.paymentProvider,
            specifiedType: const FullType.nullable(
                BookingSummaryListResponseItemsInnerPaymentProviderEnum),
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
    BookingSummaryListResponseItemsInner object, {
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
    required BookingSummaryListResponseItemsInnerBuilder result,
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
            specifiedType:
                const FullType(BookingSummaryListResponseItemsInnerStatusEnum),
          ) as BookingSummaryListResponseItemsInnerStatusEnum;
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
            specifiedType: const FullType(
                BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum),
          ) as BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum;
          result.depositPaymentStatus = valueDes;
          break;
        case r'paymentProvider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(
                BookingSummaryListResponseItemsInnerPaymentProviderEnum),
          ) as BookingSummaryListResponseItemsInnerPaymentProviderEnum?;
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
  BookingSummaryListResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BookingSummaryListResponseItemsInnerBuilder();
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

class BookingSummaryListResponseItemsInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const BookingSummaryListResponseItemsInnerStatusEnum pending =
      _$bookingSummaryListResponseItemsInnerStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const BookingSummaryListResponseItemsInnerStatusEnum confirmed =
      _$bookingSummaryListResponseItemsInnerStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const BookingSummaryListResponseItemsInnerStatusEnum inProgress =
      _$bookingSummaryListResponseItemsInnerStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'completed')
  static const BookingSummaryListResponseItemsInnerStatusEnum completed =
      _$bookingSummaryListResponseItemsInnerStatusEnum_completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const BookingSummaryListResponseItemsInnerStatusEnum cancelled =
      _$bookingSummaryListResponseItemsInnerStatusEnum_cancelled;

  static Serializer<BookingSummaryListResponseItemsInnerStatusEnum>
      get serializer =>
          _$bookingSummaryListResponseItemsInnerStatusEnumSerializer;

  const BookingSummaryListResponseItemsInnerStatusEnum._(String name)
      : super(name);

  static BuiltSet<BookingSummaryListResponseItemsInnerStatusEnum> get values =>
      _$bookingSummaryListResponseItemsInnerStatusEnumValues;
  static BookingSummaryListResponseItemsInnerStatusEnum valueOf(String name) =>
      _$bookingSummaryListResponseItemsInnerStatusEnumValueOf(name);
}

class BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
      pending =
      _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'authorized')
  static const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
      authorized =
      _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_authorized;
  @BuiltValueEnumConst(wireName: r'succeeded')
  static const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
      succeeded =
      _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_succeeded;
  @BuiltValueEnumConst(wireName: r'failed')
  static const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
      failed =
      _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_failed;
  @BuiltValueEnumConst(wireName: r'refunded')
  static const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
      refunded =
      _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_refunded;

  static Serializer<
          BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum>
      get serializer =>
          _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnumSerializer;

  const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum._(
      String name)
      : super(name);

  static BuiltSet<BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum>
      get values =>
          _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnumValues;
  static BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum valueOf(
          String name) =>
      _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnumValueOf(
          name);
}

class BookingSummaryListResponseItemsInnerPaymentProviderEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'wave')
  static const BookingSummaryListResponseItemsInnerPaymentProviderEnum wave =
      _$bookingSummaryListResponseItemsInnerPaymentProviderEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const BookingSummaryListResponseItemsInnerPaymentProviderEnum
      orangeMoney =
      _$bookingSummaryListResponseItemsInnerPaymentProviderEnum_orangeMoney;

  static Serializer<BookingSummaryListResponseItemsInnerPaymentProviderEnum>
      get serializer =>
          _$bookingSummaryListResponseItemsInnerPaymentProviderEnumSerializer;

  const BookingSummaryListResponseItemsInnerPaymentProviderEnum._(String name)
      : super(name);

  static BuiltSet<BookingSummaryListResponseItemsInnerPaymentProviderEnum>
      get values =>
          _$bookingSummaryListResponseItemsInnerPaymentProviderEnumValues;
  static BookingSummaryListResponseItemsInnerPaymentProviderEnum valueOf(
          String name) =>
      _$bookingSummaryListResponseItemsInnerPaymentProviderEnumValueOf(name);
}
