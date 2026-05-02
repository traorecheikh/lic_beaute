// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_salon_hour.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProSalonHour extends ProSalonHour {
  @override
  final int dayOfWeek;
  @override
  final bool isOpen;
  @override
  final String? opensAt;
  @override
  final String? closesAt;

  factory _$ProSalonHour([void Function(ProSalonHourBuilder)? updates]) =>
      (ProSalonHourBuilder()..update(updates))._build();

  _$ProSalonHour._(
      {required this.dayOfWeek,
      required this.isOpen,
      this.opensAt,
      this.closesAt})
      : super._();
  @override
  ProSalonHour rebuild(void Function(ProSalonHourBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProSalonHourBuilder toBuilder() => ProSalonHourBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProSalonHour &&
        dayOfWeek == other.dayOfWeek &&
        isOpen == other.isOpen &&
        opensAt == other.opensAt &&
        closesAt == other.closesAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, dayOfWeek.hashCode);
    _$hash = $jc(_$hash, isOpen.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProSalonHour')
          ..add('dayOfWeek', dayOfWeek)
          ..add('isOpen', isOpen)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class ProSalonHourBuilder
    implements Builder<ProSalonHour, ProSalonHourBuilder> {
  _$ProSalonHour? _$v;

  int? _dayOfWeek;
  int? get dayOfWeek => _$this._dayOfWeek;
  set dayOfWeek(int? dayOfWeek) => _$this._dayOfWeek = dayOfWeek;

  bool? _isOpen;
  bool? get isOpen => _$this._isOpen;
  set isOpen(bool? isOpen) => _$this._isOpen = isOpen;

  String? _opensAt;
  String? get opensAt => _$this._opensAt;
  set opensAt(String? opensAt) => _$this._opensAt = opensAt;

  String? _closesAt;
  String? get closesAt => _$this._closesAt;
  set closesAt(String? closesAt) => _$this._closesAt = closesAt;

  ProSalonHourBuilder() {
    ProSalonHour._defaults(this);
  }

  ProSalonHourBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _dayOfWeek = $v.dayOfWeek;
      _isOpen = $v.isOpen;
      _opensAt = $v.opensAt;
      _closesAt = $v.closesAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProSalonHour other) {
    _$v = other as _$ProSalonHour;
  }

  @override
  void update(void Function(ProSalonHourBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProSalonHour build() => _build();

  _$ProSalonHour _build() {
    final _$result = _$v ??
        _$ProSalonHour._(
          dayOfWeek: BuiltValueNullFieldError.checkNotNull(
              dayOfWeek, r'ProSalonHour', 'dayOfWeek'),
          isOpen: BuiltValueNullFieldError.checkNotNull(
              isOpen, r'ProSalonHour', 'isOpen'),
          opensAt: opensAt,
          closesAt: closesAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
