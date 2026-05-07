//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_subscription_list_response_items_inner.g.dart';

/// AdminSubscriptionListResponseItemsInner
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
abstract class AdminSubscriptionListResponseItemsInner implements Built<AdminSubscriptionListResponseItemsInner, AdminSubscriptionListResponseItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'salonId')
  String get salonId;

  @BuiltValueField(wireName: r'salonName')
  String get salonName;

  @BuiltValueField(wireName: r'tier')
  AdminSubscriptionListResponseItemsInnerTierEnum get tier;
  // enum tierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'status')
  AdminSubscriptionListResponseItemsInnerStatusEnum get status;
  // enum statusEnum {  inactive,  active,  past_due,  cancelled,  expired,  paused,  };

  @BuiltValueField(wireName: r'billingProvider')
  AdminSubscriptionListResponseItemsInnerBillingProviderEnum? get billingProvider;
  // enum billingProviderEnum {  intech,  manual,  };

  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'autoRenew')
  bool get autoRenew;

  @BuiltValueField(wireName: r'isComplimentary')
  bool get isComplimentary;

  AdminSubscriptionListResponseItemsInner._();

  factory AdminSubscriptionListResponseItemsInner([void updates(AdminSubscriptionListResponseItemsInnerBuilder b)]) = _$AdminSubscriptionListResponseItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSubscriptionListResponseItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSubscriptionListResponseItemsInner> get serializer => _$AdminSubscriptionListResponseItemsInnerSerializer();
}

class _$AdminSubscriptionListResponseItemsInnerSerializer implements PrimitiveSerializer<AdminSubscriptionListResponseItemsInner> {
  @override
  final Iterable<Type> types = const [AdminSubscriptionListResponseItemsInner, _$AdminSubscriptionListResponseItemsInner];

  @override
  final String wireName = r'AdminSubscriptionListResponseItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSubscriptionListResponseItemsInner object, {
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
      specifiedType: const FullType(AdminSubscriptionListResponseItemsInnerTierEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminSubscriptionListResponseItemsInnerStatusEnum),
    );
    yield r'billingProvider';
    yield object.billingProvider == null ? null : serializers.serialize(
      object.billingProvider,
      specifiedType: const FullType.nullable(AdminSubscriptionListResponseItemsInnerBillingProviderEnum),
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
    AdminSubscriptionListResponseItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSubscriptionListResponseItemsInnerBuilder result,
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
            specifiedType: const FullType(AdminSubscriptionListResponseItemsInnerTierEnum),
          ) as AdminSubscriptionListResponseItemsInnerTierEnum;
          result.tier = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSubscriptionListResponseItemsInnerStatusEnum),
          ) as AdminSubscriptionListResponseItemsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'billingProvider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminSubscriptionListResponseItemsInnerBillingProviderEnum),
          ) as AdminSubscriptionListResponseItemsInnerBillingProviderEnum?;
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
  AdminSubscriptionListResponseItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSubscriptionListResponseItemsInnerBuilder();
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

class AdminSubscriptionListResponseItemsInnerTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const AdminSubscriptionListResponseItemsInnerTierEnum standard = _$adminSubscriptionListResponseItemsInnerTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const AdminSubscriptionListResponseItemsInnerTierEnum premium = _$adminSubscriptionListResponseItemsInnerTierEnum_premium;

  static Serializer<AdminSubscriptionListResponseItemsInnerTierEnum> get serializer => _$adminSubscriptionListResponseItemsInnerTierEnumSerializer;

  const AdminSubscriptionListResponseItemsInnerTierEnum._(String name): super(name);

  static BuiltSet<AdminSubscriptionListResponseItemsInnerTierEnum> get values => _$adminSubscriptionListResponseItemsInnerTierEnumValues;
  static AdminSubscriptionListResponseItemsInnerTierEnum valueOf(String name) => _$adminSubscriptionListResponseItemsInnerTierEnumValueOf(name);
}

class AdminSubscriptionListResponseItemsInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'inactive')
  static const AdminSubscriptionListResponseItemsInnerStatusEnum inactive = _$adminSubscriptionListResponseItemsInnerStatusEnum_inactive;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminSubscriptionListResponseItemsInnerStatusEnum active = _$adminSubscriptionListResponseItemsInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'past_due')
  static const AdminSubscriptionListResponseItemsInnerStatusEnum pastDue = _$adminSubscriptionListResponseItemsInnerStatusEnum_pastDue;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminSubscriptionListResponseItemsInnerStatusEnum cancelled = _$adminSubscriptionListResponseItemsInnerStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'expired')
  static const AdminSubscriptionListResponseItemsInnerStatusEnum expired = _$adminSubscriptionListResponseItemsInnerStatusEnum_expired;
  @BuiltValueEnumConst(wireName: r'paused')
  static const AdminSubscriptionListResponseItemsInnerStatusEnum paused = _$adminSubscriptionListResponseItemsInnerStatusEnum_paused;

  static Serializer<AdminSubscriptionListResponseItemsInnerStatusEnum> get serializer => _$adminSubscriptionListResponseItemsInnerStatusEnumSerializer;

  const AdminSubscriptionListResponseItemsInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminSubscriptionListResponseItemsInnerStatusEnum> get values => _$adminSubscriptionListResponseItemsInnerStatusEnumValues;
  static AdminSubscriptionListResponseItemsInnerStatusEnum valueOf(String name) => _$adminSubscriptionListResponseItemsInnerStatusEnumValueOf(name);
}

class AdminSubscriptionListResponseItemsInnerBillingProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'intech')
  static const AdminSubscriptionListResponseItemsInnerBillingProviderEnum intech = _$adminSubscriptionListResponseItemsInnerBillingProviderEnum_intech;
  @BuiltValueEnumConst(wireName: r'manual')
  static const AdminSubscriptionListResponseItemsInnerBillingProviderEnum manual = _$adminSubscriptionListResponseItemsInnerBillingProviderEnum_manual;

  static Serializer<AdminSubscriptionListResponseItemsInnerBillingProviderEnum> get serializer => _$adminSubscriptionListResponseItemsInnerBillingProviderEnumSerializer;

  const AdminSubscriptionListResponseItemsInnerBillingProviderEnum._(String name): super(name);

  static BuiltSet<AdminSubscriptionListResponseItemsInnerBillingProviderEnum> get values => _$adminSubscriptionListResponseItemsInnerBillingProviderEnumValues;
  static AdminSubscriptionListResponseItemsInnerBillingProviderEnum valueOf(String name) => _$adminSubscriptionListResponseItemsInnerBillingProviderEnumValueOf(name);
}

