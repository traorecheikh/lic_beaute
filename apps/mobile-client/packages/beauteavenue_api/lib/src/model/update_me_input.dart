//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_me_input.g.dart';

/// UpdateMeInput
///
/// Properties:
/// * [fullName] 
/// * [phone] 
/// * [city] 
/// * [avatarMediaId] 
/// * [preferredContactChannel] 
/// * [pushOptIn] 
/// * [marketingOptIn] 
/// * [preferredLanguage] 
/// * [currentPassword] 
/// * [newPassword] 
@BuiltValue()
abstract class UpdateMeInput implements Built<UpdateMeInput, UpdateMeInputBuilder> {
  @BuiltValueField(wireName: r'fullName')
  String? get fullName;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'city')
  String? get city;

  @BuiltValueField(wireName: r'avatarMediaId')
  String? get avatarMediaId;

  @BuiltValueField(wireName: r'preferredContactChannel')
  UpdateMeInputPreferredContactChannelEnum? get preferredContactChannel;
  // enum preferredContactChannelEnum {  phone,  sms,  };

  @BuiltValueField(wireName: r'pushOptIn')
  bool? get pushOptIn;

  @BuiltValueField(wireName: r'marketingOptIn')
  bool? get marketingOptIn;

  @BuiltValueField(wireName: r'preferredLanguage')
  UpdateMeInputPreferredLanguageEnum? get preferredLanguage;
  // enum preferredLanguageEnum {  fr,  en,  };

  @BuiltValueField(wireName: r'currentPassword')
  String? get currentPassword;

  @BuiltValueField(wireName: r'newPassword')
  String? get newPassword;

  UpdateMeInput._();

  factory UpdateMeInput([void updates(UpdateMeInputBuilder b)]) = _$UpdateMeInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateMeInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateMeInput> get serializer => _$UpdateMeInputSerializer();
}

class _$UpdateMeInputSerializer implements PrimitiveSerializer<UpdateMeInput> {
  @override
  final Iterable<Type> types = const [UpdateMeInput, _$UpdateMeInput];

  @override
  final String wireName = r'UpdateMeInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateMeInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.fullName != null) {
      yield r'fullName';
      yield serializers.serialize(
        object.fullName,
        specifiedType: const FullType(String),
      );
    }
    if (object.phone != null) {
      yield r'phone';
      yield serializers.serialize(
        object.phone,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.city != null) {
      yield r'city';
      yield serializers.serialize(
        object.city,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.avatarMediaId != null) {
      yield r'avatarMediaId';
      yield serializers.serialize(
        object.avatarMediaId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.preferredContactChannel != null) {
      yield r'preferredContactChannel';
      yield serializers.serialize(
        object.preferredContactChannel,
        specifiedType: const FullType(UpdateMeInputPreferredContactChannelEnum),
      );
    }
    if (object.pushOptIn != null) {
      yield r'pushOptIn';
      yield serializers.serialize(
        object.pushOptIn,
        specifiedType: const FullType(bool),
      );
    }
    if (object.marketingOptIn != null) {
      yield r'marketingOptIn';
      yield serializers.serialize(
        object.marketingOptIn,
        specifiedType: const FullType(bool),
      );
    }
    if (object.preferredLanguage != null) {
      yield r'preferredLanguage';
      yield serializers.serialize(
        object.preferredLanguage,
        specifiedType: const FullType(UpdateMeInputPreferredLanguageEnum),
      );
    }
    if (object.currentPassword != null) {
      yield r'currentPassword';
      yield serializers.serialize(
        object.currentPassword,
        specifiedType: const FullType(String),
      );
    }
    if (object.newPassword != null) {
      yield r'newPassword';
      yield serializers.serialize(
        object.newPassword,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateMeInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdateMeInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fullName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.city = valueDes;
          break;
        case r'avatarMediaId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatarMediaId = valueDes;
          break;
        case r'preferredContactChannel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UpdateMeInputPreferredContactChannelEnum),
          ) as UpdateMeInputPreferredContactChannelEnum;
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
            specifiedType: const FullType(UpdateMeInputPreferredLanguageEnum),
          ) as UpdateMeInputPreferredLanguageEnum;
          result.preferredLanguage = valueDes;
          break;
        case r'currentPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currentPassword = valueDes;
          break;
        case r'newPassword':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.newPassword = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdateMeInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateMeInputBuilder();
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

class UpdateMeInputPreferredContactChannelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'phone')
  static const UpdateMeInputPreferredContactChannelEnum phone = _$updateMeInputPreferredContactChannelEnum_phone;
  @BuiltValueEnumConst(wireName: r'sms')
  static const UpdateMeInputPreferredContactChannelEnum sms = _$updateMeInputPreferredContactChannelEnum_sms;

  static Serializer<UpdateMeInputPreferredContactChannelEnum> get serializer => _$updateMeInputPreferredContactChannelEnumSerializer;

  const UpdateMeInputPreferredContactChannelEnum._(String name): super(name);

  static BuiltSet<UpdateMeInputPreferredContactChannelEnum> get values => _$updateMeInputPreferredContactChannelEnumValues;
  static UpdateMeInputPreferredContactChannelEnum valueOf(String name) => _$updateMeInputPreferredContactChannelEnumValueOf(name);
}

class UpdateMeInputPreferredLanguageEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'fr')
  static const UpdateMeInputPreferredLanguageEnum fr = _$updateMeInputPreferredLanguageEnum_fr;
  @BuiltValueEnumConst(wireName: r'en')
  static const UpdateMeInputPreferredLanguageEnum en = _$updateMeInputPreferredLanguageEnum_en;

  static Serializer<UpdateMeInputPreferredLanguageEnum> get serializer => _$updateMeInputPreferredLanguageEnumSerializer;

  const UpdateMeInputPreferredLanguageEnum._(String name): super(name);

  static BuiltSet<UpdateMeInputPreferredLanguageEnum> get values => _$updateMeInputPreferredLanguageEnumValues;
  static UpdateMeInputPreferredLanguageEnum valueOf(String name) => _$updateMeInputPreferredLanguageEnumValueOf(name);
}

