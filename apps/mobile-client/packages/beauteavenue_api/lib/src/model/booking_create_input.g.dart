// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_create_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BookingCreateInputProviderEnum _$bookingCreateInputProviderEnum_intech =
    const BookingCreateInputProviderEnum._('intech');

BookingCreateInputProviderEnum _$bookingCreateInputProviderEnumValueOf(
    String name) {
  switch (name) {
    case 'intech':
      return _$bookingCreateInputProviderEnum_intech;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BookingCreateInputProviderEnum>
    _$bookingCreateInputProviderEnumValues = BuiltSet<
        BookingCreateInputProviderEnum>(const <BookingCreateInputProviderEnum>[
  _$bookingCreateInputProviderEnum_intech,
]);

const BookingCreateInputChannelEnum _$bookingCreateInputChannelEnum_wave =
    const BookingCreateInputChannelEnum._('wave');
const BookingCreateInputChannelEnum
    _$bookingCreateInputChannelEnum_orangeMoney =
    const BookingCreateInputChannelEnum._('orangeMoney');
const BookingCreateInputChannelEnum _$bookingCreateInputChannelEnum_freeMoney =
    const BookingCreateInputChannelEnum._('freeMoney');

BookingCreateInputChannelEnum _$bookingCreateInputChannelEnumValueOf(
    String name) {
  switch (name) {
    case 'wave':
      return _$bookingCreateInputChannelEnum_wave;
    case 'orangeMoney':
      return _$bookingCreateInputChannelEnum_orangeMoney;
    case 'freeMoney':
      return _$bookingCreateInputChannelEnum_freeMoney;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BookingCreateInputChannelEnum>
    _$bookingCreateInputChannelEnumValues = BuiltSet<
        BookingCreateInputChannelEnum>(const <BookingCreateInputChannelEnum>[
  _$bookingCreateInputChannelEnum_wave,
  _$bookingCreateInputChannelEnum_orangeMoney,
  _$bookingCreateInputChannelEnum_freeMoney,
]);

Serializer<BookingCreateInputProviderEnum>
    _$bookingCreateInputProviderEnumSerializer =
    _$BookingCreateInputProviderEnumSerializer();
Serializer<BookingCreateInputChannelEnum>
    _$bookingCreateInputChannelEnumSerializer =
    _$BookingCreateInputChannelEnumSerializer();

class _$BookingCreateInputProviderEnumSerializer
    implements PrimitiveSerializer<BookingCreateInputProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'intech': 'intech',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'intech': 'intech',
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

class _$BookingCreateInputChannelEnumSerializer
    implements PrimitiveSerializer<BookingCreateInputChannelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'wave': 'wave',
    'orangeMoney': 'orange_money',
    'freeMoney': 'free_money',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'wave': 'wave',
    'orange_money': 'orangeMoney',
    'free_money': 'freeMoney',
  };

  @override
  final Iterable<Type> types = const <Type>[BookingCreateInputChannelEnum];
  @override
  final String wireName = 'BookingCreateInputChannelEnum';

  @override
  Object serialize(
          Serializers serializers, BookingCreateInputChannelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BookingCreateInputChannelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BookingCreateInputChannelEnum.valueOf(
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
  @override
  final BookingCreateInputChannelEnum? channel;

  factory _$BookingCreateInput(
          [void Function(BookingCreateInputBuilder)? updates]) =>
      (BookingCreateInputBuilder()..update(updates))._build();

  _$BookingCreateInput._(
      {required this.salonId,
      required this.serviceId,
      this.employeeId,
      required this.startsAt,
      this.clientNote,
      this.provider,
      this.channel})
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
        provider == other.provider &&
        channel == other.channel;
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
    _$hash = $jc(_$hash, channel.hashCode);
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
          ..add('provider', provider)
          ..add('channel', channel))
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

  BookingCreateInputChannelEnum? _channel;
  BookingCreateInputChannelEnum? get channel => _$this._channel;
  set channel(BookingCreateInputChannelEnum? channel) =>
      _$this._channel = channel;

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
      _channel = $v.channel;
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
          channel: channel,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
