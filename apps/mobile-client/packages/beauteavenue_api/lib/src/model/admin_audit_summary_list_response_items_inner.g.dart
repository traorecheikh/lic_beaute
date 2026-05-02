// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_summary_list_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminAuditSummaryListResponseItemsInnerSeverityEnum
    _$adminAuditSummaryListResponseItemsInnerSeverityEnum_info =
    const AdminAuditSummaryListResponseItemsInnerSeverityEnum._('info');
const AdminAuditSummaryListResponseItemsInnerSeverityEnum
    _$adminAuditSummaryListResponseItemsInnerSeverityEnum_warning =
    const AdminAuditSummaryListResponseItemsInnerSeverityEnum._('warning');
const AdminAuditSummaryListResponseItemsInnerSeverityEnum
    _$adminAuditSummaryListResponseItemsInnerSeverityEnum_critical =
    const AdminAuditSummaryListResponseItemsInnerSeverityEnum._('critical');

AdminAuditSummaryListResponseItemsInnerSeverityEnum
    _$adminAuditSummaryListResponseItemsInnerSeverityEnumValueOf(String name) {
  switch (name) {
    case 'info':
      return _$adminAuditSummaryListResponseItemsInnerSeverityEnum_info;
    case 'warning':
      return _$adminAuditSummaryListResponseItemsInnerSeverityEnum_warning;
    case 'critical':
      return _$adminAuditSummaryListResponseItemsInnerSeverityEnum_critical;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminAuditSummaryListResponseItemsInnerSeverityEnum>
    _$adminAuditSummaryListResponseItemsInnerSeverityEnumValues = BuiltSet<
        AdminAuditSummaryListResponseItemsInnerSeverityEnum>(const <AdminAuditSummaryListResponseItemsInnerSeverityEnum>[
  _$adminAuditSummaryListResponseItemsInnerSeverityEnum_info,
  _$adminAuditSummaryListResponseItemsInnerSeverityEnum_warning,
  _$adminAuditSummaryListResponseItemsInnerSeverityEnum_critical,
]);

Serializer<AdminAuditSummaryListResponseItemsInnerSeverityEnum>
    _$adminAuditSummaryListResponseItemsInnerSeverityEnumSerializer =
    _$AdminAuditSummaryListResponseItemsInnerSeverityEnumSerializer();

class _$AdminAuditSummaryListResponseItemsInnerSeverityEnumSerializer
    implements
        PrimitiveSerializer<
            AdminAuditSummaryListResponseItemsInnerSeverityEnum> {
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
  final Iterable<Type> types = const <Type>[
    AdminAuditSummaryListResponseItemsInnerSeverityEnum
  ];
  @override
  final String wireName = 'AdminAuditSummaryListResponseItemsInnerSeverityEnum';

  @override
  Object serialize(Serializers serializers,
          AdminAuditSummaryListResponseItemsInnerSeverityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminAuditSummaryListResponseItemsInnerSeverityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminAuditSummaryListResponseItemsInnerSeverityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminAuditSummaryListResponseItemsInner
    extends AdminAuditSummaryListResponseItemsInner {
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
  final AdminAuditSummaryListResponseItemsInnerSeverityEnum severity;

  factory _$AdminAuditSummaryListResponseItemsInner(
          [void Function(AdminAuditSummaryListResponseItemsInnerBuilder)?
              updates]) =>
      (AdminAuditSummaryListResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$AdminAuditSummaryListResponseItemsInner._(
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
  AdminAuditSummaryListResponseItemsInner rebuild(
          void Function(AdminAuditSummaryListResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAuditSummaryListResponseItemsInnerBuilder toBuilder() =>
      AdminAuditSummaryListResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAuditSummaryListResponseItemsInner &&
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
    return (newBuiltValueToStringHelper(
            r'AdminAuditSummaryListResponseItemsInner')
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

class AdminAuditSummaryListResponseItemsInnerBuilder
    implements
        Builder<AdminAuditSummaryListResponseItemsInner,
            AdminAuditSummaryListResponseItemsInnerBuilder> {
  _$AdminAuditSummaryListResponseItemsInner? _$v;

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

  AdminAuditSummaryListResponseItemsInnerSeverityEnum? _severity;
  AdminAuditSummaryListResponseItemsInnerSeverityEnum? get severity =>
      _$this._severity;
  set severity(AdminAuditSummaryListResponseItemsInnerSeverityEnum? severity) =>
      _$this._severity = severity;

  AdminAuditSummaryListResponseItemsInnerBuilder() {
    AdminAuditSummaryListResponseItemsInner._defaults(this);
  }

  AdminAuditSummaryListResponseItemsInnerBuilder get _$this {
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
  void replace(AdminAuditSummaryListResponseItemsInner other) {
    _$v = other as _$AdminAuditSummaryListResponseItemsInner;
  }

  @override
  void update(
      void Function(AdminAuditSummaryListResponseItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAuditSummaryListResponseItemsInner build() => _build();

  _$AdminAuditSummaryListResponseItemsInner _build() {
    final _$result = _$v ??
        _$AdminAuditSummaryListResponseItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminAuditSummaryListResponseItemsInner', 'id'),
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'AdminAuditSummaryListResponseItemsInner', 'action'),
          summary: BuiltValueNullFieldError.checkNotNull(
              summary, r'AdminAuditSummaryListResponseItemsInner', 'summary'),
          entityType: BuiltValueNullFieldError.checkNotNull(entityType,
              r'AdminAuditSummaryListResponseItemsInner', 'entityType'),
          entityId: BuiltValueNullFieldError.checkNotNull(
              entityId, r'AdminAuditSummaryListResponseItemsInner', 'entityId'),
          actorName: BuiltValueNullFieldError.checkNotNull(actorName,
              r'AdminAuditSummaryListResponseItemsInner', 'actorName'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'AdminAuditSummaryListResponseItemsInner', 'createdAt'),
          severity: BuiltValueNullFieldError.checkNotNull(
              severity, r'AdminAuditSummaryListResponseItemsInner', 'severity'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
