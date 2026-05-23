//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'profile_options.g.dart';

/// ProfileOptions
///
/// Properties:
/// * [cities] 
/// * [languages] 
/// * [contactChannels] 
/// * [paymentProviders] 
@BuiltValue()
abstract class ProfileOptions implements Built<ProfileOptions, ProfileOptionsBuilder> {
  @BuiltValueField(wireName: r'cities')
  BuiltList<String> get cities;

  @BuiltValueField(wireName: r'languages')
  BuiltList<ProfileOptionsLanguagesEnum> get languages;
  // enum languagesEnum {  fr,  en,  };

  @BuiltValueField(wireName: r'contactChannels')
  BuiltList<ProfileOptionsContactChannelsEnum> get contactChannels;
  // enum contactChannelsEnum {  phone,  sms,  };

  @BuiltValueField(wireName: r'paymentProviders')
  BuiltList<ProfileOptionsPaymentProvidersEnum> get paymentProviders;
  // enum paymentProvidersEnum {  intech,  paydunya,  };

  ProfileOptions._();

  factory ProfileOptions([void updates(ProfileOptionsBuilder b)]) = _$ProfileOptions;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProfileOptionsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProfileOptions> get serializer => _$ProfileOptionsSerializer();
}

class _$ProfileOptionsSerializer implements PrimitiveSerializer<ProfileOptions> {
  @override
  final Iterable<Type> types = const [ProfileOptions, _$ProfileOptions];

  @override
  final String wireName = r'ProfileOptions';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProfileOptions object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cities';
    yield serializers.serialize(
      object.cities,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'languages';
    yield serializers.serialize(
      object.languages,
      specifiedType: const FullType(BuiltList, [FullType(ProfileOptionsLanguagesEnum)]),
    );
    yield r'contactChannels';
    yield serializers.serialize(
      object.contactChannels,
      specifiedType: const FullType(BuiltList, [FullType(ProfileOptionsContactChannelsEnum)]),
    );
    yield r'paymentProviders';
    yield serializers.serialize(
      object.paymentProviders,
      specifiedType: const FullType(BuiltList, [FullType(ProfileOptionsPaymentProvidersEnum)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProfileOptions object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProfileOptionsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.cities.replace(valueDes);
          break;
        case r'languages':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProfileOptionsLanguagesEnum)]),
          ) as BuiltList<ProfileOptionsLanguagesEnum>;
          result.languages.replace(valueDes);
          break;
        case r'contactChannels':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProfileOptionsContactChannelsEnum)]),
          ) as BuiltList<ProfileOptionsContactChannelsEnum>;
          result.contactChannels.replace(valueDes);
          break;
        case r'paymentProviders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProfileOptionsPaymentProvidersEnum)]),
          ) as BuiltList<ProfileOptionsPaymentProvidersEnum>;
          result.paymentProviders.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProfileOptions deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProfileOptionsBuilder();
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

class ProfileOptionsLanguagesEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'fr')
  static const ProfileOptionsLanguagesEnum fr = _$profileOptionsLanguagesEnum_fr;
  @BuiltValueEnumConst(wireName: r'en')
  static const ProfileOptionsLanguagesEnum en = _$profileOptionsLanguagesEnum_en;

  static Serializer<ProfileOptionsLanguagesEnum> get serializer => _$profileOptionsLanguagesEnumSerializer;

  const ProfileOptionsLanguagesEnum._(String name): super(name);

  static BuiltSet<ProfileOptionsLanguagesEnum> get values => _$profileOptionsLanguagesEnumValues;
  static ProfileOptionsLanguagesEnum valueOf(String name) => _$profileOptionsLanguagesEnumValueOf(name);
}

class ProfileOptionsContactChannelsEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'phone')
  static const ProfileOptionsContactChannelsEnum phone = _$profileOptionsContactChannelsEnum_phone;
  @BuiltValueEnumConst(wireName: r'sms')
  static const ProfileOptionsContactChannelsEnum sms = _$profileOptionsContactChannelsEnum_sms;

  static Serializer<ProfileOptionsContactChannelsEnum> get serializer => _$profileOptionsContactChannelsEnumSerializer;

  const ProfileOptionsContactChannelsEnum._(String name): super(name);

  static BuiltSet<ProfileOptionsContactChannelsEnum> get values => _$profileOptionsContactChannelsEnumValues;
  static ProfileOptionsContactChannelsEnum valueOf(String name) => _$profileOptionsContactChannelsEnumValueOf(name);
}

class ProfileOptionsPaymentProvidersEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'intech')
  static const ProfileOptionsPaymentProvidersEnum intech = _$profileOptionsPaymentProvidersEnum_intech;
  @BuiltValueEnumConst(wireName: r'paydunya')
  static const ProfileOptionsPaymentProvidersEnum paydunya = _$profileOptionsPaymentProvidersEnum_paydunya;

  static Serializer<ProfileOptionsPaymentProvidersEnum> get serializer => _$profileOptionsPaymentProvidersEnumSerializer;

  const ProfileOptionsPaymentProvidersEnum._(String name): super(name);

  static BuiltSet<ProfileOptionsPaymentProvidersEnum> get values => _$profileOptionsPaymentProvidersEnumValues;
  static ProfileOptionsPaymentProvidersEnum valueOf(String name) => _$profileOptionsPaymentProvidersEnumValueOf(name);
}

