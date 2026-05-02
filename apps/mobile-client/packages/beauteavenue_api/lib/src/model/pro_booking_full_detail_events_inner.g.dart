// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_booking_full_detail_events_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProBookingFullDetailEventsInner
    extends ProBookingFullDetailEventsInner {
  @override
  final String eventType;
  @override
  final String? fromStatus;
  @override
  final String? toStatus;
  @override
  final DateTime createdAt;

  factory _$ProBookingFullDetailEventsInner(
          [void Function(ProBookingFullDetailEventsInnerBuilder)? updates]) =>
      (ProBookingFullDetailEventsInnerBuilder()..update(updates))._build();

  _$ProBookingFullDetailEventsInner._(
      {required this.eventType,
      this.fromStatus,
      this.toStatus,
      required this.createdAt})
      : super._();
  @override
  ProBookingFullDetailEventsInner rebuild(
          void Function(ProBookingFullDetailEventsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProBookingFullDetailEventsInnerBuilder toBuilder() =>
      ProBookingFullDetailEventsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProBookingFullDetailEventsInner &&
        eventType == other.eventType &&
        fromStatus == other.fromStatus &&
        toStatus == other.toStatus &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, eventType.hashCode);
    _$hash = $jc(_$hash, fromStatus.hashCode);
    _$hash = $jc(_$hash, toStatus.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProBookingFullDetailEventsInner')
          ..add('eventType', eventType)
          ..add('fromStatus', fromStatus)
          ..add('toStatus', toStatus)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ProBookingFullDetailEventsInnerBuilder
    implements
        Builder<ProBookingFullDetailEventsInner,
            ProBookingFullDetailEventsInnerBuilder> {
  _$ProBookingFullDetailEventsInner? _$v;

  String? _eventType;
  String? get eventType => _$this._eventType;
  set eventType(String? eventType) => _$this._eventType = eventType;

  String? _fromStatus;
  String? get fromStatus => _$this._fromStatus;
  set fromStatus(String? fromStatus) => _$this._fromStatus = fromStatus;

  String? _toStatus;
  String? get toStatus => _$this._toStatus;
  set toStatus(String? toStatus) => _$this._toStatus = toStatus;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ProBookingFullDetailEventsInnerBuilder() {
    ProBookingFullDetailEventsInner._defaults(this);
  }

  ProBookingFullDetailEventsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _eventType = $v.eventType;
      _fromStatus = $v.fromStatus;
      _toStatus = $v.toStatus;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProBookingFullDetailEventsInner other) {
    _$v = other as _$ProBookingFullDetailEventsInner;
  }

  @override
  void update(void Function(ProBookingFullDetailEventsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProBookingFullDetailEventsInner build() => _build();

  _$ProBookingFullDetailEventsInner _build() {
    final _$result = _$v ??
        _$ProBookingFullDetailEventsInner._(
          eventType: BuiltValueNullFieldError.checkNotNull(
              eventType, r'ProBookingFullDetailEventsInner', 'eventType'),
          fromStatus: fromStatus,
          toStatus: toStatus,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'ProBookingFullDetailEventsInner', 'createdAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
