// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_salon_queue_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSalonQueueItemApprovalStatusEnum
    _$adminSalonQueueItemApprovalStatusEnum_pendingReview =
    const AdminSalonQueueItemApprovalStatusEnum._('pendingReview');
const AdminSalonQueueItemApprovalStatusEnum
    _$adminSalonQueueItemApprovalStatusEnum_needsInfo =
    const AdminSalonQueueItemApprovalStatusEnum._('needsInfo');
const AdminSalonQueueItemApprovalStatusEnum
    _$adminSalonQueueItemApprovalStatusEnum_approved =
    const AdminSalonQueueItemApprovalStatusEnum._('approved');
const AdminSalonQueueItemApprovalStatusEnum
    _$adminSalonQueueItemApprovalStatusEnum_rejected =
    const AdminSalonQueueItemApprovalStatusEnum._('rejected');

AdminSalonQueueItemApprovalStatusEnum
    _$adminSalonQueueItemApprovalStatusEnumValueOf(String name) {
  switch (name) {
    case 'pendingReview':
      return _$adminSalonQueueItemApprovalStatusEnum_pendingReview;
    case 'needsInfo':
      return _$adminSalonQueueItemApprovalStatusEnum_needsInfo;
    case 'approved':
      return _$adminSalonQueueItemApprovalStatusEnum_approved;
    case 'rejected':
      return _$adminSalonQueueItemApprovalStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSalonQueueItemApprovalStatusEnum>
    _$adminSalonQueueItemApprovalStatusEnumValues = BuiltSet<
        AdminSalonQueueItemApprovalStatusEnum>(const <AdminSalonQueueItemApprovalStatusEnum>[
  _$adminSalonQueueItemApprovalStatusEnum_pendingReview,
  _$adminSalonQueueItemApprovalStatusEnum_needsInfo,
  _$adminSalonQueueItemApprovalStatusEnum_approved,
  _$adminSalonQueueItemApprovalStatusEnum_rejected,
]);

const AdminSalonQueueItemSubscriptionIntentTierEnum
    _$adminSalonQueueItemSubscriptionIntentTierEnum_standard =
    const AdminSalonQueueItemSubscriptionIntentTierEnum._('standard');
const AdminSalonQueueItemSubscriptionIntentTierEnum
    _$adminSalonQueueItemSubscriptionIntentTierEnum_premium =
    const AdminSalonQueueItemSubscriptionIntentTierEnum._('premium');

AdminSalonQueueItemSubscriptionIntentTierEnum
    _$adminSalonQueueItemSubscriptionIntentTierEnumValueOf(String name) {
  switch (name) {
    case 'standard':
      return _$adminSalonQueueItemSubscriptionIntentTierEnum_standard;
    case 'premium':
      return _$adminSalonQueueItemSubscriptionIntentTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSalonQueueItemSubscriptionIntentTierEnum>
    _$adminSalonQueueItemSubscriptionIntentTierEnumValues = BuiltSet<
        AdminSalonQueueItemSubscriptionIntentTierEnum>(const <AdminSalonQueueItemSubscriptionIntentTierEnum>[
  _$adminSalonQueueItemSubscriptionIntentTierEnum_standard,
  _$adminSalonQueueItemSubscriptionIntentTierEnum_premium,
]);

Serializer<AdminSalonQueueItemApprovalStatusEnum>
    _$adminSalonQueueItemApprovalStatusEnumSerializer =
    _$AdminSalonQueueItemApprovalStatusEnumSerializer();
Serializer<AdminSalonQueueItemSubscriptionIntentTierEnum>
    _$adminSalonQueueItemSubscriptionIntentTierEnumSerializer =
    _$AdminSalonQueueItemSubscriptionIntentTierEnumSerializer();

class _$AdminSalonQueueItemApprovalStatusEnumSerializer
    implements PrimitiveSerializer<AdminSalonQueueItemApprovalStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pendingReview': 'pending_review',
    'needsInfo': 'needs_info',
    'approved': 'approved',
    'rejected': 'rejected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending_review': 'pendingReview',
    'needs_info': 'needsInfo',
    'approved': 'approved',
    'rejected': 'rejected',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSalonQueueItemApprovalStatusEnum
  ];
  @override
  final String wireName = 'AdminSalonQueueItemApprovalStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminSalonQueueItemApprovalStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSalonQueueItemApprovalStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSalonQueueItemApprovalStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSalonQueueItemSubscriptionIntentTierEnumSerializer
    implements
        PrimitiveSerializer<AdminSalonQueueItemSubscriptionIntentTierEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'standard': 'standard',
    'premium': 'premium',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'standard': 'standard',
    'premium': 'premium',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSalonQueueItemSubscriptionIntentTierEnum
  ];
  @override
  final String wireName = 'AdminSalonQueueItemSubscriptionIntentTierEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSalonQueueItemSubscriptionIntentTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSalonQueueItemSubscriptionIntentTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSalonQueueItemSubscriptionIntentTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSalonQueueItem extends AdminSalonQueueItem {
  @override
  final String id;
  @override
  final String salonName;
  @override
  final String category;
  @override
  final String city;
  @override
  final String ownerName;
  @override
  final DateTime submittedAt;
  @override
  final AdminSalonQueueItemApprovalStatusEnum approvalStatus;
  @override
  final AdminSalonQueueItemSubscriptionIntentTierEnum subscriptionIntentTier;
  @override
  final BuiltList<String> missingEvidence;
  @override
  final String? latestAdminNote;

  factory _$AdminSalonQueueItem(
          [void Function(AdminSalonQueueItemBuilder)? updates]) =>
      (AdminSalonQueueItemBuilder()..update(updates))._build();

  _$AdminSalonQueueItem._(
      {required this.id,
      required this.salonName,
      required this.category,
      required this.city,
      required this.ownerName,
      required this.submittedAt,
      required this.approvalStatus,
      required this.subscriptionIntentTier,
      required this.missingEvidence,
      this.latestAdminNote})
      : super._();
  @override
  AdminSalonQueueItem rebuild(
          void Function(AdminSalonQueueItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSalonQueueItemBuilder toBuilder() =>
      AdminSalonQueueItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSalonQueueItem &&
        id == other.id &&
        salonName == other.salonName &&
        category == other.category &&
        city == other.city &&
        ownerName == other.ownerName &&
        submittedAt == other.submittedAt &&
        approvalStatus == other.approvalStatus &&
        subscriptionIntentTier == other.subscriptionIntentTier &&
        missingEvidence == other.missingEvidence &&
        latestAdminNote == other.latestAdminNote;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, salonName.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, ownerName.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, approvalStatus.hashCode);
    _$hash = $jc(_$hash, subscriptionIntentTier.hashCode);
    _$hash = $jc(_$hash, missingEvidence.hashCode);
    _$hash = $jc(_$hash, latestAdminNote.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSalonQueueItem')
          ..add('id', id)
          ..add('salonName', salonName)
          ..add('category', category)
          ..add('city', city)
          ..add('ownerName', ownerName)
          ..add('submittedAt', submittedAt)
          ..add('approvalStatus', approvalStatus)
          ..add('subscriptionIntentTier', subscriptionIntentTier)
          ..add('missingEvidence', missingEvidence)
          ..add('latestAdminNote', latestAdminNote))
        .toString();
  }
}

class AdminSalonQueueItemBuilder
    implements Builder<AdminSalonQueueItem, AdminSalonQueueItemBuilder> {
  _$AdminSalonQueueItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _salonName;
  String? get salonName => _$this._salonName;
  set salonName(String? salonName) => _$this._salonName = salonName;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _ownerName;
  String? get ownerName => _$this._ownerName;
  set ownerName(String? ownerName) => _$this._ownerName = ownerName;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  AdminSalonQueueItemApprovalStatusEnum? _approvalStatus;
  AdminSalonQueueItemApprovalStatusEnum? get approvalStatus =>
      _$this._approvalStatus;
  set approvalStatus(AdminSalonQueueItemApprovalStatusEnum? approvalStatus) =>
      _$this._approvalStatus = approvalStatus;

  AdminSalonQueueItemSubscriptionIntentTierEnum? _subscriptionIntentTier;
  AdminSalonQueueItemSubscriptionIntentTierEnum? get subscriptionIntentTier =>
      _$this._subscriptionIntentTier;
  set subscriptionIntentTier(
          AdminSalonQueueItemSubscriptionIntentTierEnum?
              subscriptionIntentTier) =>
      _$this._subscriptionIntentTier = subscriptionIntentTier;

  ListBuilder<String>? _missingEvidence;
  ListBuilder<String> get missingEvidence =>
      _$this._missingEvidence ??= ListBuilder<String>();
  set missingEvidence(ListBuilder<String>? missingEvidence) =>
      _$this._missingEvidence = missingEvidence;

  String? _latestAdminNote;
  String? get latestAdminNote => _$this._latestAdminNote;
  set latestAdminNote(String? latestAdminNote) =>
      _$this._latestAdminNote = latestAdminNote;

  AdminSalonQueueItemBuilder() {
    AdminSalonQueueItem._defaults(this);
  }

  AdminSalonQueueItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _salonName = $v.salonName;
      _category = $v.category;
      _city = $v.city;
      _ownerName = $v.ownerName;
      _submittedAt = $v.submittedAt;
      _approvalStatus = $v.approvalStatus;
      _subscriptionIntentTier = $v.subscriptionIntentTier;
      _missingEvidence = $v.missingEvidence.toBuilder();
      _latestAdminNote = $v.latestAdminNote;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSalonQueueItem other) {
    _$v = other as _$AdminSalonQueueItem;
  }

  @override
  void update(void Function(AdminSalonQueueItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSalonQueueItem build() => _build();

  _$AdminSalonQueueItem _build() {
    _$AdminSalonQueueItem _$result;
    try {
      _$result = _$v ??
          _$AdminSalonQueueItem._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminSalonQueueItem', 'id'),
            salonName: BuiltValueNullFieldError.checkNotNull(
                salonName, r'AdminSalonQueueItem', 'salonName'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'AdminSalonQueueItem', 'category'),
            city: BuiltValueNullFieldError.checkNotNull(
                city, r'AdminSalonQueueItem', 'city'),
            ownerName: BuiltValueNullFieldError.checkNotNull(
                ownerName, r'AdminSalonQueueItem', 'ownerName'),
            submittedAt: BuiltValueNullFieldError.checkNotNull(
                submittedAt, r'AdminSalonQueueItem', 'submittedAt'),
            approvalStatus: BuiltValueNullFieldError.checkNotNull(
                approvalStatus, r'AdminSalonQueueItem', 'approvalStatus'),
            subscriptionIntentTier: BuiltValueNullFieldError.checkNotNull(
                subscriptionIntentTier,
                r'AdminSalonQueueItem',
                'subscriptionIntentTier'),
            missingEvidence: missingEvidence.build(),
            latestAdminNote: latestAdminNote,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'missingEvidence';
        missingEvidence.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminSalonQueueItem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
