// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_salons_response_facets_categories_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchSalonsResponseFacetsCategoriesInner
    extends SearchSalonsResponseFacetsCategoriesInner {
  @override
  final String value;
  @override
  final int count;
  @override
  final bool? active;

  factory _$SearchSalonsResponseFacetsCategoriesInner(
          [void Function(SearchSalonsResponseFacetsCategoriesInnerBuilder)?
              updates]) =>
      (SearchSalonsResponseFacetsCategoriesInnerBuilder()..update(updates))
          ._build();

  _$SearchSalonsResponseFacetsCategoriesInner._(
      {required this.value, required this.count, this.active})
      : super._();
  @override
  SearchSalonsResponseFacetsCategoriesInner rebuild(
          void Function(SearchSalonsResponseFacetsCategoriesInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchSalonsResponseFacetsCategoriesInnerBuilder toBuilder() =>
      SearchSalonsResponseFacetsCategoriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchSalonsResponseFacetsCategoriesInner &&
        value == other.value &&
        count == other.count &&
        active == other.active;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'SearchSalonsResponseFacetsCategoriesInner')
          ..add('value', value)
          ..add('count', count)
          ..add('active', active))
        .toString();
  }
}

class SearchSalonsResponseFacetsCategoriesInnerBuilder
    implements
        Builder<SearchSalonsResponseFacetsCategoriesInner,
            SearchSalonsResponseFacetsCategoriesInnerBuilder> {
  _$SearchSalonsResponseFacetsCategoriesInner? _$v;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  SearchSalonsResponseFacetsCategoriesInnerBuilder() {
    SearchSalonsResponseFacetsCategoriesInner._defaults(this);
  }

  SearchSalonsResponseFacetsCategoriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _count = $v.count;
      _active = $v.active;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchSalonsResponseFacetsCategoriesInner other) {
    _$v = other as _$SearchSalonsResponseFacetsCategoriesInner;
  }

  @override
  void update(
      void Function(SearchSalonsResponseFacetsCategoriesInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchSalonsResponseFacetsCategoriesInner build() => _build();

  _$SearchSalonsResponseFacetsCategoriesInner _build() {
    final _$result = _$v ??
        _$SearchSalonsResponseFacetsCategoriesInner._(
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'SearchSalonsResponseFacetsCategoriesInner', 'value'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'SearchSalonsResponseFacetsCategoriesInner', 'count'),
          active: active,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
