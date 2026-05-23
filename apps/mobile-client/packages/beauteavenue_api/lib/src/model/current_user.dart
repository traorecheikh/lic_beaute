//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'current_user.g.dart';

/// CurrentUser
///
/// Properties:
/// * [id] 
/// * [fullName] 
/// * [email] 
/// * [phone] 
/// * [role] 
/// * [salonId] 
/// * [city] 
/// * [avatarUrl] 
/// * [preferredContactChannel] 
/// * [pushOptIn] 
/// * [marketingOptIn] 
/// * [preferredLanguage] 
@BuiltValue()
abstract class CurrentUser implements Built<CurrentUser, CurrentUserBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'role')
  CurrentUserRoleEnum get role;
  // enum roleEnum {  client,  salon_staff,  salon_manager,  salon_owner,  platform_admin,  };

  @BuiltValueField(wireName: r'salonId')
  String? get salonId;

  @BuiltValueField(wireName: r'city')
  String? get city;

  @BuiltValueField(wireName: r'avatarUrl')
  String? get avatarUrl;

  @BuiltValueField(wireName: r'preferredContactChannel')
  CurrentUserPreferredContactChannelEnum get preferredContactChannel;
  // enum preferredContactChannelEnum {  phone,  sms,  };

  @BuiltValueField(wireName: r'pushOptIn')
  bool get pushOptIn;

  @BuiltValueField(wireName: r'marketingOptIn')
  bool get marketingOptIn;

  @BuiltValueField(wireName: r'preferredLanguage')
  CurrentUserPreferredLanguageEnum get preferredLanguage;
  // enum preferredLanguageEnum {  fr,  en,  };

  CurrentUser._();

  factory CurrentUser([void updates(CurrentUserBuilder b)]) = _$CurrentUser;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CurrentUserBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CurrentUser> get serializer => _$CurrentUserSerializer();
}

class _$CurrentUserSerializer implements PrimitiveSerializer<CurrentUser> {
  @override
  final Iterable<Type> types = const [CurrentUser, _$CurrentUser];

  @override
  final String wireName = r'CurrentUser';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CurrentUser object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield object.email == null ? null : serializers.serialize(
      object.email,
      specifiedType: const FullType.nullable(String),
    );
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(CurrentUserRoleEnum),
    );
    yield r'salonId';
    yield object.salonId == null ? null : serializers.serialize(
      object.salonId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'city';
    yield object.city == null ? null : serializers.serialize(
      object.city,
      specifiedType: const FullType.nullable(String),
    );
    yield r'avatarUrl';
    yield object.avatarUrl == null ? null : serializers.serialize(
      object.avatarUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'preferredContactChannel';
    yield serializers.serialize(
      object.preferredContactChannel,
      specifiedType: const FullType(CurrentUserPreferredContactChannelEnum),
    );
    yield r'pushOptIn';
    yield serializers.serialize(
      object.pushOptIn,
      specifiedType: const FullType(bool),
    );
    yield r'marketingOptIn';
    yield serializers.serialize(
      object.marketingOptIn,
      specifiedType: const FullType(bool),
    );
    yield r'preferredLanguage';
    yield serializers.serialize(
      object.preferredLanguage,
      specifiedType: const FullType(CurrentUserPreferredLanguageEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CurrentUser object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CurrentUserBuilder result,
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
        case r'fullName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CurrentUserRoleEnum),
          ) as CurrentUserRoleEnum;
          result.role = valueDes;
          break;
        case r'salonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.salonId = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.city = valueDes;
          break;
        case r'avatarUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatarUrl = valueDes;
          break;
        case r'preferredContactChannel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CurrentUserPreferredContactChannelEnum),
          ) as CurrentUserPreferredContactChannelEnum;
          result.preferredContactChannel = valueDes;
          break;
        case r'pushOptIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.pushOptIn = valueDes;
          break;
        case r'marketingOptIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.marketingOptIn = valueDes;
          break;
        case r'preferredLanguage':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CurrentUserPreferredLanguageEnum),
          ) as CurrentUserPreferredLanguageEnum;
          result.preferredLanguage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CurrentUser deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CurrentUserBuilder();
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

class CurrentUserRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'client')
  static const CurrentUserRoleEnum client = _$currentUserRoleEnum_client;
  @BuiltValueEnumConst(wireName: r'salon_staff')
  static const CurrentUserRoleEnum salonStaff = _$currentUserRoleEnum_salonStaff;
  @BuiltValueEnumConst(wireName: r'salon_manager')
  static const CurrentUserRoleEnum salonManager = _$currentUserRoleEnum_salonManager;
  @BuiltValueEnumConst(wireName: r'salon_owner')
  static const CurrentUserRoleEnum salonOwner = _$currentUserRoleEnum_salonOwner;
  @BuiltValueEnumConst(wireName: r'platform_admin')
  static const CurrentUserRoleEnum platformAdmin = _$currentUserRoleEnum_platformAdmin;

  static Serializer<CurrentUserRoleEnum> get serializer => _$currentUserRoleEnumSerializer;

  const CurrentUserRoleEnum._(String name): super(name);

  static BuiltSet<CurrentUserRoleEnum> get values => _$currentUserRoleEnumValues;
  static CurrentUserRoleEnum valueOf(String name) => _$currentUserRoleEnumValueOf(name);
}

class CurrentUserPreferredContactChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'phone')
  static const CurrentUserPreferredContactChannelEnum phone = _$currentUserPreferredContactChannelEnum_phone;
  @BuiltValueEnumConst(wireName: r'sms')
  static const CurrentUserPreferredContactChannelEnum sms = _$currentUserPreferredContactChannelEnum_sms;

  static Serializer<CurrentUserPreferredContactChannelEnum> get serializer => _$currentUserPreferredContactChannelEnumSerializer;

  const CurrentUserPreferredContactChannelEnum._(String name): super(name);

  static BuiltSet<CurrentUserPreferredContactChannelEnum> get values => _$currentUserPreferredContactChannelEnumValues;
  static CurrentUserPreferredContactChannelEnum valueOf(String name) => _$currentUserPreferredContactChannelEnumValueOf(name);
}

class CurrentUserPreferredLanguageEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'fr')
  static const CurrentUserPreferredLanguageEnum fr = _$currentUserPreferredLanguageEnum_fr;
  @BuiltValueEnumConst(wireName: r'en')
  static const CurrentUserPreferredLanguageEnum en = _$currentUserPreferredLanguageEnum_en;

  static Serializer<CurrentUserPreferredLanguageEnum> get serializer => _$currentUserPreferredLanguageEnumSerializer;

  const CurrentUserPreferredLanguageEnum._(String name): super(name);

  static BuiltSet<CurrentUserPreferredLanguageEnum> get values => _$currentUserPreferredLanguageEnumValues;
  static CurrentUserPreferredLanguageEnum valueOf(String name) => _$currentUserPreferredLanguageEnumValueOf(name);
}

