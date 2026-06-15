// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_suggestions_response_entity_hints_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SearchSuggestionsResponseEntityHintsInnerTypeEnum
    _$searchSuggestionsResponseEntityHintsInnerTypeEnum_category =
    const SearchSuggestionsResponseEntityHintsInnerTypeEnum._('category');
const SearchSuggestionsResponseEntityHintsInnerTypeEnum
    _$searchSuggestionsResponseEntityHintsInnerTypeEnum_city =
    const SearchSuggestionsResponseEntityHintsInnerTypeEnum._('city');
const SearchSuggestionsResponseEntityHintsInnerTypeEnum
    _$searchSuggestionsResponseEntityHintsInnerTypeEnum_neighborhood =
    const SearchSuggestionsResponseEntityHintsInnerTypeEnum._('neighborhood');

SearchSuggestionsResponseEntityHintsInnerTypeEnum
    _$searchSuggestionsResponseEntityHintsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'category':
      return _$searchSuggestionsResponseEntityHintsInnerTypeEnum_category;
    case 'city':
      return _$searchSuggestionsResponseEntityHintsInnerTypeEnum_city;
    case 'neighborhood':
      return _$searchSuggestionsResponseEntityHintsInnerTypeEnum_neighborhood;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchSuggestionsResponseEntityHintsInnerTypeEnum>
    _$searchSuggestionsResponseEntityHintsInnerTypeEnumValues = BuiltSet<
        SearchSuggestionsResponseEntityHintsInnerTypeEnum>(const <SearchSuggestionsResponseEntityHintsInnerTypeEnum>[
  _$searchSuggestionsResponseEntityHintsInnerTypeEnum_category,
  _$searchSuggestionsResponseEntityHintsInnerTypeEnum_city,
  _$searchSuggestionsResponseEntityHintsInnerTypeEnum_neighborhood,
]);

Serializer<SearchSuggestionsResponseEntityHintsInnerTypeEnum>
    _$searchSuggestionsResponseEntityHintsInnerTypeEnumSerializer =
    _$SearchSuggestionsResponseEntityHintsInnerTypeEnumSerializer();

class _$SearchSuggestionsResponseEntityHintsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<SearchSuggestionsResponseEntityHintsInnerTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'category': 'category',
    'city': 'city',
    'neighborhood': 'neighborhood',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'category': 'category',
    'city': 'city',
    'neighborhood': 'neighborhood',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SearchSuggestionsResponseEntityHintsInnerTypeEnum
  ];
  @override
  final String wireName = 'SearchSuggestionsResponseEntityHintsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          SearchSuggestionsResponseEntityHintsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchSuggestionsResponseEntityHintsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchSuggestionsResponseEntityHintsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchSuggestionsResponseEntityHintsInner
    extends SearchSuggestionsResponseEntityHintsInner {
  @override
  final SearchSuggestionsResponseEntityHintsInnerTypeEnum type;
  @override
  final String value;
  @override
  final int count;

  factory _$SearchSuggestionsResponseEntityHintsInner(
          [void Function(SearchSuggestionsResponseEntityHintsInnerBuilder)?
              updates]) =>
      (SearchSuggestionsResponseEntityHintsInnerBuilder()..update(updates))
          ._build();

  _$SearchSuggestionsResponseEntityHintsInner._(
      {required this.type, required this.value, required this.count})
      : super._();
  @override
  SearchSuggestionsResponseEntityHintsInner rebuild(
          void Function(SearchSuggestionsResponseEntityHintsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchSuggestionsResponseEntityHintsInnerBuilder toBuilder() =>
      SearchSuggestionsResponseEntityHintsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchSuggestionsResponseEntityHintsInner &&
        type == other.type &&
        value == other.value &&
        count == other.count;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'SearchSuggestionsResponseEntityHintsInner')
          ..add('type', type)
          ..add('value', value)
          ..add('count', count))
        .toString();
  }
}

class SearchSuggestionsResponseEntityHintsInnerBuilder
    implements
        Builder<SearchSuggestionsResponseEntityHintsInner,
            SearchSuggestionsResponseEntityHintsInnerBuilder> {
  _$SearchSuggestionsResponseEntityHintsInner? _$v;

  SearchSuggestionsResponseEntityHintsInnerTypeEnum? _type;
  SearchSuggestionsResponseEntityHintsInnerTypeEnum? get type => _$this._type;
  set type(SearchSuggestionsResponseEntityHintsInnerTypeEnum? type) =>
      _$this._type = type;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  SearchSuggestionsResponseEntityHintsInnerBuilder() {
    SearchSuggestionsResponseEntityHintsInner._defaults(this);
  }

  SearchSuggestionsResponseEntityHintsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _value = $v.value;
      _count = $v.count;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchSuggestionsResponseEntityHintsInner other) {
    _$v = other as _$SearchSuggestionsResponseEntityHintsInner;
  }

  @override
  void update(
      void Function(SearchSuggestionsResponseEntityHintsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchSuggestionsResponseEntityHintsInner build() => _build();

  _$SearchSuggestionsResponseEntityHintsInner _build() {
    final _$result = _$v ??
        _$SearchSuggestionsResponseEntityHintsInner._(
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'SearchSuggestionsResponseEntityHintsInner', 'type'),
          value: BuiltValueNullFieldError.checkNotNull(
              value, r'SearchSuggestionsResponseEntityHintsInner', 'value'),
          count: BuiltValueNullFieldError.checkNotNull(
              count, r'SearchSuggestionsResponseEntityHintsInner', 'count'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
