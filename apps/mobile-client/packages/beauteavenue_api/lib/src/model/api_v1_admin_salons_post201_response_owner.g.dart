// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_salons_post201_response_owner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminSalonsPost201ResponseOwner
    extends ApiV1AdminSalonsPost201ResponseOwner {
  @override
  final String fullName;
  @override
  final String email;
  @override
  final String phone;

  factory _$ApiV1AdminSalonsPost201ResponseOwner(
          [void Function(ApiV1AdminSalonsPost201ResponseOwnerBuilder)?
              updates]) =>
      (ApiV1AdminSalonsPost201ResponseOwnerBuilder()..update(updates))._build();

  _$ApiV1AdminSalonsPost201ResponseOwner._(
      {required this.fullName, required this.email, required this.phone})
      : super._();
  @override
  ApiV1AdminSalonsPost201ResponseOwner rebuild(
          void Function(ApiV1AdminSalonsPost201ResponseOwnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminSalonsPost201ResponseOwnerBuilder toBuilder() =>
      ApiV1AdminSalonsPost201ResponseOwnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminSalonsPost201ResponseOwner &&
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
    return (newBuiltValueToStringHelper(r'ApiV1AdminSalonsPost201ResponseOwner')
          ..add('fullName', fullName)
          ..add('email', email)
          ..add('phone', phone))
        .toString();
  }
}

class ApiV1AdminSalonsPost201ResponseOwnerBuilder
    implements
        Builder<ApiV1AdminSalonsPost201ResponseOwner,
            ApiV1AdminSalonsPost201ResponseOwnerBuilder> {
  _$ApiV1AdminSalonsPost201ResponseOwner? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  ApiV1AdminSalonsPost201ResponseOwnerBuilder() {
    ApiV1AdminSalonsPost201ResponseOwner._defaults(this);
  }

  ApiV1AdminSalonsPost201ResponseOwnerBuilder get _$this {
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
  void replace(ApiV1AdminSalonsPost201ResponseOwner other) {
    _$v = other as _$ApiV1AdminSalonsPost201ResponseOwner;
  }

  @override
  void update(
      void Function(ApiV1AdminSalonsPost201ResponseOwnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminSalonsPost201ResponseOwner build() => _build();

  _$ApiV1AdminSalonsPost201ResponseOwner _build() {
    final _$result = _$v ??
        _$ApiV1AdminSalonsPost201ResponseOwner._(
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'ApiV1AdminSalonsPost201ResponseOwner', 'fullName'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'ApiV1AdminSalonsPost201ResponseOwner', 'email'),
          phone: BuiltValueNullFieldError.checkNotNull(
              phone, r'ApiV1AdminSalonsPost201ResponseOwner', 'phone'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
