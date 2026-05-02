// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_inactivity_alerts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDashboardInactivityAlertsInnerStatusEnum
    _$adminDashboardInactivityAlertsInnerStatusEnum_pendingReview =
    const AdminDashboardInactivityAlertsInnerStatusEnum._('pendingReview');
const AdminDashboardInactivityAlertsInnerStatusEnum
    _$adminDashboardInactivityAlertsInnerStatusEnum_needsInfo =
    const AdminDashboardInactivityAlertsInnerStatusEnum._('needsInfo');
const AdminDashboardInactivityAlertsInnerStatusEnum
    _$adminDashboardInactivityAlertsInnerStatusEnum_approved =
    const AdminDashboardInactivityAlertsInnerStatusEnum._('approved');
const AdminDashboardInactivityAlertsInnerStatusEnum
    _$adminDashboardInactivityAlertsInnerStatusEnum_rejected =
    const AdminDashboardInactivityAlertsInnerStatusEnum._('rejected');

AdminDashboardInactivityAlertsInnerStatusEnum
    _$adminDashboardInactivityAlertsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'pendingReview':
      return _$adminDashboardInactivityAlertsInnerStatusEnum_pendingReview;
    case 'needsInfo':
      return _$adminDashboardInactivityAlertsInnerStatusEnum_needsInfo;
    case 'approved':
      return _$adminDashboardInactivityAlertsInnerStatusEnum_approved;
    case 'rejected':
      return _$adminDashboardInactivityAlertsInnerStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDashboardInactivityAlertsInnerStatusEnum>
    _$adminDashboardInactivityAlertsInnerStatusEnumValues = BuiltSet<
        AdminDashboardInactivityAlertsInnerStatusEnum>(const <AdminDashboardInactivityAlertsInnerStatusEnum>[
  _$adminDashboardInactivityAlertsInnerStatusEnum_pendingReview,
  _$adminDashboardInactivityAlertsInnerStatusEnum_needsInfo,
  _$adminDashboardInactivityAlertsInnerStatusEnum_approved,
  _$adminDashboardInactivityAlertsInnerStatusEnum_rejected,
]);

Serializer<AdminDashboardInactivityAlertsInnerStatusEnum>
    _$adminDashboardInactivityAlertsInnerStatusEnumSerializer =
    _$AdminDashboardInactivityAlertsInnerStatusEnumSerializer();

class _$AdminDashboardInactivityAlertsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminDashboardInactivityAlertsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pendingReview': 'pending_review',
    'needsInfo': 'needs_info',
    'approved': 'approved',
    'rejected': 'rejected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending_review': 'pendingReview',
    'needs_info': 'needsInfo',
    'approved': 'approved',
    'rejected': 'rejected',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDashboardInactivityAlertsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminDashboardInactivityAlertsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminDashboardInactivityAlertsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminDashboardInactivityAlertsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminDashboardInactivityAlertsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminDashboardInactivityAlertsInner
    extends AdminDashboardInactivityAlertsInner {
  @override
  final String salonId;
  @override
  final String salonName;
  @override
  final int daysWithoutBookings;
  @override
  final String city;
  @override
  final AdminDashboardInactivityAlertsInnerStatusEnum status;

  factory _$AdminDashboardInactivityAlertsInner(
          [void Function(AdminDashboardInactivityAlertsInnerBuilder)?
              updates]) =>
      (AdminDashboardInactivityAlertsInnerBuilder()..update(updates))._build();

  _$AdminDashboardInactivityAlertsInner._(
      {required this.salonId,
      required this.salonName,
      required this.daysWithoutBookings,
      required this.city,
      required this.status})
      : super._();
  @override
  AdminDashboardInactivityAlertsInner rebuild(
          void Function(AdminDashboardInactivityAlertsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardInactivityAlertsInnerBuilder toBuilder() =>
      AdminDashboardInactivityAlertsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardInactivityAlertsInner &&
        salonId == other.salonId &&
        salonName == other.salonName &&
        daysWithoutBookings == other.daysWithoutBookings &&
        city == other.city &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jc(_$hash, salonName.hashCode);
    _$hash = $jc(_$hash, daysWithoutBookings.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardInactivityAlertsInner')
          ..add('salonId', salonId)
          ..add('salonName', salonName)
          ..add('daysWithoutBookings', daysWithoutBookings)
          ..add('city', city)
          ..add('status', status))
        .toString();
  }
}

class AdminDashboardInactivityAlertsInnerBuilder
    implements
        Builder<AdminDashboardInactivityAlertsInner,
            AdminDashboardInactivityAlertsInnerBuilder> {
  _$AdminDashboardInactivityAlertsInner? _$v;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _salonName;
  String? get salonName => _$this._salonName;
  set salonName(String? salonName) => _$this._salonName = salonName;

  int? _daysWithoutBookings;
  int? get daysWithoutBookings => _$this._daysWithoutBookings;
  set daysWithoutBookings(int? daysWithoutBookings) =>
      _$this._daysWithoutBookings = daysWithoutBookings;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  AdminDashboardInactivityAlertsInnerStatusEnum? _status;
  AdminDashboardInactivityAlertsInnerStatusEnum? get status => _$this._status;
  set status(AdminDashboardInactivityAlertsInnerStatusEnum? status) =>
      _$this._status = status;

  AdminDashboardInactivityAlertsInnerBuilder() {
    AdminDashboardInactivityAlertsInner._defaults(this);
  }

  AdminDashboardInactivityAlertsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _salonId = $v.salonId;
      _salonName = $v.salonName;
      _daysWithoutBookings = $v.daysWithoutBookings;
      _city = $v.city;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardInactivityAlertsInner other) {
    _$v = other as _$AdminDashboardInactivityAlertsInner;
  }

  @override
  void update(
      void Function(AdminDashboardInactivityAlertsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardInactivityAlertsInner build() => _build();

  _$AdminDashboardInactivityAlertsInner _build() {
    final _$result = _$v ??
        _$AdminDashboardInactivityAlertsInner._(
          salonId: BuiltValueNullFieldError.checkNotNull(
              salonId, r'AdminDashboardInactivityAlertsInner', 'salonId'),
          salonName: BuiltValueNullFieldError.checkNotNull(
              salonName, r'AdminDashboardInactivityAlertsInner', 'salonName'),
          daysWithoutBookings: BuiltValueNullFieldError.checkNotNull(
              daysWithoutBookings,
              r'AdminDashboardInactivityAlertsInner',
              'daysWithoutBookings'),
          city: BuiltValueNullFieldError.checkNotNull(
              city, r'AdminDashboardInactivityAlertsInner', 'city'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminDashboardInactivityAlertsInner', 'status'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
