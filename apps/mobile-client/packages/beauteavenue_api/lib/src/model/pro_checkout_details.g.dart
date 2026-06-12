// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_checkout_details.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProCheckoutDetailsStatusEnum _$proCheckoutDetailsStatusEnum_pending =
    const ProCheckoutDetailsStatusEnum._('pending');
const ProCheckoutDetailsStatusEnum _$proCheckoutDetailsStatusEnum_confirmed =
    const ProCheckoutDetailsStatusEnum._('confirmed');
const ProCheckoutDetailsStatusEnum _$proCheckoutDetailsStatusEnum_inProgress =
    const ProCheckoutDetailsStatusEnum._('inProgress');
const ProCheckoutDetailsStatusEnum _$proCheckoutDetailsStatusEnum_completed =
    const ProCheckoutDetailsStatusEnum._('completed');
const ProCheckoutDetailsStatusEnum _$proCheckoutDetailsStatusEnum_cancelled =
    const ProCheckoutDetailsStatusEnum._('cancelled');

ProCheckoutDetailsStatusEnum _$proCheckoutDetailsStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'pending':
      return _$proCheckoutDetailsStatusEnum_pending;
    case 'confirmed':
      return _$proCheckoutDetailsStatusEnum_confirmed;
    case 'inProgress':
      return _$proCheckoutDetailsStatusEnum_inProgress;
    case 'completed':
      return _$proCheckoutDetailsStatusEnum_completed;
    case 'cancelled':
      return _$proCheckoutDetailsStatusEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProCheckoutDetailsStatusEnum>
    _$proCheckoutDetailsStatusEnumValues =
    BuiltSet<ProCheckoutDetailsStatusEnum>(const <ProCheckoutDetailsStatusEnum>[
  _$proCheckoutDetailsStatusEnum_pending,
  _$proCheckoutDetailsStatusEnum_confirmed,
  _$proCheckoutDetailsStatusEnum_inProgress,
  _$proCheckoutDetailsStatusEnum_completed,
  _$proCheckoutDetailsStatusEnum_cancelled,
]);

Serializer<ProCheckoutDetailsStatusEnum>
    _$proCheckoutDetailsStatusEnumSerializer =
    _$ProCheckoutDetailsStatusEnumSerializer();

