// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_pro_vouchers_post201_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ProVouchersPost201Response
    extends ApiV1ProVouchersPost201Response {
  @override
  final String id;
  @override
  final String code;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String discountLabel;
  @override
  final String? expiresAt;
  @override
  final int? maxRedemptions;

  factory _$ApiV1ProVouchersPost201Response(
          [void Function(ApiV1ProVouchersPost201ResponseBuilder)? updates]) =>
      (ApiV1ProVouchersPost201ResponseBuilder()..update(updates))._build();

  _$ApiV1ProVouchersPost201Response._(
      {required this.id,
      required this.code,
      required this.title,
      this.description,
      required this.discountLabel,
      this.expiresAt,
      this.maxRedemptions})
      : super._();
  @override
  ApiV1ProVouchersPost201Response rebuild(
          void Function(ApiV1ProVouchersPost201ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1ProVouchersPost201ResponseBuilder toBuilder() =>
      ApiV1ProVouchersPost201ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ProVouchersPost201Response &&
        id == other.id &&
        code == other.code &&
        title == other.title &&
        description == other.description &&
        discountLabel == other.discountLabel &&
        expiresAt == other.expiresAt &&
        maxRedemptions == other.maxRedemptions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, discountLabel.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, maxRedemptions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1ProVouchersPost201Response')
          ..add('id', id)
          ..add('code', code)
          ..add('title', title)
          ..add('description', description)
          ..add('discountLabel', discountLabel)
          ..add('expiresAt', expiresAt)
          ..add('maxRedemptions', maxRedemptions))
        .toString();
  }
}

class ApiV1ProVouchersPost201ResponseBuilder
    implements
        Builder<ApiV1ProVouchersPost201Response,
            ApiV1ProVouchersPost201ResponseBuilder> {
  _$ApiV1ProVouchersPost201Response? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _discountLabel;
  String? get discountLabel => _$this._discountLabel;
  set discountLabel(String? discountLabel) =>
      _$this._discountLabel = discountLabel;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  int? _maxRedemptions;
  int? get maxRedemptions => _$this._maxRedemptions;
  set maxRedemptions(int? maxRedemptions) =>
      _$this._maxRedemptions = maxRedemptions;

  ApiV1ProVouchersPost201ResponseBuilder() {
    ApiV1ProVouchersPost201Response._defaults(this);
  }

  ApiV1ProVouchersPost201ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _title = $v.title;
      _description = $v.description;
      _discountLabel = $v.discountLabel;
      _expiresAt = $v.expiresAt;
      _maxRedemptions = $v.maxRedemptions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1ProVouchersPost201Response other) {
    _$v = other as _$ApiV1ProVouchersPost201Response;
  }

  @override
  void update(void Function(ApiV1ProVouchersPost201ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ProVouchersPost201Response build() => _build();

  _$ApiV1ProVouchersPost201Response _build() {
    final _$result = _$v ??
        _$ApiV1ProVouchersPost201Response._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ApiV1ProVouchersPost201Response', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'ApiV1ProVouchersPost201Response', 'code'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'ApiV1ProVouchersPost201Response', 'title'),
          description: description,
          discountLabel: BuiltValueNullFieldError.checkNotNull(discountLabel,
              r'ApiV1ProVouchersPost201Response', 'discountLabel'),
          expiresAt: expiresAt,
          maxRedemptions: maxRedemptions,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
