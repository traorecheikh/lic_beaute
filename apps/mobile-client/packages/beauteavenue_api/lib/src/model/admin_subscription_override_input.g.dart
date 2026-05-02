// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_subscription_override_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSubscriptionOverrideInputActionEnum
    _$adminSubscriptionOverrideInputActionEnum_grantComplimentaryPremium =
    const AdminSubscriptionOverrideInputActionEnum._(
        'grantComplimentaryPremium');
const AdminSubscriptionOverrideInputActionEnum
    _$adminSubscriptionOverrideInputActionEnum_extendExpiry =
    const AdminSubscriptionOverrideInputActionEnum._('extendExpiry');
const AdminSubscriptionOverrideInputActionEnum
    _$adminSubscriptionOverrideInputActionEnum_downgradeToStandard =
    const AdminSubscriptionOverrideInputActionEnum._('downgradeToStandard');
const AdminSubscriptionOverrideInputActionEnum
    _$adminSubscriptionOverrideInputActionEnum_pauseSubscription =
    const AdminSubscriptionOverrideInputActionEnum._('pauseSubscription');
const AdminSubscriptionOverrideInputActionEnum
    _$adminSubscriptionOverrideInputActionEnum_resumeSubscription =
    const AdminSubscriptionOverrideInputActionEnum._('resumeSubscription');
const AdminSubscriptionOverrideInputActionEnum
    _$adminSubscriptionOverrideInputActionEnum_terminateSubscription =
    const AdminSubscriptionOverrideInputActionEnum._('terminateSubscription');
const AdminSubscriptionOverrideInputActionEnum
    _$adminSubscriptionOverrideInputActionEnum_markChargeResolved =
    const AdminSubscriptionOverrideInputActionEnum._('markChargeResolved');

AdminSubscriptionOverrideInputActionEnum
    _$adminSubscriptionOverrideInputActionEnumValueOf(String name) {
  switch (name) {
    case 'grantComplimentaryPremium':
      return _$adminSubscriptionOverrideInputActionEnum_grantComplimentaryPremium;
    case 'extendExpiry':
      return _$adminSubscriptionOverrideInputActionEnum_extendExpiry;
    case 'downgradeToStandard':
      return _$adminSubscriptionOverrideInputActionEnum_downgradeToStandard;
    case 'pauseSubscription':
      return _$adminSubscriptionOverrideInputActionEnum_pauseSubscription;
    case 'resumeSubscription':
      return _$adminSubscriptionOverrideInputActionEnum_resumeSubscription;
    case 'terminateSubscription':
      return _$adminSubscriptionOverrideInputActionEnum_terminateSubscription;
    case 'markChargeResolved':
      return _$adminSubscriptionOverrideInputActionEnum_markChargeResolved;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionOverrideInputActionEnum>
    _$adminSubscriptionOverrideInputActionEnumValues = BuiltSet<
        AdminSubscriptionOverrideInputActionEnum>(const <AdminSubscriptionOverrideInputActionEnum>[
  _$adminSubscriptionOverrideInputActionEnum_grantComplimentaryPremium,
  _$adminSubscriptionOverrideInputActionEnum_extendExpiry,
  _$adminSubscriptionOverrideInputActionEnum_downgradeToStandard,
  _$adminSubscriptionOverrideInputActionEnum_pauseSubscription,
  _$adminSubscriptionOverrideInputActionEnum_resumeSubscription,
  _$adminSubscriptionOverrideInputActionEnum_terminateSubscription,
  _$adminSubscriptionOverrideInputActionEnum_markChargeResolved,
]);

Serializer<AdminSubscriptionOverrideInputActionEnum>
    _$adminSubscriptionOverrideInputActionEnumSerializer =
    _$AdminSubscriptionOverrideInputActionEnumSerializer();

class _$AdminSubscriptionOverrideInputActionEnumSerializer
    implements PrimitiveSerializer<AdminSubscriptionOverrideInputActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'grantComplimentaryPremium': 'grant_complimentary_premium',
    'extendExpiry': 'extend_expiry',
    'downgradeToStandard': 'downgrade_to_standard',
    'pauseSubscription': 'pause_subscription',
    'resumeSubscription': 'resume_subscription',
    'terminateSubscription': 'terminate_subscription',
    'markChargeResolved': 'mark_charge_resolved',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'grant_complimentary_premium': 'grantComplimentaryPremium',
    'extend_expiry': 'extendExpiry',
    'downgrade_to_standard': 'downgradeToStandard',
    'pause_subscription': 'pauseSubscription',
    'resume_subscription': 'resumeSubscription',
    'terminate_subscription': 'terminateSubscription',
    'mark_charge_resolved': 'markChargeResolved',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSubscriptionOverrideInputActionEnum
  ];
  @override
  final String wireName = 'AdminSubscriptionOverrideInputActionEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSubscriptionOverrideInputActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionOverrideInputActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionOverrideInputActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionOverrideInput extends AdminSubscriptionOverrideInput {
  @override
  final AdminSubscriptionOverrideInputActionEnum action;
  @override
  final String reason;
  @override
  final DateTime? effectiveAt;
  @override
  final DateTime? expiresAt;
  @override
  final AdminSubscriptionOverrideInputMetadata? metadata;

  factory _$AdminSubscriptionOverrideInput(
          [void Function(AdminSubscriptionOverrideInputBuilder)? updates]) =>
      (AdminSubscriptionOverrideInputBuilder()..update(updates))._build();

  _$AdminSubscriptionOverrideInput._(
      {required this.action,
      required this.reason,
      this.effectiveAt,
      this.expiresAt,
      this.metadata})
      : super._();
  @override
  AdminSubscriptionOverrideInput rebuild(
          void Function(AdminSubscriptionOverrideInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSubscriptionOverrideInputBuilder toBuilder() =>
      AdminSubscriptionOverrideInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSubscriptionOverrideInput &&
        action == other.action &&
        reason == other.reason &&
        effectiveAt == other.effectiveAt &&
        expiresAt == other.expiresAt &&
        metadata == other.metadata;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, effectiveAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, metadata.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSubscriptionOverrideInput')
          ..add('action', action)
          ..add('reason', reason)
          ..add('effectiveAt', effectiveAt)
          ..add('expiresAt', expiresAt)
          ..add('metadata', metadata))
        .toString();
  }
}

