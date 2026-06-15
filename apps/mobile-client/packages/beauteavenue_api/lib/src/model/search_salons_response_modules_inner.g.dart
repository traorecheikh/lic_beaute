// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_salons_response_modules_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SearchSalonsResponseModulesInnerTypeEnum
    _$searchSalonsResponseModulesInnerTypeEnum_nearYou =
    const SearchSalonsResponseModulesInnerTypeEnum._('nearYou');
const SearchSalonsResponseModulesInnerTypeEnum
    _$searchSalonsResponseModulesInnerTypeEnum_bookableNow =
    const SearchSalonsResponseModulesInnerTypeEnum._('bookableNow');
const SearchSalonsResponseModulesInnerTypeEnum
    _$searchSalonsResponseModulesInnerTypeEnum_prestigeForQuery =
    const SearchSalonsResponseModulesInnerTypeEnum._('prestigeForQuery');
const SearchSalonsResponseModulesInnerTypeEnum
    _$searchSalonsResponseModulesInnerTypeEnum_trendingForQuery =
    const SearchSalonsResponseModulesInnerTypeEnum._('trendingForQuery');
const SearchSalonsResponseModulesInnerTypeEnum
    _$searchSalonsResponseModulesInnerTypeEnum_continueExploring =
    const SearchSalonsResponseModulesInnerTypeEnum._('continueExploring');

SearchSalonsResponseModulesInnerTypeEnum
    _$searchSalonsResponseModulesInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'nearYou':
      return _$searchSalonsResponseModulesInnerTypeEnum_nearYou;
    case 'bookableNow':
      return _$searchSalonsResponseModulesInnerTypeEnum_bookableNow;
    case 'prestigeForQuery':
      return _$searchSalonsResponseModulesInnerTypeEnum_prestigeForQuery;
    case 'trendingForQuery':
      return _$searchSalonsResponseModulesInnerTypeEnum_trendingForQuery;
    case 'continueExploring':
      return _$searchSalonsResponseModulesInnerTypeEnum_continueExploring;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchSalonsResponseModulesInnerTypeEnum>
    _$searchSalonsResponseModulesInnerTypeEnumValues = BuiltSet<
        SearchSalonsResponseModulesInnerTypeEnum>(const <SearchSalonsResponseModulesInnerTypeEnum>[
  _$searchSalonsResponseModulesInnerTypeEnum_nearYou,
  _$searchSalonsResponseModulesInnerTypeEnum_bookableNow,
  _$searchSalonsResponseModulesInnerTypeEnum_prestigeForQuery,
  _$searchSalonsResponseModulesInnerTypeEnum_trendingForQuery,
  _$searchSalonsResponseModulesInnerTypeEnum_continueExploring,
]);

Serializer<SearchSalonsResponseModulesInnerTypeEnum>
    _$searchSalonsResponseModulesInnerTypeEnumSerializer =
    _$SearchSalonsResponseModulesInnerTypeEnumSerializer();

class _$SearchSalonsResponseModulesInnerTypeEnumSerializer
    implements PrimitiveSerializer<SearchSalonsResponseModulesInnerTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'nearYou': 'near_you',
    'bookableNow': 'bookable_now',
    'prestigeForQuery': 'prestige_for_query',
    'trendingForQuery': 'trending_for_query',
    'continueExploring': 'continue_exploring',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'near_you': 'nearYou',
    'bookable_now': 'bookableNow',
    'prestige_for_query': 'prestigeForQuery',
    'trending_for_query': 'trendingForQuery',
    'continue_exploring': 'continueExploring',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SearchSalonsResponseModulesInnerTypeEnum
  ];
  @override
  final String wireName = 'SearchSalonsResponseModulesInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          SearchSalonsResponseModulesInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchSalonsResponseModulesInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchSalonsResponseModulesInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchSalonsResponseModulesInner
    extends SearchSalonsResponseModulesInner {
  @override
  final SearchSalonsResponseModulesInnerTypeEnum type;
  @override
  final String title;
  @override
  final BuiltList<SearchSuggestionsResponseTopMatchesInner> items;

  factory _$SearchSalonsResponseModulesInner(
          [void Function(SearchSalonsResponseModulesInnerBuilder)? updates]) =>
      (SearchSalonsResponseModulesInnerBuilder()..update(updates))._build();

  _$SearchSalonsResponseModulesInner._(
      {required this.type, required this.title, required this.items})
      : super._();
  @override
  SearchSalonsResponseModulesInner rebuild(
          void Function(SearchSalonsResponseModulesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchSalonsResponseModulesInnerBuilder toBuilder() =>
      SearchSalonsResponseModulesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchSalonsResponseModulesInner &&
        type == other.type &&
        title == other.title &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchSalonsResponseModulesInner')
          ..add('type', type)
          ..add('title', title)
          ..add('items', items))
        .toString();
  }
}

class SearchSalonsResponseModulesInnerBuilder
    implements
        Builder<SearchSalonsResponseModulesInner,
            SearchSalonsResponseModulesInnerBuilder> {
  _$SearchSalonsResponseModulesInner? _$v;

  SearchSalonsResponseModulesInnerTypeEnum? _type;
  SearchSalonsResponseModulesInnerTypeEnum? get type => _$this._type;
  set type(SearchSalonsResponseModulesInnerTypeEnum? type) =>
      _$this._type = type;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  ListBuilder<SearchSuggestionsResponseTopMatchesInner>? _items;
  ListBuilder<SearchSuggestionsResponseTopMatchesInner> get items =>
      _$this._items ??= ListBuilder<SearchSuggestionsResponseTopMatchesInner>();
  set items(ListBuilder<SearchSuggestionsResponseTopMatchesInner>? items) =>
      _$this._items = items;

  SearchSalonsResponseModulesInnerBuilder() {
    SearchSalonsResponseModulesInner._defaults(this);
  }

  SearchSalonsResponseModulesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _title = $v.title;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchSalonsResponseModulesInner other) {
    _$v = other as _$SearchSalonsResponseModulesInner;
  }

  @override
  void update(void Function(SearchSalonsResponseModulesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchSalonsResponseModulesInner build() => _build();

  _$SearchSalonsResponseModulesInner _build() {
    _$SearchSalonsResponseModulesInner _$result;
    try {
      _$result = _$v ??
          _$SearchSalonsResponseModulesInner._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'SearchSalonsResponseModulesInner', 'type'),
            title: BuiltValueNullFieldError.checkNotNull(
                title, r'SearchSalonsResponseModulesInner', 'title'),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SearchSalonsResponseModulesInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
