//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/register_input_any_of1_documents_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/register_input_any_of1_hours_inner.dart';
import 'package:beauteavenue_api/src/model/register_input_any_of1_salon.dart';
import 'package:beauteavenue_api/src/model/register_input_any_of1_services_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_input_any_of1.g.dart';

/// RegisterInputAnyOf1
///
/// Properties:
/// * [type] 
/// * [fullName] 
/// * [email] 
/// * [phone] 
/// * [password] 
/// * [subscriptionIntentTier] 
/// * [salon] 
/// * [services] 
/// * [hours] 
/// * [documents] 
@BuiltValue()
abstract class RegisterInputAnyOf1 implements Built<RegisterInputAnyOf1, RegisterInputAnyOf1Builder> {
  @BuiltValueField(wireName: r'type')
  RegisterInputAnyOf1TypeEnum get type;
  // enum typeEnum {  salon_owner,  };

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'subscriptionIntentTier')
  RegisterInputAnyOf1SubscriptionIntentTierEnum? get subscriptionIntentTier;
  // enum subscriptionIntentTierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'salon')
  RegisterInputAnyOf1Salon get salon;

  @BuiltValueField(wireName: r'services')
  BuiltList<RegisterInputAnyOf1ServicesInner> get services;

  @BuiltValueField(wireName: r'hours')
  BuiltList<RegisterInputAnyOf1HoursInner> get hours;

  @BuiltValueField(wireName: r'documents')
  BuiltList<RegisterInputAnyOf1DocumentsInner>? get documents;

  RegisterInputAnyOf1._();

  factory RegisterInputAnyOf1([void updates(RegisterInputAnyOf1Builder b)]) = _$RegisterInputAnyOf1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterInputAnyOf1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterInputAnyOf1> get serializer => _$RegisterInputAnyOf1Serializer();
}

class _$RegisterInputAnyOf1Serializer implements PrimitiveSerializer<RegisterInputAnyOf1> {
  @override
  final Iterable<Type> types = const [RegisterInputAnyOf1, _$RegisterInputAnyOf1];

  @override
  final String wireName = r'RegisterInputAnyOf1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterInputAnyOf1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'type';
    yield serializers.serialize(
      object.type,
      specifiedType: const FullType(RegisterInputAnyOf1TypeEnum),
    );
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    if (object.subscriptionIntentTier != null) {
      yield r'subscriptionIntentTier';
      yield serializers.serialize(
        object.subscriptionIntentTier,
        specifiedType: const FullType(RegisterInputAnyOf1SubscriptionIntentTierEnum),
      );
    }
    yield r'salon';
    yield serializers.serialize(
      object.salon,
      specifiedType: const FullType(RegisterInputAnyOf1Salon),
    );
    yield r'services';
    yield serializers.serialize(
      object.services,
      specifiedType: const FullType(BuiltList, [FullType(RegisterInputAnyOf1ServicesInner)]),
    );
    yield r'hours';
    yield serializers.serialize(
      object.hours,
      specifiedType: const FullType(BuiltList, [FullType(RegisterInputAnyOf1HoursInner)]),
    );
    if (object.documents != null) {
      yield r'documents';
      yield serializers.serialize(
        object.documents,
        specifiedType: const FullType(BuiltList, [FullType(RegisterInputAnyOf1DocumentsInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterInputAnyOf1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterInputAnyOf1Builder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegisterInputAnyOf1TypeEnum),
          ) as RegisterInputAnyOf1TypeEnum;
          result.type = valueDes;
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
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'subscriptionIntentTier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegisterInputAnyOf1SubscriptionIntentTierEnum),
          ) as RegisterInputAnyOf1SubscriptionIntentTierEnum;
          result.subscriptionIntentTier = valueDes;
          break;
        case r'salon':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegisterInputAnyOf1Salon),
          ) as RegisterInputAnyOf1Salon;
          result.salon.replace(valueDes);
          break;
        case r'services':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RegisterInputAnyOf1ServicesInner)]),
          ) as BuiltList<RegisterInputAnyOf1ServicesInner>;
          result.services.replace(valueDes);
          break;
        case r'hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RegisterInputAnyOf1HoursInner)]),
          ) as BuiltList<RegisterInputAnyOf1HoursInner>;
          result.hours.replace(valueDes);
          break;
        case r'documents':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RegisterInputAnyOf1DocumentsInner)]),
          ) as BuiltList<RegisterInputAnyOf1DocumentsInner>;
          result.documents.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegisterInputAnyOf1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterInputAnyOf1Builder();
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

class RegisterInputAnyOf1TypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'salon_owner')
  static const RegisterInputAnyOf1TypeEnum salonOwner = _$registerInputAnyOf1TypeEnum_salonOwner;

  static Serializer<RegisterInputAnyOf1TypeEnum> get serializer => _$registerInputAnyOf1TypeEnumSerializer;

  const RegisterInputAnyOf1TypeEnum._(String name): super(name);

  static BuiltSet<RegisterInputAnyOf1TypeEnum> get values => _$registerInputAnyOf1TypeEnumValues;
  static RegisterInputAnyOf1TypeEnum valueOf(String name) => _$registerInputAnyOf1TypeEnumValueOf(name);
}

class RegisterInputAnyOf1SubscriptionIntentTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const RegisterInputAnyOf1SubscriptionIntentTierEnum standard = _$registerInputAnyOf1SubscriptionIntentTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const RegisterInputAnyOf1SubscriptionIntentTierEnum premium = _$registerInputAnyOf1SubscriptionIntentTierEnum_premium;

  static Serializer<RegisterInputAnyOf1SubscriptionIntentTierEnum> get serializer => _$registerInputAnyOf1SubscriptionIntentTierEnumSerializer;

  const RegisterInputAnyOf1SubscriptionIntentTierEnum._(String name): super(name);

  static BuiltSet<RegisterInputAnyOf1SubscriptionIntentTierEnum> get values => _$registerInputAnyOf1SubscriptionIntentTierEnumValues;
  static RegisterInputAnyOf1SubscriptionIntentTierEnum valueOf(String name) => _$registerInputAnyOf1SubscriptionIntentTierEnumValueOf(name);
}

