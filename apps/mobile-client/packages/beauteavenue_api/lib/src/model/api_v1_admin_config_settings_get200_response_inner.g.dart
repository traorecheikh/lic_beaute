// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_config_settings_get200_response_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminConfigSettingsGet200ResponseInner
    extends ApiV1AdminConfigSettingsGet200ResponseInner {
  @override
  final String id;
  @override
  final String group;
  @override
  final String key;
  @override
  final String value;
  @override
  final String? description;
  @override
  final DateTime updatedAt;

  factory _$ApiV1AdminConfigSettingsGet200ResponseInner(
          [void Function(ApiV1AdminConfigSettingsGet200ResponseInnerBuilder)?
              updates]) =>
      (ApiV1AdminConfigSettingsGet200ResponseInnerBuilder()..update(updates))
          ._build();

  _$ApiV1AdminConfigSettingsGet200ResponseInner._(
      {required this.id,
      required this.group,
      required this.key,
      required this.value,
      this.description,
      required this.updatedAt})
      : super._();
  @override
  ApiV1AdminConfigSettingsGet200ResponseInner rebuild(
          void Function(ApiV1AdminConfigSettingsGet200ResponseInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminConfigSettingsGet200ResponseInnerBuilder toBuilder() =>
      ApiV1AdminConfigSettingsGet200ResponseInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminConfigSettingsGet200ResponseInner &&
        id == other.id &&
        group == other.group &&
        key == other.key &&
        value == other.value &&
        description == other.description &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, group.hashCode);
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminConfigSettingsGet200ResponseInner')
          ..add('id', id)
          ..add('group', group)
          ..add('key', key)
          ..add('value', value)
          ..add('description', description)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ApiV1AdminConfigSettingsGet200ResponseInnerBuilder
    implements
        Builder<ApiV1AdminConfigSettingsGet200ResponseInner,
            ApiV1AdminConfigSettingsGet200ResponseInnerBuilder> {
  _$ApiV1AdminConfigSettingsGet200ResponseInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _group;
  String? get group => _$this._group;
  set group(String? group) => _$this._group = group;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ApiV1AdminConfigSettingsGet200ResponseInnerBuilder() {
    ApiV1AdminConfigSettingsGet200ResponseInner._defaults(this);
  }

  ApiV1AdminConfigSettingsGet200ResponseInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _group = $v.group;
      _key = $v.key;
      _value = $v.value;
      _description = $v.description;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminConfigSettingsGet200ResponseInner other) {
    _$v = other as _$ApiV1AdminConfigSettingsGet200ResponseInner;
  }

  @override
  void update(
      void Function(ApiV1AdminConfigSettingsGet200ResponseInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminConfigSettingsGet200ResponseInner build() => _build();

  _$ApiV1AdminConfigSettingsGet200ResponseInner _build() {
    final _$result = _$v ??
        _$ApiV1AdminConfigSettingsGet200ResponseInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ApiV1AdminConfigSettingsGet200ResponseInner', 'id'),
          group: BuiltValueNullFieldError.checkNotNull(
              group, r'ApiV1AdminConfigSettingsGet200ResponseInner', 'group'),
          key: BuiltValueNullFieldError.checkNotNull(
              key, r'ApiV1AdminConfigSettingsGet200ResponseInner', 'key'),
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'ApiV1AdminConfigSettingsGet200ResponseInner', 'value'),
          description: description,
          updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt,
              r'ApiV1AdminConfigSettingsGet200ResponseInner', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
