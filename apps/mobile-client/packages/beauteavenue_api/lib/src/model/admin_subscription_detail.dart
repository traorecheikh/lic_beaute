//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/admin_subscription_detail_entitlements_inner.dart';
import 'package:beauteavenue_api/src/model/admin_subscription_detail_events_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/admin_subscription_detail_invoices_inner.dart';
import 'package:beauteavenue_api/src/model/admin_subscription_detail_pending_charges_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_subscription_detail.g.dart';

/// AdminSubscriptionDetail
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
/// * [startedAt] 
/// * [renewedAt] 
/// * [entitlements] 
/// * [events] 
/// * [invoices] 
/// * [pendingCharges] 
@BuiltValue()
abstract class AdminSubscriptionDetail implements Built<AdminSubscriptionDetail, AdminSubscriptionDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'salonId')
  String get salonId;

  @BuiltValueField(wireName: r'salonName')
  String get salonName;

  @BuiltValueField(wireName: r'tier')
  AdminSubscriptionDetailTierEnum get tier;
  // enum tierEnum {  standard,  premium,  };

  @BuiltValueField(wireName: r'status')
  AdminSubscriptionDetailStatusEnum get status;
  // enum statusEnum {  inactive,  active,  past_due,  cancelled,  expired,  paused,  };

  @BuiltValueField(wireName: r'billingProvider')
  AdminSubscriptionDetailBillingProviderEnum? get billingProvider;
  // enum billingProviderEnum {  paydunya,  manual,  };

  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'autoRenew')
  bool get autoRenew;

  @BuiltValueField(wireName: r'isComplimentary')
  bool get isComplimentary;

  @BuiltValueField(wireName: r'startedAt')
  DateTime get startedAt;

  @BuiltValueField(wireName: r'renewedAt')
  DateTime? get renewedAt;

  @BuiltValueField(wireName: r'entitlements')
  BuiltList<AdminSubscriptionDetailEntitlementsInner> get entitlements;

  @BuiltValueField(wireName: r'events')
  BuiltList<AdminSubscriptionDetailEventsInner> get events;

  @BuiltValueField(wireName: r'invoices')
  BuiltList<AdminSubscriptionDetailInvoicesInner> get invoices;

  @BuiltValueField(wireName: r'pendingCharges')
  BuiltList<AdminSubscriptionDetailPendingChargesInner> get pendingCharges;

  AdminSubscriptionDetail._();

  factory AdminSubscriptionDetail([void updates(AdminSubscriptionDetailBuilder b)]) = _$AdminSubscriptionDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSubscriptionDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSubscriptionDetail> get serializer => _$AdminSubscriptionDetailSerializer();
}

class _$AdminSubscriptionDetailSerializer implements PrimitiveSerializer<AdminSubscriptionDetail> {
  @override
  final Iterable<Type> types = const [AdminSubscriptionDetail, _$AdminSubscriptionDetail];

  @override
  final String wireName = r'AdminSubscriptionDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSubscriptionDetail object, {
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
      specifiedType: const FullType(AdminSubscriptionDetailTierEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminSubscriptionDetailStatusEnum),
    );
    yield r'billingProvider';
    yield object.billingProvider == null ? null : serializers.serialize(
      object.billingProvider,
      specifiedType: const FullType.nullable(AdminSubscriptionDetailBillingProviderEnum),
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
    yield r'startedAt';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'renewedAt';
    yield object.renewedAt == null ? null : serializers.serialize(
      object.renewedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'entitlements';
    yield serializers.serialize(
      object.entitlements,
      specifiedType: const FullType(BuiltList, [FullType(AdminSubscriptionDetailEntitlementsInner)]),
    );
    yield r'events';
    yield serializers.serialize(
      object.events,
      specifiedType: const FullType(BuiltList, [FullType(AdminSubscriptionDetailEventsInner)]),
    );
    yield r'invoices';
    yield serializers.serialize(
      object.invoices,
      specifiedType: const FullType(BuiltList, [FullType(AdminSubscriptionDetailInvoicesInner)]),
    );
    yield r'pendingCharges';
    yield serializers.serialize(
      object.pendingCharges,
      specifiedType: const FullType(BuiltList, [FullType(AdminSubscriptionDetailPendingChargesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSubscriptionDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSubscriptionDetailBuilder result,
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
            specifiedType: const FullType(AdminSubscriptionDetailTierEnum),
          ) as AdminSubscriptionDetailTierEnum;
          result.tier = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSubscriptionDetailStatusEnum),
          ) as AdminSubscriptionDetailStatusEnum;
          result.status = valueDes;
          break;
        case r'billingProvider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminSubscriptionDetailBillingProviderEnum),
          ) as AdminSubscriptionDetailBillingProviderEnum?;
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
        case r'startedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startedAt = valueDes;
          break;
        case r'renewedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.renewedAt = valueDes;
          break;
        case r'entitlements':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminSubscriptionDetailEntitlementsInner)]),
          ) as BuiltList<AdminSubscriptionDetailEntitlementsInner>;
          result.entitlements.replace(valueDes);
          break;
        case r'events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminSubscriptionDetailEventsInner)]),
          ) as BuiltList<AdminSubscriptionDetailEventsInner>;
          result.events.replace(valueDes);
          break;
        case r'invoices':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminSubscriptionDetailInvoicesInner)]),
          ) as BuiltList<AdminSubscriptionDetailInvoicesInner>;
          result.invoices.replace(valueDes);
          break;
        case r'pendingCharges':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminSubscriptionDetailPendingChargesInner)]),
          ) as BuiltList<AdminSubscriptionDetailPendingChargesInner>;
          result.pendingCharges.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSubscriptionDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSubscriptionDetailBuilder();
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

class AdminSubscriptionDetailTierEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'standard')
  static const AdminSubscriptionDetailTierEnum standard = _$adminSubscriptionDetailTierEnum_standard;
  @BuiltValueEnumConst(wireName: r'premium')
  static const AdminSubscriptionDetailTierEnum premium = _$adminSubscriptionDetailTierEnum_premium;

  static Serializer<AdminSubscriptionDetailTierEnum> get serializer => _$adminSubscriptionDetailTierEnumSerializer;

  const AdminSubscriptionDetailTierEnum._(String name): super(name);

  static BuiltSet<AdminSubscriptionDetailTierEnum> get values => _$adminSubscriptionDetailTierEnumValues;
  static AdminSubscriptionDetailTierEnum valueOf(String name) => _$adminSubscriptionDetailTierEnumValueOf(name);
}

class AdminSubscriptionDetailStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'inactive')
  static const AdminSubscriptionDetailStatusEnum inactive = _$adminSubscriptionDetailStatusEnum_inactive;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminSubscriptionDetailStatusEnum active = _$adminSubscriptionDetailStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'past_due')
  static const AdminSubscriptionDetailStatusEnum pastDue = _$adminSubscriptionDetailStatusEnum_pastDue;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminSubscriptionDetailStatusEnum cancelled = _$adminSubscriptionDetailStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'expired')
  static const AdminSubscriptionDetailStatusEnum expired = _$adminSubscriptionDetailStatusEnum_expired;
  @BuiltValueEnumConst(wireName: r'paused')
  static const AdminSubscriptionDetailStatusEnum paused = _$adminSubscriptionDetailStatusEnum_paused;

  static Serializer<AdminSubscriptionDetailStatusEnum> get serializer => _$adminSubscriptionDetailStatusEnumSerializer;

  const AdminSubscriptionDetailStatusEnum._(String name): super(name);

  static BuiltSet<AdminSubscriptionDetailStatusEnum> get values => _$adminSubscriptionDetailStatusEnumValues;
  static AdminSubscriptionDetailStatusEnum valueOf(String name) => _$adminSubscriptionDetailStatusEnumValueOf(name);
}

class AdminSubscriptionDetailBillingProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'paydunya')
  static const AdminSubscriptionDetailBillingProviderEnum paydunya = _$adminSubscriptionDetailBillingProviderEnum_paydunya;
  @BuiltValueEnumConst(wireName: r'manual')
  static const AdminSubscriptionDetailBillingProviderEnum manual = _$adminSubscriptionDetailBillingProviderEnum_manual;

  static Serializer<AdminSubscriptionDetailBillingProviderEnum> get serializer => _$adminSubscriptionDetailBillingProviderEnumSerializer;

  const AdminSubscriptionDetailBillingProviderEnum._(String name): super(name);

  static BuiltSet<AdminSubscriptionDetailBillingProviderEnum> get values => _$adminSubscriptionDetailBillingProviderEnumValues;
  static AdminSubscriptionDetailBillingProviderEnum valueOf(String name) => _$adminSubscriptionDetailBillingProviderEnumValueOf(name);
}

