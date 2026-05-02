// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_me_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UpdateMeInput extends UpdateMeInput {
  @override
  final String? fullName;

  factory _$UpdateMeInput([void Function(UpdateMeInputBuilder)? updates]) =>
      (UpdateMeInputBuilder()..update(updates))._build();

  _$UpdateMeInput._({this.fullName}) : super._();
  @override
  UpdateMeInput rebuild(void Function(UpdateMeInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateMeInputBuilder toBuilder() => UpdateMeInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateMeInput && fullName == other.fullName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UpdateMeInput')
          ..add('fullName', fullName))
        .toString();
  }
}

class UpdateMeInputBuilder
    implements Builder<UpdateMeInput, UpdateMeInputBuilder> {
  _$UpdateMeInput? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  UpdateMeInputBuilder() {
    UpdateMeInput._defaults(this);
  }

  UpdateMeInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateMeInput other) {
    _$v = other as _$UpdateMeInput;
  }

  @override
  void update(void Function(UpdateMeInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UpdateMeInput build() => _build();

  _$UpdateMeInput _build() {
    final _$result = _$v ??
        _$UpdateMeInput._(
          fullName: fullName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
