//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_subscription_summary.g.dart';

/// AdminSubscriptionSummary
///
/// Properties:
/// * [id] 
/// * [salonId] 
/// * [salonName] 
/// * [tier] 
/// * [status] 
/// * [billingProvider] 
/// * [expiresAt] 
/// * [autoRenew] 
/// * [isComplimentary] 
@BuiltValue()
abstract class AdminSubscriptionSummary implements Built<AdminSubscriptionSummary, AdminSubscriptionSummaryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'salonId')
  String get salonId;

  @BuiltValueField(wireName: r'salonName')
  String get salonName;

  @BuiltValueField(wireName: r'tier')
  AdminSubscriptionSummaryTierEnum get tier;
  // enum tierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'status')
  AdminSubscriptionSummaryStatusEnum get status;
  // enum statusEnum {  inactive,  active,  past_due,  cancelled,  expired,  paused,  };

  @BuiltValueField(wireName: r'billingProvider')
  AdminSubscriptionSummaryBillingProviderEnum? get billingProvider;
  // enum billingProviderEnum {  paydunya,  manual,  };

  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'autoRenew')
  bool get autoRenew;

  @BuiltValueField(wireName: r'isComplimentary')
  bool get isComplimentary;

  AdminSubscriptionSummary._();

  factory AdminSubscriptionSummary([void updates(AdminSubscriptionSummaryBuilder b)]) = _$AdminSubscriptionSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSubscriptionSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSubscriptionSummary> get serializer => _$AdminSubscriptionSummarySerializer();
}

class _$AdminSubscriptionSummarySerializer implements PrimitiveSerializer<AdminSubscriptionSummary> {
  @override
  final Iterable<Type> types = const [AdminSubscriptionSummary, _$AdminSubscriptionSummary];

  @override
  final String wireName = r'AdminSubscriptionSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSubscriptionSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
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
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(AdminSubscriptionSummaryTierEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminSubscriptionSummaryStatusEnum),
    );
    yield r'billingProvider';
    yield object.billingProvider == null ? null : serializers.serialize(
      object.billingProvider,
      specifiedType: const FullType.nullable(AdminSubscriptionSummaryBillingProviderEnum),
    );
    yield r'expiresAt';
    yield object.expiresAt == null ? null : serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'autoRenew';
    yield serializers.serialize(
      object.autoRenew,
      specifiedType: const FullType(bool),
    );
    yield r'isComplimentary';
    yield serializers.serialize(
      object.isComplimentary,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSubscriptionSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSubscriptionSummaryBuilder result,
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
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSubscriptionSummaryTierEnum),
          ) as AdminSubscriptionSummaryTierEnum;
          result.tier = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSubscriptionSummaryStatusEnum),
          ) as AdminSubscriptionSummaryStatusEnum;
          result.status = valueDes;
          break;
        case r'billingProvider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminSubscriptionSummaryBillingProviderEnum),
          ) as AdminSubscriptionSummaryBillingProviderEnum?;
          if (valueDes == null) continue;
          result.billingProvider = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'autoRenew':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.autoRenew = valueDes;
          break;
        case r'isComplimentary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isComplimentary = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSubscriptionSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSubscriptionSummaryBuilder();
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

class AdminSubscriptionSummaryTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const AdminSubscriptionSummaryTierEnum standard = _$adminSubscriptionSummaryTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const AdminSubscriptionSummaryTierEnum premium = _$adminSubscriptionSummaryTierEnum_premium;

  static Serializer<AdminSubscriptionSummaryTierEnum> get serializer => _$adminSubscriptionSummaryTierEnumSerializer;

  const AdminSubscriptionSummaryTierEnum._(String name): super(name);

  static BuiltSet<AdminSubscriptionSummaryTierEnum> get values => _$adminSubscriptionSummaryTierEnumValues;
  static AdminSubscriptionSummaryTierEnum valueOf(String name) => _$adminSubscriptionSummaryTierEnumValueOf(name);
}

class AdminSubscriptionSummaryStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'inactive')
  static const AdminSubscriptionSummaryStatusEnum inactive = _$adminSubscriptionSummaryStatusEnum_inactive;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminSubscriptionSummaryStatusEnum active = _$adminSubscriptionSummaryStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'past_due')
  static const AdminSubscriptionSummaryStatusEnum pastDue = _$adminSubscriptionSummaryStatusEnum_pastDue;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminSubscriptionSummaryStatusEnum cancelled = _$adminSubscriptionSummaryStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'expired')
  static const AdminSubscriptionSummaryStatusEnum expired = _$adminSubscriptionSummaryStatusEnum_expired;
  @BuiltValueEnumConst(wireName: r'paused')
  static const AdminSubscriptionSummaryStatusEnum paused = _$adminSubscriptionSummaryStatusEnum_paused;

  static Serializer<AdminSubscriptionSummaryStatusEnum> get serializer => _$adminSubscriptionSummaryStatusEnumSerializer;

  const AdminSubscriptionSummaryStatusEnum._(String name): super(name);

  static BuiltSet<AdminSubscriptionSummaryStatusEnum> get values => _$adminSubscriptionSummaryStatusEnumValues;
  static AdminSubscriptionSummaryStatusEnum valueOf(String name) => _$adminSubscriptionSummaryStatusEnumValueOf(name);
}

class AdminSubscriptionSummaryBillingProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'paydunya')
  static const AdminSubscriptionSummaryBillingProviderEnum paydunya = _$adminSubscriptionSummaryBillingProviderEnum_paydunya;
  @BuiltValueEnumConst(wireName: r'manual')
  static const AdminSubscriptionSummaryBillingProviderEnum manual = _$adminSubscriptionSummaryBillingProviderEnum_manual;

  static Serializer<AdminSubscriptionSummaryBillingProviderEnum> get serializer => _$adminSubscriptionSummaryBillingProviderEnumSerializer;

  const AdminSubscriptionSummaryBillingProviderEnum._(String name): super(name);

  static BuiltSet<AdminSubscriptionSummaryBillingProviderEnum> get values => _$adminSubscriptionSummaryBillingProviderEnumValues;
  static AdminSubscriptionSummaryBillingProviderEnum valueOf(String name) => _$adminSubscriptionSummaryBillingProviderEnumValueOf(name);
}

