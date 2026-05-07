// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_voucher_create_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProVoucherCreateInput extends ProVoucherCreateInput {
  @override
  final String code;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String discountLabel;
  @override
  final DateTime? expiresAt;
  @override
  final int? maxRedemptions;

  factory _$ProVoucherCreateInput(
          [void Function(ProVoucherCreateInputBuilder)? updates]) =>
      (ProVoucherCreateInputBuilder()..update(updates))._build();

  _$ProVoucherCreateInput._(
      {required this.code,
      required this.title,
      this.description,
      required this.discountLabel,
      this.expiresAt,
      this.maxRedemptions})
      : super._();
  @override
  ProVoucherCreateInput rebuild(
          void Function(ProVoucherCreateInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProVoucherCreateInputBuilder toBuilder() =>
      ProVoucherCreateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProVoucherCreateInput &&
        code == other.code &&
        title == other.title &&
        description == other.description &&
        discountLabel == other.discountLabel &&
        expiresAt == other.expiresAt &&
        maxRedemptions == other.maxRedemptions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, discountLabel.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, maxRedemptions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProVoucherCreateInput')
          ..add('code', code)
          ..add('title', title)
          ..add('description', description)
          ..add('discountLabel', discountLabel)
          ..add('expiresAt', expiresAt)
          ..add('maxRedemptions', maxRedemptions))
        .toString();
  }
}

class ProVoucherCreateInputBuilder
    implements Builder<ProVoucherCreateInput, ProVoucherCreateInputBuilder> {
  _$ProVoucherCreateInput? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _discountLabel;
  String? get discountLabel => _$this._discountLabel;
  set discountLabel(String? discountLabel) =>
      _$this._discountLabel = discountLabel;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  int? _maxRedemptions;
  int? get maxRedemptions => _$this._maxRedemptions;
  set maxRedemptions(int? maxRedemptions) =>
      _$this._maxRedemptions = maxRedemptions;

  ProVoucherCreateInputBuilder() {
    ProVoucherCreateInput._defaults(this);
  }

  ProVoucherCreateInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _title = $v.title;
      _description = $v.description;
      _discountLabel = $v.discountLabel;
      _expiresAt = $v.expiresAt;
      _maxRedemptions = $v.maxRedemptions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProVoucherCreateInput other) {
    _$v = other as _$ProVoucherCreateInput;
  }

  @override
  void update(void Function(ProVoucherCreateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProVoucherCreateInput build() => _build();

  _$ProVoucherCreateInput _build() {
    final _$result = _$v ??
        _$ProVoucherCreateInput._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'ProVoucherCreateInput', 'code'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'ProVoucherCreateInput', 'title'),
          description: description,
          discountLabel: BuiltValueNullFieldError.checkNotNull(
              discountLabel, r'ProVoucherCreateInput', 'discountLabel'),
          expiresAt: expiresAt,
          maxRedemptions: maxRedemptions,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
