//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_subscription_checkout_input.g.dart';

/// ProSubscriptionCheckoutInput
///
/// Properties:
/// * [action] 
/// * [tier] 
/// * [provider] 
/// * [billingCycle] 
/// * [channel] 
@BuiltValue()
abstract class ProSubscriptionCheckoutInput implements Built<ProSubscriptionCheckoutInput, ProSubscriptionCheckoutInputBuilder> {
  @BuiltValueField(wireName: r'action')
  ProSubscriptionCheckoutInputActionEnum get action;
  // enum actionEnum {  activate,  upgrade,  renewal,  downgrade,  };

  @BuiltValueField(wireName: r'tier')
  ProSubscriptionCheckoutInputTierEnum? get tier;
  // enum tierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'provider')
  ProSubscriptionCheckoutInputProviderEnum? get provider;
  // enum providerEnum {  paydunya,  manual,  };

  @BuiltValueField(wireName: r'billingCycle')
  ProSubscriptionCheckoutInputBillingCycleEnum? get billingCycle;
  // enum billingCycleEnum {  monthly,  annual,  };

  @BuiltValueField(wireName: r'channel')
  ProSubscriptionCheckoutInputChannelEnum? get channel;
  // enum channelEnum {  carte_bancaire,  wave_senegal,  orange_senegal,  free_senegal,  wizall_senegal,  expresso_sn,  om_ci,  mtn_ci,  moov_ci,  wave_ci,  om_bf,  moov_bf,  moov_bj,  mtn_bj,  t_money_tg,  moov_tg,  om_ml,  moov_ml,  mtn_cm,  djamo,  paydunya_wallet,  wave,  orange_money,  free_money,  paydunya_card,  paydunya_airtel,  paydunya_expresso,  paydunya_free,  paydunya_mpesa,  paydunya_ng_airtel,  paydunya_ng_mtn,  paydunya_ng_9mobile,  paydunya_ng_glo,  paydunya_sam_airtel,  paydunya_sam_mtn,  paydunya_sam_safaricom,  paydunya_tigo_rw,  paydunya_airtel_rw,  paydunya_mtn_rw,  paydunya_mtn_ug,  paydunya_airtel_ug,  paydunya_orange_ml,  paydunya_mtn_ci,  paydunya_mtn_gh,  paydunya_vodafone_gh,  paydunya_airteltigo_gh,  paydunya_tm_ci,  paydunya_moov_tg,  paydunya_togocel_tg,  paydunya_wari_sn,  paydunya_wave_sn,  paydunya_cb_ci,  paydunya_orange_sn,  paydunya_free_sn,  paydunya_yup_bj,  paydunya_mtn_bj,  paydunya_moov_ci,  paydunya_orange_cm,  paydunya_mtn_cm,  paydunya_nexttel_cm,  paydunya_camtel_cm,  };

  ProSubscriptionCheckoutInput._();

  factory ProSubscriptionCheckoutInput([void updates(ProSubscriptionCheckoutInputBuilder b)]) = _$ProSubscriptionCheckoutInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProSubscriptionCheckoutInputBuilder b) => b
      ..provider = ProSubscriptionCheckoutInputProviderEnum.valueOf('paydunya')
      ..billingCycle = ProSubscriptionCheckoutInputBillingCycleEnum.valueOf('monthly');

  @BuiltValueSerializer(custom: true)
  static Serializer<ProSubscriptionCheckoutInput> get serializer => _$ProSubscriptionCheckoutInputSerializer();
}

class _$ProSubscriptionCheckoutInputSerializer implements PrimitiveSerializer<ProSubscriptionCheckoutInput> {
  @override
  final Iterable<Type> types = const [ProSubscriptionCheckoutInput, _$ProSubscriptionCheckoutInput];

