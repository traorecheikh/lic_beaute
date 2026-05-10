// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_salon_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSalonDetailApprovalStatusEnum
    _$adminSalonDetailApprovalStatusEnum_pendingReview =
    const AdminSalonDetailApprovalStatusEnum._('pendingReview');
const AdminSalonDetailApprovalStatusEnum
    _$adminSalonDetailApprovalStatusEnum_needsInfo =
    const AdminSalonDetailApprovalStatusEnum._('needsInfo');
const AdminSalonDetailApprovalStatusEnum
    _$adminSalonDetailApprovalStatusEnum_approved =
    const AdminSalonDetailApprovalStatusEnum._('approved');
const AdminSalonDetailApprovalStatusEnum
    _$adminSalonDetailApprovalStatusEnum_rejected =
    const AdminSalonDetailApprovalStatusEnum._('rejected');

AdminSalonDetailApprovalStatusEnum _$adminSalonDetailApprovalStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'pendingReview':
      return _$adminSalonDetailApprovalStatusEnum_pendingReview;
    case 'needsInfo':
      return _$adminSalonDetailApprovalStatusEnum_needsInfo;
    case 'approved':
      return _$adminSalonDetailApprovalStatusEnum_approved;
    case 'rejected':
      return _$adminSalonDetailApprovalStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSalonDetailApprovalStatusEnum>
    _$adminSalonDetailApprovalStatusEnumValues = BuiltSet<
        AdminSalonDetailApprovalStatusEnum>(const <AdminSalonDetailApprovalStatusEnum>[
  _$adminSalonDetailApprovalStatusEnum_pendingReview,
  _$adminSalonDetailApprovalStatusEnum_needsInfo,
  _$adminSalonDetailApprovalStatusEnum_approved,
  _$adminSalonDetailApprovalStatusEnum_rejected,
]);

const AdminSalonDetailSubscriptionIntentTierEnum
    _$adminSalonDetailSubscriptionIntentTierEnum_standard =
    const AdminSalonDetailSubscriptionIntentTierEnum._('standard');
const AdminSalonDetailSubscriptionIntentTierEnum
    _$adminSalonDetailSubscriptionIntentTierEnum_premium =
    const AdminSalonDetailSubscriptionIntentTierEnum._('premium');

