// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_media_media_id_approve_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminMediaMediaIdApprovePostRequest
    extends ApiV1AdminMediaMediaIdApprovePostRequest {
  @override
  final String? purpose;
  @override
  final int? displayOrder;

  factory _$ApiV1AdminMediaMediaIdApprovePostRequest(
          [void Function(ApiV1AdminMediaMediaIdApprovePostRequestBuilder)?
              updates]) =>
      (ApiV1AdminMediaMediaIdApprovePostRequestBuilder()..update(updates))
          ._build();

  _$ApiV1AdminMediaMediaIdApprovePostRequest._(
      {this.purpose, this.displayOrder})
      : super._();
  @override
  ApiV1AdminMediaMediaIdApprovePostRequest rebuild(
          void Function(ApiV1AdminMediaMediaIdApprovePostRequestBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminMediaMediaIdApprovePostRequestBuilder toBuilder() =>
      ApiV1AdminMediaMediaIdApprovePostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminMediaMediaIdApprovePostRequest &&
        purpose == other.purpose &&
        displayOrder == other.displayOrder;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, displayOrder.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminMediaMediaIdApprovePostRequest')
          ..add('purpose', purpose)
          ..add('displayOrder', displayOrder))
        .toString();
  }
}

class ApiV1AdminMediaMediaIdApprovePostRequestBuilder
    implements
        Builder<ApiV1AdminMediaMediaIdApprovePostRequest,
            ApiV1AdminMediaMediaIdApprovePostRequestBuilder> {
  _$ApiV1AdminMediaMediaIdApprovePostRequest? _$v;

  String? _purpose;
  String? get purpose => _$this._purpose;
  set purpose(String? purpose) => _$this._purpose = purpose;

  int? _displayOrder;
  int? get displayOrder => _$this._displayOrder;
  set displayOrder(int? displayOrder) => _$this._displayOrder = displayOrder;

  ApiV1AdminMediaMediaIdApprovePostRequestBuilder() {
    ApiV1AdminMediaMediaIdApprovePostRequest._defaults(this);
  }

  ApiV1AdminMediaMediaIdApprovePostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _purpose = $v.purpose;
      _displayOrder = $v.displayOrder;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminMediaMediaIdApprovePostRequest other) {
    _$v = other as _$ApiV1AdminMediaMediaIdApprovePostRequest;
  }

  @override
  void update(
      void Function(ApiV1AdminMediaMediaIdApprovePostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminMediaMediaIdApprovePostRequest build() => _build();

  _$ApiV1AdminMediaMediaIdApprovePostRequest _build() {
    final _$result = _$v ??
        _$ApiV1AdminMediaMediaIdApprovePostRequest._(
          purpose: purpose,
          displayOrder: displayOrder,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