  @override
  final String wireName = r'ProSubscriptionCheckoutInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProSubscriptionCheckoutInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(ProSubscriptionCheckoutInputActionEnum),
    );
    if (object.tier != null) {
      yield r'tier';
      yield serializers.serialize(
        object.tier,
        specifiedType: const FullType(ProSubscriptionCheckoutInputTierEnum),
      );
    }
    if (object.provider != null) {
      yield r'provider';
      yield serializers.serialize(
        object.provider,
        specifiedType: const FullType(ProSubscriptionCheckoutInputProviderEnum),
      );
    }
    if (object.billingCycle != null) {
      yield r'billingCycle';
      yield serializers.serialize(
        object.billingCycle,
        specifiedType: const FullType(ProSubscriptionCheckoutInputBillingCycleEnum),
      );
    }
    if (object.channel != null) {
      yield r'channel';
      yield serializers.serialize(
        object.channel,
        specifiedType: const FullType(ProSubscriptionCheckoutInputChannelEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProSubscriptionCheckoutInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProSubscriptionCheckoutInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProSubscriptionCheckoutInputActionEnum),
          ) as ProSubscriptionCheckoutInputActionEnum;
          result.action = valueDes;
          break;
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProSubscriptionCheckoutInputTierEnum),
          ) as ProSubscriptionCheckoutInputTierEnum;
          result.tier = valueDes;
          break;
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProSubscriptionCheckoutInputProviderEnum),
          ) as ProSubscriptionCheckoutInputProviderEnum;
          result.provider = valueDes;
          break;
        case r'billingCycle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProSubscriptionCheckoutInputBillingCycleEnum),
          ) as ProSubscriptionCheckoutInputBillingCycleEnum;
          result.billingCycle = valueDes;
          break;
        case r'channel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProSubscriptionCheckoutInputChannelEnum),
          ) as ProSubscriptionCheckoutInputChannelEnum;
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
  ProSubscriptionCheckoutInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProSubscriptionCheckoutInputBuilder();
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

class ProSubscriptionCheckoutInputActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'activate')
  static const ProSubscriptionCheckoutInputActionEnum activate = _$proSubscriptionCheckoutInputActionEnum_activate;
  @BuiltValueEnumConst(wireName: r'upgrade')
  static const ProSubscriptionCheckoutInputActionEnum upgrade = _$proSubscriptionCheckoutInputActionEnum_upgrade;
  @BuiltValueEnumConst(wireName: r'renewal')
  static const ProSubscriptionCheckoutInputActionEnum renewal = _$proSubscriptionCheckoutInputActionEnum_renewal;
  @BuiltValueEnumConst(wireName: r'downgrade')
  static const ProSubscriptionCheckoutInputActionEnum downgrade = _$proSubscriptionCheckoutInputActionEnum_downgrade;

  static Serializer<ProSubscriptionCheckoutInputActionEnum> get serializer => _$proSubscriptionCheckoutInputActionEnumSerializer;

  const ProSubscriptionCheckoutInputActionEnum._(String name): super(name);

  static BuiltSet<ProSubscriptionCheckoutInputActionEnum> get values => _$proSubscriptionCheckoutInputActionEnumValues;
  static ProSubscriptionCheckoutInputActionEnum valueOf(String name) => _$proSubscriptionCheckoutInputActionEnumValueOf(name);
}

class ProSubscriptionCheckoutInputTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const ProSubscriptionCheckoutInputTierEnum standard = _$proSubscriptionCheckoutInputTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const ProSubscriptionCheckoutInputTierEnum premium = _$proSubscriptionCheckoutInputTierEnum_premium;

  static Serializer<ProSubscriptionCheckoutInputTierEnum> get serializer => _$proSubscriptionCheckoutInputTierEnumSerializer;

  const ProSubscriptionCheckoutInputTierEnum._(String name): super(name);

  static BuiltSet<ProSubscriptionCheckoutInputTierEnum> get values => _$proSubscriptionCheckoutInputTierEnumValues;
  static ProSubscriptionCheckoutInputTierEnum valueOf(String name) => _$proSubscriptionCheckoutInputTierEnumValueOf(name);
}

class ProSubscriptionCheckoutInputProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'paydunya')
  static const ProSubscriptionCheckoutInputProviderEnum paydunya = _$proSubscriptionCheckoutInputProviderEnum_paydunya;
  @BuiltValueEnumConst(wireName: r'manual')
  static const ProSubscriptionCheckoutInputProviderEnum manual = _$proSubscriptionCheckoutInputProviderEnum_manual;

  static Serializer<ProSubscriptionCheckoutInputProviderEnum> get serializer => _$proSubscriptionCheckoutInputProviderEnumSerializer;

  const ProSubscriptionCheckoutInputProviderEnum._(String name): super(name);

  static BuiltSet<ProSubscriptionCheckoutInputProviderEnum> get values => _$proSubscriptionCheckoutInputProviderEnumValues;
  static ProSubscriptionCheckoutInputProviderEnum valueOf(String name) => _$proSubscriptionCheckoutInputProviderEnumValueOf(name);
}

class ProSubscriptionCheckoutInputBillingCycleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'monthly')
  static const ProSubscriptionCheckoutInputBillingCycleEnum monthly = _$proSubscriptionCheckoutInputBillingCycleEnum_monthly;
  @BuiltValueEnumConst(wireName: r'annual')
  static const ProSubscriptionCheckoutInputBillingCycleEnum annual = _$proSubscriptionCheckoutInputBillingCycleEnum_annual;

  static Serializer<ProSubscriptionCheckoutInputBillingCycleEnum> get serializer => _$proSubscriptionCheckoutInputBillingCycleEnumSerializer;

  const ProSubscriptionCheckoutInputBillingCycleEnum._(String name): super(name);

  static BuiltSet<ProSubscriptionCheckoutInputBillingCycleEnum> get values => _$proSubscriptionCheckoutInputBillingCycleEnumValues;
  static ProSubscriptionCheckoutInputBillingCycleEnum valueOf(String name) => _$proSubscriptionCheckoutInputBillingCycleEnumValueOf(name);
}

class ProSubscriptionCheckoutInputChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'carte_bancaire')
  static const ProSubscriptionCheckoutInputChannelEnum carteBancaire = _$proSubscriptionCheckoutInputChannelEnum_carteBancaire;
  @BuiltValueEnumConst(wireName: r'wave_senegal')
  static const ProSubscriptionCheckoutInputChannelEnum waveSenegal = _$proSubscriptionCheckoutInputChannelEnum_waveSenegal;
  @BuiltValueEnumConst(wireName: r'orange_senegal')
  static const ProSubscriptionCheckoutInputChannelEnum orangeSenegal = _$proSubscriptionCheckoutInputChannelEnum_orangeSenegal;
  @BuiltValueEnumConst(wireName: r'free_senegal')
  static const ProSubscriptionCheckoutInputChannelEnum freeSenegal = _$proSubscriptionCheckoutInputChannelEnum_freeSenegal;
  @BuiltValueEnumConst(wireName: r'wizall_senegal')
  static const ProSubscriptionCheckoutInputChannelEnum wizallSenegal = _$proSubscriptionCheckoutInputChannelEnum_wizallSenegal;
  @BuiltValueEnumConst(wireName: r'expresso_sn')
  static const ProSubscriptionCheckoutInputChannelEnum expressoSn = _$proSubscriptionCheckoutInputChannelEnum_expressoSn;
  @BuiltValueEnumConst(wireName: r'om_ci')
  static const ProSubscriptionCheckoutInputChannelEnum omCi = _$proSubscriptionCheckoutInputChannelEnum_omCi;
  @BuiltValueEnumConst(wireName: r'mtn_ci')
  static const ProSubscriptionCheckoutInputChannelEnum mtnCi = _$proSubscriptionCheckoutInputChannelEnum_mtnCi;
  @BuiltValueEnumConst(wireName: r'moov_ci')
  static const ProSubscriptionCheckoutInputChannelEnum moovCi = _$proSubscriptionCheckoutInputChannelEnum_moovCi;
  @BuiltValueEnumConst(wireName: r'wave_ci')
  static const ProSubscriptionCheckoutInputChannelEnum waveCi = _$proSubscriptionCheckoutInputChannelEnum_waveCi;
  @BuiltValueEnumConst(wireName: r'om_bf')
  static const ProSubscriptionCheckoutInputChannelEnum omBf = _$proSubscriptionCheckoutInputChannelEnum_omBf;
  @BuiltValueEnumConst(wireName: r'moov_bf')
  static const ProSubscriptionCheckoutInputChannelEnum moovBf = _$proSubscriptionCheckoutInputChannelEnum_moovBf;
  @BuiltValueEnumConst(wireName: r'moov_bj')
  static const ProSubscriptionCheckoutInputChannelEnum moovBj = _$proSubscriptionCheckoutInputChannelEnum_moovBj;
  @BuiltValueEnumConst(wireName: r'mtn_bj')
  static const ProSubscriptionCheckoutInputChannelEnum mtnBj = _$proSubscriptionCheckoutInputChannelEnum_mtnBj;
  @BuiltValueEnumConst(wireName: r't_money_tg')
  static const ProSubscriptionCheckoutInputChannelEnum tMoneyTg = _$proSubscriptionCheckoutInputChannelEnum_tMoneyTg;
  @BuiltValueEnumConst(wireName: r'moov_tg')
  static const ProSubscriptionCheckoutInputChannelEnum moovTg = _$proSubscriptionCheckoutInputChannelEnum_moovTg;
  @BuiltValueEnumConst(wireName: r'om_ml')
  static const ProSubscriptionCheckoutInputChannelEnum omMl = _$proSubscriptionCheckoutInputChannelEnum_omMl;
  @BuiltValueEnumConst(wireName: r'moov_ml')
  static const ProSubscriptionCheckoutInputChannelEnum moovMl = _$proSubscriptionCheckoutInputChannelEnum_moovMl;
  @BuiltValueEnumConst(wireName: r'mtn_cm')
  static const ProSubscriptionCheckoutInputChannelEnum mtnCm = _$proSubscriptionCheckoutInputChannelEnum_mtnCm;
  @BuiltValueEnumConst(wireName: r'djamo')
  static const ProSubscriptionCheckoutInputChannelEnum djamo = _$proSubscriptionCheckoutInputChannelEnum_djamo;
  @BuiltValueEnumConst(wireName: r'paydunya_wallet')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaWallet = _$proSubscriptionCheckoutInputChannelEnum_paydunyaWallet;
  @BuiltValueEnumConst(wireName: r'wave')
  static const ProSubscriptionCheckoutInputChannelEnum wave = _$proSubscriptionCheckoutInputChannelEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const ProSubscriptionCheckoutInputChannelEnum orangeMoney = _$proSubscriptionCheckoutInputChannelEnum_orangeMoney;
  @BuiltValueEnumConst(wireName: r'free_money')
  static const ProSubscriptionCheckoutInputChannelEnum freeMoney = _$proSubscriptionCheckoutInputChannelEnum_freeMoney;
  @BuiltValueEnumConst(wireName: r'paydunya_card')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaCard = _$proSubscriptionCheckoutInputChannelEnum_paydunyaCard;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaAirtel = _$proSubscriptionCheckoutInputChannelEnum_paydunyaAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_expresso')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaExpresso = _$proSubscriptionCheckoutInputChannelEnum_paydunyaExpresso;
  @BuiltValueEnumConst(wireName: r'paydunya_free')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaFree = _$proSubscriptionCheckoutInputChannelEnum_paydunyaFree;
  @BuiltValueEnumConst(wireName: r'paydunya_mpesa')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaMpesa = _$proSubscriptionCheckoutInputChannelEnum_paydunyaMpesa;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_airtel')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaNgAirtel = _$proSubscriptionCheckoutInputChannelEnum_paydunyaNgAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_mtn')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaNgMtn = _$proSubscriptionCheckoutInputChannelEnum_paydunyaNgMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_9mobile')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaNg9mobile = _$proSubscriptionCheckoutInputChannelEnum_paydunyaNg9mobile;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_glo')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaNgGlo = _$proSubscriptionCheckoutInputChannelEnum_paydunyaNgGlo;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_airtel')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaSamAirtel = _$proSubscriptionCheckoutInputChannelEnum_paydunyaSamAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_mtn')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaSamMtn = _$proSubscriptionCheckoutInputChannelEnum_paydunyaSamMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_safaricom')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaSamSafaricom = _$proSubscriptionCheckoutInputChannelEnum_paydunyaSamSafaricom;
  @BuiltValueEnumConst(wireName: r'paydunya_tigo_rw')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaTigoRw = _$proSubscriptionCheckoutInputChannelEnum_paydunyaTigoRw;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_rw')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaAirtelRw = _$proSubscriptionCheckoutInputChannelEnum_paydunyaAirtelRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_rw')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaMtnRw = _$proSubscriptionCheckoutInputChannelEnum_paydunyaMtnRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ug')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaMtnUg = _$proSubscriptionCheckoutInputChannelEnum_paydunyaMtnUg;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_ug')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaAirtelUg = _$proSubscriptionCheckoutInputChannelEnum_paydunyaAirtelUg;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_ml')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaOrangeMl = _$proSubscriptionCheckoutInputChannelEnum_paydunyaOrangeMl;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ci')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaMtnCi = _$proSubscriptionCheckoutInputChannelEnum_paydunyaMtnCi;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_gh')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaMtnGh = _$proSubscriptionCheckoutInputChannelEnum_paydunyaMtnGh;
  @BuiltValueEnumConst(wireName: r'paydunya_vodafone_gh')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaVodafoneGh = _$proSubscriptionCheckoutInputChannelEnum_paydunyaVodafoneGh;
  @BuiltValueEnumConst(wireName: r'paydunya_airteltigo_gh')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaAirteltigoGh = _$proSubscriptionCheckoutInputChannelEnum_paydunyaAirteltigoGh;
  @BuiltValueEnumConst(wireName: r'paydunya_tm_ci')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaTmCi = _$proSubscriptionCheckoutInputChannelEnum_paydunyaTmCi;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_tg')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaMoovTg = _$proSubscriptionCheckoutInputChannelEnum_paydunyaMoovTg;
  @BuiltValueEnumConst(wireName: r'paydunya_togocel_tg')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaTogocelTg = _$proSubscriptionCheckoutInputChannelEnum_paydunyaTogocelTg;
  @BuiltValueEnumConst(wireName: r'paydunya_wari_sn')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaWariSn = _$proSubscriptionCheckoutInputChannelEnum_paydunyaWariSn;
  @BuiltValueEnumConst(wireName: r'paydunya_wave_sn')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaWaveSn = _$proSubscriptionCheckoutInputChannelEnum_paydunyaWaveSn;
  @BuiltValueEnumConst(wireName: r'paydunya_cb_ci')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaCbCi = _$proSubscriptionCheckoutInputChannelEnum_paydunyaCbCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_sn')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaOrangeSn = _$proSubscriptionCheckoutInputChannelEnum_paydunyaOrangeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_free_sn')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaFreeSn = _$proSubscriptionCheckoutInputChannelEnum_paydunyaFreeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_yup_bj')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaYupBj = _$proSubscriptionCheckoutInputChannelEnum_paydunyaYupBj;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_bj')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaMtnBj = _$proSubscriptionCheckoutInputChannelEnum_paydunyaMtnBj;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_ci')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaMoovCi = _$proSubscriptionCheckoutInputChannelEnum_paydunyaMoovCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_cm')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaOrangeCm = _$proSubscriptionCheckoutInputChannelEnum_paydunyaOrangeCm;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_cm')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaMtnCm = _$proSubscriptionCheckoutInputChannelEnum_paydunyaMtnCm;
  @BuiltValueEnumConst(wireName: r'paydunya_nexttel_cm')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaNexttelCm = _$proSubscriptionCheckoutInputChannelEnum_paydunyaNexttelCm;
  @BuiltValueEnumConst(wireName: r'paydunya_camtel_cm')
  static const ProSubscriptionCheckoutInputChannelEnum paydunyaCamtelCm = _$proSubscriptionCheckoutInputChannelEnum_paydunyaCamtelCm;

  static Serializer<ProSubscriptionCheckoutInputChannelEnum> get serializer => _$proSubscriptionCheckoutInputChannelEnumSerializer;

  const ProSubscriptionCheckoutInputChannelEnum._(String name): super(name);

  static BuiltSet<ProSubscriptionCheckoutInputChannelEnum> get values => _$proSubscriptionCheckoutInputChannelEnumValues;
  static ProSubscriptionCheckoutInputChannelEnum valueOf(String name) => _$proSubscriptionCheckoutInputChannelEnumValueOf(name);
}