AdminSalonDetailSubscriptionIntentTierEnum
    _$adminSalonDetailSubscriptionIntentTierEnumValueOf(String name) {
  switch (name) {
    case 'standard':
      return _$adminSalonDetailSubscriptionIntentTierEnum_standard;
    case 'premium':
      return _$adminSalonDetailSubscriptionIntentTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSalonDetailSubscriptionIntentTierEnum>
    _$adminSalonDetailSubscriptionIntentTierEnumValues = BuiltSet<
        AdminSalonDetailSubscriptionIntentTierEnum>(const <AdminSalonDetailSubscriptionIntentTierEnum>[
  _$adminSalonDetailSubscriptionIntentTierEnum_standard,
  _$adminSalonDetailSubscriptionIntentTierEnum_premium,
]);

Serializer<AdminSalonDetailApprovalStatusEnum>
    _$adminSalonDetailApprovalStatusEnumSerializer =
    _$AdminSalonDetailApprovalStatusEnumSerializer();
Serializer<AdminSalonDetailSubscriptionIntentTierEnum>
    _$adminSalonDetailSubscriptionIntentTierEnumSerializer =
    _$AdminSalonDetailSubscriptionIntentTierEnumSerializer();

class _$AdminSalonDetailApprovalStatusEnumSerializer
    implements PrimitiveSerializer<AdminSalonDetailApprovalStatusEnum> {
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
  final Iterable<Type> types = const <Type>[AdminSalonDetailApprovalStatusEnum];
  @override
  final String wireName = 'AdminSalonDetailApprovalStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminSalonDetailApprovalStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSalonDetailApprovalStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSalonDetailApprovalStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSalonDetailSubscriptionIntentTierEnumSerializer
    implements PrimitiveSerializer<AdminSalonDetailSubscriptionIntentTierEnum> {
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
    AdminSalonDetailSubscriptionIntentTierEnum
  ];
  @override
  final String wireName = 'AdminSalonDetailSubscriptionIntentTierEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSalonDetailSubscriptionIntentTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSalonDetailSubscriptionIntentTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSalonDetailSubscriptionIntentTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSalonDetail extends AdminSalonDetail {
  @override
  final String id;
  @override
  final String salonName;
  @override
  final String category;
  @override
  final String city;
  @override
  final String address;
  @override
  final String description;
  @override
  final ApiV1AdminSalonsPost201ResponseOwner owner;
  @override
  final AdminSalonDetailApprovalStatusEnum approvalStatus;
  @override
  final AdminSalonDetailSubscriptionIntentTierEnum subscriptionIntentTier;
  @override
  final DateTime submittedAt;
  @override
  final BuiltList<String> missingEvidence;
  @override
  final String? latestAdminNote;
  @override
  final BuiltList<String> gallery;
  @override
  final BuiltList<ApiV1AdminSalonsPost201ResponseServicesInner> services;
  @override
  final BuiltList<ApiV1AdminSalonsPost201ResponseDocumentsInner> documents;

  factory _$AdminSalonDetail(
          [void Function(AdminSalonDetailBuilder)? updates]) =>
      (AdminSalonDetailBuilder()..update(updates))._build();

  _$AdminSalonDetail._(
      {required this.id,
      required this.salonName,
      required this.category,
      required this.city,
      required this.address,
      required this.description,
      required this.owner,
      required this.approvalStatus,
      required this.subscriptionIntentTier,
      required this.submittedAt,
      required this.missingEvidence,
      this.latestAdminNote,
      required this.gallery,
      required this.services,
      required this.documents})
      : super._();
  @override
  AdminSalonDetail rebuild(void Function(AdminSalonDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSalonDetailBuilder toBuilder() =>
      AdminSalonDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSalonDetail &&
        id == other.id &&
        salonName == other.salonName &&
        category == other.category &&
        city == other.city &&
        address == other.address &&
        description == other.description &&
        owner == other.owner &&
        approvalStatus == other.approvalStatus &&
        subscriptionIntentTier == other.subscriptionIntentTier &&
        submittedAt == other.submittedAt &&
        missingEvidence == other.missingEvidence &&
        latestAdminNote == other.latestAdminNote &&
        gallery == other.gallery &&
        services == other.services &&
        documents == other.documents;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, salonName.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, owner.hashCode);
    _$hash = $jc(_$hash, approvalStatus.hashCode);
    _$hash = $jc(_$hash, subscriptionIntentTier.hashCode);
    _$hash = $jc(_$hash, submittedAt.hashCode);
    _$hash = $jc(_$hash, missingEvidence.hashCode);
    _$hash = $jc(_$hash, latestAdminNote.hashCode);
    _$hash = $jc(_$hash, gallery.hashCode);
    _$hash = $jc(_$hash, services.hashCode);
    _$hash = $jc(_$hash, documents.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSalonDetail')
          ..add('id', id)
          ..add('salonName', salonName)
          ..add('category', category)
          ..add('city', city)
          ..add('address', address)
          ..add('description', description)
          ..add('owner', owner)
          ..add('approvalStatus', approvalStatus)
          ..add('subscriptionIntentTier', subscriptionIntentTier)
          ..add('submittedAt', submittedAt)
          ..add('missingEvidence', missingEvidence)
          ..add('latestAdminNote', latestAdminNote)
          ..add('gallery', gallery)
          ..add('services', services)
          ..add('documents', documents))
        .toString();
  }
}

class AdminSalonDetailBuilder
    implements Builder<AdminSalonDetail, AdminSalonDetailBuilder> {
  _$AdminSalonDetail? _$v;

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

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  ApiV1AdminSalonsPost201ResponseOwnerBuilder? _owner;
  ApiV1AdminSalonsPost201ResponseOwnerBuilder get owner =>
      _$this._owner ??= ApiV1AdminSalonsPost201ResponseOwnerBuilder();
  set owner(ApiV1AdminSalonsPost201ResponseOwnerBuilder? owner) =>
      _$this._owner = owner;

  AdminSalonDetailApprovalStatusEnum? _approvalStatus;
  AdminSalonDetailApprovalStatusEnum? get approvalStatus =>
      _$this._approvalStatus;
  set approvalStatus(AdminSalonDetailApprovalStatusEnum? approvalStatus) =>
      _$this._approvalStatus = approvalStatus;

  AdminSalonDetailSubscriptionIntentTierEnum? _subscriptionIntentTier;
  AdminSalonDetailSubscriptionIntentTierEnum? get subscriptionIntentTier =>
      _$this._subscriptionIntentTier;
  set subscriptionIntentTier(
          AdminSalonDetailSubscriptionIntentTierEnum? subscriptionIntentTier) =>
      _$this._subscriptionIntentTier = subscriptionIntentTier;

  DateTime? _submittedAt;
  DateTime? get submittedAt => _$this._submittedAt;
  set submittedAt(DateTime? submittedAt) => _$this._submittedAt = submittedAt;

  ListBuilder<String>? _missingEvidence;
  ListBuilder<String> get missingEvidence =>
      _$this._missingEvidence ??= ListBuilder<String>();
  set missingEvidence(ListBuilder<String>? missingEvidence) =>
      _$this._missingEvidence = missingEvidence;

  String? _latestAdminNote;
  String? get latestAdminNote => _$this._latestAdminNote;
  set latestAdminNote(String? latestAdminNote) =>
      _$this._latestAdminNote = latestAdminNote;

  ListBuilder<String>? _gallery;
  ListBuilder<String> get gallery => _$this._gallery ??= ListBuilder<String>();
  set gallery(ListBuilder<String>? gallery) => _$this._gallery = gallery;

  ListBuilder<ApiV1AdminSalonsPost201ResponseServicesInner>? _services;
  ListBuilder<ApiV1AdminSalonsPost201ResponseServicesInner> get services =>
      _$this._services ??=
          ListBuilder<ApiV1AdminSalonsPost201ResponseServicesInner>();
  set services(
          ListBuilder<ApiV1AdminSalonsPost201ResponseServicesInner>?
              services) =>
      _$this._services = services;

  ListBuilder<ApiV1AdminSalonsPost201ResponseDocumentsInner>? _documents;
  ListBuilder<ApiV1AdminSalonsPost201ResponseDocumentsInner> get documents =>
      _$this._documents ??=
          ListBuilder<ApiV1AdminSalonsPost201ResponseDocumentsInner>();
  set documents(
          ListBuilder<ApiV1AdminSalonsPost201ResponseDocumentsInner>?
              documents) =>
      _$this._documents = documents;

  AdminSalonDetailBuilder() {
    AdminSalonDetail._defaults(this);
  }

  AdminSalonDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _salonName = $v.salonName;
      _category = $v.category;
      _city = $v.city;
      _address = $v.address;
      _description = $v.description;
      _owner = $v.owner.toBuilder();
      _approvalStatus = $v.approvalStatus;
      _subscriptionIntentTier = $v.subscriptionIntentTier;
      _submittedAt = $v.submittedAt;
      _missingEvidence = $v.missingEvidence.toBuilder();
      _latestAdminNote = $v.latestAdminNote;
      _gallery = $v.gallery.toBuilder();
      _services = $v.services.toBuilder();
      _documents = $v.documents.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSalonDetail other) {
    _$v = other as _$AdminSalonDetail;
  }

  @override
  void update(void Function(AdminSalonDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSalonDetail build() => _build();

  _$AdminSalonDetail _build() {
    _$AdminSalonDetail _$result;
    try {
      _$result = _$v ??
          _$AdminSalonDetail._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AdminSalonDetail', 'id'),
            salonName: BuiltValueNullFieldError.checkNotNull(
                salonName, r'AdminSalonDetail', 'salonName'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'AdminSalonDetail', 'category'),
            city: BuiltValueNullFieldError.checkNotNull(
                city, r'AdminSalonDetail', 'city'),
            address: BuiltValueNullFieldError.checkNotNull(
                address, r'AdminSalonDetail', 'address'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'AdminSalonDetail', 'description'),
            owner: owner.build(),
            approvalStatus: BuiltValueNullFieldError.checkNotNull(
                approvalStatus, r'AdminSalonDetail', 'approvalStatus'),
            subscriptionIntentTier: BuiltValueNullFieldError.checkNotNull(
                subscriptionIntentTier,
                r'AdminSalonDetail',
                'subscriptionIntentTier'),
            submittedAt: BuiltValueNullFieldError.checkNotNull(
                submittedAt, r'AdminSalonDetail', 'submittedAt'),
            missingEvidence: missingEvidence.build(),
            latestAdminNote: latestAdminNote,
            gallery: gallery.build(),
            services: services.build(),
            documents: documents.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'owner';
        owner.build();

        _$failedField = 'missingEvidence';
        missingEvidence.build();

        _$failedField = 'gallery';
        gallery.build();
        _$failedField = 'services';
        services.build();
        _$failedField = 'documents';
        documents.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AdminSalonDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
