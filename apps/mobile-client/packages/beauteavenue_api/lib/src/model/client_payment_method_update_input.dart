//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'client_payment_method_update_input.g.dart';

/// ClientPaymentMethodUpdateInput
///
/// Properties:
/// * [phoneNumber] 
/// * [label] 
/// * [method] 
/// * [country] 
@BuiltValue()
abstract class ClientPaymentMethodUpdateInput implements Built<ClientPaymentMethodUpdateInput, ClientPaymentMethodUpdateInputBuilder> {
  @BuiltValueField(wireName: r'phoneNumber')
  String? get phoneNumber;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'method')
  ClientPaymentMethodUpdateInputMethodEnum? get method;
  // enum methodEnum {  carte_bancaire,  wave_senegal,  orange_senegal,  free_senegal,  wizall_senegal,  expresso_sn,  om_ci,  mtn_ci,  moov_ci,  wave_ci,  om_bf,  moov_bf,  moov_bj,  mtn_bj,  t_money_tg,  moov_tg,  om_ml,  moov_ml,  mtn_cm,  djamo,  paydunya_wallet,  wave,  orange_money,  free_money,  paydunya_card,  paydunya_airtel,  paydunya_expresso,  paydunya_free,  paydunya_mpesa,  paydunya_ng_airtel,  paydunya_ng_mtn,  paydunya_ng_9mobile,  paydunya_ng_glo,  paydunya_sam_airtel,  paydunya_sam_mtn,  paydunya_sam_safaricom,  paydunya_tigo_rw,  paydunya_airtel_rw,  paydunya_mtn_rw,  paydunya_mtn_ug,  paydunya_airtel_ug,  paydunya_orange_ml,  paydunya_mtn_ci,  paydunya_mtn_gh,  paydunya_vodafone_gh,  paydunya_airteltigo_gh,  paydunya_tm_ci,  paydunya_moov_tg,  paydunya_togocel_tg,  paydunya_wari_sn,  paydunya_wave_sn,  paydunya_cb_ci,  paydunya_orange_sn,  paydunya_free_sn,  paydunya_yup_bj,  paydunya_mtn_bj,  paydunya_moov_ci,  paydunya_orange_cm,  paydunya_mtn_cm,  paydunya_nexttel_cm,  paydunya_camtel_cm,  };

  @BuiltValueField(wireName: r'country')
  String? get country;

  ClientPaymentMethodUpdateInput._();

  factory ClientPaymentMethodUpdateInput([void updates(ClientPaymentMethodUpdateInputBuilder b)]) = _$ClientPaymentMethodUpdateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClientPaymentMethodUpdateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClientPaymentMethodUpdateInput> get serializer => _$ClientPaymentMethodUpdateInputSerializer();
}

class _$ClientPaymentMethodUpdateInputSerializer implements PrimitiveSerializer<ClientPaymentMethodUpdateInput> {
  @override
  final Iterable<Type> types = const [ClientPaymentMethodUpdateInput, _$ClientPaymentMethodUpdateInput];

