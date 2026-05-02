// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_top_growth_salons_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardTopGrowthSalonsInner
    extends AdminDashboardTopGrowthSalonsInner {
  @override
  final String salonId;
  @override
  final String salonName;
  @override
  final num bookingDeltaPercent;
  @override
  final int bookingsThisWeek;
  @override
  final String city;

  factory _$AdminDashboardTopGrowthSalonsInner(
          [void Function(AdminDashboardTopGrowthSalonsInnerBuilder)?
              updates]) =>
      (AdminDashboardTopGrowthSalonsInnerBuilder()..update(updates))._build();

  _$AdminDashboardTopGrowthSalonsInner._(
      {required this.salonId,
      required this.salonName,
      required this.bookingDeltaPercent,
      required this.bookingsThisWeek,
      required this.city})
      : super._();
  @override
  AdminDashboardTopGrowthSalonsInner rebuild(
          void Function(AdminDashboardTopGrowthSalonsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardTopGrowthSalonsInnerBuilder toBuilder() =>
      AdminDashboardTopGrowthSalonsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardTopGrowthSalonsInner &&
        salonId == other.salonId &&
        salonName == other.salonName &&
        bookingDeltaPercent == other.bookingDeltaPercent &&
        bookingsThisWeek == other.bookingsThisWeek &&
        city == other.city;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jc(_$hash, salonName.hashCode);
    _$hash = $jc(_$hash, bookingDeltaPercent.hashCode);
    _$hash = $jc(_$hash, bookingsThisWeek.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardTopGrowthSalonsInner')
          ..add('salonId', salonId)
          ..add('salonName', salonName)
          ..add('bookingDeltaPercent', bookingDeltaPercent)
          ..add('bookingsThisWeek', bookingsThisWeek)
          ..add('city', city))
        .toString();
  }
}

class AdminDashboardTopGrowthSalonsInnerBuilder
    implements
        Builder<AdminDashboardTopGrowthSalonsInner,
            AdminDashboardTopGrowthSalonsInnerBuilder> {
  _$AdminDashboardTopGrowthSalonsInner? _$v;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _salonName;
  String? get salonName => _$this._salonName;
  set salonName(String? salonName) => _$this._salonName = salonName;

  num? _bookingDeltaPercent;
  num? get bookingDeltaPercent => _$this._bookingDeltaPercent;
  set bookingDeltaPercent(num? bookingDeltaPercent) =>
      _$this._bookingDeltaPercent = bookingDeltaPercent;

  int? _bookingsThisWeek;
  int? get bookingsThisWeek => _$this._bookingsThisWeek;
  set bookingsThisWeek(int? bookingsThisWeek) =>
      _$this._bookingsThisWeek = bookingsThisWeek;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  AdminDashboardTopGrowthSalonsInnerBuilder() {
    AdminDashboardTopGrowthSalonsInner._defaults(this);
  }

  AdminDashboardTopGrowthSalonsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _salonId = $v.salonId;
      _salonName = $v.salonName;
      _bookingDeltaPercent = $v.bookingDeltaPercent;
      _bookingsThisWeek = $v.bookingsThisWeek;
      _city = $v.city;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardTopGrowthSalonsInner other) {
    _$v = other as _$AdminDashboardTopGrowthSalonsInner;
  }

  @override
  void update(
      void Function(AdminDashboardTopGrowthSalonsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardTopGrowthSalonsInner build() => _build();

  _$AdminDashboardTopGrowthSalonsInner _build() {
    final _$result = _$v ??
        _$AdminDashboardTopGrowthSalonsInner._(
          salonId: BuiltValueNullFieldError.checkNotNull(
              salonId, r'AdminDashboardTopGrowthSalonsInner', 'salonId'),
          salonName: BuiltValueNullFieldError.checkNotNull(
              salonName, r'AdminDashboardTopGrowthSalonsInner', 'salonName'),
          bookingDeltaPercent: BuiltValueNullFieldError.checkNotNull(
              bookingDeltaPercent,
              r'AdminDashboardTopGrowthSalonsInner',
              'bookingDeltaPercent'),
          bookingsThisWeek: BuiltValueNullFieldError.checkNotNull(
              bookingsThisWeek,
              r'AdminDashboardTopGrowthSalonsInner',
              'bookingsThisWeek'),
          city: BuiltValueNullFieldError.checkNotNull(
              city, r'AdminDashboardTopGrowthSalonsInner', 'city'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
