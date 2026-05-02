// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_booking_full_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProBookingFullDetailStatusEnum _$proBookingFullDetailStatusEnum_pending =
    const ProBookingFullDetailStatusEnum._('pending');
const ProBookingFullDetailStatusEnum
    _$proBookingFullDetailStatusEnum_confirmed =
    const ProBookingFullDetailStatusEnum._('confirmed');
const ProBookingFullDetailStatusEnum
    _$proBookingFullDetailStatusEnum_inProgress =
    const ProBookingFullDetailStatusEnum._('inProgress');
const ProBookingFullDetailStatusEnum
    _$proBookingFullDetailStatusEnum_completed =
    const ProBookingFullDetailStatusEnum._('completed');
const ProBookingFullDetailStatusEnum
    _$proBookingFullDetailStatusEnum_cancelled =
    const ProBookingFullDetailStatusEnum._('cancelled');

ProBookingFullDetailStatusEnum _$proBookingFullDetailStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'pending':
      return _$proBookingFullDetailStatusEnum_pending;
    case 'confirmed':
      return _$proBookingFullDetailStatusEnum_confirmed;
    case 'inProgress':
      return _$proBookingFullDetailStatusEnum_inProgress;
    case 'completed':
      return _$proBookingFullDetailStatusEnum_completed;
    case 'cancelled':
      return _$proBookingFullDetailStatusEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProBookingFullDetailStatusEnum>
    _$proBookingFullDetailStatusEnumValues = BuiltSet<
        ProBookingFullDetailStatusEnum>(const <ProBookingFullDetailStatusEnum>[
  _$proBookingFullDetailStatusEnum_pending,
  _$proBookingFullDetailStatusEnum_confirmed,
  _$proBookingFullDetailStatusEnum_inProgress,
  _$proBookingFullDetailStatusEnum_completed,
  _$proBookingFullDetailStatusEnum_cancelled,
]);

Serializer<ProBookingFullDetailStatusEnum>
    _$proBookingFullDetailStatusEnumSerializer =
    _$ProBookingFullDetailStatusEnumSerializer();

class _$ProBookingFullDetailStatusEnumSerializer
    implements PrimitiveSerializer<ProBookingFullDetailStatusEnum> {
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
  final Iterable<Type> types = const <Type>[ProBookingFullDetailStatusEnum];
  @override
  final String wireName = 'ProBookingFullDetailStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ProBookingFullDetailStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProBookingFullDetailStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProBookingFullDetailStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProBookingFullDetail extends ProBookingFullDetail {
  @override
  final String id;
  @override
  final String salonId;
  @override
  final String serviceId;
  @override
  final String serviceName;
  @override
  final String? employeeId;
  @override
  final String? employeeName;
  @override
  final String? clientId;
  @override
  final String? clientName;
  @override
  final String? clientPhone;
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;
  @override
  final ProBookingFullDetailStatusEnum status;
  @override
  final String source_;
  @override
  final num depositAmountXof;
  @override
  final DateTime createdAt;
  @override
  final BuiltList<ProBookingFullDetailPaymentsInner> payments;
  @override
  final BuiltList<ProBookingFullDetailEventsInner> events;

  factory _$ProBookingFullDetail(
          [void Function(ProBookingFullDetailBuilder)? updates]) =>
      (ProBookingFullDetailBuilder()..update(updates))._build();

  _$ProBookingFullDetail._(
      {required this.id,
      required this.salonId,
      required this.serviceId,
      required this.serviceName,
      this.employeeId,
      this.employeeName,
      this.clientId,
      this.clientName,
      this.clientPhone,
      required this.startsAt,
      required this.endsAt,
      required this.status,
      required this.source_,
      required this.depositAmountXof,
      required this.createdAt,
      required this.payments,
      required this.events})
      : super._();
  @override
  ProBookingFullDetail rebuild(
          void Function(ProBookingFullDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProBookingFullDetailBuilder toBuilder() =>
      ProBookingFullDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProBookingFullDetail &&
        id == other.id &&
        salonId == other.salonId &&
        serviceId == other.serviceId &&
        serviceName == other.serviceName &&
        employeeId == other.employeeId &&
        employeeName == other.employeeName &&
        clientId == other.clientId &&
        clientName == other.clientName &&
        clientPhone == other.clientPhone &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt &&
        status == other.status &&
        source_ == other.source_ &&
        depositAmountXof == other.depositAmountXof &&
        createdAt == other.createdAt &&
        payments == other.payments &&
        events == other.events;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jc(_$hash, serviceId.hashCode);
    _$hash = $jc(_$hash, serviceName.hashCode);
    _$hash = $jc(_$hash, employeeId.hashCode);
    _$hash = $jc(_$hash, employeeName.hashCode);
    _$hash = $jc(_$hash, clientId.hashCode);
    _$hash = $jc(_$hash, clientName.hashCode);
    _$hash = $jc(_$hash, clientPhone.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, depositAmountXof.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, payments.hashCode);
    _$hash = $jc(_$hash, events.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProBookingFullDetail')
          ..add('id', id)
          ..add('salonId', salonId)
          ..add('serviceId', serviceId)
          ..add('serviceName', serviceName)
          ..add('employeeId', employeeId)
          ..add('employeeName', employeeName)
          ..add('clientId', clientId)
          ..add('clientName', clientName)
          ..add('clientPhone', clientPhone)
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt)
          ..add('status', status)
          ..add('source_', source_)
          ..add('depositAmountXof', depositAmountXof)
          ..add('createdAt', createdAt)
          ..add('payments', payments)
          ..add('events', events))
        .toString();
  }
}