  @override
  final String wireName = r'ClientPaymentMethodUpdateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClientPaymentMethodUpdateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.phoneNumber != null) {
      yield r'phoneNumber';
      yield serializers.serialize(
        object.phoneNumber,
        specifiedType: const FullType(String),
      );
    }
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
        specifiedType: const FullType.nullable(ClientPaymentMethodUpdateInputMethodEnum),
      );
    }
    if (object.country != null) {
      yield r'country';
      yield serializers.serialize(
        object.country,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ClientPaymentMethodUpdateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClientPaymentMethodUpdateInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType.nullable(ClientPaymentMethodUpdateInputMethodEnum),
          ) as ClientPaymentMethodUpdateInputMethodEnum?;
          if (valueDes == null) continue;
          result.method = valueDes;
          break;
        case r'country':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
  ClientPaymentMethodUpdateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClientPaymentMethodUpdateInputBuilder();
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

class ClientPaymentMethodUpdateInputMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'carte_bancaire')
  static const ClientPaymentMethodUpdateInputMethodEnum carteBancaire = _$clientPaymentMethodUpdateInputMethodEnum_carteBancaire;
  @BuiltValueEnumConst(wireName: r'wave_senegal')
  static const ClientPaymentMethodUpdateInputMethodEnum waveSenegal = _$clientPaymentMethodUpdateInputMethodEnum_waveSenegal;
  @BuiltValueEnumConst(wireName: r'orange_senegal')
  static const ClientPaymentMethodUpdateInputMethodEnum orangeSenegal = _$clientPaymentMethodUpdateInputMethodEnum_orangeSenegal;
  @BuiltValueEnumConst(wireName: r'free_senegal')
  static const ClientPaymentMethodUpdateInputMethodEnum freeSenegal = _$clientPaymentMethodUpdateInputMethodEnum_freeSenegal;
  @BuiltValueEnumConst(wireName: r'wizall_senegal')
  static const ClientPaymentMethodUpdateInputMethodEnum wizallSenegal = _$clientPaymentMethodUpdateInputMethodEnum_wizallSenegal;
  @BuiltValueEnumConst(wireName: r'expresso_sn')
  static const ClientPaymentMethodUpdateInputMethodEnum expressoSn = _$clientPaymentMethodUpdateInputMethodEnum_expressoSn;
  @BuiltValueEnumConst(wireName: r'om_ci')
  static const ClientPaymentMethodUpdateInputMethodEnum omCi = _$clientPaymentMethodUpdateInputMethodEnum_omCi;
  @BuiltValueEnumConst(wireName: r'mtn_ci')
  static const ClientPaymentMethodUpdateInputMethodEnum mtnCi = _$clientPaymentMethodUpdateInputMethodEnum_mtnCi;
  @BuiltValueEnumConst(wireName: r'moov_ci')
  static const ClientPaymentMethodUpdateInputMethodEnum moovCi = _$clientPaymentMethodUpdateInputMethodEnum_moovCi;
  @BuiltValueEnumConst(wireName: r'wave_ci')
  static const ClientPaymentMethodUpdateInputMethodEnum waveCi = _$clientPaymentMethodUpdateInputMethodEnum_waveCi;
  @BuiltValueEnumConst(wireName: r'om_bf')
  static const ClientPaymentMethodUpdateInputMethodEnum omBf = _$clientPaymentMethodUpdateInputMethodEnum_omBf;
  @BuiltValueEnumConst(wireName: r'moov_bf')
  static const ClientPaymentMethodUpdateInputMethodEnum moovBf = _$clientPaymentMethodUpdateInputMethodEnum_moovBf;
  @BuiltValueEnumConst(wireName: r'moov_bj')
  static const ClientPaymentMethodUpdateInputMethodEnum moovBj = _$clientPaymentMethodUpdateInputMethodEnum_moovBj;
  @BuiltValueEnumConst(wireName: r'mtn_bj')
  static const ClientPaymentMethodUpdateInputMethodEnum mtnBj = _$clientPaymentMethodUpdateInputMethodEnum_mtnBj;
  @BuiltValueEnumConst(wireName: r't_money_tg')
  static const ClientPaymentMethodUpdateInputMethodEnum tMoneyTg = _$clientPaymentMethodUpdateInputMethodEnum_tMoneyTg;
  @BuiltValueEnumConst(wireName: r'moov_tg')
  static const ClientPaymentMethodUpdateInputMethodEnum moovTg = _$clientPaymentMethodUpdateInputMethodEnum_moovTg;
  @BuiltValueEnumConst(wireName: r'om_ml')
  static const ClientPaymentMethodUpdateInputMethodEnum omMl = _$clientPaymentMethodUpdateInputMethodEnum_omMl;
  @BuiltValueEnumConst(wireName: r'moov_ml')
  static const ClientPaymentMethodUpdateInputMethodEnum moovMl = _$clientPaymentMethodUpdateInputMethodEnum_moovMl;
  @BuiltValueEnumConst(wireName: r'mtn_cm')
  static const ClientPaymentMethodUpdateInputMethodEnum mtnCm = _$clientPaymentMethodUpdateInputMethodEnum_mtnCm;
  @BuiltValueEnumConst(wireName: r'djamo')
  static const ClientPaymentMethodUpdateInputMethodEnum djamo = _$clientPaymentMethodUpdateInputMethodEnum_djamo;
  @BuiltValueEnumConst(wireName: r'paydunya_wallet')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaWallet = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaWallet;
  @BuiltValueEnumConst(wireName: r'wave')
  static const ClientPaymentMethodUpdateInputMethodEnum wave = _$clientPaymentMethodUpdateInputMethodEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const ClientPaymentMethodUpdateInputMethodEnum orangeMoney = _$clientPaymentMethodUpdateInputMethodEnum_orangeMoney;
  @BuiltValueEnumConst(wireName: r'free_money')
  static const ClientPaymentMethodUpdateInputMethodEnum freeMoney = _$clientPaymentMethodUpdateInputMethodEnum_freeMoney;
  @BuiltValueEnumConst(wireName: r'paydunya_card')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaCard = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaCard;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaAirtel = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_expresso')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaExpresso = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaExpresso;
  @BuiltValueEnumConst(wireName: r'paydunya_free')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaFree = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaFree;
  @BuiltValueEnumConst(wireName: r'paydunya_mpesa')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaMpesa = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaMpesa;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_airtel')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaNgAirtel = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaNgAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_mtn')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaNgMtn = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaNgMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_9mobile')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaNg9mobile = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaNg9mobile;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_glo')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaNgGlo = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaNgGlo;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_airtel')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaSamAirtel = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaSamAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_mtn')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaSamMtn = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaSamMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_safaricom')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaSamSafaricom = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaSamSafaricom;
  @BuiltValueEnumConst(wireName: r'paydunya_tigo_rw')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaTigoRw = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaTigoRw;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_rw')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaAirtelRw = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaAirtelRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_rw')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaMtnRw = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaMtnRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ug')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaMtnUg = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaMtnUg;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_ug')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaAirtelUg = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaAirtelUg;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_ml')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaOrangeMl = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaOrangeMl;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ci')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaMtnCi = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaMtnCi;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_gh')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaMtnGh = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaMtnGh;
  @BuiltValueEnumConst(wireName: r'paydunya_vodafone_gh')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaVodafoneGh = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaVodafoneGh;
  @BuiltValueEnumConst(wireName: r'paydunya_airteltigo_gh')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaAirteltigoGh = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaAirteltigoGh;
  @BuiltValueEnumConst(wireName: r'paydunya_tm_ci')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaTmCi = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaTmCi;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_tg')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaMoovTg = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaMoovTg;
  @BuiltValueEnumConst(wireName: r'paydunya_togocel_tg')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaTogocelTg = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaTogocelTg;
  @BuiltValueEnumConst(wireName: r'paydunya_wari_sn')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaWariSn = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaWariSn;
  @BuiltValueEnumConst(wireName: r'paydunya_wave_sn')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaWaveSn = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaWaveSn;
  @BuiltValueEnumConst(wireName: r'paydunya_cb_ci')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaCbCi = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaCbCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_sn')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaOrangeSn = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaOrangeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_free_sn')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaFreeSn = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaFreeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_yup_bj')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaYupBj = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaYupBj;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_bj')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaMtnBj = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaMtnBj;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_ci')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaMoovCi = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaMoovCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_cm')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaOrangeCm = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaOrangeCm;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_cm')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaMtnCm = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaMtnCm;
  @BuiltValueEnumConst(wireName: r'paydunya_nexttel_cm')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaNexttelCm = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaNexttelCm;
  @BuiltValueEnumConst(wireName: r'paydunya_camtel_cm')
  static const ClientPaymentMethodUpdateInputMethodEnum paydunyaCamtelCm = _$clientPaymentMethodUpdateInputMethodEnum_paydunyaCamtelCm;

  static Serializer<ClientPaymentMethodUpdateInputMethodEnum> get serializer => _$clientPaymentMethodUpdateInputMethodEnumSerializer;

  const ClientPaymentMethodUpdateInputMethodEnum._(String name): super(name);

  static BuiltSet<ClientPaymentMethodUpdateInputMethodEnum> get values => _$clientPaymentMethodUpdateInputMethodEnumValues;
  static ClientPaymentMethodUpdateInputMethodEnum valueOf(String name) => _$clientPaymentMethodUpdateInputMethodEnumValueOf(name);
}

