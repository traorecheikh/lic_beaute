// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_input_any_of1_salon.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterInputAnyOf1Salon extends RegisterInputAnyOf1Salon {
  @override
  final String name;
  @override
  final String category;
  @override
  final String city;
  @override
  final String address;
  @override
  final String? description;

  factory _$RegisterInputAnyOf1Salon(
          [void Function(RegisterInputAnyOf1SalonBuilder)? updates]) =>
      (RegisterInputAnyOf1SalonBuilder()..update(updates))._build();

  _$RegisterInputAnyOf1Salon._(
      {required this.name,
      required this.category,
      required this.city,
      required this.address,
      this.description})
      : super._();
  @override
  RegisterInputAnyOf1Salon rebuild(
          void Function(RegisterInputAnyOf1SalonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterInputAnyOf1SalonBuilder toBuilder() =>
      RegisterInputAnyOf1SalonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterInputAnyOf1Salon &&
        name == other.name &&
        category == other.category &&
        city == other.city &&
        address == other.address &&
        description == other.description;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterInputAnyOf1Salon')
          ..add('name', name)
          ..add('category', category)
          ..add('city', city)
          ..add('address', address)
          ..add('description', description))
        .toString();
  }
}

class RegisterInputAnyOf1SalonBuilder
    implements
        Builder<RegisterInputAnyOf1Salon, RegisterInputAnyOf1SalonBuilder> {
  _$RegisterInputAnyOf1Salon? _$v;

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

  RegisterInputAnyOf1SalonBuilder() {
    RegisterInputAnyOf1Salon._defaults(this);
  }

  RegisterInputAnyOf1SalonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _category = $v.category;
      _city = $v.city;
      _address = $v.address;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterInputAnyOf1Salon other) {
    _$v = other as _$RegisterInputAnyOf1Salon;
  }

  @override
  void update(void Function(RegisterInputAnyOf1SalonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterInputAnyOf1Salon build() => _build();

  _$RegisterInputAnyOf1Salon _build() {
    final _$result = _$v ??
        _$RegisterInputAnyOf1Salon._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'RegisterInputAnyOf1Salon', 'name'),
          category: BuiltValueNullFieldError.checkNotNull(
              category, r'RegisterInputAnyOf1Salon', 'category'),
          city: BuiltValueNullFieldError.checkNotNull(
              city, r'RegisterInputAnyOf1Salon', 'city'),
          address: BuiltValueNullFieldError.checkNotNull(
              address, r'RegisterInputAnyOf1Salon', 'address'),
          description: description,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
