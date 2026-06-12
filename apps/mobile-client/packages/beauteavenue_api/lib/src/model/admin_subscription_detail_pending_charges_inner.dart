//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_subscription_detail_pending_charges_inner.g.dart';

/// AdminSubscriptionDetailPendingChargesInner
///
/// Properties:
/// * [id] 
/// * [amountXof] 
/// * [chargeType] 
/// * [provider] 
/// * [status] 
/// * [createdAt] 
@BuiltValue()
abstract class AdminSubscriptionDetailPendingChargesInner implements Built<AdminSubscriptionDetailPendingChargesInner, AdminSubscriptionDetailPendingChargesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'amountXof')
  int get amountXof;

  @BuiltValueField(wireName: r'chargeType')
  AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum get chargeType;
  // enum chargeTypeEnum {  upgrade,  renewal,  };

  @BuiltValueField(wireName: r'provider')
  AdminSubscriptionDetailPendingChargesInnerProviderEnum get provider;
  // enum providerEnum {  paydunya,  manual,  };

  @BuiltValueField(wireName: r'status')
  AdminSubscriptionDetailPendingChargesInnerStatusEnum get status;
  // enum statusEnum {  pending,  authorized,  succeeded,  failed,  refunded,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AdminSubscriptionDetailPendingChargesInner._();

  factory AdminSubscriptionDetailPendingChargesInner([void updates(AdminSubscriptionDetailPendingChargesInnerBuilder b)]) = _$AdminSubscriptionDetailPendingChargesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSubscriptionDetailPendingChargesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSubscriptionDetailPendingChargesInner> get serializer => _$AdminSubscriptionDetailPendingChargesInnerSerializer();
}

class _$AdminSubscriptionDetailPendingChargesInnerSerializer implements PrimitiveSerializer<AdminSubscriptionDetailPendingChargesInner> {
  @override
  final Iterable<Type> types = const [AdminSubscriptionDetailPendingChargesInner, _$AdminSubscriptionDetailPendingChargesInner];

  @override
  final String wireName = r'AdminSubscriptionDetailPendingChargesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSubscriptionDetailPendingChargesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'amountXof';
    yield serializers.serialize(
      object.amountXof,
      specifiedType: const FullType(int),
    );
    yield r'chargeType';
    yield serializers.serialize(
      object.chargeType,
      specifiedType: const FullType(AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum),
    );
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(AdminSubscriptionDetailPendingChargesInnerProviderEnum),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminSubscriptionDetailPendingChargesInnerStatusEnum),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSubscriptionDetailPendingChargesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSubscriptionDetailPendingChargesInnerBuilder result,
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
        case r'amountXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountXof = valueDes;
          break;
        case r'chargeType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum),
          ) as AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum;
          result.chargeType = valueDes;
          break;
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSubscriptionDetailPendingChargesInnerProviderEnum),
          ) as AdminSubscriptionDetailPendingChargesInnerProviderEnum;
          result.provider = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSubscriptionDetailPendingChargesInnerStatusEnum),
          ) as AdminSubscriptionDetailPendingChargesInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
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
  AdminSubscriptionDetailPendingChargesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSubscriptionDetailPendingChargesInnerBuilder();
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

class AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'upgrade')
  static const AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum upgrade = _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnum_upgrade;
  @BuiltValueEnumConst(wireName: r'renewal')
  static const AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum renewal = _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnum_renewal;

  static Serializer<AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum> get serializer => _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnumSerializer;

  const AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum._(String name): super(name);

  static BuiltSet<AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum> get values => _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnumValues;
  static AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum valueOf(String name) => _$adminSubscriptionDetailPendingChargesInnerChargeTypeEnumValueOf(name);
}

class AdminSubscriptionDetailPendingChargesInnerProviderEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'paydunya')
  static const AdminSubscriptionDetailPendingChargesInnerProviderEnum paydunya = _$adminSubscriptionDetailPendingChargesInnerProviderEnum_paydunya;
  @BuiltValueEnumConst(wireName: r'manual')
  static const AdminSubscriptionDetailPendingChargesInnerProviderEnum manual = _$adminSubscriptionDetailPendingChargesInnerProviderEnum_manual;

  static Serializer<AdminSubscriptionDetailPendingChargesInnerProviderEnum> get serializer => _$adminSubscriptionDetailPendingChargesInnerProviderEnumSerializer;

  const AdminSubscriptionDetailPendingChargesInnerProviderEnum._(String name): super(name);

  static BuiltSet<AdminSubscriptionDetailPendingChargesInnerProviderEnum> get values => _$adminSubscriptionDetailPendingChargesInnerProviderEnumValues;
  static AdminSubscriptionDetailPendingChargesInnerProviderEnum valueOf(String name) => _$adminSubscriptionDetailPendingChargesInnerProviderEnumValueOf(name);
}

class AdminSubscriptionDetailPendingChargesInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending')
  static const AdminSubscriptionDetailPendingChargesInnerStatusEnum pending = _$adminSubscriptionDetailPendingChargesInnerStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'authorized')
  static const AdminSubscriptionDetailPendingChargesInnerStatusEnum authorized = _$adminSubscriptionDetailPendingChargesInnerStatusEnum_authorized;
  @BuiltValueEnumConst(wireName: r'succeeded')
  static const AdminSubscriptionDetailPendingChargesInnerStatusEnum succeeded = _$adminSubscriptionDetailPendingChargesInnerStatusEnum_succeeded;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminSubscriptionDetailPendingChargesInnerStatusEnum failed = _$adminSubscriptionDetailPendingChargesInnerStatusEnum_failed;
  @BuiltValueEnumConst(wireName: r'refunded')
  static const AdminSubscriptionDetailPendingChargesInnerStatusEnum refunded = _$adminSubscriptionDetailPendingChargesInnerStatusEnum_refunded;

  static Serializer<AdminSubscriptionDetailPendingChargesInnerStatusEnum> get serializer => _$adminSubscriptionDetailPendingChargesInnerStatusEnumSerializer;

  const AdminSubscriptionDetailPendingChargesInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminSubscriptionDetailPendingChargesInnerStatusEnum> get values => _$adminSubscriptionDetailPendingChargesInnerStatusEnumValues;
  static AdminSubscriptionDetailPendingChargesInnerStatusEnum valueOf(String name) => _$adminSubscriptionDetailPendingChargesInnerStatusEnumValueOf(name);
}

