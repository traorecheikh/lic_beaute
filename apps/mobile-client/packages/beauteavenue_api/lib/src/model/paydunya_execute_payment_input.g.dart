// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paydunya_execute_payment_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaydunyaExecutePaymentInput extends PaydunyaExecutePaymentInput {
  @override
  final String paymentId;
  @override
  final String method;
  @override
  final BuiltMap<String, JsonObject?>? details;

  factory _$PaydunyaExecutePaymentInput(
          [void Function(PaydunyaExecutePaymentInputBuilder)? updates]) =>
      (PaydunyaExecutePaymentInputBuilder()..update(updates))._build();

  _$PaydunyaExecutePaymentInput._(
      {required this.paymentId, required this.method, this.details})
      : super._();
  @override
  PaydunyaExecutePaymentInput rebuild(
          void Function(PaydunyaExecutePaymentInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaydunyaExecutePaymentInputBuilder toBuilder() =>
      PaydunyaExecutePaymentInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaydunyaExecutePaymentInput &&
        paymentId == other.paymentId &&
        method == other.method &&
        details == other.details;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaydunyaExecutePaymentInput')
          ..add('paymentId', paymentId)
          ..add('method', method)
          ..add('details', details))
        .toString();
  }
}

class PaydunyaExecutePaymentInputBuilder
    implements
        Builder<PaydunyaExecutePaymentInput,
            PaydunyaExecutePaymentInputBuilder> {
  _$PaydunyaExecutePaymentInput? _$v;

  String? _paymentId;
  String? get paymentId => _$this._paymentId;
  set paymentId(String? paymentId) => _$this._paymentId = paymentId;

  String? _method;
  String? get method => _$this._method;
  set method(String? method) => _$this._method = method;

  MapBuilder<String, JsonObject?>? _details;
  MapBuilder<String, JsonObject?> get details =>
      _$this._details ??= MapBuilder<String, JsonObject?>();
  set details(MapBuilder<String, JsonObject?>? details) =>
      _$this._details = details;

  PaydunyaExecutePaymentInputBuilder() {
    PaydunyaExecutePaymentInput._defaults(this);
  }

  PaydunyaExecutePaymentInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentId = $v.paymentId;
      _method = $v.method;
      _details = $v.details?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaydunyaExecutePaymentInput other) {
    _$v = other as _$PaydunyaExecutePaymentInput;
  }

  @override
  void update(void Function(PaydunyaExecutePaymentInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaydunyaExecutePaymentInput build() => _build();

  _$PaydunyaExecutePaymentInput _build() {
    _$PaydunyaExecutePaymentInput _$result;
    try {
      _$result = _$v ??
          _$PaydunyaExecutePaymentInput._(
            paymentId: BuiltValueNullFieldError.checkNotNull(
                paymentId, r'PaydunyaExecutePaymentInput', 'paymentId'),
            method: BuiltValueNullFieldError.checkNotNull(
                method, r'PaydunyaExecutePaymentInput', 'method'),
            details: _details?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'details';
        _details?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PaydunyaExecutePaymentInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
