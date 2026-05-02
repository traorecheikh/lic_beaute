// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_quick_links.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardQuickLinks extends AdminDashboardQuickLinks {
  @override
  final int pendingSalonApprovals;
  @override
  final int subscriptionsNeedingAction;
  @override
  final int auditEventsToday;

  factory _$AdminDashboardQuickLinks(
          [void Function(AdminDashboardQuickLinksBuilder)? updates]) =>
      (AdminDashboardQuickLinksBuilder()..update(updates))._build();

  _$AdminDashboardQuickLinks._(
      {required this.pendingSalonApprovals,
      required this.subscriptionsNeedingAction,
      required this.auditEventsToday})
      : super._();
  @override
  AdminDashboardQuickLinks rebuild(
          void Function(AdminDashboardQuickLinksBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardQuickLinksBuilder toBuilder() =>
      AdminDashboardQuickLinksBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardQuickLinks &&
        pendingSalonApprovals == other.pendingSalonApprovals &&
        subscriptionsNeedingAction == other.subscriptionsNeedingAction &&
        auditEventsToday == other.auditEventsToday;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pendingSalonApprovals.hashCode);
    _$hash = $jc(_$hash, subscriptionsNeedingAction.hashCode);
    _$hash = $jc(_$hash, auditEventsToday.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardQuickLinks')
          ..add('pendingSalonApprovals', pendingSalonApprovals)
          ..add('subscriptionsNeedingAction', subscriptionsNeedingAction)
          ..add('auditEventsToday', auditEventsToday))
        .toString();
  }
}

class AdminDashboardQuickLinksBuilder
    implements
        Builder<AdminDashboardQuickLinks, AdminDashboardQuickLinksBuilder> {
  _$AdminDashboardQuickLinks? _$v;

  int? _pendingSalonApprovals;
  int? get pendingSalonApprovals => _$this._pendingSalonApprovals;
  set pendingSalonApprovals(int? pendingSalonApprovals) =>
      _$this._pendingSalonApprovals = pendingSalonApprovals;

  int? _subscriptionsNeedingAction;
  int? get subscriptionsNeedingAction => _$this._subscriptionsNeedingAction;
  set subscriptionsNeedingAction(int? subscriptionsNeedingAction) =>
      _$this._subscriptionsNeedingAction = subscriptionsNeedingAction;

  int? _auditEventsToday;
  int? get auditEventsToday => _$this._auditEventsToday;
  set auditEventsToday(int? auditEventsToday) =>
      _$this._auditEventsToday = auditEventsToday;

  AdminDashboardQuickLinksBuilder() {
    AdminDashboardQuickLinks._defaults(this);
  }

  AdminDashboardQuickLinksBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pendingSalonApprovals = $v.pendingSalonApprovals;
      _subscriptionsNeedingAction = $v.subscriptionsNeedingAction;
      _auditEventsToday = $v.auditEventsToday;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardQuickLinks other) {
    _$v = other as _$AdminDashboardQuickLinks;
  }

  @override
  void update(void Function(AdminDashboardQuickLinksBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardQuickLinks build() => _build();

  _$AdminDashboardQuickLinks _build() {
    final _$result = _$v ??
        _$AdminDashboardQuickLinks._(
          pendingSalonApprovals: BuiltValueNullFieldError.checkNotNull(
              pendingSalonApprovals,
              r'AdminDashboardQuickLinks',
              'pendingSalonApprovals'),
          subscriptionsNeedingAction: BuiltValueNullFieldError.checkNotNull(
              subscriptionsNeedingAction,
              r'AdminDashboardQuickLinks',
              'subscriptionsNeedingAction'),
          auditEventsToday: BuiltValueNullFieldError.checkNotNull(
              auditEventsToday,
              r'AdminDashboardQuickLinks',
              'auditEventsToday'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
