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
/// * [channel] 
@BuiltValue()
abstract class BookingCreateInput implements Built<BookingCreateInput, BookingCreateInputBuilder> {
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
  // enum providerEnum {  intech,  paydunya,  manual,  };

  @BuiltValueField(wireName: r'channel')
  BookingCreateInputChannelEnum? get channel;
  // enum channelEnum {  wave,  orange_money,  free_money,  paydunya_card,  paydunya_airtel,  paydunya_expresso,  paydunya_free,  paydunya_mpesa,  paydunya_ng_airtel,  paydunya_ng_mtn,  paydunya_ng_9mobile,  paydunya_ng_glo,  paydunya_sam_airtel,  paydunya_sam_mtn,  paydunya_sam_safaricom,  paydunya_tigo_rw,  paydunya_airtel_rw,  paydunya_mtn_rw,  paydunya_mtn_ug,  paydunya_airtel_ug,  paydunya_orange_ml,  paydunya_mtn_ci,  paydunya_mtn_gh,  paydunya_vodafone_gh,  paydunya_airteltigo_gh,  paydunya_tm_ci,  paydunya_moov_tg,  paydunya_togocel_tg,  paydunya_wari_sn,  paydunya_wave_sn,  paydunya_cb_ci,  paydunya_orange_sn,  paydunya_free_sn,  paydunya_yup_bj,  paydunya_mtn_bj,  paydunya_moov_ci,  paydunya_orange_cm,  paydunya_mtn_cm,  paydunya_nexttel_cm,  paydunya_camtel_cm,  };

  BookingCreateInput._();

  factory BookingCreateInput([void updates(BookingCreateInputBuilder b)]) = _$BookingCreateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BookingCreateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BookingCreateInput> get serializer => _$BookingCreateInputSerializer();
}