class ProBookingFullDetailBuilder
    implements Builder<ProBookingFullDetail, ProBookingFullDetailBuilder> {
  _$ProBookingFullDetail? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _serviceId;
  String? get serviceId => _$this._serviceId;
  set serviceId(String? serviceId) => _$this._serviceId = serviceId;

  String? _serviceName;
  String? get serviceName => _$this._serviceName;
  set serviceName(String? serviceName) => _$this._serviceName = serviceName;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  String? _employeeName;
  String? get employeeName => _$this._employeeName;
  set employeeName(String? employeeName) => _$this._employeeName = employeeName;

  String? _clientId;
  String? get clientId => _$this._clientId;
  set clientId(String? clientId) => _$this._clientId = clientId;

  String? _clientName;
  String? get clientName => _$this._clientName;
  set clientName(String? clientName) => _$this._clientName = clientName;

  String? _clientPhone;
  String? get clientPhone => _$this._clientPhone;
  set clientPhone(String? clientPhone) => _$this._clientPhone = clientPhone;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  ProBookingFullDetailStatusEnum? _status;
  ProBookingFullDetailStatusEnum? get status => _$this._status;
  set status(ProBookingFullDetailStatusEnum? status) => _$this._status = status;

  String? _source_;
  String? get source_ => _$this._source_;
  set source_(String? source_) => _$this._source_ = source_;

  num? _depositAmountXof;
  num? get depositAmountXof => _$this._depositAmountXof;
  set depositAmountXof(num? depositAmountXof) =>
      _$this._depositAmountXof = depositAmountXof;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ListBuilder<ProBookingFullDetailPaymentsInner>? _payments;
  ListBuilder<ProBookingFullDetailPaymentsInner> get payments =>
      _$this._payments ??= ListBuilder<ProBookingFullDetailPaymentsInner>();
  set payments(ListBuilder<ProBookingFullDetailPaymentsInner>? payments) =>
      _$this._payments = payments;

  ListBuilder<ProBookingFullDetailEventsInner>? _events;
  ListBuilder<ProBookingFullDetailEventsInner> get events =>
      _$this._events ??= ListBuilder<ProBookingFullDetailEventsInner>();
  set events(ListBuilder<ProBookingFullDetailEventsInner>? events) =>
      _$this._events = events;

  ProBookingFullDetailBuilder() {
    ProBookingFullDetail._defaults(this);
  }

  ProBookingFullDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _salonId = $v.salonId;
      _serviceId = $v.serviceId;
      _serviceName = $v.serviceName;
      _employeeId = $v.employeeId;
      _employeeName = $v.employeeName;
      _clientId = $v.clientId;
      _clientName = $v.clientName;
      _clientPhone = $v.clientPhone;
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _status = $v.status;
      _source_ = $v.source_;
      _depositAmountXof = $v.depositAmountXof;
      _createdAt = $v.createdAt;
      _payments = $v.payments.toBuilder();
      _events = $v.events.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProBookingFullDetail other) {
    _$v = other as _$ProBookingFullDetail;
  }

  @override
  void update(void Function(ProBookingFullDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProBookingFullDetail build() => _build();

  _$ProBookingFullDetail _build() {
    _$ProBookingFullDetail _$result;
    try {
      _$result = _$v ??
          _$ProBookingFullDetail._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProBookingFullDetail', 'id'),
            salonId: BuiltValueNullFieldError.checkNotNull(
                salonId, r'ProBookingFullDetail', 'salonId'),
            serviceId: BuiltValueNullFieldError.checkNotNull(
                serviceId, r'ProBookingFullDetail', 'serviceId'),
            serviceName: BuiltValueNullFieldError.checkNotNull(
                serviceName, r'ProBookingFullDetail', 'serviceName'),
            employeeId: employeeId,
            employeeName: employeeName,
            clientId: clientId,
            clientName: clientName,
            clientPhone: clientPhone,
            startsAt: BuiltValueNullFieldError.checkNotNull(
                startsAt, r'ProBookingFullDetail', 'startsAt'),
            endsAt: BuiltValueNullFieldError.checkNotNull(
                endsAt, r'ProBookingFullDetail', 'endsAt'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ProBookingFullDetail', 'status'),
            source_: BuiltValueNullFieldError.checkNotNull(
                source_, r'ProBookingFullDetail', 'source_'),
            depositAmountXof: BuiltValueNullFieldError.checkNotNull(
                depositAmountXof, r'ProBookingFullDetail', 'depositAmountXof'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'ProBookingFullDetail', 'createdAt'),
            payments: payments.build(),
            events: events.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'payments';
        payments.build();
        _$failedField = 'events';
        events.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProBookingFullDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
