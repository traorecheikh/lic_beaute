// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BookingSummaryStatusEnum _$bookingSummaryStatusEnum_pending =
    const BookingSummaryStatusEnum._('pending');
const BookingSummaryStatusEnum _$bookingSummaryStatusEnum_confirmed =
    const BookingSummaryStatusEnum._('confirmed');
const BookingSummaryStatusEnum _$bookingSummaryStatusEnum_inProgress =
    const BookingSummaryStatusEnum._('inProgress');
const BookingSummaryStatusEnum _$bookingSummaryStatusEnum_completed =
    const BookingSummaryStatusEnum._('completed');
const BookingSummaryStatusEnum _$bookingSummaryStatusEnum_cancelled =
    const BookingSummaryStatusEnum._('cancelled');

BookingSummaryStatusEnum _$bookingSummaryStatusEnumValueOf(String name) {
  switch (name) {
    case 'pending':
      return _$bookingSummaryStatusEnum_pending;
    case 'confirmed':
      return _$bookingSummaryStatusEnum_confirmed;
    case 'inProgress':
      return _$bookingSummaryStatusEnum_inProgress;
    case 'completed':
      return _$bookingSummaryStatusEnum_completed;
    case 'cancelled':
      return _$bookingSummaryStatusEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BookingSummaryStatusEnum> _$bookingSummaryStatusEnumValues =
    BuiltSet<BookingSummaryStatusEnum>(const <BookingSummaryStatusEnum>[
  _$bookingSummaryStatusEnum_pending,
  _$bookingSummaryStatusEnum_confirmed,
  _$bookingSummaryStatusEnum_inProgress,
  _$bookingSummaryStatusEnum_completed,
  _$bookingSummaryStatusEnum_cancelled,
]);

const BookingSummaryDepositPaymentStatusEnum
    _$bookingSummaryDepositPaymentStatusEnum_pending =
    const BookingSummaryDepositPaymentStatusEnum._('pending');
const BookingSummaryDepositPaymentStatusEnum
    _$bookingSummaryDepositPaymentStatusEnum_authorized =
    const BookingSummaryDepositPaymentStatusEnum._('authorized');
const BookingSummaryDepositPaymentStatusEnum
    _$bookingSummaryDepositPaymentStatusEnum_succeeded =
    const BookingSummaryDepositPaymentStatusEnum._('succeeded');
const BookingSummaryDepositPaymentStatusEnum
    _$bookingSummaryDepositPaymentStatusEnum_failed =
    const BookingSummaryDepositPaymentStatusEnum._('failed');
const BookingSummaryDepositPaymentStatusEnum
    _$bookingSummaryDepositPaymentStatusEnum_refunded =
    const BookingSummaryDepositPaymentStatusEnum._('refunded');

BookingSummaryDepositPaymentStatusEnum
    _$bookingSummaryDepositPaymentStatusEnumValueOf(String name) {
  switch (name) {
    case 'pending':
      return _$bookingSummaryDepositPaymentStatusEnum_pending;
    case 'authorized':
      return _$bookingSummaryDepositPaymentStatusEnum_authorized;
    case 'succeeded':
      return _$bookingSummaryDepositPaymentStatusEnum_succeeded;
    case 'failed':
      return _$bookingSummaryDepositPaymentStatusEnum_failed;
    case 'refunded':
      return _$bookingSummaryDepositPaymentStatusEnum_refunded;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BookingSummaryDepositPaymentStatusEnum>
    _$bookingSummaryDepositPaymentStatusEnumValues = BuiltSet<
        BookingSummaryDepositPaymentStatusEnum>(const <BookingSummaryDepositPaymentStatusEnum>[
  _$bookingSummaryDepositPaymentStatusEnum_pending,
  _$bookingSummaryDepositPaymentStatusEnum_authorized,
  _$bookingSummaryDepositPaymentStatusEnum_succeeded,
  _$bookingSummaryDepositPaymentStatusEnum_failed,
  _$bookingSummaryDepositPaymentStatusEnum_refunded,
]);

const BookingSummaryPaymentProviderEnum
    _$bookingSummaryPaymentProviderEnum_intech =
    const BookingSummaryPaymentProviderEnum._('intech');
const BookingSummaryPaymentProviderEnum
    _$bookingSummaryPaymentProviderEnum_paydunya =
    const BookingSummaryPaymentProviderEnum._('paydunya');
const BookingSummaryPaymentProviderEnum
    _$bookingSummaryPaymentProviderEnum_manual =
    const BookingSummaryPaymentProviderEnum._('manual');

BookingSummaryPaymentProviderEnum _$bookingSummaryPaymentProviderEnumValueOf(
    String name) {
  switch (name) {
    case 'intech':
      return _$bookingSummaryPaymentProviderEnum_intech;
    case 'paydunya':
      return _$bookingSummaryPaymentProviderEnum_paydunya;
    case 'manual':
      return _$bookingSummaryPaymentProviderEnum_manual;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BookingSummaryPaymentProviderEnum>
    _$bookingSummaryPaymentProviderEnumValues = BuiltSet<
        BookingSummaryPaymentProviderEnum>(const <BookingSummaryPaymentProviderEnum>[
  _$bookingSummaryPaymentProviderEnum_intech,
  _$bookingSummaryPaymentProviderEnum_paydunya,
  _$bookingSummaryPaymentProviderEnum_manual,
]);

Serializer<BookingSummaryStatusEnum> _$bookingSummaryStatusEnumSerializer =
    _$BookingSummaryStatusEnumSerializer();
Serializer<BookingSummaryDepositPaymentStatusEnum>
    _$bookingSummaryDepositPaymentStatusEnumSerializer =
    _$BookingSummaryDepositPaymentStatusEnumSerializer();
Serializer<BookingSummaryPaymentProviderEnum>
    _$bookingSummaryPaymentProviderEnumSerializer =
    _$BookingSummaryPaymentProviderEnumSerializer();

class _$BookingSummaryStatusEnumSerializer
    implements PrimitiveSerializer<BookingSummaryStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'confirmed': 'confirmed',
    'inProgress': 'in_progress',
    'completed': 'completed',
    'cancelled': 'cancelled',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'confirmed': 'confirmed',
    'in_progress': 'inProgress',
    'completed': 'completed',
    'cancelled': 'cancelled',
  };

  @override
  final Iterable<Type> types = const <Type>[BookingSummaryStatusEnum];
  @override
  final String wireName = 'BookingSummaryStatusEnum';

  @override
  Object serialize(Serializers serializers, BookingSummaryStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BookingSummaryStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BookingSummaryStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BookingSummaryDepositPaymentStatusEnumSerializer
    implements PrimitiveSerializer<BookingSummaryDepositPaymentStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'pending': 'pending',
    'authorized': 'authorized',
    'succeeded': 'succeeded',
    'failed': 'failed',
    'refunded': 'refunded',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'pending': 'pending',
    'authorized': 'authorized',
    'succeeded': 'succeeded',
    'failed': 'failed',
    'refunded': 'refunded',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BookingSummaryDepositPaymentStatusEnum
  ];
  @override
  final String wireName = 'BookingSummaryDepositPaymentStatusEnum';

  @override
  Object serialize(Serializers serializers,
          BookingSummaryDepositPaymentStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BookingSummaryDepositPaymentStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BookingSummaryDepositPaymentStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BookingSummaryPaymentProviderEnumSerializer
    implements PrimitiveSerializer<BookingSummaryPaymentProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'intech': 'intech',
    'paydunya': 'paydunya',
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'intech': 'intech',
    'paydunya': 'paydunya',
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[BookingSummaryPaymentProviderEnum];
  @override
  final String wireName = 'BookingSummaryPaymentProviderEnum';

  @override
  Object serialize(
          Serializers serializers, BookingSummaryPaymentProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BookingSummaryPaymentProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BookingSummaryPaymentProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BookingSummary extends BookingSummary {
  @override
  final String id;
  @override
  final String salonId;
  @override
  final String salonName;
  @override
  final String serviceId;
  @override
  final String serviceName;
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;
  @override
  final BookingSummaryStatusEnum status;
  @override
  final String source_;
  @override
  final num depositAmountXof;
  @override
  final BookingSummaryDepositPaymentStatusEnum depositPaymentStatus;
  @override
  final BookingSummaryPaymentProviderEnum? paymentProvider;
  @override
  final String? paymentId;

  factory _$BookingSummary([void Function(BookingSummaryBuilder)? updates]) =>
      (BookingSummaryBuilder()..update(updates))._build();

  _$BookingSummary._(
      {required this.id,
      required this.salonId,
      required this.salonName,
      required this.serviceId,
      required this.serviceName,
      required this.startsAt,
      required this.endsAt,
      required this.status,
      required this.source_,
      required this.depositAmountXof,
      required this.depositPaymentStatus,
      this.paymentProvider,
      this.paymentId})
      : super._();
  @override
  BookingSummary rebuild(void Function(BookingSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookingSummaryBuilder toBuilder() => BookingSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookingSummary &&
        id == other.id &&
        salonId == other.salonId &&
        salonName == other.salonName &&
        serviceId == other.serviceId &&
        serviceName == other.serviceName &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt &&
        status == other.status &&
        source_ == other.source_ &&
        depositAmountXof == other.depositAmountXof &&
        depositPaymentStatus == other.depositPaymentStatus &&
        paymentProvider == other.paymentProvider &&
        paymentId == other.paymentId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jc(_$hash, salonName.hashCode);
    _$hash = $jc(_$hash, serviceId.hashCode);
    _$hash = $jc(_$hash, serviceName.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, depositAmountXof.hashCode);
    _$hash = $jc(_$hash, depositPaymentStatus.hashCode);
    _$hash = $jc(_$hash, paymentProvider.hashCode);
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BookingSummary')
          ..add('id', id)
          ..add('salonId', salonId)
          ..add('salonName', salonName)
          ..add('serviceId', serviceId)
          ..add('serviceName', serviceName)
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt)
          ..add('status', status)
          ..add('source_', source_)
          ..add('depositAmountXof', depositAmountXof)
          ..add('depositPaymentStatus', depositPaymentStatus)
          ..add('paymentProvider', paymentProvider)
          ..add('paymentId', paymentId))
        .toString();
  }
}

class BookingSummaryBuilder
    implements Builder<BookingSummary, BookingSummaryBuilder> {
  _$BookingSummary? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _salonName;
  String? get salonName => _$this._salonName;
  set salonName(String? salonName) => _$this._salonName = salonName;

  String? _serviceId;
  String? get serviceId => _$this._serviceId;
  set serviceId(String? serviceId) => _$this._serviceId = serviceId;

  String? _serviceName;
  String? get serviceName => _$this._serviceName;
  set serviceName(String? serviceName) => _$this._serviceName = serviceName;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  BookingSummaryStatusEnum? _status;
  BookingSummaryStatusEnum? get status => _$this._status;
  set status(BookingSummaryStatusEnum? status) => _$this._status = status;

  String? _source_;
  String? get source_ => _$this._source_;
  set source_(String? source_) => _$this._source_ = source_;

  num? _depositAmountXof;
  num? get depositAmountXof => _$this._depositAmountXof;
  set depositAmountXof(num? depositAmountXof) =>
      _$this._depositAmountXof = depositAmountXof;

  BookingSummaryDepositPaymentStatusEnum? _depositPaymentStatus;
  BookingSummaryDepositPaymentStatusEnum? get depositPaymentStatus =>
      _$this._depositPaymentStatus;
  set depositPaymentStatus(
          BookingSummaryDepositPaymentStatusEnum? depositPaymentStatus) =>
      _$this._depositPaymentStatus = depositPaymentStatus;

  BookingSummaryPaymentProviderEnum? _paymentProvider;
  BookingSummaryPaymentProviderEnum? get paymentProvider =>
      _$this._paymentProvider;
  set paymentProvider(BookingSummaryPaymentProviderEnum? paymentProvider) =>
      _$this._paymentProvider = paymentProvider;

  String? _paymentId;
  String? get paymentId => _$this._paymentId;
  set paymentId(String? paymentId) => _$this._paymentId = paymentId;

  BookingSummaryBuilder() {
    BookingSummary._defaults(this);
  }

  BookingSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _salonId = $v.salonId;
      _salonName = $v.salonName;
      _serviceId = $v.serviceId;
      _serviceName = $v.serviceName;
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _status = $v.status;
      _source_ = $v.source_;
      _depositAmountXof = $v.depositAmountXof;
      _depositPaymentStatus = $v.depositPaymentStatus;
      _paymentProvider = $v.paymentProvider;
      _paymentId = $v.paymentId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BookingSummary other) {
    _$v = other as _$BookingSummary;
  }

  @override
  void update(void Function(BookingSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookingSummary build() => _build();

  _$BookingSummary _build() {
    final _$result = _$v ??
        _$BookingSummary._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'BookingSummary', 'id'),
          salonId: BuiltValueNullFieldError.checkNotNull(
              salonId, r'BookingSummary', 'salonId'),
          salonName: BuiltValueNullFieldError.checkNotNull(
              salonName, r'BookingSummary', 'salonName'),
          serviceId: BuiltValueNullFieldError.checkNotNull(
              serviceId, r'BookingSummary', 'serviceId'),
          serviceName: BuiltValueNullFieldError.checkNotNull(
              serviceName, r'BookingSummary', 'serviceName'),
          startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt, r'BookingSummary', 'startsAt'),
          endsAt: BuiltValueNullFieldError.checkNotNull(
              endsAt, r'BookingSummary', 'endsAt'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'BookingSummary', 'status'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'BookingSummary', 'source_'),
          depositAmountXof: BuiltValueNullFieldError.checkNotNull(
              depositAmountXof, r'BookingSummary', 'depositAmountXof'),
          depositPaymentStatus: BuiltValueNullFieldError.checkNotNull(
              depositPaymentStatus, r'BookingSummary', 'depositPaymentStatus'),
          paymentProvider: paymentProvider,
          paymentId: paymentId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
