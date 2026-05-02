// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_booking_status_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProBookingStatusUpdateStatusEnum
    _$proBookingStatusUpdateStatusEnum_pending =
    const ProBookingStatusUpdateStatusEnum._('pending');
const ProBookingStatusUpdateStatusEnum
    _$proBookingStatusUpdateStatusEnum_confirmed =
    const ProBookingStatusUpdateStatusEnum._('confirmed');
const ProBookingStatusUpdateStatusEnum
    _$proBookingStatusUpdateStatusEnum_inProgress =
    const ProBookingStatusUpdateStatusEnum._('inProgress');
const ProBookingStatusUpdateStatusEnum
    _$proBookingStatusUpdateStatusEnum_completed =
    const ProBookingStatusUpdateStatusEnum._('completed');
const ProBookingStatusUpdateStatusEnum
    _$proBookingStatusUpdateStatusEnum_cancelled =
    const ProBookingStatusUpdateStatusEnum._('cancelled');

ProBookingStatusUpdateStatusEnum _$proBookingStatusUpdateStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'pending':
      return _$proBookingStatusUpdateStatusEnum_pending;
    case 'confirmed':
      return _$proBookingStatusUpdateStatusEnum_confirmed;
    case 'inProgress':
      return _$proBookingStatusUpdateStatusEnum_inProgress;
    case 'completed':
      return _$proBookingStatusUpdateStatusEnum_completed;
    case 'cancelled':
      return _$proBookingStatusUpdateStatusEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProBookingStatusUpdateStatusEnum>
    _$proBookingStatusUpdateStatusEnumValues = BuiltSet<
        ProBookingStatusUpdateStatusEnum>(const <ProBookingStatusUpdateStatusEnum>[
  _$proBookingStatusUpdateStatusEnum_pending,
  _$proBookingStatusUpdateStatusEnum_confirmed,
  _$proBookingStatusUpdateStatusEnum_inProgress,
  _$proBookingStatusUpdateStatusEnum_completed,
  _$proBookingStatusUpdateStatusEnum_cancelled,
]);

Serializer<ProBookingStatusUpdateStatusEnum>
    _$proBookingStatusUpdateStatusEnumSerializer =
    _$ProBookingStatusUpdateStatusEnumSerializer();

class _$ProBookingStatusUpdateStatusEnumSerializer
    implements PrimitiveSerializer<ProBookingStatusUpdateStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'confirmed': 'confirmed',
    'inProgress': 'in_progress',
    'completed': 'completed',
    'cancelled': 'cancelled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'confirmed': 'confirmed',
    'in_progress': 'inProgress',
    'completed': 'completed',
    'cancelled': 'cancelled',
  };

  @override
  final Iterable<Type> types = const <Type>[ProBookingStatusUpdateStatusEnum];
  @override
  final String wireName = 'ProBookingStatusUpdateStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ProBookingStatusUpdateStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProBookingStatusUpdateStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProBookingStatusUpdateStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProBookingStatusUpdate extends ProBookingStatusUpdate {
  @override
  final ProBookingStatusUpdateStatusEnum status;

  factory _$ProBookingStatusUpdate(
          [void Function(ProBookingStatusUpdateBuilder)? updates]) =>
      (ProBookingStatusUpdateBuilder()..update(updates))._build();

  _$ProBookingStatusUpdate._({required this.status}) : super._();
  @override
  ProBookingStatusUpdate rebuild(
          void Function(ProBookingStatusUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProBookingStatusUpdateBuilder toBuilder() =>
      ProBookingStatusUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProBookingStatusUpdate && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProBookingStatusUpdate')
          ..add('status', status))
        .toString();
  }
}

class ProBookingStatusUpdateBuilder
    implements Builder<ProBookingStatusUpdate, ProBookingStatusUpdateBuilder> {
  _$ProBookingStatusUpdate? _$v;

  ProBookingStatusUpdateStatusEnum? _status;
  ProBookingStatusUpdateStatusEnum? get status => _$this._status;
  set status(ProBookingStatusUpdateStatusEnum? status) =>
      _$this._status = status;

  ProBookingStatusUpdateBuilder() {
    ProBookingStatusUpdate._defaults(this);
  }

  ProBookingStatusUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProBookingStatusUpdate other) {
    _$v = other as _$ProBookingStatusUpdate;
  }

  @override
  void update(void Function(ProBookingStatusUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProBookingStatusUpdate build() => _build();

  _$ProBookingStatusUpdate _build() {
    final _$result = _$v ??
        _$ProBookingStatusUpdate._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ProBookingStatusUpdate', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
