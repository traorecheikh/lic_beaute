// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_push_tokens_post201_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1PushTokensPost201Response extends ApiV1PushTokensPost201Response {
  @override
  final String id;
  @override
  final String token;
  @override
  final String platform;
  @override
  final String createdAt;

  factory _$ApiV1PushTokensPost201Response(
          [void Function(ApiV1PushTokensPost201ResponseBuilder)? updates]) =>
      (ApiV1PushTokensPost201ResponseBuilder()..update(updates))._build();

  _$ApiV1PushTokensPost201Response._(
      {required this.id,
      required this.token,
      required this.platform,
      required this.createdAt})
      : super._();
  @override
  ApiV1PushTokensPost201Response rebuild(
          void Function(ApiV1PushTokensPost201ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1PushTokensPost201ResponseBuilder toBuilder() =>
      ApiV1PushTokensPost201ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1PushTokensPost201Response &&
        id == other.id &&
        token == other.token &&
        platform == other.platform &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1PushTokensPost201Response')
          ..add('id', id)
          ..add('token', token)
          ..add('platform', platform)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ApiV1PushTokensPost201ResponseBuilder
    implements
        Builder<ApiV1PushTokensPost201Response,
            ApiV1PushTokensPost201ResponseBuilder> {
  _$ApiV1PushTokensPost201Response? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _platform;
  String? get platform => _$this._platform;
  set platform(String? platform) => _$this._platform = platform;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  ApiV1PushTokensPost201ResponseBuilder() {
    ApiV1PushTokensPost201Response._defaults(this);
  }

  ApiV1PushTokensPost201ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _token = $v.token;
      _platform = $v.platform;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1PushTokensPost201Response other) {
    _$v = other as _$ApiV1PushTokensPost201Response;
  }

  @override
  void update(void Function(ApiV1PushTokensPost201ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1PushTokensPost201Response build() => _build();

  _$ApiV1PushTokensPost201Response _build() {
    final _$result = _$v ??
        _$ApiV1PushTokensPost201Response._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ApiV1PushTokensPost201Response', 'id'),
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'ApiV1PushTokensPost201Response', 'token'),
          platform: BuiltValueNullFieldError.checkNotNull(
              platform, r'ApiV1PushTokensPost201Response', 'platform'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'ApiV1PushTokensPost201Response', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
