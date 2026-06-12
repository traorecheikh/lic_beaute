//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'client_payment_method_create_input.g.dart';

/// ClientPaymentMethodCreateInput
///
/// Properties:
/// * [provider] 
/// * [phoneNumber] 
/// * [label] 
/// * [method] 
/// * [country] 
@BuiltValue()
abstract class ClientPaymentMethodCreateInput implements Built<ClientPaymentMethodCreateInput, ClientPaymentMethodCreateInputBuilder> {
  @BuiltValueField(wireName: r'provider')
  ClientPaymentMethodCreateInputProviderEnum get provider;
  // enum providerEnum {  paydunya,  manual,  };

  @BuiltValueField(wireName: r'phoneNumber')
  String get phoneNumber;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'method')
  ClientPaymentMethodCreateInputMethodEnum? get method;
  // enum methodEnum {  carte_bancaire,  wave_senegal,  orange_senegal,  free_senegal,  wizall_senegal,  expresso_sn,  om_ci,  mtn_ci,  moov_ci,  wave_ci,  om_bf,  moov_bf,  moov_bj,  mtn_bj,  t_money_tg,  moov_tg,  om_ml,  moov_ml,  mtn_cm,  djamo,  paydunya_wallet,  wave,  orange_money,  free_money,  paydunya_card,  paydunya_airtel,  paydunya_expresso,  paydunya_free,  paydunya_mpesa,  paydunya_ng_airtel,  paydunya_ng_mtn,  paydunya_ng_9mobile,  paydunya_ng_glo,  paydunya_sam_airtel,  paydunya_sam_mtn,  paydunya_sam_safaricom,  paydunya_tigo_rw,  paydunya_airtel_rw,  paydunya_mtn_rw,  paydunya_mtn_ug,  paydunya_airtel_ug,  paydunya_orange_ml,  paydunya_mtn_ci,  paydunya_mtn_gh,  paydunya_vodafone_gh,  paydunya_airteltigo_gh,  paydunya_tm_ci,  paydunya_moov_tg,  paydunya_togocel_tg,  paydunya_wari_sn,  paydunya_wave_sn,  paydunya_cb_ci,  paydunya_orange_sn,  paydunya_free_sn,  paydunya_yup_bj,  paydunya_mtn_bj,  paydunya_moov_ci,  paydunya_orange_cm,  paydunya_mtn_cm,  paydunya_nexttel_cm,  paydunya_camtel_cm,  };

  @BuiltValueField(wireName: r'country')
  String? get country;

  ClientPaymentMethodCreateInput._();

  factory ClientPaymentMethodCreateInput([void updates(ClientPaymentMethodCreateInputBuilder b)]) = _$ClientPaymentMethodCreateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClientPaymentMethodCreateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClientPaymentMethodCreateInput> get serializer => _$ClientPaymentMethodCreateInputSerializer();
}

class _$ClientPaymentMethodCreateInputSerializer implements PrimitiveSerializer<ClientPaymentMethodCreateInput> {
  @override
  final Iterable<Type> types = const [ClientPaymentMethodCreateInput, _$ClientPaymentMethodCreateInput];

  @override
  final String wireName = r'ClientPaymentMethodCreateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClientPaymentMethodCreateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(ClientPaymentMethodCreateInputProviderEnum),
    );
    yield r'phoneNumber';
    yield serializers.serialize(
      object.phoneNumber,
      specifiedType: const FullType(String),
    );
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.method != null) {
      yield r'method';
      yield serializers.serialize(
        object.method,
        specifiedType: const FullType(ClientPaymentMethodCreateInputMethodEnum),
      );
    }
    if (object.country != null) {
      yield r'country';
      yield serializers.serialize(
        object.country,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ClientPaymentMethodCreateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClientPaymentMethodCreateInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClientPaymentMethodCreateInputProviderEnum),
          ) as ClientPaymentMethodCreateInputProviderEnum;
          result.provider = valueDes;
          break;
        case r'phoneNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phoneNumber = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClientPaymentMethodCreateInputMethodEnum),
          ) as ClientPaymentMethodCreateInputMethodEnum;
          result.method = valueDes;
          break;
        case r'country':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.country = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClientPaymentMethodCreateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClientPaymentMethodCreateInputBuilder();
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

class ClientPaymentMethodCreateInputProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'paydunya')
  static const ClientPaymentMethodCreateInputProviderEnum paydunya = _$clientPaymentMethodCreateInputProviderEnum_paydunya;
  @BuiltValueEnumConst(wireName: r'manual')
  static const ClientPaymentMethodCreateInputProviderEnum manual = _$clientPaymentMethodCreateInputProviderEnum_manual;

  static Serializer<ClientPaymentMethodCreateInputProviderEnum> get serializer => _$clientPaymentMethodCreateInputProviderEnumSerializer;

  const ClientPaymentMethodCreateInputProviderEnum._(String name): super(name);

  static BuiltSet<ClientPaymentMethodCreateInputProviderEnum> get values => _$clientPaymentMethodCreateInputProviderEnumValues;
  static ClientPaymentMethodCreateInputProviderEnum valueOf(String name) => _$clientPaymentMethodCreateInputProviderEnumValueOf(name);
}

class ClientPaymentMethodCreateInputMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'carte_bancaire')
  static const ClientPaymentMethodCreateInputMethodEnum carteBancaire = _$clientPaymentMethodCreateInputMethodEnum_carteBancaire;
  @BuiltValueEnumConst(wireName: r'wave_senegal')
  static const ClientPaymentMethodCreateInputMethodEnum waveSenegal = _$clientPaymentMethodCreateInputMethodEnum_waveSenegal;
  @BuiltValueEnumConst(wireName: r'orange_senegal')
  static const ClientPaymentMethodCreateInputMethodEnum orangeSenegal = _$clientPaymentMethodCreateInputMethodEnum_orangeSenegal;
  @BuiltValueEnumConst(wireName: r'free_senegal')
  static const ClientPaymentMethodCreateInputMethodEnum freeSenegal = _$clientPaymentMethodCreateInputMethodEnum_freeSenegal;
  @BuiltValueEnumConst(wireName: r'wizall_senegal')
  static const ClientPaymentMethodCreateInputMethodEnum wizallSenegal = _$clientPaymentMethodCreateInputMethodEnum_wizallSenegal;
  @BuiltValueEnumConst(wireName: r'expresso_sn')
  static const ClientPaymentMethodCreateInputMethodEnum expressoSn = _$clientPaymentMethodCreateInputMethodEnum_expressoSn;
  @BuiltValueEnumConst(wireName: r'om_ci')
  static const ClientPaymentMethodCreateInputMethodEnum omCi = _$clientPaymentMethodCreateInputMethodEnum_omCi;
  @BuiltValueEnumConst(wireName: r'mtn_ci')
  static const ClientPaymentMethodCreateInputMethodEnum mtnCi = _$clientPaymentMethodCreateInputMethodEnum_mtnCi;
  @BuiltValueEnumConst(wireName: r'moov_ci')
  static const ClientPaymentMethodCreateInputMethodEnum moovCi = _$clientPaymentMethodCreateInputMethodEnum_moovCi;
  @BuiltValueEnumConst(wireName: r'wave_ci')
  static const ClientPaymentMethodCreateInputMethodEnum waveCi = _$clientPaymentMethodCreateInputMethodEnum_waveCi;
  @BuiltValueEnumConst(wireName: r'om_bf')
  static const ClientPaymentMethodCreateInputMethodEnum omBf = _$clientPaymentMethodCreateInputMethodEnum_omBf;
  @BuiltValueEnumConst(wireName: r'moov_bf')
  static const ClientPaymentMethodCreateInputMethodEnum moovBf = _$clientPaymentMethodCreateInputMethodEnum_moovBf;
  @BuiltValueEnumConst(wireName: r'moov_bj')
  static const ClientPaymentMethodCreateInputMethodEnum moovBj = _$clientPaymentMethodCreateInputMethodEnum_moovBj;
  @BuiltValueEnumConst(wireName: r'mtn_bj')
  static const ClientPaymentMethodCreateInputMethodEnum mtnBj = _$clientPaymentMethodCreateInputMethodEnum_mtnBj;
  @BuiltValueEnumConst(wireName: r't_money_tg')
  static const ClientPaymentMethodCreateInputMethodEnum tMoneyTg = _$clientPaymentMethodCreateInputMethodEnum_tMoneyTg;
  @BuiltValueEnumConst(wireName: r'moov_tg')
  static const ClientPaymentMethodCreateInputMethodEnum moovTg = _$clientPaymentMethodCreateInputMethodEnum_moovTg;
  @BuiltValueEnumConst(wireName: r'om_ml')
  static const ClientPaymentMethodCreateInputMethodEnum omMl = _$clientPaymentMethodCreateInputMethodEnum_omMl;
  @BuiltValueEnumConst(wireName: r'moov_ml')
  static const ClientPaymentMethodCreateInputMethodEnum moovMl = _$clientPaymentMethodCreateInputMethodEnum_moovMl;
  @BuiltValueEnumConst(wireName: r'mtn_cm')
  static const ClientPaymentMethodCreateInputMethodEnum mtnCm = _$clientPaymentMethodCreateInputMethodEnum_mtnCm;
  @BuiltValueEnumConst(wireName: r'djamo')
  static const ClientPaymentMethodCreateInputMethodEnum djamo = _$clientPaymentMethodCreateInputMethodEnum_djamo;
  @BuiltValueEnumConst(wireName: r'paydunya_wallet')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaWallet = _$clientPaymentMethodCreateInputMethodEnum_paydunyaWallet;
  @BuiltValueEnumConst(wireName: r'wave')
  static const ClientPaymentMethodCreateInputMethodEnum wave = _$clientPaymentMethodCreateInputMethodEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const ClientPaymentMethodCreateInputMethodEnum orangeMoney = _$clientPaymentMethodCreateInputMethodEnum_orangeMoney;
  @BuiltValueEnumConst(wireName: r'free_money')
  static const ClientPaymentMethodCreateInputMethodEnum freeMoney = _$clientPaymentMethodCreateInputMethodEnum_freeMoney;
  @BuiltValueEnumConst(wireName: r'paydunya_card')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaCard = _$clientPaymentMethodCreateInputMethodEnum_paydunyaCard;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaAirtel = _$clientPaymentMethodCreateInputMethodEnum_paydunyaAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_expresso')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaExpresso = _$clientPaymentMethodCreateInputMethodEnum_paydunyaExpresso;
  @BuiltValueEnumConst(wireName: r'paydunya_free')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaFree = _$clientPaymentMethodCreateInputMethodEnum_paydunyaFree;
  @BuiltValueEnumConst(wireName: r'paydunya_mpesa')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaMpesa = _$clientPaymentMethodCreateInputMethodEnum_paydunyaMpesa;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_airtel')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaNgAirtel = _$clientPaymentMethodCreateInputMethodEnum_paydunyaNgAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_mtn')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaNgMtn = _$clientPaymentMethodCreateInputMethodEnum_paydunyaNgMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_9mobile')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaNg9mobile = _$clientPaymentMethodCreateInputMethodEnum_paydunyaNg9mobile;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_glo')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaNgGlo = _$clientPaymentMethodCreateInputMethodEnum_paydunyaNgGlo;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_airtel')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaSamAirtel = _$clientPaymentMethodCreateInputMethodEnum_paydunyaSamAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_mtn')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaSamMtn = _$clientPaymentMethodCreateInputMethodEnum_paydunyaSamMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_safaricom')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaSamSafaricom = _$clientPaymentMethodCreateInputMethodEnum_paydunyaSamSafaricom;
  @BuiltValueEnumConst(wireName: r'paydunya_tigo_rw')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaTigoRw = _$clientPaymentMethodCreateInputMethodEnum_paydunyaTigoRw;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_rw')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaAirtelRw = _$clientPaymentMethodCreateInputMethodEnum_paydunyaAirtelRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_rw')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaMtnRw = _$clientPaymentMethodCreateInputMethodEnum_paydunyaMtnRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ug')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaMtnUg = _$clientPaymentMethodCreateInputMethodEnum_paydunyaMtnUg;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_ug')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaAirtelUg = _$clientPaymentMethodCreateInputMethodEnum_paydunyaAirtelUg;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_ml')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaOrangeMl = _$clientPaymentMethodCreateInputMethodEnum_paydunyaOrangeMl;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ci')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaMtnCi = _$clientPaymentMethodCreateInputMethodEnum_paydunyaMtnCi;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_gh')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaMtnGh = _$clientPaymentMethodCreateInputMethodEnum_paydunyaMtnGh;
  @BuiltValueEnumConst(wireName: r'paydunya_vodafone_gh')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaVodafoneGh = _$clientPaymentMethodCreateInputMethodEnum_paydunyaVodafoneGh;
  @BuiltValueEnumConst(wireName: r'paydunya_airteltigo_gh')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaAirteltigoGh = _$clientPaymentMethodCreateInputMethodEnum_paydunyaAirteltigoGh;
  @BuiltValueEnumConst(wireName: r'paydunya_tm_ci')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaTmCi = _$clientPaymentMethodCreateInputMethodEnum_paydunyaTmCi;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_tg')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaMoovTg = _$clientPaymentMethodCreateInputMethodEnum_paydunyaMoovTg;
  @BuiltValueEnumConst(wireName: r'paydunya_togocel_tg')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaTogocelTg = _$clientPaymentMethodCreateInputMethodEnum_paydunyaTogocelTg;
  @BuiltValueEnumConst(wireName: r'paydunya_wari_sn')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaWariSn = _$clientPaymentMethodCreateInputMethodEnum_paydunyaWariSn;
  @BuiltValueEnumConst(wireName: r'paydunya_wave_sn')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaWaveSn = _$clientPaymentMethodCreateInputMethodEnum_paydunyaWaveSn;
  @BuiltValueEnumConst(wireName: r'paydunya_cb_ci')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaCbCi = _$clientPaymentMethodCreateInputMethodEnum_paydunyaCbCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_sn')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaOrangeSn = _$clientPaymentMethodCreateInputMethodEnum_paydunyaOrangeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_free_sn')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaFreeSn = _$clientPaymentMethodCreateInputMethodEnum_paydunyaFreeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_yup_bj')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaYupBj = _$clientPaymentMethodCreateInputMethodEnum_paydunyaYupBj;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_bj')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaMtnBj = _$clientPaymentMethodCreateInputMethodEnum_paydunyaMtnBj;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_ci')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaMoovCi = _$clientPaymentMethodCreateInputMethodEnum_paydunyaMoovCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_cm')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaOrangeCm = _$clientPaymentMethodCreateInputMethodEnum_paydunyaOrangeCm;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_cm')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaMtnCm = _$clientPaymentMethodCreateInputMethodEnum_paydunyaMtnCm;
  @BuiltValueEnumConst(wireName: r'paydunya_nexttel_cm')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaNexttelCm = _$clientPaymentMethodCreateInputMethodEnum_paydunyaNexttelCm;
  @BuiltValueEnumConst(wireName: r'paydunya_camtel_cm')
  static const ClientPaymentMethodCreateInputMethodEnum paydunyaCamtelCm = _$clientPaymentMethodCreateInputMethodEnum_paydunyaCamtelCm;

  static Serializer<ClientPaymentMethodCreateInputMethodEnum> get serializer => _$clientPaymentMethodCreateInputMethodEnumSerializer;

  const ClientPaymentMethodCreateInputMethodEnum._(String name): super(name);

  static BuiltSet<ClientPaymentMethodCreateInputMethodEnum> get values => _$clientPaymentMethodCreateInputMethodEnumValues;
  static ClientPaymentMethodCreateInputMethodEnum valueOf(String name) => _$clientPaymentMethodCreateInputMethodEnumValueOf(name);
}

