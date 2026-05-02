// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_kpis_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardKpisInner extends AdminDashboardKpisInner {
  @override
  final String label;
  @override
  final num value;
  @override
  final String displayValue;
  @override
  final String note;

  factory _$AdminDashboardKpisInner(
          [void Function(AdminDashboardKpisInnerBuilder)? updates]) =>
      (AdminDashboardKpisInnerBuilder()..update(updates))._build();

  _$AdminDashboardKpisInner._(
      {required this.label,
      required this.value,
      required this.displayValue,
      required this.note})
      : super._();
  @override
  AdminDashboardKpisInner rebuild(
          void Function(AdminDashboardKpisInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminDashboardKpisInnerBuilder toBuilder() =>
      AdminDashboardKpisInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardKpisInner &&
        label == other.label &&
        value == other.value &&
        displayValue == other.displayValue &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, displayValue.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardKpisInner')
          ..add('label', label)
          ..add('value', value)
          ..add('displayValue', displayValue)
          ..add('note', note))
        .toString();
  }
}

class AdminDashboardKpisInnerBuilder
    implements
        Builder<AdminDashboardKpisInner, AdminDashboardKpisInnerBuilder> {
  _$AdminDashboardKpisInner? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  num? _value;
  num? get value => _$this._value;
  set value(num? value) => _$this._value = value;

  String? _displayValue;
  String? get displayValue => _$this._displayValue;
  set displayValue(String? displayValue) => _$this._displayValue = displayValue;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  AdminDashboardKpisInnerBuilder() {
    AdminDashboardKpisInner._defaults(this);
  }

  AdminDashboardKpisInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _value = $v.value;
      _displayValue = $v.displayValue;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardKpisInner other) {
    _$v = other as _$AdminDashboardKpisInner;
  }

  @override
  void update(void Function(AdminDashboardKpisInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardKpisInner build() => _build();

  _$AdminDashboardKpisInner _build() {
    final _$result = _$v ??
        _$AdminDashboardKpisInner._(
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'AdminDashboardKpisInner', 'label'),
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'AdminDashboardKpisInner', 'value'),
          displayValue: BuiltValueNullFieldError.checkNotNull(
              displayValue, r'AdminDashboardKpisInner', 'displayValue'),
          note: BuiltValueNullFieldError.checkNotNull(
              note, r'AdminDashboardKpisInner', 'note'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
