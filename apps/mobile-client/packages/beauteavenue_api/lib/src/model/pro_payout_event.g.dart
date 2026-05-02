// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_payout_event.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProPayoutEvent extends ProPayoutEvent {
  @override
  final String id;
  @override
  final String bookingId;
  @override
  final String eventType;
  @override
  final int amountXof;
  @override
  final DateTime createdAt;

  factory _$ProPayoutEvent([void Function(ProPayoutEventBuilder)? updates]) =>
      (ProPayoutEventBuilder()..update(updates))._build();

  _$ProPayoutEvent._(
      {required this.id,
      required this.bookingId,
      required this.eventType,
      required this.amountXof,
      required this.createdAt})
      : super._();
  @override
  ProPayoutEvent rebuild(void Function(ProPayoutEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProPayoutEventBuilder toBuilder() => ProPayoutEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProPayoutEvent &&
        id == other.id &&
        bookingId == other.bookingId &&
        eventType == other.eventType &&
        amountXof == other.amountXof &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, bookingId.hashCode);
    _$hash = $jc(_$hash, eventType.hashCode);
    _$hash = $jc(_$hash, amountXof.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProPayoutEvent')
          ..add('id', id)
          ..add('bookingId', bookingId)
          ..add('eventType', eventType)
          ..add('amountXof', amountXof)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ProPayoutEventBuilder
    implements Builder<ProPayoutEvent, ProPayoutEventBuilder> {
  _$ProPayoutEvent? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _bookingId;
  String? get bookingId => _$this._bookingId;
  set bookingId(String? bookingId) => _$this._bookingId = bookingId;

  String? _eventType;
  String? get eventType => _$this._eventType;
  set eventType(String? eventType) => _$this._eventType = eventType;

  int? _amountXof;
  int? get amountXof => _$this._amountXof;
  set amountXof(int? amountXof) => _$this._amountXof = amountXof;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ProPayoutEventBuilder() {
    ProPayoutEvent._defaults(this);
  }

  ProPayoutEventBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _bookingId = $v.bookingId;
      _eventType = $v.eventType;
      _amountXof = $v.amountXof;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProPayoutEvent other) {
    _$v = other as _$ProPayoutEvent;
  }

  @override
  void update(void Function(ProPayoutEventBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProPayoutEvent build() => _build();

  _$ProPayoutEvent _build() {
    final _$result = _$v ??
        _$ProPayoutEvent._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ProPayoutEvent', 'id'),
          bookingId: BuiltValueNullFieldError.checkNotNull(
              bookingId, r'ProPayoutEvent', 'bookingId'),
          eventType: BuiltValueNullFieldError.checkNotNull(
              eventType, r'ProPayoutEvent', 'eventType'),
          amountXof: BuiltValueNullFieldError.checkNotNull(
              amountXof, r'ProPayoutEvent', 'amountXof'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'ProPayoutEvent', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
