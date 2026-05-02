// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updated_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdatedResponse extends UpdatedResponse {
  @override
  final bool updated;

  factory _$UpdatedResponse([void Function(UpdatedResponseBuilder)? updates]) =>
      (UpdatedResponseBuilder()..update(updates))._build();

  _$UpdatedResponse._({required this.updated}) : super._();
  @override
  UpdatedResponse rebuild(void Function(UpdatedResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdatedResponseBuilder toBuilder() => UpdatedResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdatedResponse && updated == other.updated;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, updated.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdatedResponse')
          ..add('updated', updated))
        .toString();
  }
}

class UpdatedResponseBuilder
    implements Builder<UpdatedResponse, UpdatedResponseBuilder> {
  _$UpdatedResponse? _$v;

  bool? _updated;
  bool? get updated => _$this._updated;
  set updated(bool? updated) => _$this._updated = updated;

  UpdatedResponseBuilder() {
    UpdatedResponse._defaults(this);
  }

  UpdatedResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _updated = $v.updated;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdatedResponse other) {
    _$v = other as _$UpdatedResponse;
  }

  @override
  void update(void Function(UpdatedResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdatedResponse build() => _build();

  _$UpdatedResponse _build() {
    final _$result = _$v ??
        _$UpdatedResponse._(
          updated: BuiltValueNullFieldError.checkNotNull(
              updated, r'UpdatedResponse', 'updated'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
