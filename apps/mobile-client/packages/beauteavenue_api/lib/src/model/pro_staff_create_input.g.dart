// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_staff_create_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProStaffCreateInput extends ProStaffCreateInput {
  @override
  final String phone;
  @override
  final String fullName;
  @override
  final String? avatarUrl;
  @override
  final String? description;
  @override
  final BuiltList<String>? serviceIds;

  factory _$ProStaffCreateInput(
          [void Function(ProStaffCreateInputBuilder)? updates]) =>
      (ProStaffCreateInputBuilder()..update(updates))._build();

  _$ProStaffCreateInput._(
      {required this.phone,
      required this.fullName,
      this.avatarUrl,
      this.description,
      this.serviceIds})
      : super._();
  @override
  ProStaffCreateInput rebuild(
          void Function(ProStaffCreateInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProStaffCreateInputBuilder toBuilder() =>
      ProStaffCreateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProStaffCreateInput &&
        phone == other.phone &&
        fullName == other.fullName &&
        avatarUrl == other.avatarUrl &&
        description == other.description &&
        serviceIds == other.serviceIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, serviceIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProStaffCreateInput')
          ..add('phone', phone)
          ..add('fullName', fullName)
          ..add('avatarUrl', avatarUrl)
          ..add('description', description)
          ..add('serviceIds', serviceIds))
        .toString();
  }
}

class ProStaffCreateInputBuilder
    implements Builder<ProStaffCreateInput, ProStaffCreateInputBuilder> {
  _$ProStaffCreateInput? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _avatarUrl;
  String? get avatarUrl => _$this._avatarUrl;
  set avatarUrl(String? avatarUrl) => _$this._avatarUrl = avatarUrl;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  ListBuilder<String>? _serviceIds;
  ListBuilder<String> get serviceIds =>
      _$this._serviceIds ??= ListBuilder<String>();
  set serviceIds(ListBuilder<String>? serviceIds) =>
      _$this._serviceIds = serviceIds;

  ProStaffCreateInputBuilder() {
    ProStaffCreateInput._defaults(this);
  }

  ProStaffCreateInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _fullName = $v.fullName;
      _avatarUrl = $v.avatarUrl;
      _description = $v.description;
      _serviceIds = $v.serviceIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProStaffCreateInput other) {
    _$v = other as _$ProStaffCreateInput;
  }

  @override
  void update(void Function(ProStaffCreateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProStaffCreateInput build() => _build();

  _$ProStaffCreateInput _build() {
    _$ProStaffCreateInput _$result;
    try {
      _$result = _$v ??
          _$ProStaffCreateInput._(
            phone: BuiltValueNullFieldError.checkNotNull(
                phone, r'ProStaffCreateInput', 'phone'),
            fullName: BuiltValueNullFieldError.checkNotNull(
                fullName, r'ProStaffCreateInput', 'fullName'),
            avatarUrl: avatarUrl,
            description: description,
            serviceIds: _serviceIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'serviceIds';
        _serviceIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProStaffCreateInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
