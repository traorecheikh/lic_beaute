// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OtpVerifyInput extends OtpVerifyInput {
  @override
  final String phone;
  @override
  final String code;

  factory _$OtpVerifyInput([void Function(OtpVerifyInputBuilder)? updates]) =>
      (OtpVerifyInputBuilder()..update(updates))._build();

  _$OtpVerifyInput._({required this.phone, required this.code}) : super._();
  @override
  OtpVerifyInput rebuild(void Function(OtpVerifyInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OtpVerifyInputBuilder toBuilder() => OtpVerifyInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OtpVerifyInput &&
        phone == other.phone &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OtpVerifyInput')
          ..add('phone', phone)
          ..add('code', code))
        .toString();
  }
}

class OtpVerifyInputBuilder
    implements Builder<OtpVerifyInput, OtpVerifyInputBuilder> {
  _$OtpVerifyInput? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  OtpVerifyInputBuilder() {
    OtpVerifyInput._defaults(this);
  }

  OtpVerifyInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OtpVerifyInput other) {
    _$v = other as _$OtpVerifyInput;
  }

  @override
  void update(void Function(OtpVerifyInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OtpVerifyInput build() => _build();

  _$OtpVerifyInput _build() {
    final _$result = _$v ??
        _$OtpVerifyInput._(
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'OtpVerifyInput', 'phone'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'OtpVerifyInput', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
