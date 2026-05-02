// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_salon_decision_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSalonDecisionInput extends AdminSalonDecisionInput {
  @override
  final String reason;

  factory _$AdminSalonDecisionInput(
          [void Function(AdminSalonDecisionInputBuilder)? updates]) =>
      (AdminSalonDecisionInputBuilder()..update(updates))._build();

  _$AdminSalonDecisionInput._({required this.reason}) : super._();
  @override
  AdminSalonDecisionInput rebuild(
          void Function(AdminSalonDecisionInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSalonDecisionInputBuilder toBuilder() =>
      AdminSalonDecisionInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSalonDecisionInput && reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSalonDecisionInput')
          ..add('reason', reason))
        .toString();
  }
}

class AdminSalonDecisionInputBuilder
    implements
        Builder<AdminSalonDecisionInput, AdminSalonDecisionInputBuilder> {
  _$AdminSalonDecisionInput? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminSalonDecisionInputBuilder() {
    AdminSalonDecisionInput._defaults(this);
  }

  AdminSalonDecisionInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSalonDecisionInput other) {
    _$v = other as _$AdminSalonDecisionInput;
  }

  @override
  void update(void Function(AdminSalonDecisionInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSalonDecisionInput build() => _build();

  _$AdminSalonDecisionInput _build() {
    final _$result = _$v ??
        _$AdminSalonDecisionInput._(
          reason: BuiltValueNullFieldError.checkNotNull(
              reason, r'AdminSalonDecisionInput', 'reason'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
