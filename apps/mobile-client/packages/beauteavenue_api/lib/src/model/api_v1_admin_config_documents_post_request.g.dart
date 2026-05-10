// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_config_documents_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminConfigDocumentsPostRequest
    extends ApiV1AdminConfigDocumentsPostRequest {
  @override
  final String label;
  @override
  final String slug;
  @override
  final String type;
  @override
  final bool isRequired;
  @override
  final bool? enabled;

  factory _$ApiV1AdminConfigDocumentsPostRequest(
          [void Function(ApiV1AdminConfigDocumentsPostRequestBuilder)?
              updates]) =>
      (ApiV1AdminConfigDocumentsPostRequestBuilder()..update(updates))._build();

  _$ApiV1AdminConfigDocumentsPostRequest._(
      {required this.label,
      required this.slug,
      required this.type,
      required this.isRequired,
      this.enabled})
      : super._();
  @override
  ApiV1AdminConfigDocumentsPostRequest rebuild(
          void Function(ApiV1AdminConfigDocumentsPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminConfigDocumentsPostRequestBuilder toBuilder() =>
      ApiV1AdminConfigDocumentsPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminConfigDocumentsPostRequest &&
        label == other.label &&
        slug == other.slug &&
        type == other.type &&
        isRequired == other.isRequired &&
        enabled == other.enabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, isRequired.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1AdminConfigDocumentsPostRequest')
          ..add('label', label)
          ..add('slug', slug)
          ..add('type', type)
          ..add('isRequired', isRequired)
          ..add('enabled', enabled))
        .toString();
  }
}

class ApiV1AdminConfigDocumentsPostRequestBuilder
    implements
        Builder<ApiV1AdminConfigDocumentsPostRequest,
            ApiV1AdminConfigDocumentsPostRequestBuilder> {
  _$ApiV1AdminConfigDocumentsPostRequest? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _slug;
  String? get slug => _$this._slug;
  set slug(String? slug) => _$this._slug = slug;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  bool? _isRequired;
  bool? get isRequired => _$this._isRequired;
  set isRequired(bool? isRequired) => _$this._isRequired = isRequired;

  bool? _enabled;
  bool? get enabled => _$this._enabled;
  set enabled(bool? enabled) => _$this._enabled = enabled;

  ApiV1AdminConfigDocumentsPostRequestBuilder() {
    ApiV1AdminConfigDocumentsPostRequest._defaults(this);
  }

  ApiV1AdminConfigDocumentsPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _slug = $v.slug;
      _type = $v.type;
      _isRequired = $v.isRequired;
      _enabled = $v.enabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminConfigDocumentsPostRequest other) {
    _$v = other as _$ApiV1AdminConfigDocumentsPostRequest;
  }

  @override
  void update(
      void Function(ApiV1AdminConfigDocumentsPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminConfigDocumentsPostRequest build() => _build();

  _$ApiV1AdminConfigDocumentsPostRequest _build() {
    final _$result = _$v ??
        _$ApiV1AdminConfigDocumentsPostRequest._(
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'ApiV1AdminConfigDocumentsPostRequest', 'label'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'ApiV1AdminConfigDocumentsPostRequest', 'slug'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'ApiV1AdminConfigDocumentsPostRequest', 'type'),
          isRequired: BuiltValueNullFieldError.checkNotNull(isRequired,
              r'ApiV1AdminConfigDocumentsPostRequest', 'isRequired'),
          enabled: enabled,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
