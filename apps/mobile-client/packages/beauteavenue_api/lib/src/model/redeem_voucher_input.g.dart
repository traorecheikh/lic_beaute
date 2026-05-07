// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redeem_voucher_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RedeemVoucherInput extends RedeemVoucherInput {
  @override
  final String code;

  factory _$RedeemVoucherInput(
          [void Function(RedeemVoucherInputBuilder)? updates]) =>
      (RedeemVoucherInputBuilder()..update(updates))._build();

  _$RedeemVoucherInput._({required this.code}) : super._();
  @override
  RedeemVoucherInput rebuild(
          void Function(RedeemVoucherInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RedeemVoucherInputBuilder toBuilder() =>
      RedeemVoucherInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RedeemVoucherInput && code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RedeemVoucherInput')
          ..add('code', code))
        .toString();
  }
}

class RedeemVoucherInputBuilder
    implements Builder<RedeemVoucherInput, RedeemVoucherInputBuilder> {
  _$RedeemVoucherInput? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  RedeemVoucherInputBuilder() {
    RedeemVoucherInput._defaults(this);
  }

  RedeemVoucherInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RedeemVoucherInput other) {
    _$v = other as _$RedeemVoucherInput;
  }

  @override
  void update(void Function(RedeemVoucherInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RedeemVoucherInput build() => _build();

  _$RedeemVoucherInput _build() {
    final _$result = _$v ??
        _$RedeemVoucherInput._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'RedeemVoucherInput', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
