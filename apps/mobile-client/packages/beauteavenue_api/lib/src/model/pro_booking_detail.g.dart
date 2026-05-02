// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_booking_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProBookingDetailStatusEnum _$proBookingDetailStatusEnum_pending =
    const ProBookingDetailStatusEnum._('pending');
const ProBookingDetailStatusEnum _$proBookingDetailStatusEnum_confirmed =
    const ProBookingDetailStatusEnum._('confirmed');
const ProBookingDetailStatusEnum _$proBookingDetailStatusEnum_inProgress =
    const ProBookingDetailStatusEnum._('inProgress');
const ProBookingDetailStatusEnum _$proBookingDetailStatusEnum_completed =
    const ProBookingDetailStatusEnum._('completed');
const ProBookingDetailStatusEnum _$proBookingDetailStatusEnum_cancelled =
    const ProBookingDetailStatusEnum._('cancelled');

ProBookingDetailStatusEnum _$proBookingDetailStatusEnumValueOf(String name) {
  switch (name) {
    case 'pending':
      return _$proBookingDetailStatusEnum_pending;
    case 'confirmed':
      return _$proBookingDetailStatusEnum_confirmed;
    case 'inProgress':
      return _$proBookingDetailStatusEnum_inProgress;
    case 'completed':
      return _$proBookingDetailStatusEnum_completed;
    case 'cancelled':
      return _$proBookingDetailStatusEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProBookingDetailStatusEnum> _$proBookingDetailStatusEnumValues =
    BuiltSet<ProBookingDetailStatusEnum>(const <ProBookingDetailStatusEnum>[
  _$proBookingDetailStatusEnum_pending,
  _$proBookingDetailStatusEnum_confirmed,
  _$proBookingDetailStatusEnum_inProgress,
  _$proBookingDetailStatusEnum_completed,
  _$proBookingDetailStatusEnum_cancelled,
]);

Serializer<ProBookingDetailStatusEnum> _$proBookingDetailStatusEnumSerializer =
    _$ProBookingDetailStatusEnumSerializer();

class _$ProBookingDetailStatusEnumSerializer
    implements PrimitiveSerializer<ProBookingDetailStatusEnum> {
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
  final Iterable<Type> types = const <Type>[ProBookingDetailStatusEnum];
  @override
  final String wireName = 'ProBookingDetailStatusEnum';

  @override
  Object serialize(Serializers serializers, ProBookingDetailStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProBookingDetailStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProBookingDetailStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProBookingDetail extends ProBookingDetail {
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
  final ProBookingDetailStatusEnum status;
  @override
  final String source_;
  @override
  final num depositAmountXof;
  @override
  final DateTime createdAt;

  factory _$ProBookingDetail(
          [void Function(ProBookingDetailBuilder)? updates]) =>
      (ProBookingDetailBuilder()..update(updates))._build();

  _$ProBookingDetail._(
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
      required this.createdAt})
      : super._();
  @override
  ProBookingDetail rebuild(void Function(ProBookingDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProBookingDetailBuilder toBuilder() =>
      ProBookingDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProBookingDetail &&
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
        createdAt == other.createdAt;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProBookingDetail')
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
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ProBookingDetailBuilder
    implements Builder<ProBookingDetail, ProBookingDetailBuilder> {
  _$ProBookingDetail? _$v;

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

  ProBookingDetailStatusEnum? _status;
  ProBookingDetailStatusEnum? get status => _$this._status;
  set status(ProBookingDetailStatusEnum? status) => _$this._status = status;

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

  ProBookingDetailBuilder() {
    ProBookingDetail._defaults(this);
  }

  ProBookingDetailBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProBookingDetail other) {
    _$v = other as _$ProBookingDetail;
  }

  @override
  void update(void Function(ProBookingDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProBookingDetail build() => _build();

  _$ProBookingDetail _build() {
    final _$result = _$v ??
        _$ProBookingDetail._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ProBookingDetail', 'id'),
          salonId: BuiltValueNullFieldError.checkNotNull(
              salonId, r'ProBookingDetail', 'salonId'),
          serviceId: BuiltValueNullFieldError.checkNotNull(
              serviceId, r'ProBookingDetail', 'serviceId'),
          serviceName: BuiltValueNullFieldError.checkNotNull(
              serviceName, r'ProBookingDetail', 'serviceName'),
          employeeId: employeeId,
          employeeName: employeeName,
          clientId: clientId,
          clientName: clientName,
          clientPhone: clientPhone,
          startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt, r'ProBookingDetail', 'startsAt'),
          endsAt: BuiltValueNullFieldError.checkNotNull(
              endsAt, r'ProBookingDetail', 'endsAt'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ProBookingDetail', 'status'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'ProBookingDetail', 'source_'),
          depositAmountXof: BuiltValueNullFieldError.checkNotNull(
              depositAmountXof, r'ProBookingDetail', 'depositAmountXof'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'ProBookingDetail', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
