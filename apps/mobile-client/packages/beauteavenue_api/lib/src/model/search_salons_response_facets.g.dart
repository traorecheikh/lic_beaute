// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_salons_response_facets.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchSalonsResponseFacets extends SearchSalonsResponseFacets {
  @override
  final BuiltList<SearchSalonsResponseFacetsCategoriesInner> categories;
  @override
  final BuiltList<SearchSalonsResponseFacetsCategoriesInner> cities;
  @override
  final BuiltList<SearchSalonsResponseFacetsCategoriesInner> neighborhoods;
  @override
  final BuiltList<SearchSalonsResponseFacetsCategoriesInner> priceRanges;
  @override
  final int openNowCount;
  @override
  final int bookableSoonCount;

  factory _$SearchSalonsResponseFacets(
          [void Function(SearchSalonsResponseFacetsBuilder)? updates]) =>
      (SearchSalonsResponseFacetsBuilder()..update(updates))._build();

  _$SearchSalonsResponseFacets._(
      {required this.categories,
      required this.cities,
      required this.neighborhoods,
      required this.priceRanges,
      required this.openNowCount,
      required this.bookableSoonCount})
      : super._();
  @override
  SearchSalonsResponseFacets rebuild(
          void Function(SearchSalonsResponseFacetsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchSalonsResponseFacetsBuilder toBuilder() =>
      SearchSalonsResponseFacetsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchSalonsResponseFacets &&
        categories == other.categories &&
        cities == other.cities &&
        neighborhoods == other.neighborhoods &&
        priceRanges == other.priceRanges &&
        openNowCount == other.openNowCount &&
        bookableSoonCount == other.bookableSoonCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, cities.hashCode);
    _$hash = $jc(_$hash, neighborhoods.hashCode);
    _$hash = $jc(_$hash, priceRanges.hashCode);
    _$hash = $jc(_$hash, openNowCount.hashCode);
    _$hash = $jc(_$hash, bookableSoonCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchSalonsResponseFacets')
          ..add('categories', categories)
          ..add('cities', cities)
          ..add('neighborhoods', neighborhoods)
          ..add('priceRanges', priceRanges)
          ..add('openNowCount', openNowCount)
          ..add('bookableSoonCount', bookableSoonCount))
        .toString();
  }
}

class SearchSalonsResponseFacetsBuilder
    implements
        Builder<SearchSalonsResponseFacets, SearchSalonsResponseFacetsBuilder> {
  _$SearchSalonsResponseFacets? _$v;

  ListBuilder<SearchSalonsResponseFacetsCategoriesInner>? _categories;
  ListBuilder<SearchSalonsResponseFacetsCategoriesInner> get categories =>
      _$this._categories ??=
          ListBuilder<SearchSalonsResponseFacetsCategoriesInner>();
  set categories(
          ListBuilder<SearchSalonsResponseFacetsCategoriesInner>? categories) =>
      _$this._categories = categories;

  ListBuilder<SearchSalonsResponseFacetsCategoriesInner>? _cities;
  ListBuilder<SearchSalonsResponseFacetsCategoriesInner> get cities =>
      _$this._cities ??=
          ListBuilder<SearchSalonsResponseFacetsCategoriesInner>();
  set cities(ListBuilder<SearchSalonsResponseFacetsCategoriesInner>? cities) =>
      _$this._cities = cities;

  ListBuilder<SearchSalonsResponseFacetsCategoriesInner>? _neighborhoods;
  ListBuilder<SearchSalonsResponseFacetsCategoriesInner> get neighborhoods =>
      _$this._neighborhoods ??=
          ListBuilder<SearchSalonsResponseFacetsCategoriesInner>();
  set neighborhoods(
          ListBuilder<SearchSalonsResponseFacetsCategoriesInner>?
              neighborhoods) =>
      _$this._neighborhoods = neighborhoods;

  ListBuilder<SearchSalonsResponseFacetsCategoriesInner>? _priceRanges;
  ListBuilder<SearchSalonsResponseFacetsCategoriesInner> get priceRanges =>
      _$this._priceRanges ??=
          ListBuilder<SearchSalonsResponseFacetsCategoriesInner>();
  set priceRanges(
          ListBuilder<SearchSalonsResponseFacetsCategoriesInner>?
              priceRanges) =>
      _$this._priceRanges = priceRanges;

  int? _openNowCount;
  int? get openNowCount => _$this._openNowCount;
  set openNowCount(int? openNowCount) => _$this._openNowCount = openNowCount;

  int? _bookableSoonCount;
  int? get bookableSoonCount => _$this._bookableSoonCount;
  set bookableSoonCount(int? bookableSoonCount) =>
      _$this._bookableSoonCount = bookableSoonCount;

  SearchSalonsResponseFacetsBuilder() {
    SearchSalonsResponseFacets._defaults(this);
  }

  SearchSalonsResponseFacetsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categories = $v.categories.toBuilder();
      _cities = $v.cities.toBuilder();
      _neighborhoods = $v.neighborhoods.toBuilder();
      _priceRanges = $v.priceRanges.toBuilder();
      _openNowCount = $v.openNowCount;
      _bookableSoonCount = $v.bookableSoonCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchSalonsResponseFacets other) {
    _$v = other as _$SearchSalonsResponseFacets;
  }

  @override
  void update(void Function(SearchSalonsResponseFacetsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchSalonsResponseFacets build() => _build();

  _$SearchSalonsResponseFacets _build() {
    _$SearchSalonsResponseFacets _$result;
    try {
      _$result = _$v ??
          _$SearchSalonsResponseFacets._(
            categories: categories.build(),
            cities: cities.build(),
            neighborhoods: neighborhoods.build(),
            priceRanges: priceRanges.build(),
            openNowCount: BuiltValueNullFieldError.checkNotNull(
                openNowCount, r'SearchSalonsResponseFacets', 'openNowCount'),
            bookableSoonCount: BuiltValueNullFieldError.checkNotNull(
                bookableSoonCount,
                r'SearchSalonsResponseFacets',
                'bookableSoonCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();
        _$failedField = 'cities';
        cities.build();
        _$failedField = 'neighborhoods';
        neighborhoods.build();
        _$failedField = 'priceRanges';
        priceRanges.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SearchSalonsResponseFacets', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
