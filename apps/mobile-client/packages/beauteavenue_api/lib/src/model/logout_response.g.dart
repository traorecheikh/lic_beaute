// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logout_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LogoutResponse extends LogoutResponse {
  @override
  final bool revoked;

  factory _$LogoutResponse([void Function(LogoutResponseBuilder)? updates]) =>
      (LogoutResponseBuilder()..update(updates))._build();

  _$LogoutResponse._({required this.revoked}) : super._();
  @override
  LogoutResponse rebuild(void Function(LogoutResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LogoutResponseBuilder toBuilder() => LogoutResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LogoutResponse && revoked == other.revoked;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, revoked.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LogoutResponse')
          ..add('revoked', revoked))
        .toString();
  }
}

class LogoutResponseBuilder
    implements Builder<LogoutResponse, LogoutResponseBuilder> {
  _$LogoutResponse? _$v;

  bool? _revoked;
  bool? get revoked => _$this._revoked;
  set revoked(bool? revoked) => _$this._revoked = revoked;

  LogoutResponseBuilder() {
    LogoutResponse._defaults(this);
  }

  LogoutResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _revoked = $v.revoked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LogoutResponse other) {
    _$v = other as _$LogoutResponse;
  }

  @override
  void update(void Function(LogoutResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LogoutResponse build() => _build();

  _$LogoutResponse _build() {
    final _$result = _$v ??
        _$LogoutResponse._(
          revoked: BuiltValueNullFieldError.checkNotNull(
              revoked, r'LogoutResponse', 'revoked'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
