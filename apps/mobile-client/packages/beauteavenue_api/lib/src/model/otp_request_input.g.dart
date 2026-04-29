// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OtpRequestInput extends OtpRequestInput {
  @override
  final String phone;

  factory _$OtpRequestInput([void Function(OtpRequestInputBuilder)? updates]) =>
      (OtpRequestInputBuilder()..update(updates))._build();

  _$OtpRequestInput._({required this.phone}) : super._();
  @override
  OtpRequestInput rebuild(void Function(OtpRequestInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OtpRequestInputBuilder toBuilder() => OtpRequestInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OtpRequestInput && phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OtpRequestInput')
          ..add('phone', phone))
        .toString();
  }
}

class OtpRequestInputBuilder
    implements Builder<OtpRequestInput, OtpRequestInputBuilder> {
  _$OtpRequestInput? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  OtpRequestInputBuilder() {
    OtpRequestInput._defaults(this);
  }

  OtpRequestInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OtpRequestInput other) {
    _$v = other as _$OtpRequestInput;
  }

  @override
  void update(void Function(OtpRequestInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OtpRequestInput build() => _build();

  _$OtpRequestInput _build() {
    final _$result = _$v ??
        _$OtpRequestInput._(
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'OtpRequestInput', 'phone'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
