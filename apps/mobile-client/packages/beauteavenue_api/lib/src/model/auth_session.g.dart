// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthSession extends AuthSession {
  @override
  final String accessToken;
  @override
  final String refreshToken;
  @override
  final int expiresInSeconds;

  factory _$AuthSession([void Function(AuthSessionBuilder)? updates]) =>
      (AuthSessionBuilder()..update(updates))._build();

  _$AuthSession._(
      {required this.accessToken,
      required this.refreshToken,
      required this.expiresInSeconds})
      : super._();
  @override
  AuthSession rebuild(void Function(AuthSessionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthSessionBuilder toBuilder() => AuthSessionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthSession &&
        accessToken == other.accessToken &&
        refreshToken == other.refreshToken &&
        expiresInSeconds == other.expiresInSeconds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jc(_$hash, expiresInSeconds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthSession')
          ..add('accessToken', accessToken)
          ..add('refreshToken', refreshToken)
          ..add('expiresInSeconds', expiresInSeconds))
        .toString();
  }
}

class AuthSessionBuilder implements Builder<AuthSession, AuthSessionBuilder> {
  _$AuthSession? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  int? _expiresInSeconds;
  int? get expiresInSeconds => _$this._expiresInSeconds;
  set expiresInSeconds(int? expiresInSeconds) =>
      _$this._expiresInSeconds = expiresInSeconds;

  AuthSessionBuilder() {
    AuthSession._defaults(this);
  }

  AuthSessionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _refreshToken = $v.refreshToken;
      _expiresInSeconds = $v.expiresInSeconds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthSession other) {
    _$v = other as _$AuthSession;
  }

  @override
  void update(void Function(AuthSessionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthSession build() => _build();

  _$AuthSession _build() {
    final _$result = _$v ??
        _$AuthSession._(
          accessToken: BuiltValueNullFieldError.checkNotNull(
              accessToken, r'AuthSession', 'accessToken'),
          refreshToken: BuiltValueNullFieldError.checkNotNull(
              refreshToken, r'AuthSession', 'refreshToken'),
          expiresInSeconds: BuiltValueNullFieldError.checkNotNull(
              expiresInSeconds, r'AuthSession', 'expiresInSeconds'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
