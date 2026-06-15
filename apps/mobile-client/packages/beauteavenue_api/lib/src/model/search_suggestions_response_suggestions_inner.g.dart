// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_suggestions_response_suggestions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SearchSuggestionsResponseSuggestionsInnerTypeEnum
    _$searchSuggestionsResponseSuggestionsInnerTypeEnum_salon =
    const SearchSuggestionsResponseSuggestionsInnerTypeEnum._('salon');
const SearchSuggestionsResponseSuggestionsInnerTypeEnum
    _$searchSuggestionsResponseSuggestionsInnerTypeEnum_service =
    const SearchSuggestionsResponseSuggestionsInnerTypeEnum._('service');
const SearchSuggestionsResponseSuggestionsInnerTypeEnum
    _$searchSuggestionsResponseSuggestionsInnerTypeEnum_category =
    const SearchSuggestionsResponseSuggestionsInnerTypeEnum._('category');
const SearchSuggestionsResponseSuggestionsInnerTypeEnum
    _$searchSuggestionsResponseSuggestionsInnerTypeEnum_neighborhood =
    const SearchSuggestionsResponseSuggestionsInnerTypeEnum._('neighborhood');
const SearchSuggestionsResponseSuggestionsInnerTypeEnum
    _$searchSuggestionsResponseSuggestionsInnerTypeEnum_city =
    const SearchSuggestionsResponseSuggestionsInnerTypeEnum._('city');
const SearchSuggestionsResponseSuggestionsInnerTypeEnum
    _$searchSuggestionsResponseSuggestionsInnerTypeEnum_recent =
    const SearchSuggestionsResponseSuggestionsInnerTypeEnum._('recent');

