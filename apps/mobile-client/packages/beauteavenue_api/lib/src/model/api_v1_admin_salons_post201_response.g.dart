// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_salons_post201_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1AdminSalonsPost201ResponseApprovalStatusEnum
    _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_pendingReview =
    const ApiV1AdminSalonsPost201ResponseApprovalStatusEnum._('pendingReview');
const ApiV1AdminSalonsPost201ResponseApprovalStatusEnum
    _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_needsInfo =
    const ApiV1AdminSalonsPost201ResponseApprovalStatusEnum._('needsInfo');
const ApiV1AdminSalonsPost201ResponseApprovalStatusEnum
    _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_approved =
    const ApiV1AdminSalonsPost201ResponseApprovalStatusEnum._('approved');
const ApiV1AdminSalonsPost201ResponseApprovalStatusEnum
    _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_rejected =
    const ApiV1AdminSalonsPost201ResponseApprovalStatusEnum._('rejected');

ApiV1AdminSalonsPost201ResponseApprovalStatusEnum
    _$apiV1AdminSalonsPost201ResponseApprovalStatusEnumValueOf(String name) {
  switch (name) {
    case 'pendingReview':
      return _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_pendingReview;
    case 'needsInfo':
      return _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_needsInfo;
    case 'approved':
      return _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_approved;
    case 'rejected':
      return _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1AdminSalonsPost201ResponseApprovalStatusEnum>
    _$apiV1AdminSalonsPost201ResponseApprovalStatusEnumValues = BuiltSet<
        ApiV1AdminSalonsPost201ResponseApprovalStatusEnum>(const <ApiV1AdminSalonsPost201ResponseApprovalStatusEnum>[
  _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_pendingReview,
  _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_needsInfo,
  _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_approved,
  _$apiV1AdminSalonsPost201ResponseApprovalStatusEnum_rejected,
]);

const ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum
    _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum_standard =
    const ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum._(
        'standard');
const ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum
    _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum_premium =
    const ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum._(
        'premium');

ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum
    _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnumValueOf(
        String name) {
  switch (name) {
    case 'standard':
      return _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum_standard;
    case 'premium':
      return _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum_premium;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum>
    _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnumValues =
    BuiltSet<
        ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum>(const <ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum>[
  _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum_standard,
  _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum_premium,
]);

Serializer<ApiV1AdminSalonsPost201ResponseApprovalStatusEnum>
    _$apiV1AdminSalonsPost201ResponseApprovalStatusEnumSerializer =
    _$ApiV1AdminSalonsPost201ResponseApprovalStatusEnumSerializer();
Serializer<ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum>
    _$apiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnumSerializer =
    _$ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnumSerializer();

class _$ApiV1AdminSalonsPost201ResponseApprovalStatusEnumSerializer
    implements
        PrimitiveSerializer<ApiV1AdminSalonsPost201ResponseApprovalStatusEnum> {
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
    ApiV1AdminSalonsPost201ResponseApprovalStatusEnum
  ];
  @override
  final String wireName = 'ApiV1AdminSalonsPost201ResponseApprovalStatusEnum';

  @override
  Object serialize(Serializers serializers,
          ApiV1AdminSalonsPost201ResponseApprovalStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiV1AdminSalonsPost201ResponseApprovalStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiV1AdminSalonsPost201ResponseApprovalStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnumSerializer
    implements
        PrimitiveSerializer<
            ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum> {
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
    ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum
  ];
  @override
  final String wireName =
      'ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum';

  @override
  Object serialize(Serializers serializers,
          ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiV1AdminSalonsPost201Response
    extends ApiV1AdminSalonsPost201Response {
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
  final ApiV1AdminSalonsPost201ResponseApprovalStatusEnum approvalStatus;
  @override
  final ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum
      subscriptionIntentTier;
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
  @override
  final String? temporaryPassword;

  factory _$ApiV1AdminSalonsPost201Response(
          [void Function(ApiV1AdminSalonsPost201ResponseBuilder)? updates]) =>
      (ApiV1AdminSalonsPost201ResponseBuilder()..update(updates))._build();

  _$ApiV1AdminSalonsPost201Response._(
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
      required this.documents,
      this.temporaryPassword})
      : super._();
  @override
  ApiV1AdminSalonsPost201Response rebuild(
          void Function(ApiV1AdminSalonsPost201ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminSalonsPost201ResponseBuilder toBuilder() =>
      ApiV1AdminSalonsPost201ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminSalonsPost201Response &&
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
        documents == other.documents &&
        temporaryPassword == other.temporaryPassword;
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
    _$hash = $jc(_$hash, temporaryPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1AdminSalonsPost201Response')
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
          ..add('documents', documents)
          ..add('temporaryPassword', temporaryPassword))
        .toString();
  }
}

class ApiV1AdminSalonsPost201ResponseBuilder
    implements
        Builder<ApiV1AdminSalonsPost201Response,
            ApiV1AdminSalonsPost201ResponseBuilder> {
  _$ApiV1AdminSalonsPost201Response? _$v;

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

  ApiV1AdminSalonsPost201ResponseApprovalStatusEnum? _approvalStatus;
  ApiV1AdminSalonsPost201ResponseApprovalStatusEnum? get approvalStatus =>
      _$this._approvalStatus;
  set approvalStatus(
          ApiV1AdminSalonsPost201ResponseApprovalStatusEnum? approvalStatus) =>
      _$this._approvalStatus = approvalStatus;

  ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum?
      _subscriptionIntentTier;
  ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum?
      get subscriptionIntentTier => _$this._subscriptionIntentTier;
  set subscriptionIntentTier(
          ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum?
              subscriptionIntentTier) =>
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

  String? _temporaryPassword;
  String? get temporaryPassword => _$this._temporaryPassword;
  set temporaryPassword(String? temporaryPassword) =>
      _$this._temporaryPassword = temporaryPassword;

  ApiV1AdminSalonsPost201ResponseBuilder() {
    ApiV1AdminSalonsPost201Response._defaults(this);
  }

  ApiV1AdminSalonsPost201ResponseBuilder get _$this {
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
      _temporaryPassword = $v.temporaryPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminSalonsPost201Response other) {
    _$v = other as _$ApiV1AdminSalonsPost201Response;
  }

  @override
  void update(void Function(ApiV1AdminSalonsPost201ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminSalonsPost201Response build() => _build();

  _$ApiV1AdminSalonsPost201Response _build() {
    _$ApiV1AdminSalonsPost201Response _$result;
    try {
      _$result = _$v ??
          _$ApiV1AdminSalonsPost201Response._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'ApiV1AdminSalonsPost201Response', 'id'),
            salonName: BuiltValueNullFieldError.checkNotNull(
                salonName, r'ApiV1AdminSalonsPost201Response', 'salonName'),
            category: BuiltValueNullFieldError.checkNotNull(
                category, r'ApiV1AdminSalonsPost201Response', 'category'),
            city: BuiltValueNullFieldError.checkNotNull(
                city, r'ApiV1AdminSalonsPost201Response', 'city'),
            address: BuiltValueNullFieldError.checkNotNull(
                address, r'ApiV1AdminSalonsPost201Response', 'address'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'ApiV1AdminSalonsPost201Response', 'description'),
            owner: owner.build(),
            approvalStatus: BuiltValueNullFieldError.checkNotNull(
                approvalStatus,
                r'ApiV1AdminSalonsPost201Response',
                'approvalStatus'),
            subscriptionIntentTier: BuiltValueNullFieldError.checkNotNull(
                subscriptionIntentTier,
                r'ApiV1AdminSalonsPost201Response',
                'subscriptionIntentTier'),
            submittedAt: BuiltValueNullFieldError.checkNotNull(
                submittedAt, r'ApiV1AdminSalonsPost201Response', 'submittedAt'),
            missingEvidence: missingEvidence.build(),
            latestAdminNote: latestAdminNote,
            gallery: gallery.build(),
            services: services.build(),
            documents: documents.build(),
            temporaryPassword: temporaryPassword,
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
            r'ApiV1AdminSalonsPost201Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
