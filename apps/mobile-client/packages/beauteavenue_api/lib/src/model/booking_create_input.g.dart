// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_create_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BookingCreateInputProviderEnum _$bookingCreateInputProviderEnum_wave =
    const BookingCreateInputProviderEnum._('wave');
const BookingCreateInputProviderEnum
    _$bookingCreateInputProviderEnum_orangeMoney =
    const BookingCreateInputProviderEnum._('orangeMoney');

BookingCreateInputProviderEnum _$bookingCreateInputProviderEnumValueOf(
    String name) {
  switch (name) {
    case 'wave':
      return _$bookingCreateInputProviderEnum_wave;
    case 'orangeMoney':
      return _$bookingCreateInputProviderEnum_orangeMoney;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BookingCreateInputProviderEnum>
    _$bookingCreateInputProviderEnumValues = BuiltSet<
        BookingCreateInputProviderEnum>(const <BookingCreateInputProviderEnum>[
  _$bookingCreateInputProviderEnum_wave,
  _$bookingCreateInputProviderEnum_orangeMoney,
]);

Serializer<BookingCreateInputProviderEnum>
    _$bookingCreateInputProviderEnumSerializer =
    _$BookingCreateInputProviderEnumSerializer();

class _$BookingCreateInputProviderEnumSerializer
    implements PrimitiveSerializer<BookingCreateInputProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'wave': 'wave',
    'orangeMoney': 'orange_money',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'wave': 'wave',
    'orange_money': 'orangeMoney',
  };

  @override
  final Iterable<Type> types = const <Type>[BookingCreateInputProviderEnum];
  @override
  final String wireName = 'BookingCreateInputProviderEnum';

  @override
  Object serialize(
          Serializers serializers, BookingCreateInputProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BookingCreateInputProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BookingCreateInputProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BookingCreateInput extends BookingCreateInput {
  @override
  final String salonId;
  @override
  final String serviceId;
  @override
  final String? employeeId;
  @override
  final DateTime startsAt;
  @override
  final String? clientNote;
  @override
  final BookingCreateInputProviderEnum? provider;

  factory _$BookingCreateInput(
          [void Function(BookingCreateInputBuilder)? updates]) =>
      (BookingCreateInputBuilder()..update(updates))._build();

  _$BookingCreateInput._(
      {required this.salonId,
      required this.serviceId,
      this.employeeId,
      required this.startsAt,
      this.clientNote,
      this.provider})
      : super._();
  @override
  BookingCreateInput rebuild(
          void Function(BookingCreateInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookingCreateInputBuilder toBuilder() =>
      BookingCreateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookingCreateInput &&
        salonId == other.salonId &&
        serviceId == other.serviceId &&
        employeeId == other.employeeId &&
        startsAt == other.startsAt &&
        clientNote == other.clientNote &&
        provider == other.provider;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jc(_$hash, serviceId.hashCode);
    _$hash = $jc(_$hash, employeeId.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, clientNote.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BookingCreateInput')
          ..add('salonId', salonId)
          ..add('serviceId', serviceId)
          ..add('employeeId', employeeId)
          ..add('startsAt', startsAt)
          ..add('clientNote', clientNote)
          ..add('provider', provider))
        .toString();
  }
}

class BookingCreateInputBuilder
    implements Builder<BookingCreateInput, BookingCreateInputBuilder> {
  _$BookingCreateInput? _$v;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _serviceId;
  String? get serviceId => _$this._serviceId;
  set serviceId(String? serviceId) => _$this._serviceId = serviceId;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  String? _clientNote;
  String? get clientNote => _$this._clientNote;
  set clientNote(String? clientNote) => _$this._clientNote = clientNote;

  BookingCreateInputProviderEnum? _provider;
  BookingCreateInputProviderEnum? get provider => _$this._provider;
  set provider(BookingCreateInputProviderEnum? provider) =>
      _$this._provider = provider;

  BookingCreateInputBuilder() {
    BookingCreateInput._defaults(this);
  }

  BookingCreateInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _salonId = $v.salonId;
      _serviceId = $v.serviceId;
      _employeeId = $v.employeeId;
      _startsAt = $v.startsAt;
      _clientNote = $v.clientNote;
      _provider = $v.provider;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BookingCreateInput other) {
    _$v = other as _$BookingCreateInput;
  }

  @override
  void update(void Function(BookingCreateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookingCreateInput build() => _build();

  _$BookingCreateInput _build() {
    final _$result = _$v ??
        _$BookingCreateInput._(
          salonId: BuiltValueNullFieldError.checkNotNull(
              salonId, r'BookingCreateInput', 'salonId'),
          serviceId: BuiltValueNullFieldError.checkNotNull(
              serviceId, r'BookingCreateInput', 'serviceId'),
          employeeId: employeeId,
          startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt, r'BookingCreateInput', 'startsAt'),
          clientNote: clientNote,
          provider: provider,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
