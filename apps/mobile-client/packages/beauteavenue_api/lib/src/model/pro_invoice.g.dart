// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_invoice.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProInvoice extends ProInvoice {
  @override
  final String id;
  @override
  final String invoiceNumber;
  @override
  final int amountXof;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final String? pdfUrl;

  factory _$ProInvoice([void Function(ProInvoiceBuilder)? updates]) =>
      (ProInvoiceBuilder()..update(updates))._build();

  _$ProInvoice._(
      {required this.id,
      required this.invoiceNumber,
      required this.amountXof,
      required this.status,
      required this.createdAt,
      this.pdfUrl})
      : super._();
  @override
  ProInvoice rebuild(void Function(ProInvoiceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProInvoiceBuilder toBuilder() => ProInvoiceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProInvoice &&
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
    return (newBuiltValueToStringHelper(r'ProInvoice')
          ..add('id', id)
          ..add('invoiceNumber', invoiceNumber)
          ..add('amountXof', amountXof)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('pdfUrl', pdfUrl))
        .toString();
  }
}

class ProInvoiceBuilder implements Builder<ProInvoice, ProInvoiceBuilder> {
  _$ProInvoice? _$v;

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

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _pdfUrl;
  String? get pdfUrl => _$this._pdfUrl;
  set pdfUrl(String? pdfUrl) => _$this._pdfUrl = pdfUrl;

  ProInvoiceBuilder() {
    ProInvoice._defaults(this);
  }

  ProInvoiceBuilder get _$this {
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
  void replace(ProInvoice other) {
    _$v = other as _$ProInvoice;
  }

  @override
  void update(void Function(ProInvoiceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProInvoice build() => _build();

  _$ProInvoice _build() {
    final _$result = _$v ??
        _$ProInvoice._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ProInvoice', 'id'),
          invoiceNumber: BuiltValueNullFieldError.checkNotNull(
              invoiceNumber, r'ProInvoice', 'invoiceNumber'),
          amountXof: BuiltValueNullFieldError.checkNotNull(
              amountXof, r'ProInvoice', 'amountXof'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ProInvoice', 'status'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'ProInvoice', 'createdAt'),
          pdfUrl: pdfUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
