// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_config_documents_get200_response_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminConfigDocumentsGet200ResponseInner
    extends ApiV1AdminConfigDocumentsGet200ResponseInner {
  @override
  final String id;
  @override
  final String label;
  @override
  final String slug;
  @override
  final String type;
  @override
  final bool isRequired;
  @override
  final bool enabled;
  @override
  final DateTime createdAt;

  factory _$ApiV1AdminConfigDocumentsGet200ResponseInner(
          [void Function(ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder)?
              updates]) =>
      (ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder()..update(updates))
          ._build();

  _$ApiV1AdminConfigDocumentsGet200ResponseInner._(
      {required this.id,
      required this.label,
      required this.slug,
      required this.type,
      required this.isRequired,
      required this.enabled,
      required this.createdAt})
      : super._();
  @override
  ApiV1AdminConfigDocumentsGet200ResponseInner rebuild(
          void Function(ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder toBuilder() =>
      ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminConfigDocumentsGet200ResponseInner &&
        id == other.id &&
        label == other.label &&
        slug == other.slug &&
        type == other.type &&
        isRequired == other.isRequired &&
        enabled == other.enabled &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, slug.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, isRequired.hashCode);
    _$hash = $jc(_$hash, enabled.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminConfigDocumentsGet200ResponseInner')
          ..add('id', id)
          ..add('label', label)
          ..add('slug', slug)
          ..add('type', type)
          ..add('isRequired', isRequired)
          ..add('enabled', enabled)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder
    implements
        Builder<ApiV1AdminConfigDocumentsGet200ResponseInner,
            ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder> {
  _$ApiV1AdminConfigDocumentsGet200ResponseInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

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

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder() {
    ApiV1AdminConfigDocumentsGet200ResponseInner._defaults(this);
  }

  ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _label = $v.label;
      _slug = $v.slug;
      _type = $v.type;
      _isRequired = $v.isRequired;
      _enabled = $v.enabled;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminConfigDocumentsGet200ResponseInner other) {
    _$v = other as _$ApiV1AdminConfigDocumentsGet200ResponseInner;
  }

  @override
  void update(
      void Function(ApiV1AdminConfigDocumentsGet200ResponseInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminConfigDocumentsGet200ResponseInner build() => _build();

  _$ApiV1AdminConfigDocumentsGet200ResponseInner _build() {
    final _$result = _$v ??
        _$ApiV1AdminConfigDocumentsGet200ResponseInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ApiV1AdminConfigDocumentsGet200ResponseInner', 'id'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'ApiV1AdminConfigDocumentsGet200ResponseInner', 'label'),
          slug: BuiltValueNullFieldError.checkNotNull(
              slug, r'ApiV1AdminConfigDocumentsGet200ResponseInner', 'slug'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'ApiV1AdminConfigDocumentsGet200ResponseInner', 'type'),
          isRequired: BuiltValueNullFieldError.checkNotNull(isRequired,
              r'ApiV1AdminConfigDocumentsGet200ResponseInner', 'isRequired'),
          enabled: BuiltValueNullFieldError.checkNotNull(enabled,
              r'ApiV1AdminConfigDocumentsGet200ResponseInner', 'enabled'),
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'ApiV1AdminConfigDocumentsGet200ResponseInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
