// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_filters.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAuditFilters extends AdminAuditFilters {
  @override
  final String? actor;
  @override
  final String? entityType;
  @override
  final String? action;

  factory _$AdminAuditFilters(
          [void Function(AdminAuditFiltersBuilder)? updates]) =>
      (AdminAuditFiltersBuilder()..update(updates))._build();

  _$AdminAuditFilters._({this.actor, this.entityType, this.action}) : super._();
  @override
  AdminAuditFilters rebuild(void Function(AdminAuditFiltersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAuditFiltersBuilder toBuilder() =>
      AdminAuditFiltersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAuditFilters &&
        actor == other.actor &&
        entityType == other.entityType &&
        action == other.action;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, actor.hashCode);
    _$hash = $jc(_$hash, entityType.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminAuditFilters')
          ..add('actor', actor)
          ..add('entityType', entityType)
          ..add('action', action))
        .toString();
  }
}

class AdminAuditFiltersBuilder
    implements Builder<AdminAuditFilters, AdminAuditFiltersBuilder> {
  _$AdminAuditFilters? _$v;

  String? _actor;
  String? get actor => _$this._actor;
  set actor(String? actor) => _$this._actor = actor;

  String? _entityType;
  String? get entityType => _$this._entityType;
  set entityType(String? entityType) => _$this._entityType = entityType;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  AdminAuditFiltersBuilder() {
    AdminAuditFilters._defaults(this);
  }

  AdminAuditFiltersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _actor = $v.actor;
      _entityType = $v.entityType;
      _action = $v.action;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAuditFilters other) {
    _$v = other as _$AdminAuditFilters;
  }

  @override
  void update(void Function(AdminAuditFiltersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAuditFilters build() => _build();

  _$AdminAuditFilters _build() {
    final _$result = _$v ??
        _$AdminAuditFilters._(
          actor: actor,
          entityType: entityType,
          action: action,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
