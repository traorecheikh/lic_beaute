// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_analytics.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProAnalytics extends ProAnalytics {
  @override
  final String period;
  @override
  final int bookingCount;
  @override
  final int completedCount;
  @override
  final num occupancyPercent;
  @override
  final int totalRevenueXof;
  @override
  final BuiltList<ProAnalyticsTopServicesInner> topServices;

  factory _$ProAnalytics([void Function(ProAnalyticsBuilder)? updates]) =>
      (ProAnalyticsBuilder()..update(updates))._build();

  _$ProAnalytics._(
      {required this.period,
      required this.bookingCount,
      required this.completedCount,
      required this.occupancyPercent,
      required this.totalRevenueXof,
      required this.topServices})
      : super._();
  @override
  ProAnalytics rebuild(void Function(ProAnalyticsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProAnalyticsBuilder toBuilder() => ProAnalyticsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProAnalytics &&
        period == other.period &&
        bookingCount == other.bookingCount &&
        completedCount == other.completedCount &&
        occupancyPercent == other.occupancyPercent &&
        totalRevenueXof == other.totalRevenueXof &&
        topServices == other.topServices;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, period.hashCode);
    _$hash = $jc(_$hash, bookingCount.hashCode);
    _$hash = $jc(_$hash, completedCount.hashCode);
    _$hash = $jc(_$hash, occupancyPercent.hashCode);
    _$hash = $jc(_$hash, totalRevenueXof.hashCode);
    _$hash = $jc(_$hash, topServices.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProAnalytics')
          ..add('period', period)
          ..add('bookingCount', bookingCount)
          ..add('completedCount', completedCount)
          ..add('occupancyPercent', occupancyPercent)
          ..add('totalRevenueXof', totalRevenueXof)
          ..add('topServices', topServices))
        .toString();
  }
}

class ProAnalyticsBuilder
    implements Builder<ProAnalytics, ProAnalyticsBuilder> {
  _$ProAnalytics? _$v;

  String? _period;
  String? get period => _$this._period;
  set period(String? period) => _$this._period = period;

  int? _bookingCount;
  int? get bookingCount => _$this._bookingCount;
  set bookingCount(int? bookingCount) => _$this._bookingCount = bookingCount;

  int? _completedCount;
  int? get completedCount => _$this._completedCount;
  set completedCount(int? completedCount) =>
      _$this._completedCount = completedCount;

  num? _occupancyPercent;
  num? get occupancyPercent => _$this._occupancyPercent;
  set occupancyPercent(num? occupancyPercent) =>
      _$this._occupancyPercent = occupancyPercent;

  int? _totalRevenueXof;
  int? get totalRevenueXof => _$this._totalRevenueXof;
  set totalRevenueXof(int? totalRevenueXof) =>
      _$this._totalRevenueXof = totalRevenueXof;

  ListBuilder<ProAnalyticsTopServicesInner>? _topServices;
  ListBuilder<ProAnalyticsTopServicesInner> get topServices =>
      _$this._topServices ??= ListBuilder<ProAnalyticsTopServicesInner>();
  set topServices(ListBuilder<ProAnalyticsTopServicesInner>? topServices) =>
      _$this._topServices = topServices;

  ProAnalyticsBuilder() {
    ProAnalytics._defaults(this);
  }

  ProAnalyticsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _period = $v.period;
      _bookingCount = $v.bookingCount;
      _completedCount = $v.completedCount;
      _occupancyPercent = $v.occupancyPercent;
      _totalRevenueXof = $v.totalRevenueXof;
      _topServices = $v.topServices.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProAnalytics other) {
    _$v = other as _$ProAnalytics;
  }

  @override
  void update(void Function(ProAnalyticsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProAnalytics build() => _build();

  _$ProAnalytics _build() {
    _$ProAnalytics _$result;
    try {
      _$result = _$v ??
          _$ProAnalytics._(
            period: BuiltValueNullFieldError.checkNotNull(
                period, r'ProAnalytics', 'period'),
            bookingCount: BuiltValueNullFieldError.checkNotNull(
                bookingCount, r'ProAnalytics', 'bookingCount'),
            completedCount: BuiltValueNullFieldError.checkNotNull(
                completedCount, r'ProAnalytics', 'completedCount'),
            occupancyPercent: BuiltValueNullFieldError.checkNotNull(
                occupancyPercent, r'ProAnalytics', 'occupancyPercent'),
            totalRevenueXof: BuiltValueNullFieldError.checkNotNull(
                totalRevenueXof, r'ProAnalytics', 'totalRevenueXof'),
            topServices: topServices.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'topServices';
        topServices.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProAnalytics', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
