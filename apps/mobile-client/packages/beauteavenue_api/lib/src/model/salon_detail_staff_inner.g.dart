// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_detail_staff_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SalonDetailStaffInner extends SalonDetailStaffInner {
  @override
  final String id;
  @override
  final String displayName;
  @override
  final String? avatarUrl;
  @override
  final String? description;
  @override
  final BuiltList<String> serviceIds;

  factory _$SalonDetailStaffInner(
          [void Function(SalonDetailStaffInnerBuilder)? updates]) =>
      (SalonDetailStaffInnerBuilder()..update(updates))._build();

  _$SalonDetailStaffInner._(
      {required this.id,
      required this.displayName,
      this.avatarUrl,
      this.description,
      required this.serviceIds})
      : super._();
  @override
  SalonDetailStaffInner rebuild(
          void Function(SalonDetailStaffInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SalonDetailStaffInnerBuilder toBuilder() =>
      SalonDetailStaffInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SalonDetailStaffInner &&
        id == other.id &&
        displayName == other.displayName &&
        avatarUrl == other.avatarUrl &&
        description == other.description &&
        serviceIds == other.serviceIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, serviceIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SalonDetailStaffInner')
          ..add('id', id)
          ..add('displayName', displayName)
          ..add('avatarUrl', avatarUrl)
          ..add('description', description)
          ..add('serviceIds', serviceIds))
        .toString();
  }
}

class SalonDetailStaffInnerBuilder
    implements Builder<SalonDetailStaffInner, SalonDetailStaffInnerBuilder> {
  _$SalonDetailStaffInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

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

  SalonDetailStaffInnerBuilder() {
    SalonDetailStaffInner._defaults(this);
  }

  SalonDetailStaffInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _displayName = $v.displayName;
      _avatarUrl = $v.avatarUrl;
      _description = $v.description;
      _serviceIds = $v.serviceIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SalonDetailStaffInner other) {
    _$v = other as _$SalonDetailStaffInner;
  }

  @override
  void update(void Function(SalonDetailStaffInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SalonDetailStaffInner build() => _build();

  _$SalonDetailStaffInner _build() {
    _$SalonDetailStaffInner _$result;
    try {
      _$result = _$v ??
          _$SalonDetailStaffInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'SalonDetailStaffInner', 'id'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'SalonDetailStaffInner', 'displayName'),
            avatarUrl: avatarUrl,
            description: description,
            serviceIds: serviceIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'serviceIds';
        serviceIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SalonDetailStaffInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
