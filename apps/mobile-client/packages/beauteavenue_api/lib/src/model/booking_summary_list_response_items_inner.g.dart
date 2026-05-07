// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_summary_list_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BookingSummaryListResponseItemsInnerStatusEnum
    _$bookingSummaryListResponseItemsInnerStatusEnum_pending =
    const BookingSummaryListResponseItemsInnerStatusEnum._('pending');
const BookingSummaryListResponseItemsInnerStatusEnum
    _$bookingSummaryListResponseItemsInnerStatusEnum_confirmed =
    const BookingSummaryListResponseItemsInnerStatusEnum._('confirmed');
const BookingSummaryListResponseItemsInnerStatusEnum
    _$bookingSummaryListResponseItemsInnerStatusEnum_inProgress =
    const BookingSummaryListResponseItemsInnerStatusEnum._('inProgress');
const BookingSummaryListResponseItemsInnerStatusEnum
    _$bookingSummaryListResponseItemsInnerStatusEnum_completed =
    const BookingSummaryListResponseItemsInnerStatusEnum._('completed');
const BookingSummaryListResponseItemsInnerStatusEnum
    _$bookingSummaryListResponseItemsInnerStatusEnum_cancelled =
    const BookingSummaryListResponseItemsInnerStatusEnum._('cancelled');

BookingSummaryListResponseItemsInnerStatusEnum
    _$bookingSummaryListResponseItemsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'pending':
      return _$bookingSummaryListResponseItemsInnerStatusEnum_pending;
    case 'confirmed':
      return _$bookingSummaryListResponseItemsInnerStatusEnum_confirmed;
    case 'inProgress':
      return _$bookingSummaryListResponseItemsInnerStatusEnum_inProgress;
    case 'completed':
      return _$bookingSummaryListResponseItemsInnerStatusEnum_completed;
    case 'cancelled':
      return _$bookingSummaryListResponseItemsInnerStatusEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BookingSummaryListResponseItemsInnerStatusEnum>
    _$bookingSummaryListResponseItemsInnerStatusEnumValues = BuiltSet<
        BookingSummaryListResponseItemsInnerStatusEnum>(const <BookingSummaryListResponseItemsInnerStatusEnum>[
  _$bookingSummaryListResponseItemsInnerStatusEnum_pending,
  _$bookingSummaryListResponseItemsInnerStatusEnum_confirmed,
  _$bookingSummaryListResponseItemsInnerStatusEnum_inProgress,
  _$bookingSummaryListResponseItemsInnerStatusEnum_completed,
  _$bookingSummaryListResponseItemsInnerStatusEnum_cancelled,
]);

const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
    _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_pending =
    const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum._(
        'pending');
const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
    _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_authorized =
    const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum._(
        'authorized');
const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
    _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_succeeded =
    const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum._(
        'succeeded');
const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
    _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_failed =
    const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum._(
        'failed');
const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
    _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_refunded =
    const BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum._(
        'refunded');

BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
    _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'pending':
      return _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_pending;
    case 'authorized':
      return _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_authorized;
    case 'succeeded':
      return _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_succeeded;
    case 'failed':
      return _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_failed;
    case 'refunded':
      return _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_refunded;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum>
    _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnumValues =
    BuiltSet<
        BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum>(const <BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum>[
  _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_pending,
  _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_authorized,
  _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_succeeded,
  _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_failed,
  _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnum_refunded,
]);

const BookingSummaryListResponseItemsInnerPaymentProviderEnum
    _$bookingSummaryListResponseItemsInnerPaymentProviderEnum_intech =
    const BookingSummaryListResponseItemsInnerPaymentProviderEnum._('intech');