class _$ProCheckoutDetailsStatusEnumSerializer
    implements PrimitiveSerializer<ProCheckoutDetailsStatusEnum> {
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
  final Iterable<Type> types = const <Type>[ProCheckoutDetailsStatusEnum];
  @override
  final String wireName = 'ProCheckoutDetailsStatusEnum';

  @override
  Object serialize(Serializers serializers, ProCheckoutDetailsStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProCheckoutDetailsStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProCheckoutDetailsStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProCheckoutDetails extends ProCheckoutDetails {
  @override
  final String bookingId;
  @override
  final ProCheckoutDetailsStatusEnum status;
  @override
  final String? clientName;
  @override
  final String? clientPhone;
  @override
  final String serviceName;
  @override
  final DateTime startsAt;
  @override
  final String? staffName;
  @override
  final int subtotalXof;
  @override
  final int depositPaidXof;
  @override
  final int balanceXof;
  @override
  final BuiltList<ProCheckoutDetailsLineItemsInner> lineItems;

  factory _$ProCheckoutDetails(
          [void Function(ProCheckoutDetailsBuilder)? updates]) =>
      (ProCheckoutDetailsBuilder()..update(updates))._build();

  _$ProCheckoutDetails._(
      {required this.bookingId,
      required this.status,
      this.clientName,
      this.clientPhone,
      required this.serviceName,
      required this.startsAt,
      this.staffName,
      required this.subtotalXof,
      required this.depositPaidXof,
      required this.balanceXof,
      required this.lineItems})
      : super._();
  @override
  ProCheckoutDetails rebuild(
          void Function(ProCheckoutDetailsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProCheckoutDetailsBuilder toBuilder() =>
      ProCheckoutDetailsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProCheckoutDetails &&
        bookingId == other.bookingId &&
        status == other.status &&
        clientName == other.clientName &&
        clientPhone == other.clientPhone &&
        serviceName == other.serviceName &&
        startsAt == other.startsAt &&
        staffName == other.staffName &&
        subtotalXof == other.subtotalXof &&
        depositPaidXof == other.depositPaidXof &&
        balanceXof == other.balanceXof &&
        lineItems == other.lineItems;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, clientName.hashCode);
    _$hash = $jc(_$hash, clientPhone.hashCode);
    _$hash = $jc(_$hash, serviceName.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, staffName.hashCode);
    _$hash = $jc(_$hash, subtotalXof.hashCode);
    _$hash = $jc(_$hash, depositPaidXof.hashCode);
    _$hash = $jc(_$hash, balanceXof.hashCode);
    _$hash = $jc(_$hash, lineItems.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProCheckoutDetails')
          ..add('bookingId', bookingId)
          ..add('status', status)
          ..add('clientName', clientName)
          ..add('clientPhone', clientPhone)
          ..add('serviceName', serviceName)
          ..add('startsAt', startsAt)
          ..add('staffName', staffName)
          ..add('subtotalXof', subtotalXof)
          ..add('depositPaidXof', depositPaidXof)
          ..add('balanceXof', balanceXof)
          ..add('lineItems', lineItems))
        .toString();
  }
}

class ProCheckoutDetailsBuilder
    implements Builder<ProCheckoutDetails, ProCheckoutDetailsBuilder> {
  _$ProCheckoutDetails? _$v;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  ProCheckoutDetailsStatusEnum? _status;
  ProCheckoutDetailsStatusEnum? get status => _$this._status;
  set status(ProCheckoutDetailsStatusEnum? status) => _$this._status = status;

  String? _clientName;
  String? get clientName => _$this._clientName;
  set clientName(String? clientName) => _$this._clientName = clientName;

  String? _clientPhone;
  String? get clientPhone => _$this._clientPhone;
  set clientPhone(String? clientPhone) => _$this._clientPhone = clientPhone;

  String? _serviceName;
  String? get serviceName => _$this._serviceName;
  set serviceName(String? serviceName) => _$this._serviceName = serviceName;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  String? _staffName;
  String? get staffName => _$this._staffName;
  set staffName(String? staffName) => _$this._staffName = staffName;

  int? _subtotalXof;
  int? get subtotalXof => _$this._subtotalXof;
  set subtotalXof(int? subtotalXof) => _$this._subtotalXof = subtotalXof;

  int? _depositPaidXof;
  int? get depositPaidXof => _$this._depositPaidXof;
  set depositPaidXof(int? depositPaidXof) =>
      _$this._depositPaidXof = depositPaidXof;

  int? _balanceXof;
  int? get balanceXof => _$this._balanceXof;
  set balanceXof(int? balanceXof) => _$this._balanceXof = balanceXof;

  ListBuilder<ProCheckoutDetailsLineItemsInner>? _lineItems;
  ListBuilder<ProCheckoutDetailsLineItemsInner> get lineItems =>
      _$this._lineItems ??= ListBuilder<ProCheckoutDetailsLineItemsInner>();
  set lineItems(ListBuilder<ProCheckoutDetailsLineItemsInner>? lineItems) =>
      _$this._lineItems = lineItems;

  ProCheckoutDetailsBuilder() {
    ProCheckoutDetails._defaults(this);
  }

  ProCheckoutDetailsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _bookingId = $v.bookingId;
      _status = $v.status;
      _clientName = $v.clientName;
      _clientPhone = $v.clientPhone;
      _serviceName = $v.serviceName;
      _startsAt = $v.startsAt;
      _staffName = $v.staffName;
      _subtotalXof = $v.subtotalXof;
      _depositPaidXof = $v.depositPaidXof;
      _balanceXof = $v.balanceXof;
      _lineItems = $v.lineItems.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProCheckoutDetails other) {
    _$v = other as _$ProCheckoutDetails;
  }

  @override
  void update(void Function(ProCheckoutDetailsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProCheckoutDetails build() => _build();

  _$ProCheckoutDetails _build() {
    _$ProCheckoutDetails _$result;
    try {
      _$result = _$v ??
          _$ProCheckoutDetails._(
            bookingId: BuiltValueNullFieldError.checkNotNull(
                bookingId, r'ProCheckoutDetails', 'bookingId'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ProCheckoutDetails', 'status'),
            clientName: clientName,
            clientPhone: clientPhone,
            serviceName: BuiltValueNullFieldError.checkNotNull(
                serviceName, r'ProCheckoutDetails', 'serviceName'),
            startsAt: BuiltValueNullFieldError.checkNotNull(
                startsAt, r'ProCheckoutDetails', 'startsAt'),
            staffName: staffName,
            subtotalXof: BuiltValueNullFieldError.checkNotNull(
                subtotalXof, r'ProCheckoutDetails', 'subtotalXof'),
            depositPaidXof: BuiltValueNullFieldError.checkNotNull(
                depositPaidXof, r'ProCheckoutDetails', 'depositPaidXof'),
            balanceXof: BuiltValueNullFieldError.checkNotNull(
                balanceXof, r'ProCheckoutDetails', 'balanceXof'),
            lineItems: lineItems.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lineItems';
        lineItems.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProCheckoutDetails', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
