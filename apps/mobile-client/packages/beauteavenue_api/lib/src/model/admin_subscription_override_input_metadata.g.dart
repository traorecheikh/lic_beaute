// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_subscription_override_input_metadata.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSubscriptionOverrideInputMetadata
    extends AdminSubscriptionOverrideInputMetadata {
  @override
  final String? internalTicket;
  @override
  final String? subscriptionChargeId;
  @override
  final String? providerReference;

  factory _$AdminSubscriptionOverrideInputMetadata(
          [void Function(AdminSubscriptionOverrideInputMetadataBuilder)?
              updates]) =>
      (AdminSubscriptionOverrideInputMetadataBuilder()..update(updates))
          ._build();

  _$AdminSubscriptionOverrideInputMetadata._(
      {this.internalTicket, this.subscriptionChargeId, this.providerReference})
      : super._();
  @override
  AdminSubscriptionOverrideInputMetadata rebuild(
          void Function(AdminSubscriptionOverrideInputMetadataBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSubscriptionOverrideInputMetadataBuilder toBuilder() =>
      AdminSubscriptionOverrideInputMetadataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSubscriptionOverrideInputMetadata &&
        internalTicket == other.internalTicket &&
        subscriptionChargeId == other.subscriptionChargeId &&
        providerReference == other.providerReference;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, internalTicket.hashCode);
    _$hash = $jc(_$hash, subscriptionChargeId.hashCode);
    _$hash = $jc(_$hash, providerReference.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminSubscriptionOverrideInputMetadata')
          ..add('internalTicket', internalTicket)
          ..add('subscriptionChargeId', subscriptionChargeId)
          ..add('providerReference', providerReference))
        .toString();
  }
}

class AdminSubscriptionOverrideInputMetadataBuilder
    implements
        Builder<AdminSubscriptionOverrideInputMetadata,
            AdminSubscriptionOverrideInputMetadataBuilder> {
  _$AdminSubscriptionOverrideInputMetadata? _$v;

  String? _internalTicket;
  String? get internalTicket => _$this._internalTicket;
  set internalTicket(String? internalTicket) =>
      _$this._internalTicket = internalTicket;

  String? _subscriptionChargeId;
  String? get subscriptionChargeId => _$this._subscriptionChargeId;
  set subscriptionChargeId(String? subscriptionChargeId) =>
      _$this._subscriptionChargeId = subscriptionChargeId;

  String? _providerReference;
  String? get providerReference => _$this._providerReference;
  set providerReference(String? providerReference) =>
      _$this._providerReference = providerReference;

  AdminSubscriptionOverrideInputMetadataBuilder() {
    AdminSubscriptionOverrideInputMetadata._defaults(this);
  }

  AdminSubscriptionOverrideInputMetadataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _internalTicket = $v.internalTicket;
      _subscriptionChargeId = $v.subscriptionChargeId;
      _providerReference = $v.providerReference;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSubscriptionOverrideInputMetadata other) {
    _$v = other as _$AdminSubscriptionOverrideInputMetadata;
  }

  @override
  void update(
      void Function(AdminSubscriptionOverrideInputMetadataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSubscriptionOverrideInputMetadata build() => _build();

  _$AdminSubscriptionOverrideInputMetadata _build() {
    final _$result = _$v ??
        _$AdminSubscriptionOverrideInputMetadata._(
          internalTicket: internalTicket,
          subscriptionChargeId: subscriptionChargeId,
          providerReference: providerReference,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
