// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_review.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProReview extends ProReview {
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
  @override
  final String clientId;

  factory _$ProReview([void Function(ProReviewBuilder)? updates]) =>
      (ProReviewBuilder()..update(updates))._build();

  _$ProReview._(
      {required this.id,
      required this.rating,
      this.comment,
      required this.createdAt,
      this.responseText,
      this.responseAt,
      required this.clientId})
      : super._();
  @override
  ProReview rebuild(void Function(ProReviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProReviewBuilder toBuilder() => ProReviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProReview &&
        id == other.id &&
        rating == other.rating &&
        comment == other.comment &&
        createdAt == other.createdAt &&
        responseText == other.responseText &&
        responseAt == other.responseAt &&
        clientId == other.clientId;
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
    _$hash = $jc(_$hash, clientId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProReview')
          ..add('id', id)
          ..add('rating', rating)
          ..add('comment', comment)
          ..add('createdAt', createdAt)
          ..add('responseText', responseText)
          ..add('responseAt', responseAt)
          ..add('clientId', clientId))
        .toString();
  }
}

class ProReviewBuilder implements Builder<ProReview, ProReviewBuilder> {
  _$ProReview? _$v;

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

  String? _clientId;
  String? get clientId => _$this._clientId;
  set clientId(String? clientId) => _$this._clientId = clientId;

  ProReviewBuilder() {
    ProReview._defaults(this);
  }

  ProReviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _rating = $v.rating;
      _comment = $v.comment;
      _createdAt = $v.createdAt;
      _responseText = $v.responseText;
      _responseAt = $v.responseAt;
      _clientId = $v.clientId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProReview other) {
    _$v = other as _$ProReview;
  }

  @override
  void update(void Function(ProReviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProReview build() => _build();

  _$ProReview _build() {
    final _$result = _$v ??
        _$ProReview._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ProReview', 'id'),
          rating: BuiltValueNullFieldError.checkNotNull(
              rating, r'ProReview', 'rating'),
          comment: comment,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'ProReview', 'createdAt'),
          responseText: responseText,
          responseAt: responseAt,
          clientId: BuiltValueNullFieldError.checkNotNull(
              clientId, r'ProReview', 'clientId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
