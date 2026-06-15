// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_events_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchEventsResponse extends SearchEventsResponse {
  @override
  final int accepted;

  factory _$SearchEventsResponse(
          [void Function(SearchEventsResponseBuilder)? updates]) =>
      (SearchEventsResponseBuilder()..update(updates))._build();

  _$SearchEventsResponse._({required this.accepted}) : super._();
  @override
  SearchEventsResponse rebuild(
          void Function(SearchEventsResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchEventsResponseBuilder toBuilder() =>
      SearchEventsResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchEventsResponse && accepted == other.accepted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchEventsResponse')
          ..add('accepted', accepted))
        .toString();
  }
}

class SearchEventsResponseBuilder
    implements Builder<SearchEventsResponse, SearchEventsResponseBuilder> {
  _$SearchEventsResponse? _$v;

  int? _accepted;
  int? get accepted => _$this._accepted;
  set accepted(int? accepted) => _$this._accepted = accepted;

  SearchEventsResponseBuilder() {
    SearchEventsResponse._defaults(this);
  }

  SearchEventsResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accepted = $v.accepted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchEventsResponse other) {
    _$v = other as _$SearchEventsResponse;
  }

  @override
  void update(void Function(SearchEventsResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchEventsResponse build() => _build();

  _$SearchEventsResponse _build() {
    final _$result = _$v ??
        _$SearchEventsResponse._(
          accepted: BuiltValueNullFieldError.checkNotNull(
              accepted, r'SearchEventsResponse', 'accepted'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
