// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_client_detail_recent_bookings_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProClientDetailRecentBookingsInnerStatusEnum
    _$proClientDetailRecentBookingsInnerStatusEnum_pending =
    const ProClientDetailRecentBookingsInnerStatusEnum._('pending');
const ProClientDetailRecentBookingsInnerStatusEnum
    _$proClientDetailRecentBookingsInnerStatusEnum_confirmed =
    const ProClientDetailRecentBookingsInnerStatusEnum._('confirmed');
const ProClientDetailRecentBookingsInnerStatusEnum
    _$proClientDetailRecentBookingsInnerStatusEnum_inProgress =
    const ProClientDetailRecentBookingsInnerStatusEnum._('inProgress');
const ProClientDetailRecentBookingsInnerStatusEnum
    _$proClientDetailRecentBookingsInnerStatusEnum_completed =
    const ProClientDetailRecentBookingsInnerStatusEnum._('completed');
const ProClientDetailRecentBookingsInnerStatusEnum
    _$proClientDetailRecentBookingsInnerStatusEnum_cancelled =
    const ProClientDetailRecentBookingsInnerStatusEnum._('cancelled');

ProClientDetailRecentBookingsInnerStatusEnum
    _$proClientDetailRecentBookingsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'pending':
      return _$proClientDetailRecentBookingsInnerStatusEnum_pending;
    case 'confirmed':
      return _$proClientDetailRecentBookingsInnerStatusEnum_confirmed;
    case 'inProgress':
      return _$proClientDetailRecentBookingsInnerStatusEnum_inProgress;
    case 'completed':
      return _$proClientDetailRecentBookingsInnerStatusEnum_completed;
    case 'cancelled':
      return _$proClientDetailRecentBookingsInnerStatusEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProClientDetailRecentBookingsInnerStatusEnum>
    _$proClientDetailRecentBookingsInnerStatusEnumValues = BuiltSet<
        ProClientDetailRecentBookingsInnerStatusEnum>(const <ProClientDetailRecentBookingsInnerStatusEnum>[
  _$proClientDetailRecentBookingsInnerStatusEnum_pending,
  _$proClientDetailRecentBookingsInnerStatusEnum_confirmed,
  _$proClientDetailRecentBookingsInnerStatusEnum_inProgress,
  _$proClientDetailRecentBookingsInnerStatusEnum_completed,
  _$proClientDetailRecentBookingsInnerStatusEnum_cancelled,
]);

Serializer<ProClientDetailRecentBookingsInnerStatusEnum>
    _$proClientDetailRecentBookingsInnerStatusEnumSerializer =
    _$ProClientDetailRecentBookingsInnerStatusEnumSerializer();

class _$ProClientDetailRecentBookingsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<ProClientDetailRecentBookingsInnerStatusEnum> {
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
  final Iterable<Type> types = const <Type>[
    ProClientDetailRecentBookingsInnerStatusEnum
  ];
  @override
  final String wireName = 'ProClientDetailRecentBookingsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          ProClientDetailRecentBookingsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProClientDetailRecentBookingsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProClientDetailRecentBookingsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProClientDetailRecentBookingsInner
    extends ProClientDetailRecentBookingsInner {
  @override
  final String bookingId;
  @override
  final DateTime startsAt;
  @override
  final String serviceName;
  @override
  final int amountXof;
  @override
  final ProClientDetailRecentBookingsInnerStatusEnum status;

  factory _$ProClientDetailRecentBookingsInner(
          [void Function(ProClientDetailRecentBookingsInnerBuilder)?
              updates]) =>
      (ProClientDetailRecentBookingsInnerBuilder()..update(updates))._build();

  _$ProClientDetailRecentBookingsInner._(
      {required this.bookingId,
      required this.startsAt,
      required this.serviceName,
      required this.amountXof,
      required this.status})
      : super._();
  @override
  ProClientDetailRecentBookingsInner rebuild(
          void Function(ProClientDetailRecentBookingsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProClientDetailRecentBookingsInnerBuilder toBuilder() =>
      ProClientDetailRecentBookingsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProClientDetailRecentBookingsInner &&
        bookingId == other.bookingId &&
        startsAt == other.startsAt &&
        serviceName == other.serviceName &&
        amountXof == other.amountXof &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, serviceName.hashCode);
    _$hash = $jc(_$hash, amountXof.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProClientDetailRecentBookingsInner')
          ..add('bookingId', bookingId)
          ..add('startsAt', startsAt)
          ..add('serviceName', serviceName)
          ..add('amountXof', amountXof)
          ..add('status', status))
        .toString();
  }
}

class ProClientDetailRecentBookingsInnerBuilder
    implements
        Builder<ProClientDetailRecentBookingsInner,
            ProClientDetailRecentBookingsInnerBuilder> {
  _$ProClientDetailRecentBookingsInner? _$v;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  String? _serviceName;
  String? get serviceName => _$this._serviceName;
  set serviceName(String? serviceName) => _$this._serviceName = serviceName;

  int? _amountXof;
  int? get amountXof => _$this._amountXof;
  set amountXof(int? amountXof) => _$this._amountXof = amountXof;

  ProClientDetailRecentBookingsInnerStatusEnum? _status;
  ProClientDetailRecentBookingsInnerStatusEnum? get status => _$this._status;
  set status(ProClientDetailRecentBookingsInnerStatusEnum? status) =>
      _$this._status = status;

  ProClientDetailRecentBookingsInnerBuilder() {
    ProClientDetailRecentBookingsInner._defaults(this);
  }

  ProClientDetailRecentBookingsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingId = $v.bookingId;
      _startsAt = $v.startsAt;
      _serviceName = $v.serviceName;
      _amountXof = $v.amountXof;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProClientDetailRecentBookingsInner other) {
    _$v = other as _$ProClientDetailRecentBookingsInner;
  }

  @override
  void update(
      void Function(ProClientDetailRecentBookingsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProClientDetailRecentBookingsInner build() => _build();

  _$ProClientDetailRecentBookingsInner _build() {
    final _$result = _$v ??
        _$ProClientDetailRecentBookingsInner._(
          bookingId: BuiltValueNullFieldError.checkNotNull(
              bookingId, r'ProClientDetailRecentBookingsInner', 'bookingId'),
          startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt, r'ProClientDetailRecentBookingsInner', 'startsAt'),
          serviceName: BuiltValueNullFieldError.checkNotNull(serviceName,
              r'ProClientDetailRecentBookingsInner', 'serviceName'),
          amountXof: BuiltValueNullFieldError.checkNotNull(
              amountXof, r'ProClientDetailRecentBookingsInner', 'amountXof'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ProClientDetailRecentBookingsInner', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
