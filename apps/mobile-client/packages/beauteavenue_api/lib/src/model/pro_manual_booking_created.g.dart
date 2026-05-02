// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_manual_booking_created.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProManualBookingCreatedStatusEnum
    _$proManualBookingCreatedStatusEnum_pending =
    const ProManualBookingCreatedStatusEnum._('pending');
const ProManualBookingCreatedStatusEnum
    _$proManualBookingCreatedStatusEnum_confirmed =
    const ProManualBookingCreatedStatusEnum._('confirmed');
const ProManualBookingCreatedStatusEnum
    _$proManualBookingCreatedStatusEnum_inProgress =
    const ProManualBookingCreatedStatusEnum._('inProgress');
const ProManualBookingCreatedStatusEnum
    _$proManualBookingCreatedStatusEnum_completed =
    const ProManualBookingCreatedStatusEnum._('completed');
const ProManualBookingCreatedStatusEnum
    _$proManualBookingCreatedStatusEnum_cancelled =
    const ProManualBookingCreatedStatusEnum._('cancelled');

ProManualBookingCreatedStatusEnum _$proManualBookingCreatedStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'pending':
      return _$proManualBookingCreatedStatusEnum_pending;
    case 'confirmed':
      return _$proManualBookingCreatedStatusEnum_confirmed;
    case 'inProgress':
      return _$proManualBookingCreatedStatusEnum_inProgress;
    case 'completed':
      return _$proManualBookingCreatedStatusEnum_completed;
    case 'cancelled':
      return _$proManualBookingCreatedStatusEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProManualBookingCreatedStatusEnum>
    _$proManualBookingCreatedStatusEnumValues = BuiltSet<
        ProManualBookingCreatedStatusEnum>(const <ProManualBookingCreatedStatusEnum>[
  _$proManualBookingCreatedStatusEnum_pending,
  _$proManualBookingCreatedStatusEnum_confirmed,
  _$proManualBookingCreatedStatusEnum_inProgress,
  _$proManualBookingCreatedStatusEnum_completed,
  _$proManualBookingCreatedStatusEnum_cancelled,
]);

Serializer<ProManualBookingCreatedStatusEnum>
    _$proManualBookingCreatedStatusEnumSerializer =
    _$ProManualBookingCreatedStatusEnumSerializer();

class _$ProManualBookingCreatedStatusEnumSerializer
    implements PrimitiveSerializer<ProManualBookingCreatedStatusEnum> {
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
  final Iterable<Type> types = const <Type>[ProManualBookingCreatedStatusEnum];
  @override
  final String wireName = 'ProManualBookingCreatedStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ProManualBookingCreatedStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProManualBookingCreatedStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProManualBookingCreatedStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProManualBookingCreated extends ProManualBookingCreated {
  @override
  final String id;
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;
  @override
  final ProManualBookingCreatedStatusEnum status;
  @override
  final String source_;

  factory _$ProManualBookingCreated(
          [void Function(ProManualBookingCreatedBuilder)? updates]) =>
      (ProManualBookingCreatedBuilder()..update(updates))._build();

  _$ProManualBookingCreated._(
      {required this.id,
      required this.startsAt,
      required this.endsAt,
      required this.status,
      required this.source_})
      : super._();
  @override
  ProManualBookingCreated rebuild(
          void Function(ProManualBookingCreatedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProManualBookingCreatedBuilder toBuilder() =>
      ProManualBookingCreatedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProManualBookingCreated &&
        id == other.id &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt &&
        status == other.status &&
        source_ == other.source_;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProManualBookingCreated')
          ..add('id', id)
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt)
          ..add('status', status)
          ..add('source_', source_))
        .toString();
  }
}

class ProManualBookingCreatedBuilder
    implements
        Builder<ProManualBookingCreated, ProManualBookingCreatedBuilder> {
  _$ProManualBookingCreated? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  ProManualBookingCreatedStatusEnum? _status;
  ProManualBookingCreatedStatusEnum? get status => _$this._status;
  set status(ProManualBookingCreatedStatusEnum? status) =>
      _$this._status = status;

  String? _source_;
  String? get source_ => _$this._source_;
  set source_(String? source_) => _$this._source_ = source_;

  ProManualBookingCreatedBuilder() {
    ProManualBookingCreated._defaults(this);
  }

  ProManualBookingCreatedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _status = $v.status;
      _source_ = $v.source_;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProManualBookingCreated other) {
    _$v = other as _$ProManualBookingCreated;
  }

  @override
  void update(void Function(ProManualBookingCreatedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProManualBookingCreated build() => _build();

  _$ProManualBookingCreated _build() {
    final _$result = _$v ??
        _$ProManualBookingCreated._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ProManualBookingCreated', 'id'),
          startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt, r'ProManualBookingCreated', 'startsAt'),
          endsAt: BuiltValueNullFieldError.checkNotNull(
              endsAt, r'ProManualBookingCreated', 'endsAt'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ProManualBookingCreated', 'status'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'ProManualBookingCreated', 'source_'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