class AdminSubscriptionOverrideInputBuilder
    implements
        Builder<AdminSubscriptionOverrideInput,
            AdminSubscriptionOverrideInputBuilder> {
  _$AdminSubscriptionOverrideInput? _$v;

  AdminSubscriptionOverrideInputActionEnum? _action;
  AdminSubscriptionOverrideInputActionEnum? get action => _$this._action;
  set action(AdminSubscriptionOverrideInputActionEnum? action) =>
      _$this._action = action;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _effectiveAt;
  DateTime? get effectiveAt => _$this._effectiveAt;
  set effectiveAt(DateTime? effectiveAt) => _$this._effectiveAt = effectiveAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  AdminSubscriptionOverrideInputMetadataBuilder? _metadata;
  AdminSubscriptionOverrideInputMetadataBuilder get metadata =>
      _$this._metadata ??= AdminSubscriptionOverrideInputMetadataBuilder();
  set metadata(AdminSubscriptionOverrideInputMetadataBuilder? metadata) =>
      _$this._metadata = metadata;

  AdminSubscriptionOverrideInputBuilder() {
    AdminSubscriptionOverrideInput._defaults(this);
  }

  AdminSubscriptionOverrideInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _reason = $v.reason;
      _effectiveAt = $v.effectiveAt;
      _expiresAt = $v.expiresAt;
      _metadata = $v.metadata?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSubscriptionOverrideInput other) {
    _$v = other as _$AdminSubscriptionOverrideInput;
  }

  @override
  void update(void Function(AdminSubscriptionOverrideInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSubscriptionOverrideInput build() => _build();

  _$AdminSubscriptionOverrideInput _build() {
    _$AdminSubscriptionOverrideInput _$result;
    try {
      _$result = _$v ??
          _$AdminSubscriptionOverrideInput._(
            action: BuiltValueNullFieldError.checkNotNull(
                action, r'AdminSubscriptionOverrideInput', 'action'),
            reason: BuiltValueNullFieldError.checkNotNull(
                reason, r'AdminSubscriptionOverrideInput', 'reason'),
            effectiveAt: effectiveAt,
            expiresAt: expiresAt,
            metadata: _metadata?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'metadata';
        _metadata?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminSubscriptionOverrideInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
