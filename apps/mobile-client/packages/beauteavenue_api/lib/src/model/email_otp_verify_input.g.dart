// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_otp_verify_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmailOtpVerifyInput extends EmailOtpVerifyInput {
  @override
  final String email;
  @override
  final String code;

  factory _$EmailOtpVerifyInput(
          [void Function(EmailOtpVerifyInputBuilder)? updates]) =>
      (EmailOtpVerifyInputBuilder()..update(updates))._build();

  _$EmailOtpVerifyInput._({required this.email, required this.code})
      : super._();
  @override
  EmailOtpVerifyInput rebuild(
          void Function(EmailOtpVerifyInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmailOtpVerifyInputBuilder toBuilder() =>
      EmailOtpVerifyInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmailOtpVerifyInput &&
        email == other.email &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmailOtpVerifyInput')
          ..add('email', email)
          ..add('code', code))
        .toString();
  }
}

class EmailOtpVerifyInputBuilder
    implements Builder<EmailOtpVerifyInput, EmailOtpVerifyInputBuilder> {
  _$EmailOtpVerifyInput? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  EmailOtpVerifyInputBuilder() {
    EmailOtpVerifyInput._defaults(this);
  }

  EmailOtpVerifyInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmailOtpVerifyInput other) {
    _$v = other as _$EmailOtpVerifyInput;
  }

  @override
  void update(void Function(EmailOtpVerifyInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmailOtpVerifyInput build() => _build();

  _$EmailOtpVerifyInput _build() {
    final _$result = _$v ??
        _$EmailOtpVerifyInput._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'EmailOtpVerifyInput', 'email'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'EmailOtpVerifyInput', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
