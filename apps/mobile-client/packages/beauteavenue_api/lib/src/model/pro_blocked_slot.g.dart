// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_blocked_slot.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProBlockedSlotScopeEnum _$proBlockedSlotScopeEnum_salon =
    const ProBlockedSlotScopeEnum._('salon');
const ProBlockedSlotScopeEnum _$proBlockedSlotScopeEnum_employee =
    const ProBlockedSlotScopeEnum._('employee');

ProBlockedSlotScopeEnum _$proBlockedSlotScopeEnumValueOf(String name) {
  switch (name) {
    case 'salon':
      return _$proBlockedSlotScopeEnum_salon;
    case 'employee':
      return _$proBlockedSlotScopeEnum_employee;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProBlockedSlotScopeEnum> _$proBlockedSlotScopeEnumValues =
    BuiltSet<ProBlockedSlotScopeEnum>(const <ProBlockedSlotScopeEnum>[
  _$proBlockedSlotScopeEnum_salon,
  _$proBlockedSlotScopeEnum_employee,
]);

Serializer<ProBlockedSlotScopeEnum> _$proBlockedSlotScopeEnumSerializer =
    _$ProBlockedSlotScopeEnumSerializer();

class _$ProBlockedSlotScopeEnumSerializer
    implements PrimitiveSerializer<ProBlockedSlotScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'salon': 'salon',
    'employee': 'employee',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'salon': 'salon',
    'employee': 'employee',
  };

  @override
  final Iterable<Type> types = const <Type>[ProBlockedSlotScopeEnum];
  @override
  final String wireName = 'ProBlockedSlotScopeEnum';

  @override
  Object serialize(Serializers serializers, ProBlockedSlotScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProBlockedSlotScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProBlockedSlotScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProBlockedSlot extends ProBlockedSlot {
  @override
  final String id;
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;
  @override
  final String? reason;
  @override
  final ProBlockedSlotScopeEnum scope;
  @override
  final String? employeeId;

  factory _$ProBlockedSlot([void Function(ProBlockedSlotBuilder)? updates]) =>
      (ProBlockedSlotBuilder()..update(updates))._build();

  _$ProBlockedSlot._(
      {required this.id,
      required this.startsAt,
      required this.endsAt,
      this.reason,
      required this.scope,
      this.employeeId})
      : super._();
  @override
  ProBlockedSlot rebuild(void Function(ProBlockedSlotBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProBlockedSlotBuilder toBuilder() => ProBlockedSlotBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProBlockedSlot &&
        id == other.id &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt &&
        reason == other.reason &&
        scope == other.scope &&
        employeeId == other.employeeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, scope.hashCode);
    _$hash = $jc(_$hash, employeeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProBlockedSlot')
          ..add('id', id)
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt)
          ..add('reason', reason)
          ..add('scope', scope)
          ..add('employeeId', employeeId))
        .toString();
  }
}

class ProBlockedSlotBuilder
    implements Builder<ProBlockedSlot, ProBlockedSlotBuilder> {
  _$ProBlockedSlot? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ProBlockedSlotScopeEnum? _scope;
  ProBlockedSlotScopeEnum? get scope => _$this._scope;
  set scope(ProBlockedSlotScopeEnum? scope) => _$this._scope = scope;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  ProBlockedSlotBuilder() {
    ProBlockedSlot._defaults(this);
  }

  ProBlockedSlotBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _reason = $v.reason;
      _scope = $v.scope;
      _employeeId = $v.employeeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProBlockedSlot other) {
    _$v = other as _$ProBlockedSlot;
  }

  @override
  void update(void Function(ProBlockedSlotBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProBlockedSlot build() => _build();

  _$ProBlockedSlot _build() {
    final _$result = _$v ??
        _$ProBlockedSlot._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ProBlockedSlot', 'id'),
          startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt, r'ProBlockedSlot', 'startsAt'),
          endsAt: BuiltValueNullFieldError.checkNotNull(
              endsAt, r'ProBlockedSlot', 'endsAt'),
          reason: reason,
          scope: BuiltValueNullFieldError.checkNotNull(
              scope, r'ProBlockedSlot', 'scope'),
          employeeId: employeeId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
