// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_suggestions_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchSuggestionsResponse extends SearchSuggestionsResponse {
  @override
  final String normalizedQuery;
  @override
  final String? didYouMean;
  @override
  final BuiltList<SearchSuggestionsResponseSuggestionsInner> suggestions;
  @override
  final BuiltList<SearchSuggestionsResponseEntityHintsInner> entityHints;
  @override
  final BuiltList<SearchSuggestionsResponseTopMatchesInner> topMatches;

  factory _$SearchSuggestionsResponse(
          [void Function(SearchSuggestionsResponseBuilder)? updates]) =>
      (SearchSuggestionsResponseBuilder()..update(updates))._build();

  _$SearchSuggestionsResponse._(
      {required this.normalizedQuery,
      this.didYouMean,
      required this.suggestions,
      required this.entityHints,
      required this.topMatches})
      : super._();
  @override
  SearchSuggestionsResponse rebuild(
          void Function(SearchSuggestionsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchSuggestionsResponseBuilder toBuilder() =>
      SearchSuggestionsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchSuggestionsResponse &&
        normalizedQuery == other.normalizedQuery &&
        didYouMean == other.didYouMean &&
        suggestions == other.suggestions &&
        entityHints == other.entityHints &&
        topMatches == other.topMatches;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, normalizedQuery.hashCode);
    _$hash = $jc(_$hash, didYouMean.hashCode);
    _$hash = $jc(_$hash, suggestions.hashCode);
    _$hash = $jc(_$hash, entityHints.hashCode);
    _$hash = $jc(_$hash, topMatches.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchSuggestionsResponse')
          ..add('normalizedQuery', normalizedQuery)
          ..add('didYouMean', didYouMean)
          ..add('suggestions', suggestions)
          ..add('entityHints', entityHints)
          ..add('topMatches', topMatches))
        .toString();
  }
}

class SearchSuggestionsResponseBuilder
    implements
        Builder<SearchSuggestionsResponse, SearchSuggestionsResponseBuilder> {
  _$SearchSuggestionsResponse? _$v;

  String? _normalizedQuery;
  String? get normalizedQuery => _$this._normalizedQuery;
  set normalizedQuery(String? normalizedQuery) =>
      _$this._normalizedQuery = normalizedQuery;

  String? _didYouMean;
  String? get didYouMean => _$this._didYouMean;
  set didYouMean(String? didYouMean) => _$this._didYouMean = didYouMean;

  ListBuilder<SearchSuggestionsResponseSuggestionsInner>? _suggestions;
  ListBuilder<SearchSuggestionsResponseSuggestionsInner> get suggestions =>
      _$this._suggestions ??=
          ListBuilder<SearchSuggestionsResponseSuggestionsInner>();
  set suggestions(
          ListBuilder<SearchSuggestionsResponseSuggestionsInner>?
              suggestions) =>
      _$this._suggestions = suggestions;

  ListBuilder<SearchSuggestionsResponseEntityHintsInner>? _entityHints;
  ListBuilder<SearchSuggestionsResponseEntityHintsInner> get entityHints =>
      _$this._entityHints ??=
          ListBuilder<SearchSuggestionsResponseEntityHintsInner>();
  set entityHints(
          ListBuilder<SearchSuggestionsResponseEntityHintsInner>?
              entityHints) =>
      _$this._entityHints = entityHints;

  ListBuilder<SearchSuggestionsResponseTopMatchesInner>? _topMatches;
  ListBuilder<SearchSuggestionsResponseTopMatchesInner> get topMatches =>
      _$this._topMatches ??=
          ListBuilder<SearchSuggestionsResponseTopMatchesInner>();
  set topMatches(
          ListBuilder<SearchSuggestionsResponseTopMatchesInner>? topMatches) =>
      _$this._topMatches = topMatches;

  SearchSuggestionsResponseBuilder() {
    SearchSuggestionsResponse._defaults(this);
  }

  SearchSuggestionsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _normalizedQuery = $v.normalizedQuery;
      _didYouMean = $v.didYouMean;
      _suggestions = $v.suggestions.toBuilder();
      _entityHints = $v.entityHints.toBuilder();
      _topMatches = $v.topMatches.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchSuggestionsResponse other) {
    _$v = other as _$SearchSuggestionsResponse;
  }

  @override
  void update(void Function(SearchSuggestionsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchSuggestionsResponse build() => _build();

  _$SearchSuggestionsResponse _build() {
    _$SearchSuggestionsResponse _$result;
    try {
      _$result = _$v ??
          _$SearchSuggestionsResponse._(
            normalizedQuery: BuiltValueNullFieldError.checkNotNull(
                normalizedQuery,
                r'SearchSuggestionsResponse',
                'normalizedQuery'),
            didYouMean: didYouMean,
            suggestions: suggestions.build(),
            entityHints: entityHints.build(),
            topMatches: topMatches.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'suggestions';
        suggestions.build();
        _$failedField = 'entityHints';
        entityHints.build();
        _$failedField = 'topMatches';
        topMatches.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SearchSuggestionsResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
