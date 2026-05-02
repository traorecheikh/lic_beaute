// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminAuditDetailSeverityEnum _$adminAuditDetailSeverityEnum_info =
    const AdminAuditDetailSeverityEnum._('info');
const AdminAuditDetailSeverityEnum _$adminAuditDetailSeverityEnum_warning =
    const AdminAuditDetailSeverityEnum._('warning');
const AdminAuditDetailSeverityEnum _$adminAuditDetailSeverityEnum_critical =
    const AdminAuditDetailSeverityEnum._('critical');

AdminAuditDetailSeverityEnum _$adminAuditDetailSeverityEnumValueOf(
    String name) {
  switch (name) {
    case 'info':
      return _$adminAuditDetailSeverityEnum_info;
    case 'warning':
      return _$adminAuditDetailSeverityEnum_warning;
    case 'critical':
      return _$adminAuditDetailSeverityEnum_critical;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminAuditDetailSeverityEnum>
    _$adminAuditDetailSeverityEnumValues =
    BuiltSet<AdminAuditDetailSeverityEnum>(const <AdminAuditDetailSeverityEnum>[
  _$adminAuditDetailSeverityEnum_info,
  _$adminAuditDetailSeverityEnum_warning,
  _$adminAuditDetailSeverityEnum_critical,
]);

Serializer<AdminAuditDetailSeverityEnum>
    _$adminAuditDetailSeverityEnumSerializer =
    _$AdminAuditDetailSeverityEnumSerializer();

class _$AdminAuditDetailSeverityEnumSerializer
    implements PrimitiveSerializer<AdminAuditDetailSeverityEnum> {
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
  final Iterable<Type> types = const <Type>[AdminAuditDetailSeverityEnum];
  @override
  final String wireName = 'AdminAuditDetailSeverityEnum';

  @override
  Object serialize(Serializers serializers, AdminAuditDetailSeverityEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminAuditDetailSeverityEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminAuditDetailSeverityEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminAuditDetail extends AdminAuditDetail {
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
  final AdminAuditDetailSeverityEnum severity;
  @override
  final String payloadJson;
  @override
  final BuiltList<AdminAuditDetailRelatedLinksInner> relatedLinks;

  factory _$AdminAuditDetail(
          [void Function(AdminAuditDetailBuilder)? updates]) =>
      (AdminAuditDetailBuilder()..update(updates))._build();

  _$AdminAuditDetail._(
      {required this.id,
      required this.action,
      required this.summary,
      required this.entityType,
      required this.entityId,
      required this.actorName,
      required this.createdAt,
      required this.severity,
      required this.payloadJson,
      required this.relatedLinks})
      : super._();
  @override
  AdminAuditDetail rebuild(void Function(AdminAuditDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAuditDetailBuilder toBuilder() =>
      AdminAuditDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAuditDetail &&
        id == other.id &&
        action == other.action &&
        summary == other.summary &&
        entityType == other.entityType &&
        entityId == other.entityId &&
        actorName == other.actorName &&
        createdAt == other.createdAt &&
        severity == other.severity &&
        payloadJson == other.payloadJson &&
        relatedLinks == other.relatedLinks;
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
    _$hash = $jc(_$hash, payloadJson.hashCode);
    _$hash = $jc(_$hash, relatedLinks.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminAuditDetail')
          ..add('id', id)
          ..add('action', action)
          ..add('summary', summary)
          ..add('entityType', entityType)
          ..add('entityId', entityId)
          ..add('actorName', actorName)
          ..add('createdAt', createdAt)
          ..add('severity', severity)
          ..add('payloadJson', payloadJson)
          ..add('relatedLinks', relatedLinks))
        .toString();
  }
}

class AdminAuditDetailBuilder
    implements Builder<AdminAuditDetail, AdminAuditDetailBuilder> {
  _$AdminAuditDetail? _$v;

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

  AdminAuditDetailSeverityEnum? _severity;
  AdminAuditDetailSeverityEnum? get severity => _$this._severity;
  set severity(AdminAuditDetailSeverityEnum? severity) =>
      _$this._severity = severity;

  String? _payloadJson;
  String? get payloadJson => _$this._payloadJson;
  set payloadJson(String? payloadJson) => _$this._payloadJson = payloadJson;

  ListBuilder<AdminAuditDetailRelatedLinksInner>? _relatedLinks;
  ListBuilder<AdminAuditDetailRelatedLinksInner> get relatedLinks =>
      _$this._relatedLinks ??= ListBuilder<AdminAuditDetailRelatedLinksInner>();
  set relatedLinks(
          ListBuilder<AdminAuditDetailRelatedLinksInner>? relatedLinks) =>
      _$this._relatedLinks = relatedLinks;

  AdminAuditDetailBuilder() {
    AdminAuditDetail._defaults(this);
  }

  AdminAuditDetailBuilder get _$this {
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
      _payloadJson = $v.payloadJson;
      _relatedLinks = $v.relatedLinks.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAuditDetail other) {
    _$v = other as _$AdminAuditDetail;
  }

  @override
  void update(void Function(AdminAuditDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAuditDetail build() => _build();

  _$AdminAuditDetail _build() {
    _$AdminAuditDetail _$result;
    try {
      _$result = _$v ??
          _$AdminAuditDetail._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminAuditDetail', 'id'),
            action: BuiltValueNullFieldError.checkNotNull(
                action, r'AdminAuditDetail', 'action'),
            summary: BuiltValueNullFieldError.checkNotNull(
                summary, r'AdminAuditDetail', 'summary'),
            entityType: BuiltValueNullFieldError.checkNotNull(
                entityType, r'AdminAuditDetail', 'entityType'),
            entityId: BuiltValueNullFieldError.checkNotNull(
                entityId, r'AdminAuditDetail', 'entityId'),
            actorName: BuiltValueNullFieldError.checkNotNull(
                actorName, r'AdminAuditDetail', 'actorName'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'AdminAuditDetail', 'createdAt'),
            severity: BuiltValueNullFieldError.checkNotNull(
                severity, r'AdminAuditDetail', 'severity'),
            payloadJson: BuiltValueNullFieldError.checkNotNull(
                payloadJson, r'AdminAuditDetail', 'payloadJson'),
            relatedLinks: relatedLinks.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'relatedLinks';
        relatedLinks.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminAuditDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
