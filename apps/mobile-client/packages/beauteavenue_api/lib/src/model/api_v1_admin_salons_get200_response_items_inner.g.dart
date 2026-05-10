// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_salons_get200_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum
    _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_pendingReview =
    const ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum._(
        'pendingReview');
const ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum
    _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_needsInfo =
    const ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum._(
        'needsInfo');
const ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum
    _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_approved =
    const ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum._(
        'approved');
const ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum
    _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_rejected =
    const ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum._(
        'rejected');

ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum
    _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'pendingReview':
      return _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_pendingReview;
    case 'needsInfo':
      return _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_needsInfo;
    case 'approved':
      return _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_approved;
    case 'rejected':
      return _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum>
    _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnumValues =
    BuiltSet<
        ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum>(const <ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum>[
  _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_pendingReview,
  _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_needsInfo,
  _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_approved,
  _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum_rejected,
]);

const ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum
    _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum_standard =
    const ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum._(
        'standard');
const ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum
    _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum_premium =
    const ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum._(
        'premium');

ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum
    _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnumValueOf(
        String name) {
  switch (name) {
    case 'standard':
      return _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum_standard;
    case 'premium':
      return _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
        ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum>
    _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnumValues =
    BuiltSet<
        ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum>(const <ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum>[
  _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum_standard,
  _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum_premium,
]);

Serializer<ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum>
    _$apiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnumSerializer =
    _$ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnumSerializer();
Serializer<ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum>
    _$apiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnumSerializer =
    _$ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnumSerializer();

class _$ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnumSerializer
    implements
        PrimitiveSerializer<
            ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum> {
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
    ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum
  ];
  @override
  final String wireName =
      'ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum';

  @override
  Object serialize(Serializers serializers,
          ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnumSerializer
    implements
        PrimitiveSerializer<
            ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum> {
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
    ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum
  ];
  @override
  final String wireName =
      'ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum';

  @override
  Object serialize(
          Serializers serializers,
          ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum
              object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum
      deserialize(Serializers serializers, Object serialized,
              {FullType specifiedType = FullType.unspecified}) =>
          ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum
              .valueOf(_fromWire[serialized] ??
                  (serialized is String ? serialized : ''));
}

class _$ApiV1AdminSalonsGet200ResponseItemsInner
    extends ApiV1AdminSalonsGet200ResponseItemsInner {
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
  final ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum
      approvalStatus;
  @override
  final ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum
      subscriptionIntentTier;
  @override
  final BuiltList<String> missingEvidence;
  @override
  final String? latestAdminNote;

  factory _$ApiV1AdminSalonsGet200ResponseItemsInner(
          [void Function(ApiV1AdminSalonsGet200ResponseItemsInnerBuilder)?
              updates]) =>
      (ApiV1AdminSalonsGet200ResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$ApiV1AdminSalonsGet200ResponseItemsInner._(
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
  ApiV1AdminSalonsGet200ResponseItemsInner rebuild(
          void Function(ApiV1AdminSalonsGet200ResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminSalonsGet200ResponseItemsInnerBuilder toBuilder() =>
      ApiV1AdminSalonsGet200ResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminSalonsGet200ResponseItemsInner &&
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
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminSalonsGet200ResponseItemsInner')
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

class ApiV1AdminSalonsGet200ResponseItemsInnerBuilder
    implements
        Builder<ApiV1AdminSalonsGet200ResponseItemsInner,
            ApiV1AdminSalonsGet200ResponseItemsInnerBuilder> {
  _$ApiV1AdminSalonsGet200ResponseItemsInner? _$v;

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

  ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum? _approvalStatus;
  ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum?
      get approvalStatus => _$this._approvalStatus;
  set approvalStatus(
          ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum?
              approvalStatus) =>
      _$this._approvalStatus = approvalStatus;

  ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum?
      _subscriptionIntentTier;
  ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum?
      get subscriptionIntentTier => _$this._subscriptionIntentTier;
  set subscriptionIntentTier(
          ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum?
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

  ApiV1AdminSalonsGet200ResponseItemsInnerBuilder() {
    ApiV1AdminSalonsGet200ResponseItemsInner._defaults(this);
  }

  ApiV1AdminSalonsGet200ResponseItemsInnerBuilder get _$this {
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
  void replace(ApiV1AdminSalonsGet200ResponseItemsInner other) {
    _$v = other as _$ApiV1AdminSalonsGet200ResponseItemsInner;
  }

  @override
  void update(
      void Function(ApiV1AdminSalonsGet200ResponseItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminSalonsGet200ResponseItemsInner build() => _build();

  _$ApiV1AdminSalonsGet200ResponseItemsInner _build() {
    _$ApiV1AdminSalonsGet200ResponseItemsInner _$result;
    try {
      _$result = _$v ??
          _$ApiV1AdminSalonsGet200ResponseItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ApiV1AdminSalonsGet200ResponseItemsInner', 'id'),
            salonName: BuiltValueNullFieldError.checkNotNull(salonName,
                r'ApiV1AdminSalonsGet200ResponseItemsInner', 'salonName'),
            category: BuiltValueNullFieldError.checkNotNull(category,
                r'ApiV1AdminSalonsGet200ResponseItemsInner', 'category'),
            city: BuiltValueNullFieldError.checkNotNull(
                city, r'ApiV1AdminSalonsGet200ResponseItemsInner', 'city'),
            ownerName: BuiltValueNullFieldError.checkNotNull(ownerName,
                r'ApiV1AdminSalonsGet200ResponseItemsInner', 'ownerName'),
            submittedAt: BuiltValueNullFieldError.checkNotNull(submittedAt,
                r'ApiV1AdminSalonsGet200ResponseItemsInner', 'submittedAt'),
            approvalStatus: BuiltValueNullFieldError.checkNotNull(
                approvalStatus,
                r'ApiV1AdminSalonsGet200ResponseItemsInner',
                'approvalStatus'),
            subscriptionIntentTier: BuiltValueNullFieldError.checkNotNull(
                subscriptionIntentTier,
                r'ApiV1AdminSalonsGet200ResponseItemsInner',
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
            r'ApiV1AdminSalonsGet200ResponseItemsInner',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
