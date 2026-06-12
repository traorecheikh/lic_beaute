//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'payment_initiate_input.g.dart';

/// PaymentInitiateInput
///
/// Properties:
/// * [bookingId] 
/// * [provider] 
/// * [channel] 
@BuiltValue()
abstract class PaymentInitiateInput implements Built<PaymentInitiateInput, PaymentInitiateInputBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'provider')
  PaymentInitiateInputProviderEnum get provider;
  // enum providerEnum {  paydunya,  manual,  };

  @BuiltValueField(wireName: r'channel')
  PaymentInitiateInputChannelEnum? get channel;
  // enum channelEnum {  carte_bancaire,  wave_senegal,  orange_senegal,  free_senegal,  wizall_senegal,  expresso_sn,  om_ci,  mtn_ci,  moov_ci,  wave_ci,  om_bf,  moov_bf,  moov_bj,  mtn_bj,  t_money_tg,  moov_tg,  om_ml,  moov_ml,  mtn_cm,  djamo,  paydunya_wallet,  wave,  orange_money,  free_money,  paydunya_card,  paydunya_airtel,  paydunya_expresso,  paydunya_free,  paydunya_mpesa,  paydunya_ng_airtel,  paydunya_ng_mtn,  paydunya_ng_9mobile,  paydunya_ng_glo,  paydunya_sam_airtel,  paydunya_sam_mtn,  paydunya_sam_safaricom,  paydunya_tigo_rw,  paydunya_airtel_rw,  paydunya_mtn_rw,  paydunya_mtn_ug,  paydunya_airtel_ug,  paydunya_orange_ml,  paydunya_mtn_ci,  paydunya_mtn_gh,  paydunya_vodafone_gh,  paydunya_airteltigo_gh,  paydunya_tm_ci,  paydunya_moov_tg,  paydunya_togocel_tg,  paydunya_wari_sn,  paydunya_wave_sn,  paydunya_cb_ci,  paydunya_orange_sn,  paydunya_free_sn,  paydunya_yup_bj,  paydunya_mtn_bj,  paydunya_moov_ci,  paydunya_orange_cm,  paydunya_mtn_cm,  paydunya_nexttel_cm,  paydunya_camtel_cm,  };

  PaymentInitiateInput._();

  factory PaymentInitiateInput([void updates(PaymentInitiateInputBuilder b)]) = _$PaymentInitiateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PaymentInitiateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PaymentInitiateInput> get serializer => _$PaymentInitiateInputSerializer();
}

class _$PaymentInitiateInputSerializer implements PrimitiveSerializer<PaymentInitiateInput> {
  @override
  final Iterable<Type> types = const [PaymentInitiateInput, _$PaymentInitiateInput];

  @override
  final String wireName = r'PaymentInitiateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PaymentInitiateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(PaymentInitiateInputProviderEnum),
    );
    if (object.channel != null) {
      yield r'channel';
      yield serializers.serialize(
        object.channel,
        specifiedType: const FullType(PaymentInitiateInputChannelEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PaymentInitiateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PaymentInitiateInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentInitiateInputProviderEnum),
          ) as PaymentInitiateInputProviderEnum;
          result.provider = valueDes;
          break;
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PaymentInitiateInputChannelEnum),
          ) as PaymentInitiateInputChannelEnum;
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
  PaymentInitiateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentInitiateInputBuilder();
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

class PaymentInitiateInputProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'paydunya')
  static const PaymentInitiateInputProviderEnum paydunya = _$paymentInitiateInputProviderEnum_paydunya;
  @BuiltValueEnumConst(wireName: r'manual')
  static const PaymentInitiateInputProviderEnum manual = _$paymentInitiateInputProviderEnum_manual;

  static Serializer<PaymentInitiateInputProviderEnum> get serializer => _$paymentInitiateInputProviderEnumSerializer;

  const PaymentInitiateInputProviderEnum._(String name): super(name);

  static BuiltSet<PaymentInitiateInputProviderEnum> get values => _$paymentInitiateInputProviderEnumValues;
  static PaymentInitiateInputProviderEnum valueOf(String name) => _$paymentInitiateInputProviderEnumValueOf(name);
}

class PaymentInitiateInputChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'carte_bancaire')
  static const PaymentInitiateInputChannelEnum carteBancaire = _$paymentInitiateInputChannelEnum_carteBancaire;
  @BuiltValueEnumConst(wireName: r'wave_senegal')
  static const PaymentInitiateInputChannelEnum waveSenegal = _$paymentInitiateInputChannelEnum_waveSenegal;
  @BuiltValueEnumConst(wireName: r'orange_senegal')
  static const PaymentInitiateInputChannelEnum orangeSenegal = _$paymentInitiateInputChannelEnum_orangeSenegal;
  @BuiltValueEnumConst(wireName: r'free_senegal')
  static const PaymentInitiateInputChannelEnum freeSenegal = _$paymentInitiateInputChannelEnum_freeSenegal;
  @BuiltValueEnumConst(wireName: r'wizall_senegal')
  static const PaymentInitiateInputChannelEnum wizallSenegal = _$paymentInitiateInputChannelEnum_wizallSenegal;
  @BuiltValueEnumConst(wireName: r'expresso_sn')
  static const PaymentInitiateInputChannelEnum expressoSn = _$paymentInitiateInputChannelEnum_expressoSn;
  @BuiltValueEnumConst(wireName: r'om_ci')
  static const PaymentInitiateInputChannelEnum omCi = _$paymentInitiateInputChannelEnum_omCi;
  @BuiltValueEnumConst(wireName: r'mtn_ci')
  static const PaymentInitiateInputChannelEnum mtnCi = _$paymentInitiateInputChannelEnum_mtnCi;
  @BuiltValueEnumConst(wireName: r'moov_ci')
  static const PaymentInitiateInputChannelEnum moovCi = _$paymentInitiateInputChannelEnum_moovCi;
  @BuiltValueEnumConst(wireName: r'wave_ci')
  static const PaymentInitiateInputChannelEnum waveCi = _$paymentInitiateInputChannelEnum_waveCi;
  @BuiltValueEnumConst(wireName: r'om_bf')
  static const PaymentInitiateInputChannelEnum omBf = _$paymentInitiateInputChannelEnum_omBf;
  @BuiltValueEnumConst(wireName: r'moov_bf')
  static const PaymentInitiateInputChannelEnum moovBf = _$paymentInitiateInputChannelEnum_moovBf;
  @BuiltValueEnumConst(wireName: r'moov_bj')
  static const PaymentInitiateInputChannelEnum moovBj = _$paymentInitiateInputChannelEnum_moovBj;
  @BuiltValueEnumConst(wireName: r'mtn_bj')
  static const PaymentInitiateInputChannelEnum mtnBj = _$paymentInitiateInputChannelEnum_mtnBj;
  @BuiltValueEnumConst(wireName: r't_money_tg')
  static const PaymentInitiateInputChannelEnum tMoneyTg = _$paymentInitiateInputChannelEnum_tMoneyTg;
  @BuiltValueEnumConst(wireName: r'moov_tg')
  static const PaymentInitiateInputChannelEnum moovTg = _$paymentInitiateInputChannelEnum_moovTg;
  @BuiltValueEnumConst(wireName: r'om_ml')
  static const PaymentInitiateInputChannelEnum omMl = _$paymentInitiateInputChannelEnum_omMl;
  @BuiltValueEnumConst(wireName: r'moov_ml')
  static const PaymentInitiateInputChannelEnum moovMl = _$paymentInitiateInputChannelEnum_moovMl;
  @BuiltValueEnumConst(wireName: r'mtn_cm')
  static const PaymentInitiateInputChannelEnum mtnCm = _$paymentInitiateInputChannelEnum_mtnCm;
  @BuiltValueEnumConst(wireName: r'djamo')
  static const PaymentInitiateInputChannelEnum djamo = _$paymentInitiateInputChannelEnum_djamo;
  @BuiltValueEnumConst(wireName: r'paydunya_wallet')
  static const PaymentInitiateInputChannelEnum paydunyaWallet = _$paymentInitiateInputChannelEnum_paydunyaWallet;
  @BuiltValueEnumConst(wireName: r'wave')
  static const PaymentInitiateInputChannelEnum wave = _$paymentInitiateInputChannelEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const PaymentInitiateInputChannelEnum orangeMoney = _$paymentInitiateInputChannelEnum_orangeMoney;
  @BuiltValueEnumConst(wireName: r'free_money')
  static const PaymentInitiateInputChannelEnum freeMoney = _$paymentInitiateInputChannelEnum_freeMoney;
  @BuiltValueEnumConst(wireName: r'paydunya_card')
  static const PaymentInitiateInputChannelEnum paydunyaCard = _$paymentInitiateInputChannelEnum_paydunyaCard;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel')
  static const PaymentInitiateInputChannelEnum paydunyaAirtel = _$paymentInitiateInputChannelEnum_paydunyaAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_expresso')
  static const PaymentInitiateInputChannelEnum paydunyaExpresso = _$paymentInitiateInputChannelEnum_paydunyaExpresso;
  @BuiltValueEnumConst(wireName: r'paydunya_free')
  static const PaymentInitiateInputChannelEnum paydunyaFree = _$paymentInitiateInputChannelEnum_paydunyaFree;
  @BuiltValueEnumConst(wireName: r'paydunya_mpesa')
  static const PaymentInitiateInputChannelEnum paydunyaMpesa = _$paymentInitiateInputChannelEnum_paydunyaMpesa;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_airtel')
  static const PaymentInitiateInputChannelEnum paydunyaNgAirtel = _$paymentInitiateInputChannelEnum_paydunyaNgAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_mtn')
  static const PaymentInitiateInputChannelEnum paydunyaNgMtn = _$paymentInitiateInputChannelEnum_paydunyaNgMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_9mobile')
  static const PaymentInitiateInputChannelEnum paydunyaNg9mobile = _$paymentInitiateInputChannelEnum_paydunyaNg9mobile;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_glo')
  static const PaymentInitiateInputChannelEnum paydunyaNgGlo = _$paymentInitiateInputChannelEnum_paydunyaNgGlo;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_airtel')
  static const PaymentInitiateInputChannelEnum paydunyaSamAirtel = _$paymentInitiateInputChannelEnum_paydunyaSamAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_mtn')
  static const PaymentInitiateInputChannelEnum paydunyaSamMtn = _$paymentInitiateInputChannelEnum_paydunyaSamMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_safaricom')
  static const PaymentInitiateInputChannelEnum paydunyaSamSafaricom = _$paymentInitiateInputChannelEnum_paydunyaSamSafaricom;
  @BuiltValueEnumConst(wireName: r'paydunya_tigo_rw')
  static const PaymentInitiateInputChannelEnum paydunyaTigoRw = _$paymentInitiateInputChannelEnum_paydunyaTigoRw;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_rw')
  static const PaymentInitiateInputChannelEnum paydunyaAirtelRw = _$paymentInitiateInputChannelEnum_paydunyaAirtelRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_rw')
  static const PaymentInitiateInputChannelEnum paydunyaMtnRw = _$paymentInitiateInputChannelEnum_paydunyaMtnRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ug')
  static const PaymentInitiateInputChannelEnum paydunyaMtnUg = _$paymentInitiateInputChannelEnum_paydunyaMtnUg;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_ug')
  static const PaymentInitiateInputChannelEnum paydunyaAirtelUg = _$paymentInitiateInputChannelEnum_paydunyaAirtelUg;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_ml')
  static const PaymentInitiateInputChannelEnum paydunyaOrangeMl = _$paymentInitiateInputChannelEnum_paydunyaOrangeMl;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ci')
  static const PaymentInitiateInputChannelEnum paydunyaMtnCi = _$paymentInitiateInputChannelEnum_paydunyaMtnCi;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_gh')
  static const PaymentInitiateInputChannelEnum paydunyaMtnGh = _$paymentInitiateInputChannelEnum_paydunyaMtnGh;
  @BuiltValueEnumConst(wireName: r'paydunya_vodafone_gh')
  static const PaymentInitiateInputChannelEnum paydunyaVodafoneGh = _$paymentInitiateInputChannelEnum_paydunyaVodafoneGh;
  @BuiltValueEnumConst(wireName: r'paydunya_airteltigo_gh')
  static const PaymentInitiateInputChannelEnum paydunyaAirteltigoGh = _$paymentInitiateInputChannelEnum_paydunyaAirteltigoGh;
  @BuiltValueEnumConst(wireName: r'paydunya_tm_ci')
  static const PaymentInitiateInputChannelEnum paydunyaTmCi = _$paymentInitiateInputChannelEnum_paydunyaTmCi;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_tg')
  static const PaymentInitiateInputChannelEnum paydunyaMoovTg = _$paymentInitiateInputChannelEnum_paydunyaMoovTg;
  @BuiltValueEnumConst(wireName: r'paydunya_togocel_tg')
  static const PaymentInitiateInputChannelEnum paydunyaTogocelTg = _$paymentInitiateInputChannelEnum_paydunyaTogocelTg;
  @BuiltValueEnumConst(wireName: r'paydunya_wari_sn')
  static const PaymentInitiateInputChannelEnum paydunyaWariSn = _$paymentInitiateInputChannelEnum_paydunyaWariSn;
  @BuiltValueEnumConst(wireName: r'paydunya_wave_sn')
  static const PaymentInitiateInputChannelEnum paydunyaWaveSn = _$paymentInitiateInputChannelEnum_paydunyaWaveSn;
  @BuiltValueEnumConst(wireName: r'paydunya_cb_ci')
  static const PaymentInitiateInputChannelEnum paydunyaCbCi = _$paymentInitiateInputChannelEnum_paydunyaCbCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_sn')
  static const PaymentInitiateInputChannelEnum paydunyaOrangeSn = _$paymentInitiateInputChannelEnum_paydunyaOrangeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_free_sn')
  static const PaymentInitiateInputChannelEnum paydunyaFreeSn = _$paymentInitiateInputChannelEnum_paydunyaFreeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_yup_bj')
  static const PaymentInitiateInputChannelEnum paydunyaYupBj = _$paymentInitiateInputChannelEnum_paydunyaYupBj;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_bj')
  static const PaymentInitiateInputChannelEnum paydunyaMtnBj = _$paymentInitiateInputChannelEnum_paydunyaMtnBj;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_ci')
  static const PaymentInitiateInputChannelEnum paydunyaMoovCi = _$paymentInitiateInputChannelEnum_paydunyaMoovCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_cm')
  static const PaymentInitiateInputChannelEnum paydunyaOrangeCm = _$paymentInitiateInputChannelEnum_paydunyaOrangeCm;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_cm')
  static const PaymentInitiateInputChannelEnum paydunyaMtnCm = _$paymentInitiateInputChannelEnum_paydunyaMtnCm;
  @BuiltValueEnumConst(wireName: r'paydunya_nexttel_cm')
  static const PaymentInitiateInputChannelEnum paydunyaNexttelCm = _$paymentInitiateInputChannelEnum_paydunyaNexttelCm;
  @BuiltValueEnumConst(wireName: r'paydunya_camtel_cm')
  static const PaymentInitiateInputChannelEnum paydunyaCamtelCm = _$paymentInitiateInputChannelEnum_paydunyaCamtelCm;

  static Serializer<PaymentInitiateInputChannelEnum> get serializer => _$paymentInitiateInputChannelEnumSerializer;

  const PaymentInitiateInputChannelEnum._(String name): super(name);

  static BuiltSet<PaymentInitiateInputChannelEnum> get values => _$paymentInitiateInputChannelEnumValues;
  static PaymentInitiateInputChannelEnum valueOf(String name) => _$paymentInitiateInputChannelEnumValueOf(name);
}

