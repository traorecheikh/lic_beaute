// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_booking_full_detail_payments_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProBookingFullDetailPaymentsInner
    extends ProBookingFullDetailPaymentsInner {
  @override
  final String id;
  @override
  final String status;
  @override
  final int amountXof;
  @override
  final String provider;

  factory _$ProBookingFullDetailPaymentsInner(
          [void Function(ProBookingFullDetailPaymentsInnerBuilder)? updates]) =>
      (ProBookingFullDetailPaymentsInnerBuilder()..update(updates))._build();

  _$ProBookingFullDetailPaymentsInner._(
      {required this.id,
      required this.status,
      required this.amountXof,
      required this.provider})
      : super._();
  @override
  ProBookingFullDetailPaymentsInner rebuild(
          void Function(ProBookingFullDetailPaymentsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProBookingFullDetailPaymentsInnerBuilder toBuilder() =>
      ProBookingFullDetailPaymentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProBookingFullDetailPaymentsInner &&
        id == other.id &&
        status == other.status &&
        amountXof == other.amountXof &&
        provider == other.provider;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, amountXof.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProBookingFullDetailPaymentsInner')
          ..add('id', id)
          ..add('status', status)
          ..add('amountXof', amountXof)
          ..add('provider', provider))
        .toString();
  }
}

class ProBookingFullDetailPaymentsInnerBuilder
    implements
        Builder<ProBookingFullDetailPaymentsInner,
            ProBookingFullDetailPaymentsInnerBuilder> {
  _$ProBookingFullDetailPaymentsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  int? _amountXof;
  int? get amountXof => _$this._amountXof;
  set amountXof(int? amountXof) => _$this._amountXof = amountXof;

  String? _provider;
  String? get provider => _$this._provider;
  set provider(String? provider) => _$this._provider = provider;

  ProBookingFullDetailPaymentsInnerBuilder() {
    ProBookingFullDetailPaymentsInner._defaults(this);
  }

  ProBookingFullDetailPaymentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _amountXof = $v.amountXof;
      _provider = $v.provider;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProBookingFullDetailPaymentsInner other) {
    _$v = other as _$ProBookingFullDetailPaymentsInner;
  }

  @override
  void update(
      void Function(ProBookingFullDetailPaymentsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProBookingFullDetailPaymentsInner build() => _build();

  _$ProBookingFullDetailPaymentsInner _build() {
    final _$result = _$v ??
        _$ProBookingFullDetailPaymentsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ProBookingFullDetailPaymentsInner', 'id'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ProBookingFullDetailPaymentsInner', 'status'),
          amountXof: BuiltValueNullFieldError.checkNotNull(
              amountXof, r'ProBookingFullDetailPaymentsInner', 'amountXof'),
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'ProBookingFullDetailPaymentsInner', 'provider'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
