// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_staff_member.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProStaffMember extends ProStaffMember {
  @override
  final String id;
  @override
  final String userId;
  @override
  final String displayName;
  @override
  final String? avatarUrl;
  @override
  final String? description;
  @override
  final bool isActive;
  @override
  final bool schedulingEnabled;
  @override
  final BuiltList<String> serviceIds;

  factory _$ProStaffMember([void Function(ProStaffMemberBuilder)? updates]) =>
      (ProStaffMemberBuilder()..update(updates))._build();

  _$ProStaffMember._(
      {required this.id,
      required this.userId,
      required this.displayName,
      this.avatarUrl,
      this.description,
      required this.isActive,
      required this.schedulingEnabled,
      required this.serviceIds})
      : super._();
  @override
  ProStaffMember rebuild(void Function(ProStaffMemberBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProStaffMemberBuilder toBuilder() => ProStaffMemberBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProStaffMember &&
        id == other.id &&
        userId == other.userId &&
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
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
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
    return (newBuiltValueToStringHelper(r'ProStaffMember')
          ..add('id', id)
          ..add('userId', userId)
          ..add('displayName', displayName)
          ..add('avatarUrl', avatarUrl)
          ..add('description', description)
          ..add('isActive', isActive)
          ..add('schedulingEnabled', schedulingEnabled)
          ..add('serviceIds', serviceIds))
        .toString();
  }
}

class ProStaffMemberBuilder
    implements Builder<ProStaffMember, ProStaffMemberBuilder> {
  _$ProStaffMember? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

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

  ProStaffMemberBuilder() {
    ProStaffMember._defaults(this);
  }

  ProStaffMemberBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
      _displayName = $v.displayName;
      _avatarUrl = $v.avatarUrl;
      _description = $v.description;
      _isActive = $v.isActive;
      _schedulingEnabled = $v.schedulingEnabled;
      _serviceIds = $v.serviceIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProStaffMember other) {
    _$v = other as _$ProStaffMember;
  }

  @override
  void update(void Function(ProStaffMemberBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProStaffMember build() => _build();

  _$ProStaffMember _build() {
    _$ProStaffMember _$result;
    try {
      _$result = _$v ??
          _$ProStaffMember._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ProStaffMember', 'id'),
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, r'ProStaffMember', 'userId'),
            displayName: BuiltValueNullFieldError.checkNotNull(
                displayName, r'ProStaffMember', 'displayName'),
            avatarUrl: avatarUrl,
            description: description,
            isActive: BuiltValueNullFieldError.checkNotNull(
                isActive, r'ProStaffMember', 'isActive'),
            schedulingEnabled: BuiltValueNullFieldError.checkNotNull(
                schedulingEnabled, r'ProStaffMember', 'schedulingEnabled'),
            serviceIds: serviceIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'serviceIds';
        serviceIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProStaffMember', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
