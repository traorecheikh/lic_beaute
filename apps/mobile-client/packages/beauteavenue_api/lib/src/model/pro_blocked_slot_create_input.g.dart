// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_blocked_slot_create_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProBlockedSlotCreateInputScopeEnum
    _$proBlockedSlotCreateInputScopeEnum_salon =
    const ProBlockedSlotCreateInputScopeEnum._('salon');
const ProBlockedSlotCreateInputScopeEnum
    _$proBlockedSlotCreateInputScopeEnum_employee =
    const ProBlockedSlotCreateInputScopeEnum._('employee');

ProBlockedSlotCreateInputScopeEnum _$proBlockedSlotCreateInputScopeEnumValueOf(
    String name) {
  switch (name) {
    case 'salon':
      return _$proBlockedSlotCreateInputScopeEnum_salon;
    case 'employee':
      return _$proBlockedSlotCreateInputScopeEnum_employee;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProBlockedSlotCreateInputScopeEnum>
    _$proBlockedSlotCreateInputScopeEnumValues = BuiltSet<
        ProBlockedSlotCreateInputScopeEnum>(const <ProBlockedSlotCreateInputScopeEnum>[
  _$proBlockedSlotCreateInputScopeEnum_salon,
  _$proBlockedSlotCreateInputScopeEnum_employee,
]);

Serializer<ProBlockedSlotCreateInputScopeEnum>
    _$proBlockedSlotCreateInputScopeEnumSerializer =
    _$ProBlockedSlotCreateInputScopeEnumSerializer();

class _$ProBlockedSlotCreateInputScopeEnumSerializer
    implements PrimitiveSerializer<ProBlockedSlotCreateInputScopeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'salon': 'salon',
    'employee': 'employee',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'salon': 'salon',
    'employee': 'employee',
  };

  @override
  final Iterable<Type> types = const <Type>[ProBlockedSlotCreateInputScopeEnum];
  @override
  final String wireName = 'ProBlockedSlotCreateInputScopeEnum';

  @override
  Object serialize(
          Serializers serializers, ProBlockedSlotCreateInputScopeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProBlockedSlotCreateInputScopeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProBlockedSlotCreateInputScopeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProBlockedSlotCreateInput extends ProBlockedSlotCreateInput {
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;
  @override
  final String? reason;
  @override
  final ProBlockedSlotCreateInputScopeEnum? scope;
  @override
  final String? employeeId;

  factory _$ProBlockedSlotCreateInput(
          [void Function(ProBlockedSlotCreateInputBuilder)? updates]) =>
      (ProBlockedSlotCreateInputBuilder()..update(updates))._build();

  _$ProBlockedSlotCreateInput._(
      {required this.startsAt,
      required this.endsAt,
      this.reason,
      this.scope,
      this.employeeId})
      : super._();
  @override
  ProBlockedSlotCreateInput rebuild(
          void Function(ProBlockedSlotCreateInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProBlockedSlotCreateInputBuilder toBuilder() =>
      ProBlockedSlotCreateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProBlockedSlotCreateInput &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt &&
        reason == other.reason &&
        scope == other.scope &&
        employeeId == other.employeeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
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
    return (newBuiltValueToStringHelper(r'ProBlockedSlotCreateInput')
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt)
          ..add('reason', reason)
          ..add('scope', scope)
          ..add('employeeId', employeeId))
        .toString();
  }
}

class ProBlockedSlotCreateInputBuilder
    implements
        Builder<ProBlockedSlotCreateInput, ProBlockedSlotCreateInputBuilder> {
  _$ProBlockedSlotCreateInput? _$v;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  ProBlockedSlotCreateInputScopeEnum? _scope;
  ProBlockedSlotCreateInputScopeEnum? get scope => _$this._scope;
  set scope(ProBlockedSlotCreateInputScopeEnum? scope) => _$this._scope = scope;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  ProBlockedSlotCreateInputBuilder() {
    ProBlockedSlotCreateInput._defaults(this);
  }

  ProBlockedSlotCreateInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
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
  void replace(ProBlockedSlotCreateInput other) {
    _$v = other as _$ProBlockedSlotCreateInput;
  }

  @override
  void update(void Function(ProBlockedSlotCreateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProBlockedSlotCreateInput build() => _build();

  _$ProBlockedSlotCreateInput _build() {
    final _$result = _$v ??
        _$ProBlockedSlotCreateInput._(
          startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt, r'ProBlockedSlotCreateInput', 'startsAt'),
          endsAt: BuiltValueNullFieldError.checkNotNull(
              endsAt, r'ProBlockedSlotCreateInput', 'endsAt'),
          reason: reason,
          scope: scope,
          employeeId: employeeId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
