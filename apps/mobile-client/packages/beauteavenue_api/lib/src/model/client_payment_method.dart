//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'client_payment_method.g.dart';

/// ClientPaymentMethod
///
/// Properties:
/// * [id] 
/// * [provider] 
/// * [phoneNumber] 
/// * [label] 
/// * [method] 
/// * [country] 
/// * [isDefault] 
/// * [lastUsedAt] 
/// * [createdAt] 
/// * [updatedAt] 
@BuiltValue()
abstract class ClientPaymentMethod implements Built<ClientPaymentMethod, ClientPaymentMethodBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'provider')
  ClientPaymentMethodProviderEnum get provider;
  // enum providerEnum {  paydunya,  manual,  };

  @BuiltValueField(wireName: r'phoneNumber')
  String get phoneNumber;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'method')
  ClientPaymentMethodMethodEnum? get method;
  // enum methodEnum {  carte_bancaire,  wave_senegal,  orange_senegal,  free_senegal,  wizall_senegal,  expresso_sn,  om_ci,  mtn_ci,  moov_ci,  wave_ci,  om_bf,  moov_bf,  moov_bj,  mtn_bj,  t_money_tg,  moov_tg,  om_ml,  moov_ml,  mtn_cm,  djamo,  paydunya_wallet,  wave,  orange_money,  free_money,  paydunya_card,  paydunya_airtel,  paydunya_expresso,  paydunya_free,  paydunya_mpesa,  paydunya_ng_airtel,  paydunya_ng_mtn,  paydunya_ng_9mobile,  paydunya_ng_glo,  paydunya_sam_airtel,  paydunya_sam_mtn,  paydunya_sam_safaricom,  paydunya_tigo_rw,  paydunya_airtel_rw,  paydunya_mtn_rw,  paydunya_mtn_ug,  paydunya_airtel_ug,  paydunya_orange_ml,  paydunya_mtn_ci,  paydunya_mtn_gh,  paydunya_vodafone_gh,  paydunya_airteltigo_gh,  paydunya_tm_ci,  paydunya_moov_tg,  paydunya_togocel_tg,  paydunya_wari_sn,  paydunya_wave_sn,  paydunya_cb_ci,  paydunya_orange_sn,  paydunya_free_sn,  paydunya_yup_bj,  paydunya_mtn_bj,  paydunya_moov_ci,  paydunya_orange_cm,  paydunya_mtn_cm,  paydunya_nexttel_cm,  paydunya_camtel_cm,  };

  @BuiltValueField(wireName: r'country')
  String? get country;

  @BuiltValueField(wireName: r'isDefault')
  bool get isDefault;

  @BuiltValueField(wireName: r'lastUsedAt')
  String? get lastUsedAt;

  @BuiltValueField(wireName: r'createdAt')
  String get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  String get updatedAt;

  ClientPaymentMethod._();

  factory ClientPaymentMethod([void updates(ClientPaymentMethodBuilder b)]) = _$ClientPaymentMethod;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClientPaymentMethodBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClientPaymentMethod> get serializer => _$ClientPaymentMethodSerializer();
}

class _$ClientPaymentMethodSerializer implements PrimitiveSerializer<ClientPaymentMethod> {
  @override
  final Iterable<Type> types = const [ClientPaymentMethod, _$ClientPaymentMethod];

