//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'client_benefit.g.dart';

/// ClientBenefit
///
/// Properties:
/// * [id] 
/// * [kind] 
/// * [name] 
/// * [status] 
/// * [remainingUses] 
/// * [expiresAt] 
/// * [billingDate] 
/// * [salonId] 
/// * [salonName] 
/// * [createdAt] 
@BuiltValue()
abstract class ClientBenefit implements Built<ClientBenefit, ClientBenefitBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  ClientBenefitKindEnum get kind;
  // enum kindEnum {  membership,  package,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  ClientBenefitStatusEnum get status;
  // enum statusEnum {  active,  paused,  expired,  exhausted,  cancelled,  };

  @BuiltValueField(wireName: r'remainingUses')
  int? get remainingUses;

  @BuiltValueField(wireName: r'expiresAt')
  String? get expiresAt;

  @BuiltValueField(wireName: r'billingDate')
  String? get billingDate;

  @BuiltValueField(wireName: r'salonId')
  String get salonId;

  @BuiltValueField(wireName: r'salonName')
  String get salonName;

  @BuiltValueField(wireName: r'createdAt')
  String get createdAt;

  ClientBenefit._();

  factory ClientBenefit([void updates(ClientBenefitBuilder b)]) = _$ClientBenefit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClientBenefitBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClientBenefit> get serializer => _$ClientBenefitSerializer();
}

class _$ClientBenefitSerializer implements PrimitiveSerializer<ClientBenefit> {
  @override
  final Iterable<Type> types = const [ClientBenefit, _$ClientBenefit];

  @override
  final String wireName = r'ClientBenefit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClientBenefit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(ClientBenefitKindEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ClientBenefitStatusEnum),
    );
    yield r'remainingUses';
    yield object.remainingUses == null ? null : serializers.serialize(
      object.remainingUses,
      specifiedType: const FullType.nullable(int),
    );
    yield r'expiresAt';
    yield object.expiresAt == null ? null : serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'billingDate';
    yield object.billingDate == null ? null : serializers.serialize(
      object.billingDate,
      specifiedType: const FullType.nullable(String),
    );
    yield r'salonId';
    yield serializers.serialize(
      object.salonId,
      specifiedType: const FullType(String),
    );
    yield r'salonName';
    yield serializers.serialize(
      object.salonName,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ClientBenefit object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClientBenefitBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClientBenefitKindEnum),
          ) as ClientBenefitKindEnum;
          result.kind = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClientBenefitStatusEnum),
          ) as ClientBenefitStatusEnum;
          result.status = valueDes;
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
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'billingDate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.billingDate = valueDes;
          break;
        case r'salonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salonId = valueDes;
          break;
        case r'salonName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.salonName = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClientBenefit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClientBenefitBuilder();
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

class ClientBenefitKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'membership')
  static const ClientBenefitKindEnum membership = _$clientBenefitKindEnum_membership;
  @BuiltValueEnumConst(wireName: r'package')
  static const ClientBenefitKindEnum package = _$clientBenefitKindEnum_package;

  static Serializer<ClientBenefitKindEnum> get serializer => _$clientBenefitKindEnumSerializer;

  const ClientBenefitKindEnum._(String name): super(name);

  static BuiltSet<ClientBenefitKindEnum> get values => _$clientBenefitKindEnumValues;
  static ClientBenefitKindEnum valueOf(String name) => _$clientBenefitKindEnumValueOf(name);
}

class ClientBenefitStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'active')
  static const ClientBenefitStatusEnum active = _$clientBenefitStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'paused')
  static const ClientBenefitStatusEnum paused = _$clientBenefitStatusEnum_paused;
  @BuiltValueEnumConst(wireName: r'expired')
  static const ClientBenefitStatusEnum expired = _$clientBenefitStatusEnum_expired;
  @BuiltValueEnumConst(wireName: r'exhausted')
  static const ClientBenefitStatusEnum exhausted = _$clientBenefitStatusEnum_exhausted;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const ClientBenefitStatusEnum cancelled = _$clientBenefitStatusEnum_cancelled;

  static Serializer<ClientBenefitStatusEnum> get serializer => _$clientBenefitStatusEnumSerializer;

  const ClientBenefitStatusEnum._(String name): super(name);

  static BuiltSet<ClientBenefitStatusEnum> get values => _$clientBenefitStatusEnumValues;
  static ClientBenefitStatusEnum valueOf(String name) => _$clientBenefitStatusEnumValueOf(name);
}

