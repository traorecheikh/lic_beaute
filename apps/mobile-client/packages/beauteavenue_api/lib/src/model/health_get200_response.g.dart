// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HealthGet200Response extends HealthGet200Response {
  @override
  final String status;
  @override
  final DateTime timestamp;
  @override
  final HealthGet200ResponseDatabase database;

  factory _$HealthGet200Response(
          [void Function(HealthGet200ResponseBuilder)? updates]) =>
      (HealthGet200ResponseBuilder()..update(updates))._build();

  _$HealthGet200Response._(
      {required this.status, required this.timestamp, required this.database})
      : super._();
  @override
  HealthGet200Response rebuild(
          void Function(HealthGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HealthGet200ResponseBuilder toBuilder() =>
      HealthGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthGet200Response &&
        status == other.status &&
        timestamp == other.timestamp &&
        database == other.database;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jc(_$hash, database.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HealthGet200Response')
          ..add('status', status)
          ..add('timestamp', timestamp)
          ..add('database', database))
        .toString();
  }
}

class HealthGet200ResponseBuilder
    implements Builder<HealthGet200Response, HealthGet200ResponseBuilder> {
  _$HealthGet200Response? _$v;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  HealthGet200ResponseDatabaseBuilder? _database;
  HealthGet200ResponseDatabaseBuilder get database =>
      _$this._database ??= HealthGet200ResponseDatabaseBuilder();
  set database(HealthGet200ResponseDatabaseBuilder? database) =>
      _$this._database = database;

  HealthGet200ResponseBuilder() {
    HealthGet200Response._defaults(this);
  }

  HealthGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _timestamp = $v.timestamp;
      _database = $v.database.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HealthGet200Response other) {
    _$v = other as _$HealthGet200Response;
  }

  @override
  void update(void Function(HealthGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HealthGet200Response build() => _build();

  _$HealthGet200Response _build() {
    _$HealthGet200Response _$result;
    try {
      _$result = _$v ??
          _$HealthGet200Response._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'HealthGet200Response', 'status'),
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'HealthGet200Response', 'timestamp'),
            database: database.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'database';
        database.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'HealthGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
