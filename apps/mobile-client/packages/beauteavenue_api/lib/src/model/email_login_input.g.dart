// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_login_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmailLoginInput extends EmailLoginInput {
  @override
  final String email;
  @override
  final String password;

  factory _$EmailLoginInput([void Function(EmailLoginInputBuilder)? updates]) =>
      (EmailLoginInputBuilder()..update(updates))._build();

  _$EmailLoginInput._({required this.email, required this.password})
      : super._();
  @override
  EmailLoginInput rebuild(void Function(EmailLoginInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmailLoginInputBuilder toBuilder() => EmailLoginInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmailLoginInput &&
        email == other.email &&
        password == other.password;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmailLoginInput')
          ..add('email', email)
          ..add('password', password))
        .toString();
  }
}

class EmailLoginInputBuilder
    implements Builder<EmailLoginInput, EmailLoginInputBuilder> {
  _$EmailLoginInput? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  EmailLoginInputBuilder() {
    EmailLoginInput._defaults(this);
  }

  EmailLoginInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _password = $v.password;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmailLoginInput other) {
    _$v = other as _$EmailLoginInput;
  }

  @override
  void update(void Function(EmailLoginInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmailLoginInput build() => _build();

  _$EmailLoginInput _build() {
    final _$result = _$v ??
        _$EmailLoginInput._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'EmailLoginInput', 'email'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'EmailLoginInput', 'password'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
