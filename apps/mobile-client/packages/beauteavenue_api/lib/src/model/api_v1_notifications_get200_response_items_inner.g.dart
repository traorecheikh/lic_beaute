// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_notifications_get200_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1NotificationsGet200ResponseItemsInner
    extends ApiV1NotificationsGet200ResponseItemsInner {
  @override
  final String id;
  @override
  final String title;
  @override
  final String body;
  @override
  final String channel;
  @override
  final String? readAt;
  @override
  final String createdAt;

  factory _$ApiV1NotificationsGet200ResponseItemsInner(
          [void Function(ApiV1NotificationsGet200ResponseItemsInnerBuilder)?
              updates]) =>
      (ApiV1NotificationsGet200ResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$ApiV1NotificationsGet200ResponseItemsInner._(
      {required this.id,
      required this.title,
      required this.body,
      required this.channel,
      this.readAt,
      required this.createdAt})
      : super._();
  @override
  ApiV1NotificationsGet200ResponseItemsInner rebuild(
          void Function(ApiV1NotificationsGet200ResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1NotificationsGet200ResponseItemsInnerBuilder toBuilder() =>
      ApiV1NotificationsGet200ResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1NotificationsGet200ResponseItemsInner &&
        id == other.id &&
        title == other.title &&
        body == other.body &&
        channel == other.channel &&
        readAt == other.readAt &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, readAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1NotificationsGet200ResponseItemsInner')
          ..add('id', id)
          ..add('title', title)
          ..add('body', body)
          ..add('channel', channel)
          ..add('readAt', readAt)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ApiV1NotificationsGet200ResponseItemsInnerBuilder
    implements
        Builder<ApiV1NotificationsGet200ResponseItemsInner,
            ApiV1NotificationsGet200ResponseItemsInnerBuilder> {
  _$ApiV1NotificationsGet200ResponseItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  String? _channel;
  String? get channel => _$this._channel;
  set channel(String? channel) => _$this._channel = channel;

  String? _readAt;
  String? get readAt => _$this._readAt;
  set readAt(String? readAt) => _$this._readAt = readAt;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  ApiV1NotificationsGet200ResponseItemsInnerBuilder() {
    ApiV1NotificationsGet200ResponseItemsInner._defaults(this);
  }

  ApiV1NotificationsGet200ResponseItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _body = $v.body;
      _channel = $v.channel;
      _readAt = $v.readAt;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1NotificationsGet200ResponseItemsInner other) {
    _$v = other as _$ApiV1NotificationsGet200ResponseItemsInner;
  }

  @override
  void update(
      void Function(ApiV1NotificationsGet200ResponseItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1NotificationsGet200ResponseItemsInner build() => _build();

  _$ApiV1NotificationsGet200ResponseItemsInner _build() {
    final _$result = _$v ??
        _$ApiV1NotificationsGet200ResponseItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ApiV1NotificationsGet200ResponseItemsInner', 'id'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'ApiV1NotificationsGet200ResponseItemsInner', 'title'),
          body: BuiltValueNullFieldError.checkNotNull(
              body, r'ApiV1NotificationsGet200ResponseItemsInner', 'body'),
          channel: BuiltValueNullFieldError.checkNotNull(channel,
              r'ApiV1NotificationsGet200ResponseItemsInner', 'channel'),
          readAt: readAt,
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'ApiV1NotificationsGet200ResponseItemsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
