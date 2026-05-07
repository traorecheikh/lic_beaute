//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_client_benefit_create_input.g.dart';

/// ProClientBenefitCreateInput
///
/// Properties:
/// * [clientId] 
/// * [kind] 
/// * [name] 
/// * [remainingUses] 
/// * [expiresAt] 
/// * [billingDate] 
@BuiltValue()
abstract class ProClientBenefitCreateInput implements Built<ProClientBenefitCreateInput, ProClientBenefitCreateInputBuilder> {
  @BuiltValueField(wireName: r'clientId')
  String get clientId;

  @BuiltValueField(wireName: r'kind')
  ProClientBenefitCreateInputKindEnum get kind;
  // enum kindEnum {  membership,  package,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'remainingUses')
  int? get remainingUses;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'billingDate')
  DateTime? get billingDate;

  ProClientBenefitCreateInput._();

  factory ProClientBenefitCreateInput([void updates(ProClientBenefitCreateInputBuilder b)]) = _$ProClientBenefitCreateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProClientBenefitCreateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProClientBenefitCreateInput> get serializer => _$ProClientBenefitCreateInputSerializer();
}

class _$ProClientBenefitCreateInputSerializer implements PrimitiveSerializer<ProClientBenefitCreateInput> {
  @override
  final Iterable<Type> types = const [ProClientBenefitCreateInput, _$ProClientBenefitCreateInput];

  @override
  final String wireName = r'ProClientBenefitCreateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProClientBenefitCreateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'clientId';
    yield serializers.serialize(
      object.clientId,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(ProClientBenefitCreateInputKindEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.remainingUses != null) {
      yield r'remainingUses';
      yield serializers.serialize(
        object.remainingUses,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.expiresAt != null) {
      yield r'expiresAt';
      yield serializers.serialize(
        object.expiresAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.billingDate != null) {
      yield r'billingDate';
      yield serializers.serialize(
        object.billingDate,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProClientBenefitCreateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProClientBenefitCreateInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'clientId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.clientId = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProClientBenefitCreateInputKindEnum),
          ) as ProClientBenefitCreateInputKindEnum;
          result.kind = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'remainingUses':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.remainingUses = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'billingDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.billingDate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProClientBenefitCreateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProClientBenefitCreateInputBuilder();
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

class ProClientBenefitCreateInputKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'membership')
  static const ProClientBenefitCreateInputKindEnum membership = _$proClientBenefitCreateInputKindEnum_membership;
  @BuiltValueEnumConst(wireName: r'package')
  static const ProClientBenefitCreateInputKindEnum package = _$proClientBenefitCreateInputKindEnum_package;

  static Serializer<ProClientBenefitCreateInputKindEnum> get serializer => _$proClientBenefitCreateInputKindEnumSerializer;

  const ProClientBenefitCreateInputKindEnum._(String name): super(name);

  static BuiltSet<ProClientBenefitCreateInputKindEnum> get values => _$proClientBenefitCreateInputKindEnumValues;
  static ProClientBenefitCreateInputKindEnum valueOf(String name) => _$proClientBenefitCreateInputKindEnumValueOf(name);
}

