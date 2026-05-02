// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_subscription_detail_entitlements_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSubscriptionDetailEntitlementsInner
    extends AdminSubscriptionDetailEntitlementsInner {
  @override
  final String label;
  @override
  final bool enabled;
  @override
  final String? note;

  factory _$AdminSubscriptionDetailEntitlementsInner(
          [void Function(AdminSubscriptionDetailEntitlementsInnerBuilder)?
              updates]) =>
      (AdminSubscriptionDetailEntitlementsInnerBuilder()..update(updates))
          ._build();

  _$AdminSubscriptionDetailEntitlementsInner._(
      {required this.label, required this.enabled, this.note})
      : super._();
  @override
  AdminSubscriptionDetailEntitlementsInner rebuild(
          void Function(AdminSubscriptionDetailEntitlementsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSubscriptionDetailEntitlementsInnerBuilder toBuilder() =>
      AdminSubscriptionDetailEntitlementsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSubscriptionDetailEntitlementsInner &&
        label == other.label &&
        enabled == other.enabled &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminSubscriptionDetailEntitlementsInner')
          ..add('label', label)
          ..add('enabled', enabled)
          ..add('note', note))
        .toString();
  }
}

class AdminSubscriptionDetailEntitlementsInnerBuilder
    implements
        Builder<AdminSubscriptionDetailEntitlementsInner,
            AdminSubscriptionDetailEntitlementsInnerBuilder> {
  _$AdminSubscriptionDetailEntitlementsInner? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminSubscriptionDetailEntitlementsInnerBuilder() {
    AdminSubscriptionDetailEntitlementsInner._defaults(this);
  }

  AdminSubscriptionDetailEntitlementsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _enabled = $v.enabled;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSubscriptionDetailEntitlementsInner other) {
    _$v = other as _$AdminSubscriptionDetailEntitlementsInner;
  }

  @override
  void update(
      void Function(AdminSubscriptionDetailEntitlementsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSubscriptionDetailEntitlementsInner build() => _build();

  _$AdminSubscriptionDetailEntitlementsInner _build() {
    final _$result = _$v ??
        _$AdminSubscriptionDetailEntitlementsInner._(
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'AdminSubscriptionDetailEntitlementsInner', 'label'),
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'AdminSubscriptionDetailEntitlementsInner', 'enabled'),
          note: note,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
