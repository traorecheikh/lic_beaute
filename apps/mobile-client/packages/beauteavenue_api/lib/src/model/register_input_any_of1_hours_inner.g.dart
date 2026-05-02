// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_input_any_of1_hours_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterInputAnyOf1HoursInner extends RegisterInputAnyOf1HoursInner {
  @override
  final int dayOfWeek;
  @override
  final bool isOpen;
  @override
  final String? opensAt;
  @override
  final String? closesAt;

  factory _$RegisterInputAnyOf1HoursInner(
          [void Function(RegisterInputAnyOf1HoursInnerBuilder)? updates]) =>
      (RegisterInputAnyOf1HoursInnerBuilder()..update(updates))._build();

  _$RegisterInputAnyOf1HoursInner._(
      {required this.dayOfWeek,
      required this.isOpen,
      this.opensAt,
      this.closesAt})
      : super._();
  @override
  RegisterInputAnyOf1HoursInner rebuild(
          void Function(RegisterInputAnyOf1HoursInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterInputAnyOf1HoursInnerBuilder toBuilder() =>
      RegisterInputAnyOf1HoursInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterInputAnyOf1HoursInner &&
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
    return (newBuiltValueToStringHelper(r'RegisterInputAnyOf1HoursInner')
          ..add('dayOfWeek', dayOfWeek)
          ..add('isOpen', isOpen)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class RegisterInputAnyOf1HoursInnerBuilder
    implements
        Builder<RegisterInputAnyOf1HoursInner,
            RegisterInputAnyOf1HoursInnerBuilder> {
  _$RegisterInputAnyOf1HoursInner? _$v;

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

  RegisterInputAnyOf1HoursInnerBuilder() {
    RegisterInputAnyOf1HoursInner._defaults(this);
  }

  RegisterInputAnyOf1HoursInnerBuilder get _$this {
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
  void replace(RegisterInputAnyOf1HoursInner other) {
    _$v = other as _$RegisterInputAnyOf1HoursInner;
  }

  @override
  void update(void Function(RegisterInputAnyOf1HoursInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterInputAnyOf1HoursInner build() => _build();

  _$RegisterInputAnyOf1HoursInner _build() {
    final _$result = _$v ??
        _$RegisterInputAnyOf1HoursInner._(
          dayOfWeek: BuiltValueNullFieldError.checkNotNull(
              dayOfWeek, r'RegisterInputAnyOf1HoursInner', 'dayOfWeek'),
          isOpen: BuiltValueNullFieldError.checkNotNull(
              isOpen, r'RegisterInputAnyOf1HoursInner', 'isOpen'),
          opensAt: opensAt,
          closesAt: closesAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
