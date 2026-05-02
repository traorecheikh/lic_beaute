// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleted_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DeletedResponse extends DeletedResponse {
  @override
  final bool deleted;

  factory _$DeletedResponse([void Function(DeletedResponseBuilder)? updates]) =>
      (DeletedResponseBuilder()..update(updates))._build();

  _$DeletedResponse._({required this.deleted}) : super._();
  @override
  DeletedResponse rebuild(void Function(DeletedResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeletedResponseBuilder toBuilder() => DeletedResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeletedResponse && deleted == other.deleted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deleted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeletedResponse')
          ..add('deleted', deleted))
        .toString();
  }
}

class DeletedResponseBuilder
    implements Builder<DeletedResponse, DeletedResponseBuilder> {
  _$DeletedResponse? _$v;

  bool? _deleted;
  bool? get deleted => _$this._deleted;
  set deleted(bool? deleted) => _$this._deleted = deleted;

  DeletedResponseBuilder() {
    DeletedResponse._defaults(this);
  }

  DeletedResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deleted = $v.deleted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeletedResponse other) {
    _$v = other as _$DeletedResponse;
  }

  @override
  void update(void Function(DeletedResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeletedResponse build() => _build();

  _$DeletedResponse _build() {
    final _$result = _$v ??
        _$DeletedResponse._(
          deleted: BuiltValueNullFieldError.checkNotNull(
              deleted, r'DeletedResponse', 'deleted'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
