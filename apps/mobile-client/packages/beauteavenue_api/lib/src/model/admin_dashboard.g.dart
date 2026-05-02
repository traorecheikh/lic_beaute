// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboard extends AdminDashboard {
  @override
  final BuiltList<AdminDashboardKpisInner> kpis;
  @override
  final BuiltList<AdminDashboardTopGrowthSalonsInner> topGrowthSalons;
  @override
  final BuiltList<AdminDashboardInactivityAlertsInner> inactivityAlerts;
  @override
  final AdminDashboardQuickLinks quickLinks;

  factory _$AdminDashboard([void Function(AdminDashboardBuilder)? updates]) =>
      (AdminDashboardBuilder()..update(updates))._build();

  _$AdminDashboard._(
      {required this.kpis,
      required this.topGrowthSalons,
      required this.inactivityAlerts,
      required this.quickLinks})
      : super._();
  @override
  AdminDashboard rebuild(void Function(AdminDashboardBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardBuilder toBuilder() => AdminDashboardBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboard &&
        kpis == other.kpis &&
        topGrowthSalons == other.topGrowthSalons &&
        inactivityAlerts == other.inactivityAlerts &&
        quickLinks == other.quickLinks;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kpis.hashCode);
    _$hash = $jc(_$hash, topGrowthSalons.hashCode);
    _$hash = $jc(_$hash, inactivityAlerts.hashCode);
    _$hash = $jc(_$hash, quickLinks.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboard')
          ..add('kpis', kpis)
          ..add('topGrowthSalons', topGrowthSalons)
          ..add('inactivityAlerts', inactivityAlerts)
          ..add('quickLinks', quickLinks))
        .toString();
  }
}

class AdminDashboardBuilder
    implements Builder<AdminDashboard, AdminDashboardBuilder> {
  _$AdminDashboard? _$v;

  ListBuilder<AdminDashboardKpisInner>? _kpis;
  ListBuilder<AdminDashboardKpisInner> get kpis =>
      _$this._kpis ??= ListBuilder<AdminDashboardKpisInner>();
  set kpis(ListBuilder<AdminDashboardKpisInner>? kpis) => _$this._kpis = kpis;

  ListBuilder<AdminDashboardTopGrowthSalonsInner>? _topGrowthSalons;
  ListBuilder<AdminDashboardTopGrowthSalonsInner> get topGrowthSalons =>
      _$this._topGrowthSalons ??=
          ListBuilder<AdminDashboardTopGrowthSalonsInner>();
  set topGrowthSalons(
          ListBuilder<AdminDashboardTopGrowthSalonsInner>? topGrowthSalons) =>
      _$this._topGrowthSalons = topGrowthSalons;

  ListBuilder<AdminDashboardInactivityAlertsInner>? _inactivityAlerts;
  ListBuilder<AdminDashboardInactivityAlertsInner> get inactivityAlerts =>
      _$this._inactivityAlerts ??=
          ListBuilder<AdminDashboardInactivityAlertsInner>();
  set inactivityAlerts(
          ListBuilder<AdminDashboardInactivityAlertsInner>? inactivityAlerts) =>
      _$this._inactivityAlerts = inactivityAlerts;

  AdminDashboardQuickLinksBuilder? _quickLinks;
  AdminDashboardQuickLinksBuilder get quickLinks =>
      _$this._quickLinks ??= AdminDashboardQuickLinksBuilder();
  set quickLinks(AdminDashboardQuickLinksBuilder? quickLinks) =>
      _$this._quickLinks = quickLinks;

  AdminDashboardBuilder() {
    AdminDashboard._defaults(this);
  }

  AdminDashboardBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kpis = $v.kpis.toBuilder();
      _topGrowthSalons = $v.topGrowthSalons.toBuilder();
      _inactivityAlerts = $v.inactivityAlerts.toBuilder();
      _quickLinks = $v.quickLinks.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboard other) {
    _$v = other as _$AdminDashboard;
  }

  @override
  void update(void Function(AdminDashboardBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboard build() => _build();

  _$AdminDashboard _build() {
    _$AdminDashboard _$result;
    try {
      _$result = _$v ??
          _$AdminDashboard._(
            kpis: kpis.build(),
            topGrowthSalons: topGrowthSalons.build(),
            inactivityAlerts: inactivityAlerts.build(),
            quickLinks: quickLinks.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'kpis';
        kpis.build();
        _$failedField = 'topGrowthSalons';
        topGrowthSalons.build();
        _$failedField = 'inactivityAlerts';
        inactivityAlerts.build();
        _$failedField = 'quickLinks';
        quickLinks.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminDashboard', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
