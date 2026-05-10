// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_salons_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1AdminSalonsPostRequest extends ApiV1AdminSalonsPostRequest {
  @override
  final String name;
  @override
  final String category;
  @override
  final String city;
  @override
  final String address;
  @override
  final String description;
  @override
  final String ownerEmail;
  @override
  final String ownerPhone;
  @override
  final String ownerName;

  factory _$ApiV1AdminSalonsPostRequest(
          [void Function(ApiV1AdminSalonsPostRequestBuilder)? updates]) =>
      (ApiV1AdminSalonsPostRequestBuilder()..update(updates))._build();

  _$ApiV1AdminSalonsPostRequest._(
      {required this.name,
      required this.category,
      required this.city,
      required this.address,
      required this.description,
      required this.ownerEmail,
      required this.ownerPhone,
      required this.ownerName})
      : super._();
  @override
  ApiV1AdminSalonsPostRequest rebuild(
          void Function(ApiV1AdminSalonsPostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminSalonsPostRequestBuilder toBuilder() =>
      ApiV1AdminSalonsPostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminSalonsPostRequest &&
        name == other.name &&
        category == other.category &&
        city == other.city &&
        address == other.address &&
        description == other.description &&
        ownerEmail == other.ownerEmail &&
        ownerPhone == other.ownerPhone &&
        ownerName == other.ownerName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, ownerEmail.hashCode);
    _$hash = $jc(_$hash, ownerPhone.hashCode);
    _$hash = $jc(_$hash, ownerName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1AdminSalonsPostRequest')
          ..add('name', name)
          ..add('category', category)
          ..add('city', city)
          ..add('address', address)
          ..add('description', description)
          ..add('ownerEmail', ownerEmail)
          ..add('ownerPhone', ownerPhone)
          ..add('ownerName', ownerName))
        .toString();
  }
}

class ApiV1AdminSalonsPostRequestBuilder
    implements
        Builder<ApiV1AdminSalonsPostRequest,
            ApiV1AdminSalonsPostRequestBuilder> {
  _$ApiV1AdminSalonsPostRequest? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _ownerEmail;
  String? get ownerEmail => _$this._ownerEmail;
  set ownerEmail(String? ownerEmail) => _$this._ownerEmail = ownerEmail;

  String? _ownerPhone;
  String? get ownerPhone => _$this._ownerPhone;
  set ownerPhone(String? ownerPhone) => _$this._ownerPhone = ownerPhone;

  String? _ownerName;
  String? get ownerName => _$this._ownerName;
  set ownerName(String? ownerName) => _$this._ownerName = ownerName;

  ApiV1AdminSalonsPostRequestBuilder() {
    ApiV1AdminSalonsPostRequest._defaults(this);
  }

  ApiV1AdminSalonsPostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _category = $v.category;
      _city = $v.city;
      _address = $v.address;
      _description = $v.description;
      _ownerEmail = $v.ownerEmail;
      _ownerPhone = $v.ownerPhone;
      _ownerName = $v.ownerName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminSalonsPostRequest other) {
    _$v = other as _$ApiV1AdminSalonsPostRequest;
  }

  @override
  void update(void Function(ApiV1AdminSalonsPostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminSalonsPostRequest build() => _build();

  _$ApiV1AdminSalonsPostRequest _build() {
    final _$result = _$v ??
        _$ApiV1AdminSalonsPostRequest._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ApiV1AdminSalonsPostRequest', 'name'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'ApiV1AdminSalonsPostRequest', 'category'),
          city: BuiltValueNullFieldError.checkNotNull(
              city, r'ApiV1AdminSalonsPostRequest', 'city'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'ApiV1AdminSalonsPostRequest', 'address'),
          description: BuiltValueNullFieldError.checkNotNull(
              description, r'ApiV1AdminSalonsPostRequest', 'description'),
          ownerEmail: BuiltValueNullFieldError.checkNotNull(
              ownerEmail, r'ApiV1AdminSalonsPostRequest', 'ownerEmail'),
          ownerPhone: BuiltValueNullFieldError.checkNotNull(
              ownerPhone, r'ApiV1AdminSalonsPostRequest', 'ownerPhone'),
          ownerName: BuiltValueNullFieldError.checkNotNull(
              ownerName, r'ApiV1AdminSalonsPostRequest', 'ownerName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
