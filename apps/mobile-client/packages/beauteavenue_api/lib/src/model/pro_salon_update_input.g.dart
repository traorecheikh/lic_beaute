// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_salon_update_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProSalonUpdateInput extends ProSalonUpdateInput {
  @override
  final String? category;
  @override
  final String? logoUrl;
  @override
  final String? description;
  @override
  final String? city;
  @override
  final String? address;
  @override
  final String? neighborhood;
  @override
  final num? latitude;
  @override
  final num? longitude;
  @override
  final ProSalonUpdateInputTeamDisplay? teamDisplay;
  @override
  final String? phone;
  @override
  final String? instagram;
  @override
  final BuiltList<String>? gallery;

  factory _$ProSalonUpdateInput(
          [void Function(ProSalonUpdateInputBuilder)? updates]) =>
      (ProSalonUpdateInputBuilder()..update(updates))._build();

  _$ProSalonUpdateInput._(
      {this.category,
      this.logoUrl,
      this.description,
      this.city,
      this.address,
      this.neighborhood,
      this.latitude,
      this.longitude,
      this.teamDisplay,
      this.phone,
      this.instagram,
      this.gallery})
      : super._();
  @override
  ProSalonUpdateInput rebuild(
          void Function(ProSalonUpdateInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProSalonUpdateInputBuilder toBuilder() =>
      ProSalonUpdateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProSalonUpdateInput &&
        category == other.category &&
        logoUrl == other.logoUrl &&
        description == other.description &&
        city == other.city &&
        address == other.address &&
        neighborhood == other.neighborhood &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        teamDisplay == other.teamDisplay &&
        phone == other.phone &&
        instagram == other.instagram &&
        gallery == other.gallery;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, logoUrl.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, neighborhood.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, teamDisplay.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, instagram.hashCode);
    _$hash = $jc(_$hash, gallery.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProSalonUpdateInput')
          ..add('category', category)
          ..add('logoUrl', logoUrl)
          ..add('description', description)
          ..add('city', city)
          ..add('address', address)
          ..add('neighborhood', neighborhood)
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('teamDisplay', teamDisplay)
          ..add('phone', phone)
          ..add('instagram', instagram)
          ..add('gallery', gallery))
        .toString();
  }
}

class ProSalonUpdateInputBuilder
    implements Builder<ProSalonUpdateInput, ProSalonUpdateInputBuilder> {
  _$ProSalonUpdateInput? _$v;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _logoUrl;
  String? get logoUrl => _$this._logoUrl;
  set logoUrl(String? logoUrl) => _$this._logoUrl = logoUrl;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _neighborhood;
  String? get neighborhood => _$this._neighborhood;
  set neighborhood(String? neighborhood) => _$this._neighborhood = neighborhood;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  ProSalonUpdateInputTeamDisplayBuilder? _teamDisplay;
  ProSalonUpdateInputTeamDisplayBuilder get teamDisplay =>
      _$this._teamDisplay ??= ProSalonUpdateInputTeamDisplayBuilder();
  set teamDisplay(ProSalonUpdateInputTeamDisplayBuilder? teamDisplay) =>
      _$this._teamDisplay = teamDisplay;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _instagram;
  String? get instagram => _$this._instagram;
  set instagram(String? instagram) => _$this._instagram = instagram;

  ListBuilder<String>? _gallery;
  ListBuilder<String> get gallery => _$this._gallery ??= ListBuilder<String>();
  set gallery(ListBuilder<String>? gallery) => _$this._gallery = gallery;

  ProSalonUpdateInputBuilder() {
    ProSalonUpdateInput._defaults(this);
  }

  ProSalonUpdateInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _category = $v.category;
      _logoUrl = $v.logoUrl;
      _description = $v.description;
      _city = $v.city;
      _address = $v.address;
      _neighborhood = $v.neighborhood;
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _teamDisplay = $v.teamDisplay?.toBuilder();
      _phone = $v.phone;
      _instagram = $v.instagram;
      _gallery = $v.gallery?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProSalonUpdateInput other) {
    _$v = other as _$ProSalonUpdateInput;
  }

  @override
  void update(void Function(ProSalonUpdateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProSalonUpdateInput build() => _build();

  _$ProSalonUpdateInput _build() {
    _$ProSalonUpdateInput _$result;
    try {
      _$result = _$v ??
          _$ProSalonUpdateInput._(
            category: category,
            logoUrl: logoUrl,
            description: description,
            city: city,
            address: address,
            neighborhood: neighborhood,
            latitude: latitude,
            longitude: longitude,
            teamDisplay: _teamDisplay?.build(),
            phone: phone,
            instagram: instagram,
            gallery: _gallery?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'teamDisplay';
        _teamDisplay?.build();

        _$failedField = 'gallery';
        _gallery?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProSalonUpdateInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
