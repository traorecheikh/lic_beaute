// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_salon_queue_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSalonQueueResponseItemsInnerApprovalStatusEnum
    _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_pendingReview =
    const AdminSalonQueueResponseItemsInnerApprovalStatusEnum._(
        'pendingReview');
const AdminSalonQueueResponseItemsInnerApprovalStatusEnum
    _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_needsInfo =
    const AdminSalonQueueResponseItemsInnerApprovalStatusEnum._('needsInfo');
const AdminSalonQueueResponseItemsInnerApprovalStatusEnum
    _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_approved =
    const AdminSalonQueueResponseItemsInnerApprovalStatusEnum._('approved');
const AdminSalonQueueResponseItemsInnerApprovalStatusEnum
    _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_rejected =
    const AdminSalonQueueResponseItemsInnerApprovalStatusEnum._('rejected');

AdminSalonQueueResponseItemsInnerApprovalStatusEnum
    _$adminSalonQueueResponseItemsInnerApprovalStatusEnumValueOf(String name) {
  switch (name) {
    case 'pendingReview':
      return _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_pendingReview;
    case 'needsInfo':
      return _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_needsInfo;
    case 'approved':
      return _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_approved;
    case 'rejected':
      return _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSalonQueueResponseItemsInnerApprovalStatusEnum>
    _$adminSalonQueueResponseItemsInnerApprovalStatusEnumValues = BuiltSet<
        AdminSalonQueueResponseItemsInnerApprovalStatusEnum>(const <AdminSalonQueueResponseItemsInnerApprovalStatusEnum>[
  _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_pendingReview,
  _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_needsInfo,
  _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_approved,
  _$adminSalonQueueResponseItemsInnerApprovalStatusEnum_rejected,
]);

const AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum
    _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum_standard =
    const AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum._(
        'standard');
const AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum
    _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum_premium =
    const AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum._(
        'premium');

AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum
    _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnumValueOf(
        String name) {
  switch (name) {
    case 'standard':
      return _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum_standard;
    case 'premium':
      return _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum>
    _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnumValues =
    BuiltSet<
        AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum>(const <AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum>[
  _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum_standard,
  _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum_premium,
]);

Serializer<AdminSalonQueueResponseItemsInnerApprovalStatusEnum>
    _$adminSalonQueueResponseItemsInnerApprovalStatusEnumSerializer =
    _$AdminSalonQueueResponseItemsInnerApprovalStatusEnumSerializer();
Serializer<AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum>
    _$adminSalonQueueResponseItemsInnerSubscriptionIntentTierEnumSerializer =
    _$AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnumSerializer();

class _$AdminSalonQueueResponseItemsInnerApprovalStatusEnumSerializer
    implements
        PrimitiveSerializer<
            AdminSalonQueueResponseItemsInnerApprovalStatusEnum> {
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
    AdminSalonQueueResponseItemsInnerApprovalStatusEnum
  ];
  @override
  final String wireName = 'AdminSalonQueueResponseItemsInnerApprovalStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSalonQueueResponseItemsInnerApprovalStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSalonQueueResponseItemsInnerApprovalStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSalonQueueResponseItemsInnerApprovalStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnumSerializer
    implements
        PrimitiveSerializer<
            AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum> {
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
    AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum
  ];
  @override
  final String wireName =
      'AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSalonQueueResponseItemsInner
    extends AdminSalonQueueResponseItemsInner {
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
  final AdminSalonQueueResponseItemsInnerApprovalStatusEnum approvalStatus;
  @override
  final AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum
      subscriptionIntentTier;
  @override
  final BuiltList<String> missingEvidence;
  @override
  final String? latestAdminNote;

  factory _$AdminSalonQueueResponseItemsInner(
          [void Function(AdminSalonQueueResponseItemsInnerBuilder)? updates]) =>
      (AdminSalonQueueResponseItemsInnerBuilder()..update(updates))._build();

  _$AdminSalonQueueResponseItemsInner._(
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
  AdminSalonQueueResponseItemsInner rebuild(
          void Function(AdminSalonQueueResponseItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSalonQueueResponseItemsInnerBuilder toBuilder() =>
      AdminSalonQueueResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSalonQueueResponseItemsInner &&
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
    return (newBuiltValueToStringHelper(r'AdminSalonQueueResponseItemsInner')
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

class AdminSalonQueueResponseItemsInnerBuilder
    implements
        Builder<AdminSalonQueueResponseItemsInner,
            AdminSalonQueueResponseItemsInnerBuilder> {
  _$AdminSalonQueueResponseItemsInner? _$v;

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

  AdminSalonQueueResponseItemsInnerApprovalStatusEnum? _approvalStatus;
  AdminSalonQueueResponseItemsInnerApprovalStatusEnum? get approvalStatus =>
      _$this._approvalStatus;
  set approvalStatus(
          AdminSalonQueueResponseItemsInnerApprovalStatusEnum?
              approvalStatus) =>
      _$this._approvalStatus = approvalStatus;

  AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum?
      _subscriptionIntentTier;
  AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum?
      get subscriptionIntentTier => _$this._subscriptionIntentTier;
  set subscriptionIntentTier(
          AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum?
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

  AdminSalonQueueResponseItemsInnerBuilder() {
    AdminSalonQueueResponseItemsInner._defaults(this);
  }

  AdminSalonQueueResponseItemsInnerBuilder get _$this {
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
  void replace(AdminSalonQueueResponseItemsInner other) {
    _$v = other as _$AdminSalonQueueResponseItemsInner;
  }

  @override
  void update(
      void Function(AdminSalonQueueResponseItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSalonQueueResponseItemsInner build() => _build();

  _$AdminSalonQueueResponseItemsInner _build() {
    _$AdminSalonQueueResponseItemsInner _$result;
    try {
      _$result = _$v ??
          _$AdminSalonQueueResponseItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminSalonQueueResponseItemsInner', 'id'),
            salonName: BuiltValueNullFieldError.checkNotNull(
                salonName, r'AdminSalonQueueResponseItemsInner', 'salonName'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'AdminSalonQueueResponseItemsInner', 'category'),
            city: BuiltValueNullFieldError.checkNotNull(
                city, r'AdminSalonQueueResponseItemsInner', 'city'),
            ownerName: BuiltValueNullFieldError.checkNotNull(
                ownerName, r'AdminSalonQueueResponseItemsInner', 'ownerName'),
            submittedAt: BuiltValueNullFieldError.checkNotNull(submittedAt,
                r'AdminSalonQueueResponseItemsInner', 'submittedAt'),
            approvalStatus: BuiltValueNullFieldError.checkNotNull(
                approvalStatus,
                r'AdminSalonQueueResponseItemsInner',
                'approvalStatus'),
            subscriptionIntentTier: BuiltValueNullFieldError.checkNotNull(
                subscriptionIntentTier,
                r'AdminSalonQueueResponseItemsInner',
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
            r'AdminSalonQueueResponseItemsInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
