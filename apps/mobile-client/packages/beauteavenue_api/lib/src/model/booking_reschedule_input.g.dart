// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_reschedule_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BookingRescheduleInput extends BookingRescheduleInput {
  @override
  final DateTime startsAt;

  factory _$BookingRescheduleInput(
          [void Function(BookingRescheduleInputBuilder)? updates]) =>
      (BookingRescheduleInputBuilder()..update(updates))._build();

  _$BookingRescheduleInput._({required this.startsAt}) : super._();
  @override
  BookingRescheduleInput rebuild(
          void Function(BookingRescheduleInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookingRescheduleInputBuilder toBuilder() =>
      BookingRescheduleInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookingRescheduleInput && startsAt == other.startsAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BookingRescheduleInput')
          ..add('startsAt', startsAt))
        .toString();
  }
}

class BookingRescheduleInputBuilder
    implements Builder<BookingRescheduleInput, BookingRescheduleInputBuilder> {
  _$BookingRescheduleInput? _$v;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  BookingRescheduleInputBuilder() {
    BookingRescheduleInput._defaults(this);
  }

  BookingRescheduleInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startsAt = $v.startsAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BookingRescheduleInput other) {
    _$v = other as _$BookingRescheduleInput;
  }

  @override
  void update(void Function(BookingRescheduleInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookingRescheduleInput build() => _build();

  _$BookingRescheduleInput _build() {
    final _$result = _$v ??
        _$BookingRescheduleInput._(
          startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt, r'BookingRescheduleInput', 'startsAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
