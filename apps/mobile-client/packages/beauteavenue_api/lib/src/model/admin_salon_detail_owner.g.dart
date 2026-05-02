// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_salon_detail_owner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSalonDetailOwner extends AdminSalonDetailOwner {
  @override
  final String fullName;
  @override
  final String email;
  @override
  final String phone;

  factory _$AdminSalonDetailOwner(
          [void Function(AdminSalonDetailOwnerBuilder)? updates]) =>
      (AdminSalonDetailOwnerBuilder()..update(updates))._build();

  _$AdminSalonDetailOwner._(
      {required this.fullName, required this.email, required this.phone})
      : super._();
  @override
  AdminSalonDetailOwner rebuild(
          void Function(AdminSalonDetailOwnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSalonDetailOwnerBuilder toBuilder() =>
      AdminSalonDetailOwnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSalonDetailOwner &&
        fullName == other.fullName &&
        email == other.email &&
        phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSalonDetailOwner')
          ..add('fullName', fullName)
          ..add('email', email)
          ..add('phone', phone))
        .toString();
  }
}

class AdminSalonDetailOwnerBuilder
    implements Builder<AdminSalonDetailOwner, AdminSalonDetailOwnerBuilder> {
  _$AdminSalonDetailOwner? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  AdminSalonDetailOwnerBuilder() {
    AdminSalonDetailOwner._defaults(this);
  }

  AdminSalonDetailOwnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _email = $v.email;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSalonDetailOwner other) {
    _$v = other as _$AdminSalonDetailOwner;
  }

  @override
  void update(void Function(AdminSalonDetailOwnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSalonDetailOwner build() => _build();

  _$AdminSalonDetailOwner _build() {
    final _$result = _$v ??
        _$AdminSalonDetailOwner._(
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'AdminSalonDetailOwner', 'fullName'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'AdminSalonDetailOwner', 'email'),
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'AdminSalonDetailOwner', 'phone'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
