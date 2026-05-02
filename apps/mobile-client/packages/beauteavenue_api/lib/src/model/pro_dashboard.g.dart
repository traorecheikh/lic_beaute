// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_dashboard.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProDashboard extends ProDashboard {
  @override
  final int pendingBookingCount;
  @override
  final int todayBookingCount;
  @override
  final int? totalRevenueXof;

  factory _$ProDashboard([void Function(ProDashboardBuilder)? updates]) =>
      (ProDashboardBuilder()..update(updates))._build();

  _$ProDashboard._(
      {required this.pendingBookingCount,
      required this.todayBookingCount,
      this.totalRevenueXof})
      : super._();
  @override
  ProDashboard rebuild(void Function(ProDashboardBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProDashboardBuilder toBuilder() => ProDashboardBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProDashboard &&
        pendingBookingCount == other.pendingBookingCount &&
        todayBookingCount == other.todayBookingCount &&
        totalRevenueXof == other.totalRevenueXof;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pendingBookingCount.hashCode);
    _$hash = $jc(_$hash, todayBookingCount.hashCode);
    _$hash = $jc(_$hash, totalRevenueXof.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProDashboard')
          ..add('pendingBookingCount', pendingBookingCount)
          ..add('todayBookingCount', todayBookingCount)
          ..add('totalRevenueXof', totalRevenueXof))
        .toString();
  }
}

class ProDashboardBuilder
    implements Builder<ProDashboard, ProDashboardBuilder> {
  _$ProDashboard? _$v;

  int? _pendingBookingCount;
  int? get pendingBookingCount => _$this._pendingBookingCount;
  set pendingBookingCount(int? pendingBookingCount) =>
      _$this._pendingBookingCount = pendingBookingCount;

  int? _todayBookingCount;
  int? get todayBookingCount => _$this._todayBookingCount;
  set todayBookingCount(int? todayBookingCount) =>
      _$this._todayBookingCount = todayBookingCount;

  int? _totalRevenueXof;
  int? get totalRevenueXof => _$this._totalRevenueXof;
  set totalRevenueXof(int? totalRevenueXof) =>
      _$this._totalRevenueXof = totalRevenueXof;

  ProDashboardBuilder() {
    ProDashboard._defaults(this);
  }

  ProDashboardBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pendingBookingCount = $v.pendingBookingCount;
      _todayBookingCount = $v.todayBookingCount;
      _totalRevenueXof = $v.totalRevenueXof;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProDashboard other) {
    _$v = other as _$ProDashboard;
  }

  @override
  void update(void Function(ProDashboardBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProDashboard build() => _build();

  _$ProDashboard _build() {
    final _$result = _$v ??
        _$ProDashboard._(
          pendingBookingCount: BuiltValueNullFieldError.checkNotNull(
              pendingBookingCount, r'ProDashboard', 'pendingBookingCount'),
          todayBookingCount: BuiltValueNullFieldError.checkNotNull(
              todayBookingCount, r'ProDashboard', 'todayBookingCount'),
          totalRevenueXof: totalRevenueXof,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
