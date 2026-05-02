// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_subscription_detail_invoices_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSubscriptionDetailInvoicesInnerStatusEnum
    _$adminSubscriptionDetailInvoicesInnerStatusEnum_issued =
    const AdminSubscriptionDetailInvoicesInnerStatusEnum._('issued');
const AdminSubscriptionDetailInvoicesInnerStatusEnum
    _$adminSubscriptionDetailInvoicesInnerStatusEnum_void_ =
    const AdminSubscriptionDetailInvoicesInnerStatusEnum._('void_');
const AdminSubscriptionDetailInvoicesInnerStatusEnum
    _$adminSubscriptionDetailInvoicesInnerStatusEnum_paid =
    const AdminSubscriptionDetailInvoicesInnerStatusEnum._('paid');
const AdminSubscriptionDetailInvoicesInnerStatusEnum
    _$adminSubscriptionDetailInvoicesInnerStatusEnum_comped =
    const AdminSubscriptionDetailInvoicesInnerStatusEnum._('comped');

AdminSubscriptionDetailInvoicesInnerStatusEnum
    _$adminSubscriptionDetailInvoicesInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'issued':
      return _$adminSubscriptionDetailInvoicesInnerStatusEnum_issued;
    case 'void_':
      return _$adminSubscriptionDetailInvoicesInnerStatusEnum_void_;
    case 'paid':
      return _$adminSubscriptionDetailInvoicesInnerStatusEnum_paid;
    case 'comped':
      return _$adminSubscriptionDetailInvoicesInnerStatusEnum_comped;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionDetailInvoicesInnerStatusEnum>
    _$adminSubscriptionDetailInvoicesInnerStatusEnumValues = BuiltSet<
        AdminSubscriptionDetailInvoicesInnerStatusEnum>(const <AdminSubscriptionDetailInvoicesInnerStatusEnum>[
  _$adminSubscriptionDetailInvoicesInnerStatusEnum_issued,
  _$adminSubscriptionDetailInvoicesInnerStatusEnum_void_,
  _$adminSubscriptionDetailInvoicesInnerStatusEnum_paid,
  _$adminSubscriptionDetailInvoicesInnerStatusEnum_comped,
]);

Serializer<AdminSubscriptionDetailInvoicesInnerStatusEnum>
    _$adminSubscriptionDetailInvoicesInnerStatusEnumSerializer =
    _$AdminSubscriptionDetailInvoicesInnerStatusEnumSerializer();

class _$AdminSubscriptionDetailInvoicesInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminSubscriptionDetailInvoicesInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'issued': 'issued',
    'void_': 'void',
    'paid': 'paid',
    'comped': 'comped',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'issued': 'issued',
    'void': 'void_',
    'paid': 'paid',
    'comped': 'comped',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSubscriptionDetailInvoicesInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminSubscriptionDetailInvoicesInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSubscriptionDetailInvoicesInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionDetailInvoicesInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionDetailInvoicesInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionDetailInvoicesInner
    extends AdminSubscriptionDetailInvoicesInner {
  @override
  final String id;
  @override
  final String invoiceNumber;
  @override
  final int amountXof;
  @override
  final AdminSubscriptionDetailInvoicesInnerStatusEnum status;
  @override
  final DateTime createdAt;
  @override
  final String pdfUrl;

  factory _$AdminSubscriptionDetailInvoicesInner(
          [void Function(AdminSubscriptionDetailInvoicesInnerBuilder)?
              updates]) =>
      (AdminSubscriptionDetailInvoicesInnerBuilder()..update(updates))._build();

  _$AdminSubscriptionDetailInvoicesInner._(
      {required this.id,
      required this.invoiceNumber,
      required this.amountXof,
      required this.status,
      required this.createdAt,
      required this.pdfUrl})
      : super._();
  @override
  AdminSubscriptionDetailInvoicesInner rebuild(
          void Function(AdminSubscriptionDetailInvoicesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSubscriptionDetailInvoicesInnerBuilder toBuilder() =>
      AdminSubscriptionDetailInvoicesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSubscriptionDetailInvoicesInner &&
        id == other.id &&
        invoiceNumber == other.invoiceNumber &&
        amountXof == other.amountXof &&
        status == other.status &&
        createdAt == other.createdAt &&
        pdfUrl == other.pdfUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, invoiceNumber.hashCode);
    _$hash = $jc(_$hash, amountXof.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, pdfUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSubscriptionDetailInvoicesInner')
          ..add('id', id)
          ..add('invoiceNumber', invoiceNumber)
          ..add('amountXof', amountXof)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('pdfUrl', pdfUrl))
        .toString();
  }
}

class AdminSubscriptionDetailInvoicesInnerBuilder
    implements
        Builder<AdminSubscriptionDetailInvoicesInner,
            AdminSubscriptionDetailInvoicesInnerBuilder> {
  _$AdminSubscriptionDetailInvoicesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _invoiceNumber;
  String? get invoiceNumber => _$this._invoiceNumber;
  set invoiceNumber(String? invoiceNumber) =>
      _$this._invoiceNumber = invoiceNumber;

  int? _amountXof;
  int? get amountXof => _$this._amountXof;
  set amountXof(int? amountXof) => _$this._amountXof = amountXof;

  AdminSubscriptionDetailInvoicesInnerStatusEnum? _status;
  AdminSubscriptionDetailInvoicesInnerStatusEnum? get status => _$this._status;
  set status(AdminSubscriptionDetailInvoicesInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _pdfUrl;
  String? get pdfUrl => _$this._pdfUrl;
  set pdfUrl(String? pdfUrl) => _$this._pdfUrl = pdfUrl;

  AdminSubscriptionDetailInvoicesInnerBuilder() {
    AdminSubscriptionDetailInvoicesInner._defaults(this);
  }

  AdminSubscriptionDetailInvoicesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _invoiceNumber = $v.invoiceNumber;
      _amountXof = $v.amountXof;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _pdfUrl = $v.pdfUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSubscriptionDetailInvoicesInner other) {
    _$v = other as _$AdminSubscriptionDetailInvoicesInner;
  }

  @override
  void update(
      void Function(AdminSubscriptionDetailInvoicesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSubscriptionDetailInvoicesInner build() => _build();

  _$AdminSubscriptionDetailInvoicesInner _build() {
    final _$result = _$v ??
        _$AdminSubscriptionDetailInvoicesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminSubscriptionDetailInvoicesInner', 'id'),
          invoiceNumber: BuiltValueNullFieldError.checkNotNull(invoiceNumber,
              r'AdminSubscriptionDetailInvoicesInner', 'invoiceNumber'),
          amountXof: BuiltValueNullFieldError.checkNotNull(
              amountXof, r'AdminSubscriptionDetailInvoicesInner', 'amountXof'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminSubscriptionDetailInvoicesInner', 'status'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminSubscriptionDetailInvoicesInner', 'createdAt'),
          pdfUrl: BuiltValueNullFieldError.checkNotNull(
              pdfUrl, r'AdminSubscriptionDetailInvoicesInner', 'pdfUrl'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
