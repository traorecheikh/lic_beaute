// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_otp_request_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmailOtpRequestInput extends EmailOtpRequestInput {
  @override
  final String email;

  factory _$EmailOtpRequestInput(
          [void Function(EmailOtpRequestInputBuilder)? updates]) =>
      (EmailOtpRequestInputBuilder()..update(updates))._build();

  _$EmailOtpRequestInput._({required this.email}) : super._();
  @override
  EmailOtpRequestInput rebuild(
          void Function(EmailOtpRequestInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmailOtpRequestInputBuilder toBuilder() =>
      EmailOtpRequestInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmailOtpRequestInput && email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmailOtpRequestInput')
          ..add('email', email))
        .toString();
  }
}

class EmailOtpRequestInputBuilder
    implements Builder<EmailOtpRequestInput, EmailOtpRequestInputBuilder> {
  _$EmailOtpRequestInput? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  EmailOtpRequestInputBuilder() {
    EmailOtpRequestInput._defaults(this);
  }

  EmailOtpRequestInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmailOtpRequestInput other) {
    _$v = other as _$EmailOtpRequestInput;
  }

  @override
  void update(void Function(EmailOtpRequestInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmailOtpRequestInput build() => _build();

  _$EmailOtpRequestInput _build() {
    final _$result = _$v ??
        _$EmailOtpRequestInput._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'EmailOtpRequestInput', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
