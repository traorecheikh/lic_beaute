//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/admin_subscription_override_input_metadata.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_subscription_override_input.g.dart';

/// AdminSubscriptionOverrideInput
///
/// Properties:
/// * [action]
/// * [reason]
/// * [effectiveAt]
/// * [expiresAt]
/// * [metadata]
@BuiltValue()
abstract class AdminSubscriptionOverrideInput
    implements
        Built<AdminSubscriptionOverrideInput,
            AdminSubscriptionOverrideInputBuilder> {
  @BuiltValueField(wireName: r'action')
  AdminSubscriptionOverrideInputActionEnum get action;
  // enum actionEnum {  grant_complimentary_premium,  extend_expiry,  downgrade_to_standard,  pause_subscription,  resume_subscription,  terminate_subscription,  mark_charge_resolved,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'effectiveAt')
  DateTime? get effectiveAt;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'metadata')
  AdminSubscriptionOverrideInputMetadata? get metadata;

  AdminSubscriptionOverrideInput._();

  factory AdminSubscriptionOverrideInput(
          [void updates(AdminSubscriptionOverrideInputBuilder b)]) =
      _$AdminSubscriptionOverrideInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSubscriptionOverrideInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSubscriptionOverrideInput> get serializer =>
      _$AdminSubscriptionOverrideInputSerializer();
}

class _$AdminSubscriptionOverrideInputSerializer
    implements PrimitiveSerializer<AdminSubscriptionOverrideInput> {
  @override
  final Iterable<Type> types = const [
    AdminSubscriptionOverrideInput,
    _$AdminSubscriptionOverrideInput
  ];

  @override
  final String wireName = r'AdminSubscriptionOverrideInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSubscriptionOverrideInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(AdminSubscriptionOverrideInputActionEnum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.effectiveAt != null) {
      yield r'effectiveAt';
      yield serializers.serialize(
        object.effectiveAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.expiresAt != null) {
      yield r'expiresAt';
      yield serializers.serialize(
        object.expiresAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.metadata != null) {
      yield r'metadata';
      yield serializers.serialize(
        object.metadata,
        specifiedType: const FullType(AdminSubscriptionOverrideInputMetadata),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSubscriptionOverrideInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSubscriptionOverrideInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(AdminSubscriptionOverrideInputActionEnum),
          ) as AdminSubscriptionOverrideInputActionEnum;
          result.action = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'effectiveAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.effectiveAt = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'metadata':
          final valueDes = serializers.deserialize(
            value,
            specifiedType:
                const FullType(AdminSubscriptionOverrideInputMetadata),
          ) as AdminSubscriptionOverrideInputMetadata;
          result.metadata.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSubscriptionOverrideInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSubscriptionOverrideInputBuilder();
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

class AdminSubscriptionOverrideInputActionEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'grant_complimentary_premium')
  static const AdminSubscriptionOverrideInputActionEnum
      grantComplimentaryPremium =
      _$adminSubscriptionOverrideInputActionEnum_grantComplimentaryPremium;
  @BuiltValueEnumConst(wireName: r'extend_expiry')
  static const AdminSubscriptionOverrideInputActionEnum extendExpiry =
      _$adminSubscriptionOverrideInputActionEnum_extendExpiry;
  @BuiltValueEnumConst(wireName: r'downgrade_to_standard')
  static const AdminSubscriptionOverrideInputActionEnum downgradeToStandard =
      _$adminSubscriptionOverrideInputActionEnum_downgradeToStandard;
  @BuiltValueEnumConst(wireName: r'pause_subscription')
  static const AdminSubscriptionOverrideInputActionEnum pauseSubscription =
      _$adminSubscriptionOverrideInputActionEnum_pauseSubscription;
  @BuiltValueEnumConst(wireName: r'resume_subscription')
  static const AdminSubscriptionOverrideInputActionEnum resumeSubscription =
      _$adminSubscriptionOverrideInputActionEnum_resumeSubscription;
  @BuiltValueEnumConst(wireName: r'terminate_subscription')
  static const AdminSubscriptionOverrideInputActionEnum terminateSubscription =
      _$adminSubscriptionOverrideInputActionEnum_terminateSubscription;
  @BuiltValueEnumConst(wireName: r'mark_charge_resolved')
  static const AdminSubscriptionOverrideInputActionEnum markChargeResolved =
      _$adminSubscriptionOverrideInputActionEnum_markChargeResolved;

  static Serializer<AdminSubscriptionOverrideInputActionEnum> get serializer =>
      _$adminSubscriptionOverrideInputActionEnumSerializer;

  const AdminSubscriptionOverrideInputActionEnum._(String name) : super(name);

  static BuiltSet<AdminSubscriptionOverrideInputActionEnum> get values =>
      _$adminSubscriptionOverrideInputActionEnumValues;
  static AdminSubscriptionOverrideInputActionEnum valueOf(String name) =>
      _$adminSubscriptionOverrideInputActionEnumValueOf(name);
}
