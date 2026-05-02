// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_subscription_list_response_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSubscriptionListResponseSummary
    extends AdminSubscriptionListResponseSummary {
  @override
  final int premiumCount;
  @override
  final int standardCount;
  @override
  final int pausedCount;

  factory _$AdminSubscriptionListResponseSummary(
          [void Function(AdminSubscriptionListResponseSummaryBuilder)?
              updates]) =>
      (AdminSubscriptionListResponseSummaryBuilder()..update(updates))._build();

  _$AdminSubscriptionListResponseSummary._(
      {required this.premiumCount,
      required this.standardCount,
      required this.pausedCount})
      : super._();
  @override
  AdminSubscriptionListResponseSummary rebuild(
          void Function(AdminSubscriptionListResponseSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSubscriptionListResponseSummaryBuilder toBuilder() =>
      AdminSubscriptionListResponseSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSubscriptionListResponseSummary &&
        premiumCount == other.premiumCount &&
        standardCount == other.standardCount &&
        pausedCount == other.pausedCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, premiumCount.hashCode);
    _$hash = $jc(_$hash, standardCount.hashCode);
    _$hash = $jc(_$hash, pausedCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSubscriptionListResponseSummary')
          ..add('premiumCount', premiumCount)
          ..add('standardCount', standardCount)
          ..add('pausedCount', pausedCount))
        .toString();
  }
}

class AdminSubscriptionListResponseSummaryBuilder
    implements
        Builder<AdminSubscriptionListResponseSummary,
            AdminSubscriptionListResponseSummaryBuilder> {
  _$AdminSubscriptionListResponseSummary? _$v;

  int? _premiumCount;
  int? get premiumCount => _$this._premiumCount;
  set premiumCount(int? premiumCount) => _$this._premiumCount = premiumCount;

  int? _standardCount;
  int? get standardCount => _$this._standardCount;
  set standardCount(int? standardCount) =>
      _$this._standardCount = standardCount;

  int? _pausedCount;
  int? get pausedCount => _$this._pausedCount;
  set pausedCount(int? pausedCount) => _$this._pausedCount = pausedCount;

  AdminSubscriptionListResponseSummaryBuilder() {
    AdminSubscriptionListResponseSummary._defaults(this);
  }

  AdminSubscriptionListResponseSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _premiumCount = $v.premiumCount;
      _standardCount = $v.standardCount;
      _pausedCount = $v.pausedCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSubscriptionListResponseSummary other) {
    _$v = other as _$AdminSubscriptionListResponseSummary;
  }

  @override
  void update(
      void Function(AdminSubscriptionListResponseSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSubscriptionListResponseSummary build() => _build();

  _$AdminSubscriptionListResponseSummary _build() {
    final _$result = _$v ??
        _$AdminSubscriptionListResponseSummary._(
          premiumCount: BuiltValueNullFieldError.checkNotNull(premiumCount,
              r'AdminSubscriptionListResponseSummary', 'premiumCount'),
          standardCount: BuiltValueNullFieldError.checkNotNull(standardCount,
              r'AdminSubscriptionListResponseSummary', 'standardCount'),
          pausedCount: BuiltValueNullFieldError.checkNotNull(pausedCount,
              r'AdminSubscriptionListResponseSummary', 'pausedCount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
