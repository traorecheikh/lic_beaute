// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paydunya_method_list_response_methods_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaydunyaMethodListResponseMethodsInner
    extends PaydunyaMethodListResponseMethodsInner {
  @override
  final String code;
  @override
  final String country;
  @override
  final String label;
  @override
  final bool enabled;

  factory _$PaydunyaMethodListResponseMethodsInner(
          [void Function(PaydunyaMethodListResponseMethodsInnerBuilder)?
              updates]) =>
      (PaydunyaMethodListResponseMethodsInnerBuilder()..update(updates))
          ._build();

  _$PaydunyaMethodListResponseMethodsInner._(
      {required this.code,
      required this.country,
      required this.label,
      required this.enabled})
      : super._();
  @override
  PaydunyaMethodListResponseMethodsInner rebuild(
          void Function(PaydunyaMethodListResponseMethodsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaydunyaMethodListResponseMethodsInnerBuilder toBuilder() =>
      PaydunyaMethodListResponseMethodsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaydunyaMethodListResponseMethodsInner &&
        code == other.code &&
        country == other.country &&
        label == other.label &&
        enabled == other.enabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, country.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'PaydunyaMethodListResponseMethodsInner')
          ..add('code', code)
          ..add('country', country)
          ..add('label', label)
          ..add('enabled', enabled))
        .toString();
  }
}

class PaydunyaMethodListResponseMethodsInnerBuilder
    implements
        Builder<PaydunyaMethodListResponseMethodsInner,
            PaydunyaMethodListResponseMethodsInnerBuilder> {
  _$PaydunyaMethodListResponseMethodsInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _country;
  String? get country => _$this._country;
  set country(String? country) => _$this._country = country;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  PaydunyaMethodListResponseMethodsInnerBuilder() {
    PaydunyaMethodListResponseMethodsInner._defaults(this);
  }

  PaydunyaMethodListResponseMethodsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _country = $v.country;
      _label = $v.label;
      _enabled = $v.enabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaydunyaMethodListResponseMethodsInner other) {
    _$v = other as _$PaydunyaMethodListResponseMethodsInner;
  }

  @override
  void update(
      void Function(PaydunyaMethodListResponseMethodsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaydunyaMethodListResponseMethodsInner build() => _build();

  _$PaydunyaMethodListResponseMethodsInner _build() {
    final _$result = _$v ??
        _$PaydunyaMethodListResponseMethodsInner._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'PaydunyaMethodListResponseMethodsInner', 'code'),
          country: BuiltValueNullFieldError.checkNotNull(
              country, r'PaydunyaMethodListResponseMethodsInner', 'country'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'PaydunyaMethodListResponseMethodsInner', 'label'),
          enabled: BuiltValueNullFieldError.checkNotNull(
              enabled, r'PaydunyaMethodListResponseMethodsInner', 'enabled'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
