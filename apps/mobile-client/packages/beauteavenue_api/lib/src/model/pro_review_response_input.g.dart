// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_review_response_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProReviewResponseInput extends ProReviewResponseInput {
  @override
  final String responseText;

  factory _$ProReviewResponseInput(
          [void Function(ProReviewResponseInputBuilder)? updates]) =>
      (ProReviewResponseInputBuilder()..update(updates))._build();

  _$ProReviewResponseInput._({required this.responseText}) : super._();
  @override
  ProReviewResponseInput rebuild(
          void Function(ProReviewResponseInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProReviewResponseInputBuilder toBuilder() =>
      ProReviewResponseInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProReviewResponseInput &&
        responseText == other.responseText;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, responseText.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProReviewResponseInput')
          ..add('responseText', responseText))
        .toString();
  }
}

class ProReviewResponseInputBuilder
    implements Builder<ProReviewResponseInput, ProReviewResponseInputBuilder> {
  _$ProReviewResponseInput? _$v;

  String? _responseText;
  String? get responseText => _$this._responseText;
  set responseText(String? responseText) => _$this._responseText = responseText;

  ProReviewResponseInputBuilder() {
    ProReviewResponseInput._defaults(this);
  }

  ProReviewResponseInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _responseText = $v.responseText;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProReviewResponseInput other) {
    _$v = other as _$ProReviewResponseInput;
  }

  @override
  void update(void Function(ProReviewResponseInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProReviewResponseInput build() => _build();

  _$ProReviewResponseInput _build() {
    final _$result = _$v ??
        _$ProReviewResponseInput._(
          responseText: BuiltValueNullFieldError.checkNotNull(
              responseText, r'ProReviewResponseInput', 'responseText'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
