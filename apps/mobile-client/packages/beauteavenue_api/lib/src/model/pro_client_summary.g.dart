// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_client_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProClientSummary extends ProClientSummary {
  @override
  final String id;
  @override
  final String fullName;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final int visitCount;
  @override
  final int totalSpentXof;
  @override
  final DateTime? lastVisitAt;

  factory _$ProClientSummary(
          [void Function(ProClientSummaryBuilder)? updates]) =>
      (ProClientSummaryBuilder()..update(updates))._build();

  _$ProClientSummary._(
      {required this.id,
      required this.fullName,
      this.phone,
      this.email,
      required this.visitCount,
      required this.totalSpentXof,
      this.lastVisitAt})
      : super._();
  @override
  ProClientSummary rebuild(void Function(ProClientSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProClientSummaryBuilder toBuilder() =>
      ProClientSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProClientSummary &&
        id == other.id &&
        fullName == other.fullName &&
        phone == other.phone &&
        email == other.email &&
        visitCount == other.visitCount &&
        totalSpentXof == other.totalSpentXof &&
        lastVisitAt == other.lastVisitAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, visitCount.hashCode);
    _$hash = $jc(_$hash, totalSpentXof.hashCode);
    _$hash = $jc(_$hash, lastVisitAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProClientSummary')
          ..add('id', id)
          ..add('fullName', fullName)
          ..add('phone', phone)
          ..add('email', email)
          ..add('visitCount', visitCount)
          ..add('totalSpentXof', totalSpentXof)
          ..add('lastVisitAt', lastVisitAt))
        .toString();
  }
}

class ProClientSummaryBuilder
    implements Builder<ProClientSummary, ProClientSummaryBuilder> {
  _$ProClientSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  int? _visitCount;
  int? get visitCount => _$this._visitCount;
  set visitCount(int? visitCount) => _$this._visitCount = visitCount;

  int? _totalSpentXof;
  int? get totalSpentXof => _$this._totalSpentXof;
  set totalSpentXof(int? totalSpentXof) =>
      _$this._totalSpentXof = totalSpentXof;

  DateTime? _lastVisitAt;
  DateTime? get lastVisitAt => _$this._lastVisitAt;
  set lastVisitAt(DateTime? lastVisitAt) => _$this._lastVisitAt = lastVisitAt;

  ProClientSummaryBuilder() {
    ProClientSummary._defaults(this);
  }

  ProClientSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _fullName = $v.fullName;
      _phone = $v.phone;
      _email = $v.email;
      _visitCount = $v.visitCount;
      _totalSpentXof = $v.totalSpentXof;
      _lastVisitAt = $v.lastVisitAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProClientSummary other) {
    _$v = other as _$ProClientSummary;
  }

  @override
  void update(void Function(ProClientSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProClientSummary build() => _build();

  _$ProClientSummary _build() {
    final _$result = _$v ??
        _$ProClientSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ProClientSummary', 'id'),
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'ProClientSummary', 'fullName'),
          phone: phone,
          email: email,
          visitCount: BuiltValueNullFieldError.checkNotNull(
              visitCount, r'ProClientSummary', 'visitCount'),
          totalSpentXof: BuiltValueNullFieldError.checkNotNull(
              totalSpentXof, r'ProClientSummary', 'totalSpentXof'),
          lastVisitAt: lastVisitAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
