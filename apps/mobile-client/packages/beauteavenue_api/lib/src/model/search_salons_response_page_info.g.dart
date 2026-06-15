// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_salons_response_page_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchSalonsResponsePageInfo extends SearchSalonsResponsePageInfo {
  @override
  final String? nextCursor;
  @override
  final int totalApprox;
  @override
  final bool hasMore;

  factory _$SearchSalonsResponsePageInfo(
          [void Function(SearchSalonsResponsePageInfoBuilder)? updates]) =>
      (SearchSalonsResponsePageInfoBuilder()..update(updates))._build();

  _$SearchSalonsResponsePageInfo._(
      {this.nextCursor, required this.totalApprox, required this.hasMore})
      : super._();
  @override
  SearchSalonsResponsePageInfo rebuild(
          void Function(SearchSalonsResponsePageInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchSalonsResponsePageInfoBuilder toBuilder() =>
      SearchSalonsResponsePageInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchSalonsResponsePageInfo &&
        nextCursor == other.nextCursor &&
        totalApprox == other.totalApprox &&
        hasMore == other.hasMore;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, totalApprox.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchSalonsResponsePageInfo')
          ..add('nextCursor', nextCursor)
          ..add('totalApprox', totalApprox)
          ..add('hasMore', hasMore))
        .toString();
  }
}

class SearchSalonsResponsePageInfoBuilder
    implements
        Builder<SearchSalonsResponsePageInfo,
            SearchSalonsResponsePageInfoBuilder> {
  _$SearchSalonsResponsePageInfo? _$v;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  int? _totalApprox;
  int? get totalApprox => _$this._totalApprox;
  set totalApprox(int? totalApprox) => _$this._totalApprox = totalApprox;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  SearchSalonsResponsePageInfoBuilder() {
    SearchSalonsResponsePageInfo._defaults(this);
  }

  SearchSalonsResponsePageInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nextCursor = $v.nextCursor;
      _totalApprox = $v.totalApprox;
      _hasMore = $v.hasMore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchSalonsResponsePageInfo other) {
    _$v = other as _$SearchSalonsResponsePageInfo;
  }

  @override
  void update(void Function(SearchSalonsResponsePageInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchSalonsResponsePageInfo build() => _build();

  _$SearchSalonsResponsePageInfo _build() {
    final _$result = _$v ??
        _$SearchSalonsResponsePageInfo._(
          nextCursor: nextCursor,
          totalApprox: BuiltValueNullFieldError.checkNotNull(
              totalApprox, r'SearchSalonsResponsePageInfo', 'totalApprox'),
          hasMore: BuiltValueNullFieldError.checkNotNull(
              hasMore, r'SearchSalonsResponsePageInfo', 'hasMore'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
