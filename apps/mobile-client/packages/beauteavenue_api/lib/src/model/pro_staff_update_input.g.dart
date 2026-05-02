// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_staff_update_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProStaffUpdateInput extends ProStaffUpdateInput {
  @override
  final String? displayName;
  @override
  final String? avatarUrl;
  @override
  final String? description;
  @override
  final bool? isActive;
  @override
  final bool? schedulingEnabled;
  @override
  final BuiltList<String>? serviceIds;

  factory _$ProStaffUpdateInput(
          [void Function(ProStaffUpdateInputBuilder)? updates]) =>
      (ProStaffUpdateInputBuilder()..update(updates))._build();

  _$ProStaffUpdateInput._(
      {this.displayName,
      this.avatarUrl,
      this.description,
      this.isActive,
      this.schedulingEnabled,
      this.serviceIds})
      : super._();
  @override
  ProStaffUpdateInput rebuild(
          void Function(ProStaffUpdateInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProStaffUpdateInputBuilder toBuilder() =>
      ProStaffUpdateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProStaffUpdateInput &&
        displayName == other.displayName &&
        avatarUrl == other.avatarUrl &&
        description == other.description &&
        isActive == other.isActive &&
        schedulingEnabled == other.schedulingEnabled &&
        serviceIds == other.serviceIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, avatarUrl.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, schedulingEnabled.hashCode);
    _$hash = $jc(_$hash, serviceIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProStaffUpdateInput')
          ..add('displayName', displayName)
          ..add('avatarUrl', avatarUrl)
          ..add('description', description)
          ..add('isActive', isActive)
          ..add('schedulingEnabled', schedulingEnabled)
          ..add('serviceIds', serviceIds))
        .toString();
  }
}

class ProStaffUpdateInputBuilder
    implements Builder<ProStaffUpdateInput, ProStaffUpdateInputBuilder> {
  _$ProStaffUpdateInput? _$v;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _avatarUrl;
  String? get avatarUrl => _$this._avatarUrl;
  set avatarUrl(String? avatarUrl) => _$this._avatarUrl = avatarUrl;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  bool? _schedulingEnabled;
  bool? get schedulingEnabled => _$this._schedulingEnabled;
  set schedulingEnabled(bool? schedulingEnabled) =>
      _$this._schedulingEnabled = schedulingEnabled;

  ListBuilder<String>? _serviceIds;
  ListBuilder<String> get serviceIds =>
      _$this._serviceIds ??= ListBuilder<String>();
  set serviceIds(ListBuilder<String>? serviceIds) =>
      _$this._serviceIds = serviceIds;

  ProStaffUpdateInputBuilder() {
    ProStaffUpdateInput._defaults(this);
  }

  ProStaffUpdateInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayName = $v.displayName;
      _avatarUrl = $v.avatarUrl;
      _description = $v.description;
      _isActive = $v.isActive;
      _schedulingEnabled = $v.schedulingEnabled;
      _serviceIds = $v.serviceIds?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProStaffUpdateInput other) {
    _$v = other as _$ProStaffUpdateInput;
  }

  @override
  void update(void Function(ProStaffUpdateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProStaffUpdateInput build() => _build();

  _$ProStaffUpdateInput _build() {
    _$ProStaffUpdateInput _$result;
    try {
      _$result = _$v ??
          _$ProStaffUpdateInput._(
            displayName: displayName,
            avatarUrl: avatarUrl,
            description: description,
            isActive: isActive,
            schedulingEnabled: schedulingEnabled,
            serviceIds: _serviceIds?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'serviceIds';
        _serviceIds?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProStaffUpdateInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
