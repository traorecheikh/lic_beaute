// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_config_categories_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminConfigCategoriesPostRequest
    extends ApiV1AdminConfigCategoriesPostRequest {
  @override
  final String name;
  @override
  final String slug;
  @override
  final bool? enabled;

  factory _$ApiV1AdminConfigCategoriesPostRequest(
          [void Function(ApiV1AdminConfigCategoriesPostRequestBuilder)?
              updates]) =>
      (ApiV1AdminConfigCategoriesPostRequestBuilder()..update(updates))
          ._build();

  _$ApiV1AdminConfigCategoriesPostRequest._(
      {required this.name, required this.slug, this.enabled})
      : super._();
  @override
  ApiV1AdminConfigCategoriesPostRequest rebuild(
          void Function(ApiV1AdminConfigCategoriesPostRequestBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminConfigCategoriesPostRequestBuilder toBuilder() =>
      ApiV1AdminConfigCategoriesPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminConfigCategoriesPostRequest &&
        name == other.name &&
        slug == other.slug &&
        enabled == other.enabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminConfigCategoriesPostRequest')
          ..add('name', name)
          ..add('slug', slug)
          ..add('enabled', enabled))
        .toString();
  }
}

class ApiV1AdminConfigCategoriesPostRequestBuilder
    implements
        Builder<ApiV1AdminConfigCategoriesPostRequest,
            ApiV1AdminConfigCategoriesPostRequestBuilder> {
  _$ApiV1AdminConfigCategoriesPostRequest? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  ApiV1AdminConfigCategoriesPostRequestBuilder() {
    ApiV1AdminConfigCategoriesPostRequest._defaults(this);
  }

  ApiV1AdminConfigCategoriesPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _slug = $v.slug;
      _enabled = $v.enabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminConfigCategoriesPostRequest other) {
    _$v = other as _$ApiV1AdminConfigCategoriesPostRequest;
  }

  @override
  void update(
      void Function(ApiV1AdminConfigCategoriesPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminConfigCategoriesPostRequest build() => _build();

  _$ApiV1AdminConfigCategoriesPostRequest _build() {
    final _$result = _$v ??
        _$ApiV1AdminConfigCategoriesPostRequest._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ApiV1AdminConfigCategoriesPostRequest', 'name'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'ApiV1AdminConfigCategoriesPostRequest', 'slug'),
          enabled: enabled,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