SearchSuggestionsResponseSuggestionsInnerTypeEnum
    _$searchSuggestionsResponseSuggestionsInnerTypeEnumValueOf(String name) {
  switch (name) {
    case 'salon':
      return _$searchSuggestionsResponseSuggestionsInnerTypeEnum_salon;
    case 'service':
      return _$searchSuggestionsResponseSuggestionsInnerTypeEnum_service;
    case 'category':
      return _$searchSuggestionsResponseSuggestionsInnerTypeEnum_category;
    case 'neighborhood':
      return _$searchSuggestionsResponseSuggestionsInnerTypeEnum_neighborhood;
    case 'city':
      return _$searchSuggestionsResponseSuggestionsInnerTypeEnum_city;
    case 'recent':
      return _$searchSuggestionsResponseSuggestionsInnerTypeEnum_recent;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchSuggestionsResponseSuggestionsInnerTypeEnum>
    _$searchSuggestionsResponseSuggestionsInnerTypeEnumValues = BuiltSet<
        SearchSuggestionsResponseSuggestionsInnerTypeEnum>(const <SearchSuggestionsResponseSuggestionsInnerTypeEnum>[
  _$searchSuggestionsResponseSuggestionsInnerTypeEnum_salon,
  _$searchSuggestionsResponseSuggestionsInnerTypeEnum_service,
  _$searchSuggestionsResponseSuggestionsInnerTypeEnum_category,
  _$searchSuggestionsResponseSuggestionsInnerTypeEnum_neighborhood,
  _$searchSuggestionsResponseSuggestionsInnerTypeEnum_city,
  _$searchSuggestionsResponseSuggestionsInnerTypeEnum_recent,
]);

Serializer<SearchSuggestionsResponseSuggestionsInnerTypeEnum>
    _$searchSuggestionsResponseSuggestionsInnerTypeEnumSerializer =
    _$SearchSuggestionsResponseSuggestionsInnerTypeEnumSerializer();

class _$SearchSuggestionsResponseSuggestionsInnerTypeEnumSerializer
    implements
        PrimitiveSerializer<SearchSuggestionsResponseSuggestionsInnerTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'salon': 'salon',
    'service': 'service',
    'category': 'category',
    'neighborhood': 'neighborhood',
    'city': 'city',
    'recent': 'recent',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'salon': 'salon',
    'service': 'service',
    'category': 'category',
    'neighborhood': 'neighborhood',
    'city': 'city',
    'recent': 'recent',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SearchSuggestionsResponseSuggestionsInnerTypeEnum
  ];
  @override
  final String wireName = 'SearchSuggestionsResponseSuggestionsInnerTypeEnum';

  @override
  Object serialize(Serializers serializers,
          SearchSuggestionsResponseSuggestionsInnerTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchSuggestionsResponseSuggestionsInnerTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchSuggestionsResponseSuggestionsInnerTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchSuggestionsResponseSuggestionsInner
    extends SearchSuggestionsResponseSuggestionsInner {
  @override
  final String text;
  @override
  final SearchSuggestionsResponseSuggestionsInnerTypeEnum type;
  @override
  final String? salonId;
  @override
  final String? logoUrl;
  @override
  final String? subtitle;

  factory _$SearchSuggestionsResponseSuggestionsInner(
          [void Function(SearchSuggestionsResponseSuggestionsInnerBuilder)?
              updates]) =>
      (SearchSuggestionsResponseSuggestionsInnerBuilder()..update(updates))
          ._build();

  _$SearchSuggestionsResponseSuggestionsInner._(
      {required this.text,
      required this.type,
      this.salonId,
      this.logoUrl,
      this.subtitle})
      : super._();
  @override
  SearchSuggestionsResponseSuggestionsInner rebuild(
          void Function(SearchSuggestionsResponseSuggestionsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchSuggestionsResponseSuggestionsInnerBuilder toBuilder() =>
      SearchSuggestionsResponseSuggestionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchSuggestionsResponseSuggestionsInner &&
        text == other.text &&
        type == other.type &&
        salonId == other.salonId &&
        logoUrl == other.logoUrl &&
        subtitle == other.subtitle;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, subtitle.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'SearchSuggestionsResponseSuggestionsInner')
          ..add('text', text)
          ..add('type', type)
          ..add('salonId', salonId)
          ..add('logoUrl', logoUrl)
          ..add('subtitle', subtitle))
        .toString();
  }
}

class SearchSuggestionsResponseSuggestionsInnerBuilder
    implements
        Builder<SearchSuggestionsResponseSuggestionsInner,
            SearchSuggestionsResponseSuggestionsInnerBuilder> {
  _$SearchSuggestionsResponseSuggestionsInner? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  SearchSuggestionsResponseSuggestionsInnerTypeEnum? _type;
  SearchSuggestionsResponseSuggestionsInnerTypeEnum? get type => _$this._type;
  set type(SearchSuggestionsResponseSuggestionsInnerTypeEnum? type) =>
      _$this._type = type;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  String? _subtitle;
  String? get subtitle => _$this._subtitle;
  set subtitle(String? subtitle) => _$this._subtitle = subtitle;

  SearchSuggestionsResponseSuggestionsInnerBuilder() {
    SearchSuggestionsResponseSuggestionsInner._defaults(this);
  }

  SearchSuggestionsResponseSuggestionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _type = $v.type;
      _salonId = $v.salonId;
      _logoUrl = $v.logoUrl;
      _subtitle = $v.subtitle;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchSuggestionsResponseSuggestionsInner other) {
    _$v = other as _$SearchSuggestionsResponseSuggestionsInner;
  }

  @override
  void update(
      void Function(SearchSuggestionsResponseSuggestionsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchSuggestionsResponseSuggestionsInner build() => _build();

  _$SearchSuggestionsResponseSuggestionsInner _build() {
    final _$result = _$v ??
        _$SearchSuggestionsResponseSuggestionsInner._(
          text: BuiltValueNullFieldError.checkNotNull(
              text, r'SearchSuggestionsResponseSuggestionsInner', 'text'),
          type: BuiltValueNullFieldError.checkNotNull(
              type, r'SearchSuggestionsResponseSuggestionsInner', 'type'),
          salonId: salonId,
          logoUrl: logoUrl,
          subtitle: subtitle,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