class _$BookingCreateInputSerializer implements PrimitiveSerializer<BookingCreateInput> {
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
    if (object.channel != null) {
      yield r'channel';
      yield serializers.serialize(
        object.channel,
        specifiedType: const FullType(BookingCreateInputChannelEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BookingCreateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
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
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BookingCreateInputChannelEnum),
          ) as BookingCreateInputChannelEnum;
          result.channel = valueDes;
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

  @BuiltValueEnumConst(wireName: r'intech')
  static const BookingCreateInputProviderEnum intech = _$bookingCreateInputProviderEnum_intech;
  @BuiltValueEnumConst(wireName: r'paydunya')
  static const BookingCreateInputProviderEnum paydunya = _$bookingCreateInputProviderEnum_paydunya;
  @BuiltValueEnumConst(wireName: r'manual')
  static const BookingCreateInputProviderEnum manual = _$bookingCreateInputProviderEnum_manual;

  static Serializer<BookingCreateInputProviderEnum> get serializer => _$bookingCreateInputProviderEnumSerializer;

  const BookingCreateInputProviderEnum._(String name): super(name);

  static BuiltSet<BookingCreateInputProviderEnum> get values => _$bookingCreateInputProviderEnumValues;
  static BookingCreateInputProviderEnum valueOf(String name) => _$bookingCreateInputProviderEnumValueOf(name);
}

class BookingCreateInputChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'wave')
  static const BookingCreateInputChannelEnum wave = _$bookingCreateInputChannelEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const BookingCreateInputChannelEnum orangeMoney = _$bookingCreateInputChannelEnum_orangeMoney;
  @BuiltValueEnumConst(wireName: r'free_money')
  static const BookingCreateInputChannelEnum freeMoney = _$bookingCreateInputChannelEnum_freeMoney;
  @BuiltValueEnumConst(wireName: r'paydunya_card')
  static const BookingCreateInputChannelEnum paydunyaCard = _$bookingCreateInputChannelEnum_paydunyaCard;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel')
  static const BookingCreateInputChannelEnum paydunyaAirtel = _$bookingCreateInputChannelEnum_paydunyaAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_expresso')
  static const BookingCreateInputChannelEnum paydunyaExpresso = _$bookingCreateInputChannelEnum_paydunyaExpresso;
  @BuiltValueEnumConst(wireName: r'paydunya_free')
  static const BookingCreateInputChannelEnum paydunyaFree = _$bookingCreateInputChannelEnum_paydunyaFree;
  @BuiltValueEnumConst(wireName: r'paydunya_mpesa')
  static const BookingCreateInputChannelEnum paydunyaMpesa = _$bookingCreateInputChannelEnum_paydunyaMpesa;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_airtel')
  static const BookingCreateInputChannelEnum paydunyaNgAirtel = _$bookingCreateInputChannelEnum_paydunyaNgAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_mtn')
  static const BookingCreateInputChannelEnum paydunyaNgMtn = _$bookingCreateInputChannelEnum_paydunyaNgMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_9mobile')
  static const BookingCreateInputChannelEnum paydunyaNg9mobile = _$bookingCreateInputChannelEnum_paydunyaNg9mobile;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_glo')
  static const BookingCreateInputChannelEnum paydunyaNgGlo = _$bookingCreateInputChannelEnum_paydunyaNgGlo;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_airtel')
  static const BookingCreateInputChannelEnum paydunyaSamAirtel = _$bookingCreateInputChannelEnum_paydunyaSamAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_mtn')
  static const BookingCreateInputChannelEnum paydunyaSamMtn = _$bookingCreateInputChannelEnum_paydunyaSamMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_safaricom')
  static const BookingCreateInputChannelEnum paydunyaSamSafaricom = _$bookingCreateInputChannelEnum_paydunyaSamSafaricom;
  @BuiltValueEnumConst(wireName: r'paydunya_tigo_rw')
  static const BookingCreateInputChannelEnum paydunyaTigoRw = _$bookingCreateInputChannelEnum_paydunyaTigoRw;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_rw')
  static const BookingCreateInputChannelEnum paydunyaAirtelRw = _$bookingCreateInputChannelEnum_paydunyaAirtelRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_rw')
  static const BookingCreateInputChannelEnum paydunyaMtnRw = _$bookingCreateInputChannelEnum_paydunyaMtnRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ug')
  static const BookingCreateInputChannelEnum paydunyaMtnUg = _$bookingCreateInputChannelEnum_paydunyaMtnUg;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_ug')
  static const BookingCreateInputChannelEnum paydunyaAirtelUg = _$bookingCreateInputChannelEnum_paydunyaAirtelUg;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_ml')
  static const BookingCreateInputChannelEnum paydunyaOrangeMl = _$bookingCreateInputChannelEnum_paydunyaOrangeMl;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ci')
  static const BookingCreateInputChannelEnum paydunyaMtnCi = _$bookingCreateInputChannelEnum_paydunyaMtnCi;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_gh')
  static const BookingCreateInputChannelEnum paydunyaMtnGh = _$bookingCreateInputChannelEnum_paydunyaMtnGh;
  @BuiltValueEnumConst(wireName: r'paydunya_vodafone_gh')
  static const BookingCreateInputChannelEnum paydunyaVodafoneGh = _$bookingCreateInputChannelEnum_paydunyaVodafoneGh;
  @BuiltValueEnumConst(wireName: r'paydunya_airteltigo_gh')
  static const BookingCreateInputChannelEnum paydunyaAirteltigoGh = _$bookingCreateInputChannelEnum_paydunyaAirteltigoGh;
  @BuiltValueEnumConst(wireName: r'paydunya_tm_ci')
  static const BookingCreateInputChannelEnum paydunyaTmCi = _$bookingCreateInputChannelEnum_paydunyaTmCi;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_tg')
  static const BookingCreateInputChannelEnum paydunyaMoovTg = _$bookingCreateInputChannelEnum_paydunyaMoovTg;
  @BuiltValueEnumConst(wireName: r'paydunya_togocel_tg')
  static const BookingCreateInputChannelEnum paydunyaTogocelTg = _$bookingCreateInputChannelEnum_paydunyaTogocelTg;
  @BuiltValueEnumConst(wireName: r'paydunya_wari_sn')
  static const BookingCreateInputChannelEnum paydunyaWariSn = _$bookingCreateInputChannelEnum_paydunyaWariSn;
  @BuiltValueEnumConst(wireName: r'paydunya_wave_sn')
  static const BookingCreateInputChannelEnum paydunyaWaveSn = _$bookingCreateInputChannelEnum_paydunyaWaveSn;
  @BuiltValueEnumConst(wireName: r'paydunya_cb_ci')
  static const BookingCreateInputChannelEnum paydunyaCbCi = _$bookingCreateInputChannelEnum_paydunyaCbCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_sn')
  static const BookingCreateInputChannelEnum paydunyaOrangeSn = _$bookingCreateInputChannelEnum_paydunyaOrangeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_free_sn')
  static const BookingCreateInputChannelEnum paydunyaFreeSn = _$bookingCreateInputChannelEnum_paydunyaFreeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_yup_bj')
  static const BookingCreateInputChannelEnum paydunyaYupBj = _$bookingCreateInputChannelEnum_paydunyaYupBj;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_bj')
  static const BookingCreateInputChannelEnum paydunyaMtnBj = _$bookingCreateInputChannelEnum_paydunyaMtnBj;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_ci')
  static const BookingCreateInputChannelEnum paydunyaMoovCi = _$bookingCreateInputChannelEnum_paydunyaMoovCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_cm')
  static const BookingCreateInputChannelEnum paydunyaOrangeCm = _$bookingCreateInputChannelEnum_paydunyaOrangeCm;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_cm')
  static const BookingCreateInputChannelEnum paydunyaMtnCm = _$bookingCreateInputChannelEnum_paydunyaMtnCm;
  @BuiltValueEnumConst(wireName: r'paydunya_nexttel_cm')
  static const BookingCreateInputChannelEnum paydunyaNexttelCm = _$bookingCreateInputChannelEnum_paydunyaNexttelCm;
  @BuiltValueEnumConst(wireName: r'paydunya_camtel_cm')
  static const BookingCreateInputChannelEnum paydunyaCamtelCm = _$bookingCreateInputChannelEnum_paydunyaCamtelCm;

  static Serializer<BookingCreateInputChannelEnum> get serializer => _$bookingCreateInputChannelEnumSerializer;

  const BookingCreateInputChannelEnum._(String name): super(name);

  static BuiltSet<BookingCreateInputChannelEnum> get values => _$bookingCreateInputChannelEnumValues;
  static BookingCreateInputChannelEnum valueOf(String name) => _$bookingCreateInputChannelEnumValueOf(name);
}

