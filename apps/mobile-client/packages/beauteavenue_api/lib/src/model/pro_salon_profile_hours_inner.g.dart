// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_salon_profile_hours_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProSalonProfileHoursInner extends ProSalonProfileHoursInner {
  @override
  final int dayOfWeek;
  @override
  final bool isOpen;
  @override
  final String? opensAt;
  @override
  final String? closesAt;

  factory _$ProSalonProfileHoursInner(
          [void Function(ProSalonProfileHoursInnerBuilder)? updates]) =>
      (ProSalonProfileHoursInnerBuilder()..update(updates))._build();

  _$ProSalonProfileHoursInner._(
      {required this.dayOfWeek,
      required this.isOpen,
      this.opensAt,
      this.closesAt})
      : super._();
  @override
  ProSalonProfileHoursInner rebuild(
          void Function(ProSalonProfileHoursInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProSalonProfileHoursInnerBuilder toBuilder() =>
      ProSalonProfileHoursInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProSalonProfileHoursInner &&
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
    return (newBuiltValueToStringHelper(r'ProSalonProfileHoursInner')
          ..add('dayOfWeek', dayOfWeek)
          ..add('isOpen', isOpen)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class ProSalonProfileHoursInnerBuilder
    implements
        Builder<ProSalonProfileHoursInner, ProSalonProfileHoursInnerBuilder> {
  _$ProSalonProfileHoursInner? _$v;

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

  ProSalonProfileHoursInnerBuilder() {
    ProSalonProfileHoursInner._defaults(this);
  }

  ProSalonProfileHoursInnerBuilder get _$this {
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
  void replace(ProSalonProfileHoursInner other) {
    _$v = other as _$ProSalonProfileHoursInner;
  }

  @override
  void update(void Function(ProSalonProfileHoursInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProSalonProfileHoursInner build() => _build();

  _$ProSalonProfileHoursInner _build() {
    final _$result = _$v ??
        _$ProSalonProfileHoursInner._(
          dayOfWeek: BuiltValueNullFieldError.checkNotNull(
              dayOfWeek, r'ProSalonProfileHoursInner', 'dayOfWeek'),
          isOpen: BuiltValueNullFieldError.checkNotNull(
              isOpen, r'ProSalonProfileHoursInner', 'isOpen'),
          opensAt: opensAt,
          closesAt: closesAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
