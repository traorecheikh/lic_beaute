// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_manual_booking_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProManualBookingInput extends ProManualBookingInput {
  @override
  final String? clientId;
  @override
  final String serviceId;
  @override
  final String? employeeId;
  @override
  final DateTime startsAt;
  @override
  final String? clientName;
  @override
  final String? clientPhone;

  factory _$ProManualBookingInput(
          [void Function(ProManualBookingInputBuilder)? updates]) =>
      (ProManualBookingInputBuilder()..update(updates))._build();

  _$ProManualBookingInput._(
      {this.clientId,
      required this.serviceId,
      this.employeeId,
      required this.startsAt,
      this.clientName,
      this.clientPhone})
      : super._();
  @override
  ProManualBookingInput rebuild(
          void Function(ProManualBookingInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProManualBookingInputBuilder toBuilder() =>
      ProManualBookingInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProManualBookingInput &&
        clientId == other.clientId &&
        serviceId == other.serviceId &&
        employeeId == other.employeeId &&
        startsAt == other.startsAt &&
        clientName == other.clientName &&
        clientPhone == other.clientPhone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientId.hashCode);
    _$hash = $jc(_$hash, serviceId.hashCode);
    _$hash = $jc(_$hash, employeeId.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, clientName.hashCode);
    _$hash = $jc(_$hash, clientPhone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProManualBookingInput')
          ..add('clientId', clientId)
          ..add('serviceId', serviceId)
          ..add('employeeId', employeeId)
          ..add('startsAt', startsAt)
          ..add('clientName', clientName)
          ..add('clientPhone', clientPhone))
        .toString();
  }
}

class ProManualBookingInputBuilder
    implements Builder<ProManualBookingInput, ProManualBookingInputBuilder> {
  _$ProManualBookingInput? _$v;

  String? _clientId;
  String? get clientId => _$this._clientId;
  set clientId(String? clientId) => _$this._clientId = clientId;

  String? _serviceId;
  String? get serviceId => _$this._serviceId;
  set serviceId(String? serviceId) => _$this._serviceId = serviceId;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  String? _clientName;
  String? get clientName => _$this._clientName;
  set clientName(String? clientName) => _$this._clientName = clientName;

  String? _clientPhone;
  String? get clientPhone => _$this._clientPhone;
  set clientPhone(String? clientPhone) => _$this._clientPhone = clientPhone;

  ProManualBookingInputBuilder() {
    ProManualBookingInput._defaults(this);
  }

  ProManualBookingInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientId = $v.clientId;
      _serviceId = $v.serviceId;
      _employeeId = $v.employeeId;
      _startsAt = $v.startsAt;
      _clientName = $v.clientName;
      _clientPhone = $v.clientPhone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProManualBookingInput other) {
    _$v = other as _$ProManualBookingInput;
  }

  @override
  void update(void Function(ProManualBookingInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProManualBookingInput build() => _build();

  _$ProManualBookingInput _build() {
    final _$result = _$v ??
        _$ProManualBookingInput._(
          clientId: clientId,
          serviceId: BuiltValueNullFieldError.checkNotNull(
              serviceId, r'ProManualBookingInput', 'serviceId'),
          employeeId: employeeId,
          startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt, r'ProManualBookingInput', 'startsAt'),
          clientName: clientName,
          clientPhone: clientPhone,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
