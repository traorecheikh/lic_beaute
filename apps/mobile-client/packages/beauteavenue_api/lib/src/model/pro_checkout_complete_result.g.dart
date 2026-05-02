// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_checkout_complete_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProCheckoutCompleteResultStatusEnum
    _$proCheckoutCompleteResultStatusEnum_pending =
    const ProCheckoutCompleteResultStatusEnum._('pending');
const ProCheckoutCompleteResultStatusEnum
    _$proCheckoutCompleteResultStatusEnum_confirmed =
    const ProCheckoutCompleteResultStatusEnum._('confirmed');
const ProCheckoutCompleteResultStatusEnum
    _$proCheckoutCompleteResultStatusEnum_inProgress =
    const ProCheckoutCompleteResultStatusEnum._('inProgress');
const ProCheckoutCompleteResultStatusEnum
    _$proCheckoutCompleteResultStatusEnum_completed =
    const ProCheckoutCompleteResultStatusEnum._('completed');
const ProCheckoutCompleteResultStatusEnum
    _$proCheckoutCompleteResultStatusEnum_cancelled =
    const ProCheckoutCompleteResultStatusEnum._('cancelled');

ProCheckoutCompleteResultStatusEnum
    _$proCheckoutCompleteResultStatusEnumValueOf(String name) {
  switch (name) {
    case 'pending':
      return _$proCheckoutCompleteResultStatusEnum_pending;
    case 'confirmed':
      return _$proCheckoutCompleteResultStatusEnum_confirmed;
    case 'inProgress':
      return _$proCheckoutCompleteResultStatusEnum_inProgress;
    case 'completed':
      return _$proCheckoutCompleteResultStatusEnum_completed;
    case 'cancelled':
      return _$proCheckoutCompleteResultStatusEnum_cancelled;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProCheckoutCompleteResultStatusEnum>
    _$proCheckoutCompleteResultStatusEnumValues = BuiltSet<
        ProCheckoutCompleteResultStatusEnum>(const <ProCheckoutCompleteResultStatusEnum>[
  _$proCheckoutCompleteResultStatusEnum_pending,
  _$proCheckoutCompleteResultStatusEnum_confirmed,
  _$proCheckoutCompleteResultStatusEnum_inProgress,
  _$proCheckoutCompleteResultStatusEnum_completed,
  _$proCheckoutCompleteResultStatusEnum_cancelled,
]);

Serializer<ProCheckoutCompleteResultStatusEnum>
    _$proCheckoutCompleteResultStatusEnumSerializer =
    _$ProCheckoutCompleteResultStatusEnumSerializer();

class _$ProCheckoutCompleteResultStatusEnumSerializer
    implements PrimitiveSerializer<ProCheckoutCompleteResultStatusEnum> {
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
    ProCheckoutCompleteResultStatusEnum
  ];
  @override
  final String wireName = 'ProCheckoutCompleteResultStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ProCheckoutCompleteResultStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProCheckoutCompleteResultStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProCheckoutCompleteResultStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProCheckoutCompleteResult extends ProCheckoutCompleteResult {
  @override
  final bool completed;
  @override
  final String bookingId;
  @override
  final ProCheckoutCompleteResultStatusEnum status;
  @override
  final int chargedXof;

  factory _$ProCheckoutCompleteResult(
          [void Function(ProCheckoutCompleteResultBuilder)? updates]) =>
      (ProCheckoutCompleteResultBuilder()..update(updates))._build();

  _$ProCheckoutCompleteResult._(
      {required this.completed,
      required this.bookingId,
      required this.status,
      required this.chargedXof})
      : super._();
  @override
  ProCheckoutCompleteResult rebuild(
          void Function(ProCheckoutCompleteResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProCheckoutCompleteResultBuilder toBuilder() =>
      ProCheckoutCompleteResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProCheckoutCompleteResult &&
        completed == other.completed &&
        bookingId == other.bookingId &&
        status == other.status &&
        chargedXof == other.chargedXof;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, completed.hashCode);
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, chargedXof.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProCheckoutCompleteResult')
          ..add('completed', completed)
          ..add('bookingId', bookingId)
          ..add('status', status)
          ..add('chargedXof', chargedXof))
        .toString();
  }
}

class ProCheckoutCompleteResultBuilder
    implements
        Builder<ProCheckoutCompleteResult, ProCheckoutCompleteResultBuilder> {
  _$ProCheckoutCompleteResult? _$v;

  bool? _completed;
  bool? get completed => _$this._completed;
  set completed(bool? completed) => _$this._completed = completed;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  ProCheckoutCompleteResultStatusEnum? _status;
  ProCheckoutCompleteResultStatusEnum? get status => _$this._status;
  set status(ProCheckoutCompleteResultStatusEnum? status) =>
      _$this._status = status;

  int? _chargedXof;
  int? get chargedXof => _$this._chargedXof;
  set chargedXof(int? chargedXof) => _$this._chargedXof = chargedXof;

  ProCheckoutCompleteResultBuilder() {
    ProCheckoutCompleteResult._defaults(this);
  }

  ProCheckoutCompleteResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _completed = $v.completed;
      _bookingId = $v.bookingId;
      _status = $v.status;
      _chargedXof = $v.chargedXof;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProCheckoutCompleteResult other) {
    _$v = other as _$ProCheckoutCompleteResult;
  }

  @override
  void update(void Function(ProCheckoutCompleteResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProCheckoutCompleteResult build() => _build();

  _$ProCheckoutCompleteResult _build() {
    final _$result = _$v ??
        _$ProCheckoutCompleteResult._(
          completed: BuiltValueNullFieldError.checkNotNull(
              completed, r'ProCheckoutCompleteResult', 'completed'),
          bookingId: BuiltValueNullFieldError.checkNotNull(
              bookingId, r'ProCheckoutCompleteResult', 'bookingId'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ProCheckoutCompleteResult', 'status'),
          chargedXof: BuiltValueNullFieldError.checkNotNull(
              chargedXof, r'ProCheckoutCompleteResult', 'chargedXof'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
