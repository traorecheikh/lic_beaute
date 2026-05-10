// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_bookings_booking_id_review_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1BookingsBookingIdReviewPostRequest
    extends ApiV1BookingsBookingIdReviewPostRequest {
  @override
  final int rating;
  @override
  final String? comment;

  factory _$ApiV1BookingsBookingIdReviewPostRequest(
          [void Function(ApiV1BookingsBookingIdReviewPostRequestBuilder)?
              updates]) =>
      (ApiV1BookingsBookingIdReviewPostRequestBuilder()..update(updates))
          ._build();

  _$ApiV1BookingsBookingIdReviewPostRequest._(
      {required this.rating, this.comment})
      : super._();
  @override
  ApiV1BookingsBookingIdReviewPostRequest rebuild(
          void Function(ApiV1BookingsBookingIdReviewPostRequestBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1BookingsBookingIdReviewPostRequestBuilder toBuilder() =>
      ApiV1BookingsBookingIdReviewPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1BookingsBookingIdReviewPostRequest &&
        rating == other.rating &&
        comment == other.comment;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1BookingsBookingIdReviewPostRequest')
          ..add('rating', rating)
          ..add('comment', comment))
        .toString();
  }
}

class ApiV1BookingsBookingIdReviewPostRequestBuilder
    implements
        Builder<ApiV1BookingsBookingIdReviewPostRequest,
            ApiV1BookingsBookingIdReviewPostRequestBuilder> {
  _$ApiV1BookingsBookingIdReviewPostRequest? _$v;

  int? _rating;
  int? get rating => _$this._rating;
  set rating(int? rating) => _$this._rating = rating;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  ApiV1BookingsBookingIdReviewPostRequestBuilder() {
    ApiV1BookingsBookingIdReviewPostRequest._defaults(this);
  }

  ApiV1BookingsBookingIdReviewPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rating = $v.rating;
      _comment = $v.comment;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1BookingsBookingIdReviewPostRequest other) {
    _$v = other as _$ApiV1BookingsBookingIdReviewPostRequest;
  }

  @override
  void update(
      void Function(ApiV1BookingsBookingIdReviewPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1BookingsBookingIdReviewPostRequest build() => _build();

  _$ApiV1BookingsBookingIdReviewPostRequest _build() {
    final _$result = _$v ??
        _$ApiV1BookingsBookingIdReviewPostRequest._(
          rating: BuiltValueNullFieldError.checkNotNull(
              rating, r'ApiV1BookingsBookingIdReviewPostRequest', 'rating'),
          comment: comment,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
