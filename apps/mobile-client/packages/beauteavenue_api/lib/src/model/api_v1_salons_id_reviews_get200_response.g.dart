// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_salons_id_reviews_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1SalonsIdReviewsGet200Response
    extends ApiV1SalonsIdReviewsGet200Response {
  @override
  final BuiltList<ApiV1BookingsBookingIdReviewPost201Response> items;
  @override
  final int total;

  factory _$ApiV1SalonsIdReviewsGet200Response(
          [void Function(ApiV1SalonsIdReviewsGet200ResponseBuilder)?
              updates]) =>
      (ApiV1SalonsIdReviewsGet200ResponseBuilder()..update(updates))._build();

  _$ApiV1SalonsIdReviewsGet200Response._(
      {required this.items, required this.total})
      : super._();
  @override
  ApiV1SalonsIdReviewsGet200Response rebuild(
          void Function(ApiV1SalonsIdReviewsGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1SalonsIdReviewsGet200ResponseBuilder toBuilder() =>
      ApiV1SalonsIdReviewsGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1SalonsIdReviewsGet200Response &&
        items == other.items &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1SalonsIdReviewsGet200Response')
          ..add('items', items)
          ..add('total', total))
        .toString();
  }
}

class ApiV1SalonsIdReviewsGet200ResponseBuilder
    implements
        Builder<ApiV1SalonsIdReviewsGet200Response,
            ApiV1SalonsIdReviewsGet200ResponseBuilder> {
  _$ApiV1SalonsIdReviewsGet200Response? _$v;

  ListBuilder<ApiV1BookingsBookingIdReviewPost201Response>? _items;
  ListBuilder<ApiV1BookingsBookingIdReviewPost201Response> get items =>
      _$this._items ??=
          ListBuilder<ApiV1BookingsBookingIdReviewPost201Response>();
  set items(ListBuilder<ApiV1BookingsBookingIdReviewPost201Response>? items) =>
      _$this._items = items;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  ApiV1SalonsIdReviewsGet200ResponseBuilder() {
    ApiV1SalonsIdReviewsGet200Response._defaults(this);
  }

  ApiV1SalonsIdReviewsGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1SalonsIdReviewsGet200Response other) {
    _$v = other as _$ApiV1SalonsIdReviewsGet200Response;
  }

  @override
  void update(
      void Function(ApiV1SalonsIdReviewsGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1SalonsIdReviewsGet200Response build() => _build();

  _$ApiV1SalonsIdReviewsGet200Response _build() {
    _$ApiV1SalonsIdReviewsGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiV1SalonsIdReviewsGet200Response._(
            items: items.build(),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'ApiV1SalonsIdReviewsGet200Response', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiV1SalonsIdReviewsGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
