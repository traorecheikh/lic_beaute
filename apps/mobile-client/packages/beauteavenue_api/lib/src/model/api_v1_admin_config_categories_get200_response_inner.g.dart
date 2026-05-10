// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_config_categories_get200_response_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminConfigCategoriesGet200ResponseInner
    extends ApiV1AdminConfigCategoriesGet200ResponseInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final bool enabled;
  @override
  final DateTime createdAt;

  factory _$ApiV1AdminConfigCategoriesGet200ResponseInner(
          [void Function(ApiV1AdminConfigCategoriesGet200ResponseInnerBuilder)?
              updates]) =>
      (ApiV1AdminConfigCategoriesGet200ResponseInnerBuilder()..update(updates))
          ._build();

  _$ApiV1AdminConfigCategoriesGet200ResponseInner._(
      {required this.id,
      required this.name,
      required this.slug,
      required this.enabled,
      required this.createdAt})
      : super._();
  @override
  ApiV1AdminConfigCategoriesGet200ResponseInner rebuild(
          void Function(ApiV1AdminConfigCategoriesGet200ResponseInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminConfigCategoriesGet200ResponseInnerBuilder toBuilder() =>
      ApiV1AdminConfigCategoriesGet200ResponseInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminConfigCategoriesGet200ResponseInner &&
        id == other.id &&
        name == other.name &&
        slug == other.slug &&
        enabled == other.enabled &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminConfigCategoriesGet200ResponseInner')
          ..add('id', id)
          ..add('name', name)
          ..add('slug', slug)
          ..add('enabled', enabled)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ApiV1AdminConfigCategoriesGet200ResponseInnerBuilder
    implements
        Builder<ApiV1AdminConfigCategoriesGet200ResponseInner,
            ApiV1AdminConfigCategoriesGet200ResponseInnerBuilder> {
  _$ApiV1AdminConfigCategoriesGet200ResponseInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ApiV1AdminConfigCategoriesGet200ResponseInnerBuilder() {
    ApiV1AdminConfigCategoriesGet200ResponseInner._defaults(this);
  }

  ApiV1AdminConfigCategoriesGet200ResponseInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _slug = $v.slug;
      _enabled = $v.enabled;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminConfigCategoriesGet200ResponseInner other) {
    _$v = other as _$ApiV1AdminConfigCategoriesGet200ResponseInner;
  }

  @override
  void update(
      void Function(ApiV1AdminConfigCategoriesGet200ResponseInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminConfigCategoriesGet200ResponseInner build() => _build();

  _$ApiV1AdminConfigCategoriesGet200ResponseInner _build() {
    final _$result = _$v ??
        _$ApiV1AdminConfigCategoriesGet200ResponseInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ApiV1AdminConfigCategoriesGet200ResponseInner', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ApiV1AdminConfigCategoriesGet200ResponseInner', 'name'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'ApiV1AdminConfigCategoriesGet200ResponseInner', 'slug'),
          enabled: BuiltValueNullFieldError.checkNotNull(enabled,
              r'ApiV1AdminConfigCategoriesGet200ResponseInner', 'enabled'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'ApiV1AdminConfigCategoriesGet200ResponseInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
