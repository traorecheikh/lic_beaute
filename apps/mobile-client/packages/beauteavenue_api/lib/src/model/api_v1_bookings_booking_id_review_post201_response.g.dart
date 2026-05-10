// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_bookings_booking_id_review_post201_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1BookingsBookingIdReviewPost201Response
    extends ApiV1BookingsBookingIdReviewPost201Response {
  @override
  final String id;
  @override
  final int rating;
  @override
  final String? comment;
  @override
  final DateTime createdAt;
  @override
  final String? responseText;
  @override
  final DateTime? responseAt;

  factory _$ApiV1BookingsBookingIdReviewPost201Response(
          [void Function(ApiV1BookingsBookingIdReviewPost201ResponseBuilder)?
              updates]) =>
      (ApiV1BookingsBookingIdReviewPost201ResponseBuilder()..update(updates))
          ._build();

  _$ApiV1BookingsBookingIdReviewPost201Response._(
      {required this.id,
      required this.rating,
      this.comment,
      required this.createdAt,
      this.responseText,
      this.responseAt})
      : super._();
  @override
  ApiV1BookingsBookingIdReviewPost201Response rebuild(
          void Function(ApiV1BookingsBookingIdReviewPost201ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1BookingsBookingIdReviewPost201ResponseBuilder toBuilder() =>
      ApiV1BookingsBookingIdReviewPost201ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1BookingsBookingIdReviewPost201Response &&
        id == other.id &&
        rating == other.rating &&
        comment == other.comment &&
        createdAt == other.createdAt &&
        responseText == other.responseText &&
        responseAt == other.responseAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, comment.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, responseText.hashCode);
    _$hash = $jc(_$hash, responseAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1BookingsBookingIdReviewPost201Response')
          ..add('id', id)
          ..add('rating', rating)
          ..add('comment', comment)
          ..add('createdAt', createdAt)
          ..add('responseText', responseText)
          ..add('responseAt', responseAt))
        .toString();
  }
}

class ApiV1BookingsBookingIdReviewPost201ResponseBuilder
    implements
        Builder<ApiV1BookingsBookingIdReviewPost201Response,
            ApiV1BookingsBookingIdReviewPost201ResponseBuilder> {
  _$ApiV1BookingsBookingIdReviewPost201Response? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _rating;
  int? get rating => _$this._rating;
  set rating(int? rating) => _$this._rating = rating;

  String? _comment;
  String? get comment => _$this._comment;
  set comment(String? comment) => _$this._comment = comment;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _responseText;
  String? get responseText => _$this._responseText;
  set responseText(String? responseText) => _$this._responseText = responseText;

  DateTime? _responseAt;
  DateTime? get responseAt => _$this._responseAt;
  set responseAt(DateTime? responseAt) => _$this._responseAt = responseAt;

  ApiV1BookingsBookingIdReviewPost201ResponseBuilder() {
    ApiV1BookingsBookingIdReviewPost201Response._defaults(this);
  }

  ApiV1BookingsBookingIdReviewPost201ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _rating = $v.rating;
      _comment = $v.comment;
      _createdAt = $v.createdAt;
      _responseText = $v.responseText;
      _responseAt = $v.responseAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1BookingsBookingIdReviewPost201Response other) {
    _$v = other as _$ApiV1BookingsBookingIdReviewPost201Response;
  }

  @override
  void update(
      void Function(ApiV1BookingsBookingIdReviewPost201ResponseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1BookingsBookingIdReviewPost201Response build() => _build();

  _$ApiV1BookingsBookingIdReviewPost201Response _build() {
    final _$result = _$v ??
        _$ApiV1BookingsBookingIdReviewPost201Response._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ApiV1BookingsBookingIdReviewPost201Response', 'id'),
          rating: BuiltValueNullFieldError.checkNotNull(
              rating, r'ApiV1BookingsBookingIdReviewPost201Response', 'rating'),
          comment: comment,
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'ApiV1BookingsBookingIdReviewPost201Response', 'createdAt'),
          responseText: responseText,
          responseAt: responseAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
