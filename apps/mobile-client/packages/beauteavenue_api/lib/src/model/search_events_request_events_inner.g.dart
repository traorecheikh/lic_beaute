// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_events_request_events_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SearchEventsRequestEventsInnerEventTypeEnum
    _$searchEventsRequestEventsInnerEventTypeEnum_searchSubmitted =
    const SearchEventsRequestEventsInnerEventTypeEnum._('searchSubmitted');
const SearchEventsRequestEventsInnerEventTypeEnum
    _$searchEventsRequestEventsInnerEventTypeEnum_suggestionTapped =
    const SearchEventsRequestEventsInnerEventTypeEnum._('suggestionTapped');
const SearchEventsRequestEventsInnerEventTypeEnum
    _$searchEventsRequestEventsInnerEventTypeEnum_filterApplied =
    const SearchEventsRequestEventsInnerEventTypeEnum._('filterApplied');
const SearchEventsRequestEventsInnerEventTypeEnum
    _$searchEventsRequestEventsInnerEventTypeEnum_resultOpened =
    const SearchEventsRequestEventsInnerEventTypeEnum._('resultOpened');
const SearchEventsRequestEventsInnerEventTypeEnum
    _$searchEventsRequestEventsInnerEventTypeEnum_moduleItemOpened =
    const SearchEventsRequestEventsInnerEventTypeEnum._('moduleItemOpened');

