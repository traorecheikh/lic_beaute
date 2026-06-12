//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_v1_me_payment_methods_get200_response_items_inner.g.dart';

/// ApiV1MePaymentMethodsGet200ResponseItemsInner
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
abstract class ApiV1MePaymentMethodsGet200ResponseItemsInner implements Built<ApiV1MePaymentMethodsGet200ResponseItemsInner, ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'provider')
  ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum get provider;
  // enum providerEnum {  paydunya,  manual,  };

  @BuiltValueField(wireName: r'phoneNumber')
  String get phoneNumber;

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'method')
  ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum? get method;
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

  ApiV1MePaymentMethodsGet200ResponseItemsInner._();

  factory ApiV1MePaymentMethodsGet200ResponseItemsInner([void updates(ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder b)]) = _$ApiV1MePaymentMethodsGet200ResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiV1MePaymentMethodsGet200ResponseItemsInner> get serializer => _$ApiV1MePaymentMethodsGet200ResponseItemsInnerSerializer();
}

class _$ApiV1MePaymentMethodsGet200ResponseItemsInnerSerializer implements PrimitiveSerializer<ApiV1MePaymentMethodsGet200ResponseItemsInner> {
  @override
  final Iterable<Type> types = const [ApiV1MePaymentMethodsGet200ResponseItemsInner, _$ApiV1MePaymentMethodsGet200ResponseItemsInner];

  @override
  final String wireName = r'ApiV1MePaymentMethodsGet200ResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiV1MePaymentMethodsGet200ResponseItemsInner object, {
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
      specifiedType: const FullType(ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum),
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
        specifiedType: const FullType.nullable(ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum),
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
    ApiV1MePaymentMethodsGet200ResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder result,
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
            specifiedType: const FullType(ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum),
          ) as ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum;
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
            specifiedType: const FullType.nullable(ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum),
          ) as ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum?;
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
  ApiV1MePaymentMethodsGet200ResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder();
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

class ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'paydunya')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum paydunya = _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum_paydunya;
  @BuiltValueEnumConst(wireName: r'manual')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum manual = _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum_manual;

  static Serializer<ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum> get serializer => _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnumSerializer;

  const ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum._(String name): super(name);

  static BuiltSet<ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum> get values => _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnumValues;
  static ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum valueOf(String name) => _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnumValueOf(name);
}

class ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'carte_bancaire')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum carteBancaire = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_carteBancaire;
  @BuiltValueEnumConst(wireName: r'wave_senegal')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum waveSenegal = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_waveSenegal;
  @BuiltValueEnumConst(wireName: r'orange_senegal')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum orangeSenegal = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_orangeSenegal;
  @BuiltValueEnumConst(wireName: r'free_senegal')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum freeSenegal = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_freeSenegal;
  @BuiltValueEnumConst(wireName: r'wizall_senegal')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum wizallSenegal = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_wizallSenegal;
  @BuiltValueEnumConst(wireName: r'expresso_sn')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum expressoSn = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_expressoSn;
  @BuiltValueEnumConst(wireName: r'om_ci')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum omCi = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_omCi;
  @BuiltValueEnumConst(wireName: r'mtn_ci')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum mtnCi = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_mtnCi;
  @BuiltValueEnumConst(wireName: r'moov_ci')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum moovCi = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_moovCi;
  @BuiltValueEnumConst(wireName: r'wave_ci')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum waveCi = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_waveCi;
  @BuiltValueEnumConst(wireName: r'om_bf')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum omBf = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_omBf;
  @BuiltValueEnumConst(wireName: r'moov_bf')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum moovBf = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_moovBf;
  @BuiltValueEnumConst(wireName: r'moov_bj')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum moovBj = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_moovBj;
  @BuiltValueEnumConst(wireName: r'mtn_bj')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum mtnBj = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_mtnBj;
  @BuiltValueEnumConst(wireName: r't_money_tg')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum tMoneyTg = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_tMoneyTg;
  @BuiltValueEnumConst(wireName: r'moov_tg')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum moovTg = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_moovTg;
  @BuiltValueEnumConst(wireName: r'om_ml')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum omMl = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_omMl;
  @BuiltValueEnumConst(wireName: r'moov_ml')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum moovMl = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_moovMl;
  @BuiltValueEnumConst(wireName: r'mtn_cm')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum mtnCm = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_mtnCm;
  @BuiltValueEnumConst(wireName: r'djamo')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum djamo = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_djamo;
  @BuiltValueEnumConst(wireName: r'paydunya_wallet')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaWallet = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaWallet;
  @BuiltValueEnumConst(wireName: r'wave')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum wave = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_wave;
  @BuiltValueEnumConst(wireName: r'orange_money')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum orangeMoney = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_orangeMoney;
  @BuiltValueEnumConst(wireName: r'free_money')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum freeMoney = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_freeMoney;
  @BuiltValueEnumConst(wireName: r'paydunya_card')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaCard = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaCard;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaAirtel = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_expresso')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaExpresso = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaExpresso;
  @BuiltValueEnumConst(wireName: r'paydunya_free')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaFree = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaFree;
  @BuiltValueEnumConst(wireName: r'paydunya_mpesa')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaMpesa = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaMpesa;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_airtel')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaNgAirtel = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaNgAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_mtn')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaNgMtn = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaNgMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_9mobile')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaNg9mobile = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaNg9mobile;
  @BuiltValueEnumConst(wireName: r'paydunya_ng_glo')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaNgGlo = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaNgGlo;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_airtel')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaSamAirtel = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaSamAirtel;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_mtn')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaSamMtn = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaSamMtn;
  @BuiltValueEnumConst(wireName: r'paydunya_sam_safaricom')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaSamSafaricom = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaSamSafaricom;
  @BuiltValueEnumConst(wireName: r'paydunya_tigo_rw')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaTigoRw = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaTigoRw;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_rw')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaAirtelRw = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaAirtelRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_rw')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaMtnRw = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaMtnRw;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ug')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaMtnUg = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaMtnUg;
  @BuiltValueEnumConst(wireName: r'paydunya_airtel_ug')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaAirtelUg = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaAirtelUg;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_ml')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaOrangeMl = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaOrangeMl;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_ci')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaMtnCi = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaMtnCi;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_gh')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaMtnGh = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaMtnGh;
  @BuiltValueEnumConst(wireName: r'paydunya_vodafone_gh')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaVodafoneGh = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaVodafoneGh;
  @BuiltValueEnumConst(wireName: r'paydunya_airteltigo_gh')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaAirteltigoGh = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaAirteltigoGh;
  @BuiltValueEnumConst(wireName: r'paydunya_tm_ci')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaTmCi = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaTmCi;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_tg')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaMoovTg = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaMoovTg;
  @BuiltValueEnumConst(wireName: r'paydunya_togocel_tg')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaTogocelTg = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaTogocelTg;
  @BuiltValueEnumConst(wireName: r'paydunya_wari_sn')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaWariSn = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaWariSn;
  @BuiltValueEnumConst(wireName: r'paydunya_wave_sn')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaWaveSn = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaWaveSn;
  @BuiltValueEnumConst(wireName: r'paydunya_cb_ci')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaCbCi = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaCbCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_sn')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaOrangeSn = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaOrangeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_free_sn')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaFreeSn = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaFreeSn;
  @BuiltValueEnumConst(wireName: r'paydunya_yup_bj')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaYupBj = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaYupBj;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_bj')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaMtnBj = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaMtnBj;
  @BuiltValueEnumConst(wireName: r'paydunya_moov_ci')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaMoovCi = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaMoovCi;
  @BuiltValueEnumConst(wireName: r'paydunya_orange_cm')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaOrangeCm = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaOrangeCm;
  @BuiltValueEnumConst(wireName: r'paydunya_mtn_cm')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaMtnCm = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaMtnCm;
  @BuiltValueEnumConst(wireName: r'paydunya_nexttel_cm')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaNexttelCm = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaNexttelCm;
  @BuiltValueEnumConst(wireName: r'paydunya_camtel_cm')
  static const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum paydunyaCamtelCm = _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum_paydunyaCamtelCm;

  static Serializer<ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum> get serializer => _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnumSerializer;

  const ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum._(String name): super(name);

  static BuiltSet<ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum> get values => _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnumValues;
  static ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum valueOf(String name) => _$apiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnumValueOf(name);
}

