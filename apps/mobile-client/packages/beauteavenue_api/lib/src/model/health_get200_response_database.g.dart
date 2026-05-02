// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_get200_response_database.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$HealthGet200ResponseDatabase extends HealthGet200ResponseDatabase {
  @override
  final String? driver;
  @override
  final String? mode;
  @override
  final int? attempts;

  factory _$HealthGet200ResponseDatabase(
          [void Function(HealthGet200ResponseDatabaseBuilder)? updates]) =>
      (HealthGet200ResponseDatabaseBuilder()..update(updates))._build();

  _$HealthGet200ResponseDatabase._({this.driver, this.mode, this.attempts})
      : super._();
  @override
  HealthGet200ResponseDatabase rebuild(
          void Function(HealthGet200ResponseDatabaseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HealthGet200ResponseDatabaseBuilder toBuilder() =>
      HealthGet200ResponseDatabaseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthGet200ResponseDatabase &&
        driver == other.driver &&
        mode == other.mode &&
        attempts == other.attempts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, driver.hashCode);
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, attempts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HealthGet200ResponseDatabase')
          ..add('driver', driver)
          ..add('mode', mode)
          ..add('attempts', attempts))
        .toString();
  }
}

class HealthGet200ResponseDatabaseBuilder
    implements
        Builder<HealthGet200ResponseDatabase,
            HealthGet200ResponseDatabaseBuilder> {
  _$HealthGet200ResponseDatabase? _$v;

  String? _driver;
  String? get driver => _$this._driver;
  set driver(String? driver) => _$this._driver = driver;

  String? _mode;
  String? get mode => _$this._mode;
  set mode(String? mode) => _$this._mode = mode;

  int? _attempts;
  int? get attempts => _$this._attempts;
  set attempts(int? attempts) => _$this._attempts = attempts;

  HealthGet200ResponseDatabaseBuilder() {
    HealthGet200ResponseDatabase._defaults(this);
  }

  HealthGet200ResponseDatabaseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _driver = $v.driver;
      _mode = $v.mode;
      _attempts = $v.attempts;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HealthGet200ResponseDatabase other) {
    _$v = other as _$HealthGet200ResponseDatabase;
  }

  @override
  void update(void Function(HealthGet200ResponseDatabaseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HealthGet200ResponseDatabase build() => _build();

  _$HealthGet200ResponseDatabase _build() {
    final _$result = _$v ??
        _$HealthGet200ResponseDatabase._(
          driver: driver,
          mode: mode,
          attempts: attempts,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