  @override
  final String wireName = r'ClientPaymentMethod';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClientPaymentMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(ClientPaymentMethodProviderEnum),
    );
    yield r'phoneNumber';
    yield serializers.serialize(
      object.phoneNumber,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield object.label == null ? null : serializers.serialize(
      object.label,
      specifiedType: const FullType.nullable(String),
    );
    if (object.method != null) {
      yield r'method';
      yield serializers.serialize(
        object.method,
        specifiedType: const FullType.nullable(ClientPaymentMethodMethodEnum),
      );
    }
    if (object.country != null) {
      yield r'country';
      yield serializers.serialize(
        object.country,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'isDefault';
    yield serializers.serialize(
      object.isDefault,
      specifiedType: const FullType(bool),
    );
    yield r'lastUsedAt';
    yield object.lastUsedAt == null ? null : serializers.serialize(
      object.lastUsedAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(String),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ClientPaymentMethod object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClientPaymentMethodBuilder result,
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
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClientPaymentMethodProviderEnum),
          ) as ClientPaymentMethodProviderEnum;
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
            specifiedType: const FullType.nullable(ClientPaymentMethodMethodEnum),
          ) as ClientPaymentMethodMethodEnum?;
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
        case r'isDefault':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isDefault = valueDes;
          break;
        case r'lastUsedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lastUsedAt = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClientPaymentMethod deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClientPaymentMethodBuilder();
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

class ClientPaymentMethodProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'paydunya')
  static const ClientPaymentMethodProviderEnum paydunya = _$clientPaymentMethodProviderEnum_paydunya;
  @BuiltValueEnumConst(wireName: r'manual')
  static const ClientPaymentMethodProviderEnum manual = _$clientPaymentMethodProviderEnum_manual;

  static Serializer<ClientPaymentMethodProviderEnum> get serializer => _$clientPaymentMethodProviderEnumSerializer;

  const ClientPaymentMethodProviderEnum._(String name): super(name);

  static BuiltSet<ClientPaymentMethodProviderEnum> get values => _$clientPaymentMethodProviderEnumValues;
  static ClientPaymentMethodProviderEnum valueOf(String name) => _$clientPaymentMethodProviderEnumValueOf(name);
}

class ClientPaymentMethodMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'carte_bancaire')
  static const ClientPaymentMethodMethodEnum carteBancaire = _$clientPaymentMethodMethodEnum_carteBancaire;
  @BuiltValueEnumConst(wireName: r'wave_senegal')
  static const ClientPaymentMethodMethodEnum waveSenegal = _$clientPaymentMethodMethodEnum_waveSenegal;
  @BuiltValueEnumConst(wireName: r'orange_senegal')
  static const ClientPaymentMethodMethodEnum orangeSenegal = _$clientPaymentMethodMethodEnum_orangeSenegal;
  @BuiltValueEnumConst(wireName: r'free_senegal')
  static const ClientPaymentMethodMethodEnum freeSenegal = _$clientPaymentMethodMethodEnum_freeSenegal;
  @BuiltValueEnumConst(wireName: r'wizall_senegal')
  static const ClientPaymentMethodMethodEnum wizallSenegal = _$clientPaymentMethodMethodEnum_wizallSenegal;
  @BuiltValueEnumConst(wireName: r'expresso_sn')
  static const ClientPaymentMethodMethodEnum expressoSn = _$clientPaymentMethodMethodEnum_expressoSn;
  @BuiltValueEnumConst(wireName: r'om_ci')
  static const ClientPaymentMethodMethodEnum omCi = _$clientPaymentMethodMethodEnum_omCi;
  @BuiltValueEnumConst(wireName: r'mtn_ci')
  static const ClientPaymentMethodMethodEnum mtnCi = _$clientPaymentMethodMethodEnum_mtnCi;
  @BuiltValueEnumConst(wireName: r'moov_ci')
  static const ClientPaymentMethodMethodEnum moovCi = _$clientPaymentMethodMethodEnum_moovCi;
  @BuiltValueEnumConst(wireName: r'wave_ci')
  static const ClientPaymentMethodMethodEnum waveCi = _$clientPaymentMethodMethodEnum_waveCi;
  @BuiltValueEnumConst(wireName: r'om_bf')
  static const ClientPaymentMethodMethodEnum omBf = _$clientPaymentMethodMethodEnum_omBf;
  @BuiltValueEnumConst(wireName: r'moov_bf')
  static const ClientPaymentMethodMethodEnum moovBf = _$clientPaymentMethodMethodEnum_moovBf;
  @BuiltValueEnumConst(wireName: r'moov_bj')
  static const ClientPaymentMethodMethodEnum moovBj = _$clientPaymentMethodMethodEnum_moovBj;
  @BuiltValueEnumConst(wireName: r'mtn_bj')
  static const ClientPaymentMethodMethodEnum mtnBj = _$clientPaymentMethodMethodEnum_mtnBj;
  @BuiltValueEnumConst(wireName: r't_money_tg')
  static const ClientPaymentMethodMethodEnum tMoneyTg = _$clientPaymentMethodMethodEnum_tMoneyTg;
  @BuiltValueEnumConst(wireName: r'moov_tg')
  static const ClientPaymentMethodMethodEnum moovTg = _$clientPaymentMethodMethodEnum_moovTg;
  @BuiltValueEnumConst(wireName: r'om_ml')
  static const ClientPaymentMethodMethodEnum omMl = _$clientPaymentMethodMethodEnum_omMl;
  @BuiltValueEnumConst(wireName: r'moov_ml')
  static const ClientPaymentMethodMethodEnum moovMl = _$clientPaymentMethodMethodEnum_moovMl;
  @BuiltValueEnumConst(wireName: r'mtn_cm')
  static const ClientPaymentMethodMethodEnum mtnCm = _$clientPaymentMethodMethodEnum_mtnCm;
  @BuiltValueEnumConst(wireName: r'djamo')
  static const ClientPaymentMethodMethodEnum djamo = _$clientPaymentMethodMethodEnum_djamo;
  @BuiltValueEnumConst(wireName: r'paydunya_wallet')
  static const ClientPaymentMethodMethodEnum paydunyaWallet = _$clientPaymentMethodMethodEnum_paydunyaWallet;
  @BuiltValueEnumConst(wireName: r'wave')
  static const ClientPaymentMethodMethodEnum wave = _$clientPaymentMethodMethodEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const ClientPaymentMethodMethodEnum orangeMoney = _$clientPaymentMethodMethodEnum_orangeMoney;
  @BuiltValueEnumConst(wireName: r'free_money')
  static const ClientPaymentMethodMethodEnum freeMoney = _$clientPaymentMethodMethodEnum_freeMoney;
  @BuiltValueEnumConst(wireName: r'paydunya_card')
  static const ClientPaymentMethodMethodEnum paydunyaCard = _$clientPaymentMethodMethodEnum_paydunyaCard;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel')
  static const ClientPaymentMethodMethodEnum paydunyaAirtel = _$clientPaymentMethodMethodEnum_paydunyaAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_expresso')
  static const ClientPaymentMethodMethodEnum paydunyaExpresso = _$clientPaymentMethodMethodEnum_paydunyaExpresso;
  @BuiltValueEnumConst(wireName: r'paydunya_free')
  static const ClientPaymentMethodMethodEnum paydunyaFree = _$clientPaymentMethodMethodEnum_paydunyaFree;
  @BuiltValueEnumConst(wireName: r'paydunya_mpesa')
  static const ClientPaymentMethodMethodEnum paydunyaMpesa = _$clientPaymentMethodMethodEnum_paydunyaMpesa;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_airtel')
  static const ClientPaymentMethodMethodEnum paydunyaNgAirtel = _$clientPaymentMethodMethodEnum_paydunyaNgAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_mtn')
  static const ClientPaymentMethodMethodEnum paydunyaNgMtn = _$clientPaymentMethodMethodEnum_paydunyaNgMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_9mobile')
  static const ClientPaymentMethodMethodEnum paydunyaNg9mobile = _$clientPaymentMethodMethodEnum_paydunyaNg9mobile;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_glo')
  static const ClientPaymentMethodMethodEnum paydunyaNgGlo = _$clientPaymentMethodMethodEnum_paydunyaNgGlo;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_airtel')
  static const ClientPaymentMethodMethodEnum paydunyaSamAirtel = _$clientPaymentMethodMethodEnum_paydunyaSamAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_mtn')
  static const ClientPaymentMethodMethodEnum paydunyaSamMtn = _$clientPaymentMethodMethodEnum_paydunyaSamMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_safaricom')
  static const ClientPaymentMethodMethodEnum paydunyaSamSafaricom = _$clientPaymentMethodMethodEnum_paydunyaSamSafaricom;
  @BuiltValueEnumConst(wireName: r'paydunya_tigo_rw')
  static const ClientPaymentMethodMethodEnum paydunyaTigoRw = _$clientPaymentMethodMethodEnum_paydunyaTigoRw;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_rw')
  static const ClientPaymentMethodMethodEnum paydunyaAirtelRw = _$clientPaymentMethodMethodEnum_paydunyaAirtelRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_rw')
  static const ClientPaymentMethodMethodEnum paydunyaMtnRw = _$clientPaymentMethodMethodEnum_paydunyaMtnRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ug')
  static const ClientPaymentMethodMethodEnum paydunyaMtnUg = _$clientPaymentMethodMethodEnum_paydunyaMtnUg;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_ug')
  static const ClientPaymentMethodMethodEnum paydunyaAirtelUg = _$clientPaymentMethodMethodEnum_paydunyaAirtelUg;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_ml')
  static const ClientPaymentMethodMethodEnum paydunyaOrangeMl = _$clientPaymentMethodMethodEnum_paydunyaOrangeMl;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ci')
  static const ClientPaymentMethodMethodEnum paydunyaMtnCi = _$clientPaymentMethodMethodEnum_paydunyaMtnCi;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_gh')
  static const ClientPaymentMethodMethodEnum paydunyaMtnGh = _$clientPaymentMethodMethodEnum_paydunyaMtnGh;
  @BuiltValueEnumConst(wireName: r'paydunya_vodafone_gh')
  static const ClientPaymentMethodMethodEnum paydunyaVodafoneGh = _$clientPaymentMethodMethodEnum_paydunyaVodafoneGh;
  @BuiltValueEnumConst(wireName: r'paydunya_airteltigo_gh')
  static const ClientPaymentMethodMethodEnum paydunyaAirteltigoGh = _$clientPaymentMethodMethodEnum_paydunyaAirteltigoGh;
  @BuiltValueEnumConst(wireName: r'paydunya_tm_ci')
  static const ClientPaymentMethodMethodEnum paydunyaTmCi = _$clientPaymentMethodMethodEnum_paydunyaTmCi;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_tg')
  static const ClientPaymentMethodMethodEnum paydunyaMoovTg = _$clientPaymentMethodMethodEnum_paydunyaMoovTg;
  @BuiltValueEnumConst(wireName: r'paydunya_togocel_tg')
  static const ClientPaymentMethodMethodEnum paydunyaTogocelTg = _$clientPaymentMethodMethodEnum_paydunyaTogocelTg;
  @BuiltValueEnumConst(wireName: r'paydunya_wari_sn')
  static const ClientPaymentMethodMethodEnum paydunyaWariSn = _$clientPaymentMethodMethodEnum_paydunyaWariSn;
  @BuiltValueEnumConst(wireName: r'paydunya_wave_sn')
  static const ClientPaymentMethodMethodEnum paydunyaWaveSn = _$clientPaymentMethodMethodEnum_paydunyaWaveSn;
  @BuiltValueEnumConst(wireName: r'paydunya_cb_ci')
  static const ClientPaymentMethodMethodEnum paydunyaCbCi = _$clientPaymentMethodMethodEnum_paydunyaCbCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_sn')
  static const ClientPaymentMethodMethodEnum paydunyaOrangeSn = _$clientPaymentMethodMethodEnum_paydunyaOrangeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_free_sn')
  static const ClientPaymentMethodMethodEnum paydunyaFreeSn = _$clientPaymentMethodMethodEnum_paydunyaFreeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_yup_bj')
  static const ClientPaymentMethodMethodEnum paydunyaYupBj = _$clientPaymentMethodMethodEnum_paydunyaYupBj;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_bj')
  static const ClientPaymentMethodMethodEnum paydunyaMtnBj = _$clientPaymentMethodMethodEnum_paydunyaMtnBj;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_ci')
  static const ClientPaymentMethodMethodEnum paydunyaMoovCi = _$clientPaymentMethodMethodEnum_paydunyaMoovCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_cm')
  static const ClientPaymentMethodMethodEnum paydunyaOrangeCm = _$clientPaymentMethodMethodEnum_paydunyaOrangeCm;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_cm')
  static const ClientPaymentMethodMethodEnum paydunyaMtnCm = _$clientPaymentMethodMethodEnum_paydunyaMtnCm;
  @BuiltValueEnumConst(wireName: r'paydunya_nexttel_cm')
  static const ClientPaymentMethodMethodEnum paydunyaNexttelCm = _$clientPaymentMethodMethodEnum_paydunyaNexttelCm;
  @BuiltValueEnumConst(wireName: r'paydunya_camtel_cm')
  static const ClientPaymentMethodMethodEnum paydunyaCamtelCm = _$clientPaymentMethodMethodEnum_paydunyaCamtelCm;

  static Serializer<ClientPaymentMethodMethodEnum> get serializer => _$clientPaymentMethodMethodEnumSerializer;

  const ClientPaymentMethodMethodEnum._(String name): super(name);

  static BuiltSet<ClientPaymentMethodMethodEnum> get values => _$clientPaymentMethodMethodEnumValues;
  static ClientPaymentMethodMethodEnum valueOf(String name) => _$clientPaymentMethodMethodEnumValueOf(name);
}

