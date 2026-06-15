// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_salons_response_query.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchSalonsResponseQuery extends SearchSalonsResponseQuery {
  @override
  final String normalized;
  @override
  final String? corrected;
  @override
  final BuiltList<SearchSuggestionsResponseEntityHintsInner>
      interpretedEntities;

  factory _$SearchSalonsResponseQuery(
          [void Function(SearchSalonsResponseQueryBuilder)? updates]) =>
      (SearchSalonsResponseQueryBuilder()..update(updates))._build();

  _$SearchSalonsResponseQuery._(
      {required this.normalized,
      this.corrected,
      required this.interpretedEntities})
      : super._();
  @override
  SearchSalonsResponseQuery rebuild(
          void Function(SearchSalonsResponseQueryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchSalonsResponseQueryBuilder toBuilder() =>
      SearchSalonsResponseQueryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchSalonsResponseQuery &&
        normalized == other.normalized &&
        corrected == other.corrected &&
        interpretedEntities == other.interpretedEntities;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, normalized.hashCode);
    _$hash = $jc(_$hash, corrected.hashCode);
    _$hash = $jc(_$hash, interpretedEntities.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchSalonsResponseQuery')
          ..add('normalized', normalized)
          ..add('corrected', corrected)
          ..add('interpretedEntities', interpretedEntities))
        .toString();
  }
}

class SearchSalonsResponseQueryBuilder
    implements
        Builder<SearchSalonsResponseQuery, SearchSalonsResponseQueryBuilder> {
  _$SearchSalonsResponseQuery? _$v;

  String? _normalized;
  String? get normalized => _$this._normalized;
  set normalized(String? normalized) => _$this._normalized = normalized;

  String? _corrected;
  String? get corrected => _$this._corrected;
  set corrected(String? corrected) => _$this._corrected = corrected;

  ListBuilder<SearchSuggestionsResponseEntityHintsInner>? _interpretedEntities;
  ListBuilder<SearchSuggestionsResponseEntityHintsInner>
      get interpretedEntities => _$this._interpretedEntities ??=
          ListBuilder<SearchSuggestionsResponseEntityHintsInner>();
  set interpretedEntities(
          ListBuilder<SearchSuggestionsResponseEntityHintsInner>?
              interpretedEntities) =>
      _$this._interpretedEntities = interpretedEntities;

  SearchSalonsResponseQueryBuilder() {
    SearchSalonsResponseQuery._defaults(this);
  }

  SearchSalonsResponseQueryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _normalized = $v.normalized;
      _corrected = $v.corrected;
      _interpretedEntities = $v.interpretedEntities.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchSalonsResponseQuery other) {
    _$v = other as _$SearchSalonsResponseQuery;
  }

  @override
  void update(void Function(SearchSalonsResponseQueryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchSalonsResponseQuery build() => _build();

  _$SearchSalonsResponseQuery _build() {
    _$SearchSalonsResponseQuery _$result;
    try {
      _$result = _$v ??
          _$SearchSalonsResponseQuery._(
            normalized: BuiltValueNullFieldError.checkNotNull(
                normalized, r'SearchSalonsResponseQuery', 'normalized'),
            corrected: corrected,
            interpretedEntities: interpretedEntities.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'interpretedEntities';
        interpretedEntities.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SearchSalonsResponseQuery', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