SearchEventsRequestEventsInnerEventTypeEnum
    _$searchEventsRequestEventsInnerEventTypeEnumValueOf(String name) {
  switch (name) {
    case 'searchSubmitted':
      return _$searchEventsRequestEventsInnerEventTypeEnum_searchSubmitted;
    case 'suggestionTapped':
      return _$searchEventsRequestEventsInnerEventTypeEnum_suggestionTapped;
    case 'filterApplied':
      return _$searchEventsRequestEventsInnerEventTypeEnum_filterApplied;
    case 'resultOpened':
      return _$searchEventsRequestEventsInnerEventTypeEnum_resultOpened;
    case 'moduleItemOpened':
      return _$searchEventsRequestEventsInnerEventTypeEnum_moduleItemOpened;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SearchEventsRequestEventsInnerEventTypeEnum>
    _$searchEventsRequestEventsInnerEventTypeEnumValues = BuiltSet<
        SearchEventsRequestEventsInnerEventTypeEnum>(const <SearchEventsRequestEventsInnerEventTypeEnum>[
  _$searchEventsRequestEventsInnerEventTypeEnum_searchSubmitted,
  _$searchEventsRequestEventsInnerEventTypeEnum_suggestionTapped,
  _$searchEventsRequestEventsInnerEventTypeEnum_filterApplied,
  _$searchEventsRequestEventsInnerEventTypeEnum_resultOpened,
  _$searchEventsRequestEventsInnerEventTypeEnum_moduleItemOpened,
]);

Serializer<SearchEventsRequestEventsInnerEventTypeEnum>
    _$searchEventsRequestEventsInnerEventTypeEnumSerializer =
    _$SearchEventsRequestEventsInnerEventTypeEnumSerializer();

class _$SearchEventsRequestEventsInnerEventTypeEnumSerializer
    implements
        PrimitiveSerializer<SearchEventsRequestEventsInnerEventTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'searchSubmitted': 'search_submitted',
    'suggestionTapped': 'suggestion_tapped',
    'filterApplied': 'filter_applied',
    'resultOpened': 'result_opened',
    'moduleItemOpened': 'module_item_opened',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'search_submitted': 'searchSubmitted',
    'suggestion_tapped': 'suggestionTapped',
    'filter_applied': 'filterApplied',
    'result_opened': 'resultOpened',
    'module_item_opened': 'moduleItemOpened',
  };

  @override
  final Iterable<Type> types = const <Type>[
    SearchEventsRequestEventsInnerEventTypeEnum
  ];
  @override
  final String wireName = 'SearchEventsRequestEventsInnerEventTypeEnum';

  @override
  Object serialize(Serializers serializers,
          SearchEventsRequestEventsInnerEventTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SearchEventsRequestEventsInnerEventTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SearchEventsRequestEventsInnerEventTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$SearchEventsRequestEventsInner extends SearchEventsRequestEventsInner {
  @override
  final String sessionKey;
  @override
  final SearchEventsRequestEventsInnerEventTypeEnum eventType;
  @override
  final String? query;
  @override
  final String? salonId;
  @override
  final String? category;
  @override
  final String? city;
  @override
  final int? position;
  @override
  final BuiltMap<String, JsonObject?>? metadata;

  factory _$SearchEventsRequestEventsInner(
          [void Function(SearchEventsRequestEventsInnerBuilder)? updates]) =>
      (SearchEventsRequestEventsInnerBuilder()..update(updates))._build();

  _$SearchEventsRequestEventsInner._(
      {required this.sessionKey,
      required this.eventType,
      this.query,
      this.salonId,
      this.category,
      this.city,
      this.position,
      this.metadata})
      : super._();
  @override
  SearchEventsRequestEventsInner rebuild(
          void Function(SearchEventsRequestEventsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchEventsRequestEventsInnerBuilder toBuilder() =>
      SearchEventsRequestEventsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchEventsRequestEventsInner &&
        sessionKey == other.sessionKey &&
        eventType == other.eventType &&
        query == other.query &&
        salonId == other.salonId &&
        category == other.category &&
        city == other.city &&
        position == other.position &&
        metadata == other.metadata;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sessionKey.hashCode);
    _$hash = $jc(_$hash, eventType.hashCode);
    _$hash = $jc(_$hash, query.hashCode);
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, metadata.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchEventsRequestEventsInner')
          ..add('sessionKey', sessionKey)
          ..add('eventType', eventType)
          ..add('query', query)
          ..add('salonId', salonId)
          ..add('category', category)
          ..add('city', city)
          ..add('position', position)
          ..add('metadata', metadata))
        .toString();
  }
}

class SearchEventsRequestEventsInnerBuilder
    implements
        Builder<SearchEventsRequestEventsInner,
            SearchEventsRequestEventsInnerBuilder> {
  _$SearchEventsRequestEventsInner? _$v;

  String? _sessionKey;
  String? get sessionKey => _$this._sessionKey;
  set sessionKey(String? sessionKey) => _$this._sessionKey = sessionKey;

  SearchEventsRequestEventsInnerEventTypeEnum? _eventType;
  SearchEventsRequestEventsInnerEventTypeEnum? get eventType =>
      _$this._eventType;
  set eventType(SearchEventsRequestEventsInnerEventTypeEnum? eventType) =>
      _$this._eventType = eventType;

  String? _query;
  String? get query => _$this._query;
  set query(String? query) => _$this._query = query;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  int? _position;
  int? get position => _$this._position;
  set position(int? position) => _$this._position = position;

  MapBuilder<String, JsonObject?>? _metadata;
  MapBuilder<String, JsonObject?> get metadata =>
      _$this._metadata ??= MapBuilder<String, JsonObject?>();
  set metadata(MapBuilder<String, JsonObject?>? metadata) =>
      _$this._metadata = metadata;

  SearchEventsRequestEventsInnerBuilder() {
    SearchEventsRequestEventsInner._defaults(this);
  }

  SearchEventsRequestEventsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sessionKey = $v.sessionKey;
      _eventType = $v.eventType;
      _query = $v.query;
      _salonId = $v.salonId;
      _category = $v.category;
      _city = $v.city;
      _position = $v.position;
      _metadata = $v.metadata?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchEventsRequestEventsInner other) {
    _$v = other as _$SearchEventsRequestEventsInner;
  }

  @override
  void update(void Function(SearchEventsRequestEventsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchEventsRequestEventsInner build() => _build();

  _$SearchEventsRequestEventsInner _build() {
    _$SearchEventsRequestEventsInner _$result;
    try {
      _$result = _$v ??
          _$SearchEventsRequestEventsInner._(
            sessionKey: BuiltValueNullFieldError.checkNotNull(
                sessionKey, r'SearchEventsRequestEventsInner', 'sessionKey'),
            eventType: BuiltValueNullFieldError.checkNotNull(
                eventType, r'SearchEventsRequestEventsInner', 'eventType'),
            query: query,
            salonId: salonId,
            category: category,
            city: city,
            position: position,
            metadata: _metadata?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'metadata';
        _metadata?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SearchEventsRequestEventsInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
