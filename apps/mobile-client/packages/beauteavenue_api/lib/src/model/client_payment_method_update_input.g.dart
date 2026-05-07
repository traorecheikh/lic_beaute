// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_payment_method_update_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ClientPaymentMethodUpdateInput extends ClientPaymentMethodUpdateInput {
  @override
  final String? phoneNumber;
  @override
  final String? label;

  factory _$ClientPaymentMethodUpdateInput(
          [void Function(ClientPaymentMethodUpdateInputBuilder)? updates]) =>
      (ClientPaymentMethodUpdateInputBuilder()..update(updates))._build();

  _$ClientPaymentMethodUpdateInput._({this.phoneNumber, this.label})
      : super._();
  @override
  ClientPaymentMethodUpdateInput rebuild(
          void Function(ClientPaymentMethodUpdateInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClientPaymentMethodUpdateInputBuilder toBuilder() =>
      ClientPaymentMethodUpdateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClientPaymentMethodUpdateInput &&
        phoneNumber == other.phoneNumber &&
        label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClientPaymentMethodUpdateInput')
          ..add('phoneNumber', phoneNumber)
          ..add('label', label))
        .toString();
  }
}

class ClientPaymentMethodUpdateInputBuilder
    implements
        Builder<ClientPaymentMethodUpdateInput,
            ClientPaymentMethodUpdateInputBuilder> {
  _$ClientPaymentMethodUpdateInput? _$v;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ClientPaymentMethodUpdateInputBuilder() {
    ClientPaymentMethodUpdateInput._defaults(this);
  }

  ClientPaymentMethodUpdateInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phoneNumber = $v.phoneNumber;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClientPaymentMethodUpdateInput other) {
    _$v = other as _$ClientPaymentMethodUpdateInput;
  }

  @override
  void update(void Function(ClientPaymentMethodUpdateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClientPaymentMethodUpdateInput build() => _build();

  _$ClientPaymentMethodUpdateInput _build() {
    final _$result = _$v ??
        _$ClientPaymentMethodUpdateInput._(
          phoneNumber: phoneNumber,
          label: label,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
