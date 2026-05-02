// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_client_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProClientDetail extends ProClientDetail {
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
  @override
  final BuiltList<ProClientDetailRecentBookingsInner> recentBookings;

  factory _$ProClientDetail([void Function(ProClientDetailBuilder)? updates]) =>
      (ProClientDetailBuilder()..update(updates))._build();

  _$ProClientDetail._(
      {required this.id,
      required this.fullName,
      this.phone,
      this.email,
      required this.visitCount,
      required this.totalSpentXof,
      this.lastVisitAt,
      required this.recentBookings})
      : super._();
  @override
  ProClientDetail rebuild(void Function(ProClientDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProClientDetailBuilder toBuilder() => ProClientDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProClientDetail &&
        id == other.id &&
        fullName == other.fullName &&
        phone == other.phone &&
        email == other.email &&
        visitCount == other.visitCount &&
        totalSpentXof == other.totalSpentXof &&
        lastVisitAt == other.lastVisitAt &&
        recentBookings == other.recentBookings;
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
    _$hash = $jc(_$hash, recentBookings.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProClientDetail')
          ..add('id', id)
          ..add('fullName', fullName)
          ..add('phone', phone)
          ..add('email', email)
          ..add('visitCount', visitCount)
          ..add('totalSpentXof', totalSpentXof)
          ..add('lastVisitAt', lastVisitAt)
          ..add('recentBookings', recentBookings))
        .toString();
  }
}

class ProClientDetailBuilder
    implements Builder<ProClientDetail, ProClientDetailBuilder> {
  _$ProClientDetail? _$v;

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

  ListBuilder<ProClientDetailRecentBookingsInner>? _recentBookings;
  ListBuilder<ProClientDetailRecentBookingsInner> get recentBookings =>
      _$this._recentBookings ??=
          ListBuilder<ProClientDetailRecentBookingsInner>();
  set recentBookings(
          ListBuilder<ProClientDetailRecentBookingsInner>? recentBookings) =>
      _$this._recentBookings = recentBookings;

  ProClientDetailBuilder() {
    ProClientDetail._defaults(this);
  }

  ProClientDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _fullName = $v.fullName;
      _phone = $v.phone;
      _email = $v.email;
      _visitCount = $v.visitCount;
      _totalSpentXof = $v.totalSpentXof;
      _lastVisitAt = $v.lastVisitAt;
      _recentBookings = $v.recentBookings.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProClientDetail other) {
    _$v = other as _$ProClientDetail;
  }

  @override
  void update(void Function(ProClientDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProClientDetail build() => _build();

  _$ProClientDetail _build() {
    _$ProClientDetail _$result;
    try {
      _$result = _$v ??
          _$ProClientDetail._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProClientDetail', 'id'),
            fullName: BuiltValueNullFieldError.checkNotNull(
                fullName, r'ProClientDetail', 'fullName'),
            phone: phone,
            email: email,
            visitCount: BuiltValueNullFieldError.checkNotNull(
                visitCount, r'ProClientDetail', 'visitCount'),
            totalSpentXof: BuiltValueNullFieldError.checkNotNull(
                totalSpentXof, r'ProClientDetail', 'totalSpentXof'),
            lastVisitAt: lastVisitAt,
            recentBookings: recentBookings.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'recentBookings';
        recentBookings.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProClientDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
