// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_events_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchEventsRequest extends SearchEventsRequest {
  @override
  final BuiltList<SearchEventsRequestEventsInner> events;

  factory _$SearchEventsRequest(
          [void Function(SearchEventsRequestBuilder)? updates]) =>
      (SearchEventsRequestBuilder()..update(updates))._build();

  _$SearchEventsRequest._({required this.events}) : super._();
  @override
  SearchEventsRequest rebuild(
          void Function(SearchEventsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchEventsRequestBuilder toBuilder() =>
      SearchEventsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchEventsRequest && events == other.events;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, events.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchEventsRequest')
          ..add('events', events))
        .toString();
  }
}

class SearchEventsRequestBuilder
    implements Builder<SearchEventsRequest, SearchEventsRequestBuilder> {
  _$SearchEventsRequest? _$v;

  ListBuilder<SearchEventsRequestEventsInner>? _events;
  ListBuilder<SearchEventsRequestEventsInner> get events =>
      _$this._events ??= ListBuilder<SearchEventsRequestEventsInner>();
  set events(ListBuilder<SearchEventsRequestEventsInner>? events) =>
      _$this._events = events;

  SearchEventsRequestBuilder() {
    SearchEventsRequest._defaults(this);
  }

  SearchEventsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _events = $v.events.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchEventsRequest other) {
    _$v = other as _$SearchEventsRequest;
  }

  @override
  void update(void Function(SearchEventsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchEventsRequest build() => _build();

  _$SearchEventsRequest _build() {
    _$SearchEventsRequest _$result;
    try {
      _$result = _$v ??
          _$SearchEventsRequest._(
            events: events.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'events';
        events.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SearchEventsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
