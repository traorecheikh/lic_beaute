// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminAuditSummarySeverityEnum _$adminAuditSummarySeverityEnum_info =
    const AdminAuditSummarySeverityEnum._('info');
const AdminAuditSummarySeverityEnum _$adminAuditSummarySeverityEnum_warning =
    const AdminAuditSummarySeverityEnum._('warning');
const AdminAuditSummarySeverityEnum _$adminAuditSummarySeverityEnum_critical =
    const AdminAuditSummarySeverityEnum._('critical');

AdminAuditSummarySeverityEnum _$adminAuditSummarySeverityEnumValueOf(
    String name) {
  switch (name) {
    case 'info':
      return _$adminAuditSummarySeverityEnum_info;
    case 'warning':
      return _$adminAuditSummarySeverityEnum_warning;
    case 'critical':
      return _$adminAuditSummarySeverityEnum_critical;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminAuditSummarySeverityEnum>
    _$adminAuditSummarySeverityEnumValues = BuiltSet<
        AdminAuditSummarySeverityEnum>(const <AdminAuditSummarySeverityEnum>[
  _$adminAuditSummarySeverityEnum_info,
  _$adminAuditSummarySeverityEnum_warning,
  _$adminAuditSummarySeverityEnum_critical,
]);

Serializer<AdminAuditSummarySeverityEnum>
    _$adminAuditSummarySeverityEnumSerializer =
    _$AdminAuditSummarySeverityEnumSerializer();

class _$AdminAuditSummarySeverityEnumSerializer
    implements PrimitiveSerializer<AdminAuditSummarySeverityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'info': 'info',
    'warning': 'warning',
    'critical': 'critical',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'info': 'info',
    'warning': 'warning',
    'critical': 'critical',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminAuditSummarySeverityEnum];
  @override
  final String wireName = 'AdminAuditSummarySeverityEnum';

  @override
  Object serialize(
          Serializers serializers, AdminAuditSummarySeverityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminAuditSummarySeverityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminAuditSummarySeverityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminAuditSummary extends AdminAuditSummary {
  @override
  final String id;
  @override
  final String action;
  @override
  final String summary;
  @override
  final String entityType;
  @override
  final String entityId;
  @override
  final String actorName;
  @override
  final DateTime createdAt;
  @override
  final AdminAuditSummarySeverityEnum severity;

  factory _$AdminAuditSummary(
          [void Function(AdminAuditSummaryBuilder)? updates]) =>
      (AdminAuditSummaryBuilder()..update(updates))._build();

  _$AdminAuditSummary._(
      {required this.id,
      required this.action,
      required this.summary,
      required this.entityType,
      required this.entityId,
      required this.actorName,
      required this.createdAt,
      required this.severity})
      : super._();
  @override
  AdminAuditSummary rebuild(void Function(AdminAuditSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAuditSummaryBuilder toBuilder() =>
      AdminAuditSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAuditSummary &&
        id == other.id &&
        action == other.action &&
        summary == other.summary &&
        entityType == other.entityType &&
        entityId == other.entityId &&
        actorName == other.actorName &&
        createdAt == other.createdAt &&
        severity == other.severity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, entityType.hashCode);
    _$hash = $jc(_$hash, entityId.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, severity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminAuditSummary')
          ..add('id', id)
          ..add('action', action)
          ..add('summary', summary)
          ..add('entityType', entityType)
          ..add('entityId', entityId)
          ..add('actorName', actorName)
          ..add('createdAt', createdAt)
          ..add('severity', severity))
        .toString();
  }
}

class AdminAuditSummaryBuilder
    implements Builder<AdminAuditSummary, AdminAuditSummaryBuilder> {
  _$AdminAuditSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _action;
  String? get action => _$this._action;
  set action(String? action) => _$this._action = action;

  String? _summary;
  String? get summary => _$this._summary;
  set summary(String? summary) => _$this._summary = summary;

  String? _entityType;
  String? get entityType => _$this._entityType;
  set entityType(String? entityType) => _$this._entityType = entityType;

  String? _entityId;
  String? get entityId => _$this._entityId;
  set entityId(String? entityId) => _$this._entityId = entityId;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminAuditSummarySeverityEnum? _severity;
  AdminAuditSummarySeverityEnum? get severity => _$this._severity;
  set severity(AdminAuditSummarySeverityEnum? severity) =>
      _$this._severity = severity;

  AdminAuditSummaryBuilder() {
    AdminAuditSummary._defaults(this);
  }

  AdminAuditSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _action = $v.action;
      _summary = $v.summary;
      _entityType = $v.entityType;
      _entityId = $v.entityId;
      _actorName = $v.actorName;
      _createdAt = $v.createdAt;
      _severity = $v.severity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAuditSummary other) {
    _$v = other as _$AdminAuditSummary;
  }

  @override
  void update(void Function(AdminAuditSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAuditSummary build() => _build();

  _$AdminAuditSummary _build() {
    final _$result = _$v ??
        _$AdminAuditSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminAuditSummary', 'id'),
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'AdminAuditSummary', 'action'),
          summary: BuiltValueNullFieldError.checkNotNull(
              summary, r'AdminAuditSummary', 'summary'),
          entityType: BuiltValueNullFieldError.checkNotNull(
              entityType, r'AdminAuditSummary', 'entityType'),
          entityId: BuiltValueNullFieldError.checkNotNull(
              entityId, r'AdminAuditSummary', 'entityId'),
          actorName: BuiltValueNullFieldError.checkNotNull(
              actorName, r'AdminAuditSummary', 'actorName'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminAuditSummary', 'createdAt'),
          severity: BuiltValueNullFieldError.checkNotNull(
              severity, r'AdminAuditSummary', 'severity'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
