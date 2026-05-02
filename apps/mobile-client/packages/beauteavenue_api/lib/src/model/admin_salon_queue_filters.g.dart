// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_salon_queue_filters.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSalonQueueFiltersStatusEnum
    _$adminSalonQueueFiltersStatusEnum_pendingReview =
    const AdminSalonQueueFiltersStatusEnum._('pendingReview');
const AdminSalonQueueFiltersStatusEnum
    _$adminSalonQueueFiltersStatusEnum_needsInfo =
    const AdminSalonQueueFiltersStatusEnum._('needsInfo');
const AdminSalonQueueFiltersStatusEnum
    _$adminSalonQueueFiltersStatusEnum_approved =
    const AdminSalonQueueFiltersStatusEnum._('approved');
const AdminSalonQueueFiltersStatusEnum
    _$adminSalonQueueFiltersStatusEnum_rejected =
    const AdminSalonQueueFiltersStatusEnum._('rejected');

AdminSalonQueueFiltersStatusEnum _$adminSalonQueueFiltersStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'pendingReview':
      return _$adminSalonQueueFiltersStatusEnum_pendingReview;
    case 'needsInfo':
      return _$adminSalonQueueFiltersStatusEnum_needsInfo;
    case 'approved':
      return _$adminSalonQueueFiltersStatusEnum_approved;
    case 'rejected':
      return _$adminSalonQueueFiltersStatusEnum_rejected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSalonQueueFiltersStatusEnum>
    _$adminSalonQueueFiltersStatusEnumValues = BuiltSet<
        AdminSalonQueueFiltersStatusEnum>(const <AdminSalonQueueFiltersStatusEnum>[
  _$adminSalonQueueFiltersStatusEnum_pendingReview,
  _$adminSalonQueueFiltersStatusEnum_needsInfo,
  _$adminSalonQueueFiltersStatusEnum_approved,
  _$adminSalonQueueFiltersStatusEnum_rejected,
]);

Serializer<AdminSalonQueueFiltersStatusEnum>
    _$adminSalonQueueFiltersStatusEnumSerializer =
    _$AdminSalonQueueFiltersStatusEnumSerializer();

class _$AdminSalonQueueFiltersStatusEnumSerializer
    implements PrimitiveSerializer<AdminSalonQueueFiltersStatusEnum> {
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
  final Iterable<Type> types = const <Type>[AdminSalonQueueFiltersStatusEnum];
  @override
  final String wireName = 'AdminSalonQueueFiltersStatusEnum';

  @override
  Object serialize(
          Serializers serializers, AdminSalonQueueFiltersStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSalonQueueFiltersStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSalonQueueFiltersStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSalonQueueFilters extends AdminSalonQueueFilters {
  @override
  final String? search;
  @override
  final String? category;
  @override
  final String? city;
  @override
  final AdminSalonQueueFiltersStatusEnum? status;

  factory _$AdminSalonQueueFilters(
          [void Function(AdminSalonQueueFiltersBuilder)? updates]) =>
      (AdminSalonQueueFiltersBuilder()..update(updates))._build();

  _$AdminSalonQueueFilters._(
      {this.search, this.category, this.city, this.status})
      : super._();
  @override
  AdminSalonQueueFilters rebuild(
          void Function(AdminSalonQueueFiltersBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSalonQueueFiltersBuilder toBuilder() =>
      AdminSalonQueueFiltersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSalonQueueFilters &&
        search == other.search &&
        category == other.category &&
        city == other.city &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, search.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSalonQueueFilters')
          ..add('search', search)
          ..add('category', category)
          ..add('city', city)
          ..add('status', status))
        .toString();
  }
}

class AdminSalonQueueFiltersBuilder
    implements Builder<AdminSalonQueueFilters, AdminSalonQueueFiltersBuilder> {
  _$AdminSalonQueueFilters? _$v;

  String? _search;
  String? get search => _$this._search;
  set search(String? search) => _$this._search = search;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  AdminSalonQueueFiltersStatusEnum? _status;
  AdminSalonQueueFiltersStatusEnum? get status => _$this._status;
  set status(AdminSalonQueueFiltersStatusEnum? status) =>
      _$this._status = status;

  AdminSalonQueueFiltersBuilder() {
    AdminSalonQueueFilters._defaults(this);
  }

  AdminSalonQueueFiltersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _search = $v.search;
      _category = $v.category;
      _city = $v.city;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSalonQueueFilters other) {
    _$v = other as _$AdminSalonQueueFilters;
  }

  @override
  void update(void Function(AdminSalonQueueFiltersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSalonQueueFilters build() => _build();

  _$AdminSalonQueueFilters _build() {
    final _$result = _$v ??
        _$AdminSalonQueueFilters._(
          search: search,
          category: category,
          city: city,
          status: status,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
