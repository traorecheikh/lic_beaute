// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_notifications_id_read_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1NotificationsIdReadPost200Response
    extends ApiV1NotificationsIdReadPost200Response {
  @override
  final bool read;

  factory _$ApiV1NotificationsIdReadPost200Response(
          [void Function(ApiV1NotificationsIdReadPost200ResponseBuilder)?
              updates]) =>
      (ApiV1NotificationsIdReadPost200ResponseBuilder()..update(updates))
          ._build();

  _$ApiV1NotificationsIdReadPost200Response._({required this.read}) : super._();
  @override
  ApiV1NotificationsIdReadPost200Response rebuild(
          void Function(ApiV1NotificationsIdReadPost200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1NotificationsIdReadPost200ResponseBuilder toBuilder() =>
      ApiV1NotificationsIdReadPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1NotificationsIdReadPost200Response &&
        read == other.read;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, read.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1NotificationsIdReadPost200Response')
          ..add('read', read))
        .toString();
  }
}

class ApiV1NotificationsIdReadPost200ResponseBuilder
    implements
        Builder<ApiV1NotificationsIdReadPost200Response,
            ApiV1NotificationsIdReadPost200ResponseBuilder> {
  _$ApiV1NotificationsIdReadPost200Response? _$v;

  bool? _read;
  bool? get read => _$this._read;
  set read(bool? read) => _$this._read = read;

  ApiV1NotificationsIdReadPost200ResponseBuilder() {
    ApiV1NotificationsIdReadPost200Response._defaults(this);
  }

  ApiV1NotificationsIdReadPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _read = $v.read;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1NotificationsIdReadPost200Response other) {
    _$v = other as _$ApiV1NotificationsIdReadPost200Response;
  }

  @override
  void update(
      void Function(ApiV1NotificationsIdReadPost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1NotificationsIdReadPost200Response build() => _build();

  _$ApiV1NotificationsIdReadPost200Response _build() {
    final _$result = _$v ??
        _$ApiV1NotificationsIdReadPost200Response._(
          read: BuiltValueNullFieldError.checkNotNull(
              read, r'ApiV1NotificationsIdReadPost200Response', 'read'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