BookingSummaryListResponseItemsInnerPaymentProviderEnum
    _$bookingSummaryListResponseItemsInnerPaymentProviderEnumValueOf(
        String name) {
  switch (name) {
    case 'intech':
      return _$bookingSummaryListResponseItemsInnerPaymentProviderEnum_intech;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BookingSummaryListResponseItemsInnerPaymentProviderEnum>
    _$bookingSummaryListResponseItemsInnerPaymentProviderEnumValues = BuiltSet<
        BookingSummaryListResponseItemsInnerPaymentProviderEnum>(const <BookingSummaryListResponseItemsInnerPaymentProviderEnum>[
  _$bookingSummaryListResponseItemsInnerPaymentProviderEnum_intech,
]);

Serializer<BookingSummaryListResponseItemsInnerStatusEnum>
    _$bookingSummaryListResponseItemsInnerStatusEnumSerializer =
    _$BookingSummaryListResponseItemsInnerStatusEnumSerializer();
Serializer<BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum>
    _$bookingSummaryListResponseItemsInnerDepositPaymentStatusEnumSerializer =
    _$BookingSummaryListResponseItemsInnerDepositPaymentStatusEnumSerializer();
Serializer<BookingSummaryListResponseItemsInnerPaymentProviderEnum>
    _$bookingSummaryListResponseItemsInnerPaymentProviderEnumSerializer =
    _$BookingSummaryListResponseItemsInnerPaymentProviderEnumSerializer();

class _$BookingSummaryListResponseItemsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<BookingSummaryListResponseItemsInnerStatusEnum> {
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
  final Iterable<Type> types = const <Type>[
    BookingSummaryListResponseItemsInnerStatusEnum
  ];
  @override
  final String wireName = 'BookingSummaryListResponseItemsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          BookingSummaryListResponseItemsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BookingSummaryListResponseItemsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BookingSummaryListResponseItemsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BookingSummaryListResponseItemsInnerDepositPaymentStatusEnumSerializer
    implements
        PrimitiveSerializer<
            BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum> {
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
    BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
  ];
  @override
  final String wireName =
      'BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum';

  @override
  Object serialize(Serializers serializers,
          BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BookingSummaryListResponseItemsInnerPaymentProviderEnumSerializer
    implements
        PrimitiveSerializer<
            BookingSummaryListResponseItemsInnerPaymentProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'intech': 'intech',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'intech': 'intech',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BookingSummaryListResponseItemsInnerPaymentProviderEnum
  ];
  @override
  final String wireName =
      'BookingSummaryListResponseItemsInnerPaymentProviderEnum';

  @override
  Object serialize(Serializers serializers,
          BookingSummaryListResponseItemsInnerPaymentProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BookingSummaryListResponseItemsInnerPaymentProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BookingSummaryListResponseItemsInnerPaymentProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BookingSummaryListResponseItemsInner
    extends BookingSummaryListResponseItemsInner {
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
  final BookingSummaryListResponseItemsInnerStatusEnum status;
  @override
  final String source_;
  @override
  final num depositAmountXof;
  @override
  final BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
      depositPaymentStatus;
  @override
  final BookingSummaryListResponseItemsInnerPaymentProviderEnum?
      paymentProvider;
  @override
  final String? paymentId;

  factory _$BookingSummaryListResponseItemsInner(
          [void Function(BookingSummaryListResponseItemsInnerBuilder)?
              updates]) =>
      (BookingSummaryListResponseItemsInnerBuilder()..update(updates))._build();

  _$BookingSummaryListResponseItemsInner._(
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
  BookingSummaryListResponseItemsInner rebuild(
          void Function(BookingSummaryListResponseItemsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookingSummaryListResponseItemsInnerBuilder toBuilder() =>
      BookingSummaryListResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookingSummaryListResponseItemsInner &&
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
    return (newBuiltValueToStringHelper(r'BookingSummaryListResponseItemsInner')
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

class BookingSummaryListResponseItemsInnerBuilder
    implements
        Builder<BookingSummaryListResponseItemsInner,
            BookingSummaryListResponseItemsInnerBuilder> {
  _$BookingSummaryListResponseItemsInner? _$v;

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

  BookingSummaryListResponseItemsInnerStatusEnum? _status;
  BookingSummaryListResponseItemsInnerStatusEnum? get status => _$this._status;
  set status(BookingSummaryListResponseItemsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _source_;
  String? get source_ => _$this._source_;
  set source_(String? source_) => _$this._source_ = source_;

  num? _depositAmountXof;
  num? get depositAmountXof => _$this._depositAmountXof;
  set depositAmountXof(num? depositAmountXof) =>
      _$this._depositAmountXof = depositAmountXof;

  BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum?
      _depositPaymentStatus;
  BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum?
      get depositPaymentStatus => _$this._depositPaymentStatus;
  set depositPaymentStatus(
          BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum?
              depositPaymentStatus) =>
      _$this._depositPaymentStatus = depositPaymentStatus;

  BookingSummaryListResponseItemsInnerPaymentProviderEnum? _paymentProvider;
  BookingSummaryListResponseItemsInnerPaymentProviderEnum?
      get paymentProvider => _$this._paymentProvider;
  set paymentProvider(
          BookingSummaryListResponseItemsInnerPaymentProviderEnum?
              paymentProvider) =>
      _$this._paymentProvider = paymentProvider;

  String? _paymentId;
  String? get paymentId => _$this._paymentId;
  set paymentId(String? paymentId) => _$this._paymentId = paymentId;

  BookingSummaryListResponseItemsInnerBuilder() {
    BookingSummaryListResponseItemsInner._defaults(this);
  }

  BookingSummaryListResponseItemsInnerBuilder get _$this {
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
  void replace(BookingSummaryListResponseItemsInner other) {
    _$v = other as _$BookingSummaryListResponseItemsInner;
  }

  @override
  void update(
      void Function(BookingSummaryListResponseItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookingSummaryListResponseItemsInner build() => _build();

  _$BookingSummaryListResponseItemsInner _build() {
    final _$result = _$v ??
        _$BookingSummaryListResponseItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'BookingSummaryListResponseItemsInner', 'id'),
          salonId: BuiltValueNullFieldError.checkNotNull(
              salonId, r'BookingSummaryListResponseItemsInner', 'salonId'),
          salonName: BuiltValueNullFieldError.checkNotNull(
              salonName, r'BookingSummaryListResponseItemsInner', 'salonName'),
          serviceId: BuiltValueNullFieldError.checkNotNull(
              serviceId, r'BookingSummaryListResponseItemsInner', 'serviceId'),
          serviceName: BuiltValueNullFieldError.checkNotNull(serviceName,
              r'BookingSummaryListResponseItemsInner', 'serviceName'),
          startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt, r'BookingSummaryListResponseItemsInner', 'startsAt'),
          endsAt: BuiltValueNullFieldError.checkNotNull(
              endsAt, r'BookingSummaryListResponseItemsInner', 'endsAt'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'BookingSummaryListResponseItemsInner', 'status'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'BookingSummaryListResponseItemsInner', 'source_'),
          depositAmountXof: BuiltValueNullFieldError.checkNotNull(
              depositAmountXof,
              r'BookingSummaryListResponseItemsInner',
              'depositAmountXof'),
          depositPaymentStatus: BuiltValueNullFieldError.checkNotNull(
              depositPaymentStatus,
              r'BookingSummaryListResponseItemsInner',
              'depositPaymentStatus'),
          paymentProvider: paymentProvider,
          paymentId: paymentId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
