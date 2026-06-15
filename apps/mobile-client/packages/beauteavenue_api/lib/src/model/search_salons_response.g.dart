// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_salons_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchSalonsResponse extends SearchSalonsResponse {
  @override
  final SearchSalonsResponseQuery query;
  @override
  final SearchSalonsResponseFacets facets;
  @override
  final BuiltList<SearchSuggestionsResponseTopMatchesInner> results;
  @override
  final BuiltList<SearchSalonsResponseModulesInner> modules;
  @override
  final SearchSalonsResponsePageInfo pageInfo;

  factory _$SearchSalonsResponse(
          [void Function(SearchSalonsResponseBuilder)? updates]) =>
      (SearchSalonsResponseBuilder()..update(updates))._build();

  _$SearchSalonsResponse._(
      {required this.query,
      required this.facets,
      required this.results,
      required this.modules,
      required this.pageInfo})
      : super._();
  @override
  SearchSalonsResponse rebuild(
          void Function(SearchSalonsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchSalonsResponseBuilder toBuilder() =>
      SearchSalonsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchSalonsResponse &&
        query == other.query &&
        facets == other.facets &&
        results == other.results &&
        modules == other.modules &&
        pageInfo == other.pageInfo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, query.hashCode);
    _$hash = $jc(_$hash, facets.hashCode);
    _$hash = $jc(_$hash, results.hashCode);
    _$hash = $jc(_$hash, modules.hashCode);
    _$hash = $jc(_$hash, pageInfo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchSalonsResponse')
          ..add('query', query)
          ..add('facets', facets)
          ..add('results', results)
          ..add('modules', modules)
          ..add('pageInfo', pageInfo))
        .toString();
  }
}

class SearchSalonsResponseBuilder
    implements Builder<SearchSalonsResponse, SearchSalonsResponseBuilder> {
  _$SearchSalonsResponse? _$v;

  SearchSalonsResponseQueryBuilder? _query;
  SearchSalonsResponseQueryBuilder get query =>
      _$this._query ??= SearchSalonsResponseQueryBuilder();
  set query(SearchSalonsResponseQueryBuilder? query) => _$this._query = query;

  SearchSalonsResponseFacetsBuilder? _facets;
  SearchSalonsResponseFacetsBuilder get facets =>
      _$this._facets ??= SearchSalonsResponseFacetsBuilder();
  set facets(SearchSalonsResponseFacetsBuilder? facets) =>
      _$this._facets = facets;

  ListBuilder<SearchSuggestionsResponseTopMatchesInner>? _results;
  ListBuilder<SearchSuggestionsResponseTopMatchesInner> get results =>
      _$this._results ??=
          ListBuilder<SearchSuggestionsResponseTopMatchesInner>();
  set results(ListBuilder<SearchSuggestionsResponseTopMatchesInner>? results) =>
      _$this._results = results;

  ListBuilder<SearchSalonsResponseModulesInner>? _modules;
  ListBuilder<SearchSalonsResponseModulesInner> get modules =>
      _$this._modules ??= ListBuilder<SearchSalonsResponseModulesInner>();
  set modules(ListBuilder<SearchSalonsResponseModulesInner>? modules) =>
      _$this._modules = modules;

  SearchSalonsResponsePageInfoBuilder? _pageInfo;
  SearchSalonsResponsePageInfoBuilder get pageInfo =>
      _$this._pageInfo ??= SearchSalonsResponsePageInfoBuilder();
  set pageInfo(SearchSalonsResponsePageInfoBuilder? pageInfo) =>
      _$this._pageInfo = pageInfo;

  SearchSalonsResponseBuilder() {
    SearchSalonsResponse._defaults(this);
  }

  SearchSalonsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _query = $v.query.toBuilder();
      _facets = $v.facets.toBuilder();
      _results = $v.results.toBuilder();
      _modules = $v.modules.toBuilder();
      _pageInfo = $v.pageInfo.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchSalonsResponse other) {
    _$v = other as _$SearchSalonsResponse;
  }

  @override
  void update(void Function(SearchSalonsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchSalonsResponse build() => _build();

  _$SearchSalonsResponse _build() {
    _$SearchSalonsResponse _$result;
    try {
      _$result = _$v ??
          _$SearchSalonsResponse._(
            query: query.build(),
            facets: facets.build(),
            results: results.build(),
            modules: modules.build(),
            pageInfo: pageInfo.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'query';
        query.build();
        _$failedField = 'facets';
        facets.build();
        _$failedField = 'results';
        results.build();
        _$failedField = 'modules';
        modules.build();
        _$failedField = 'pageInfo';
        pageInfo.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SearchSalonsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
