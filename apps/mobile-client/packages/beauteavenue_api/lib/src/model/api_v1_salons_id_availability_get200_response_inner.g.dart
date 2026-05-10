// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_salons_id_availability_get200_response_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1SalonsIdAvailabilityGet200ResponseInner
    extends ApiV1SalonsIdAvailabilityGet200ResponseInner {
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;
  @override
  final String? employeeId;

  factory _$ApiV1SalonsIdAvailabilityGet200ResponseInner(
          [void Function(ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder)?
              updates]) =>
      (ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder()..update(updates))
          ._build();

  _$ApiV1SalonsIdAvailabilityGet200ResponseInner._(
      {required this.startsAt, required this.endsAt, this.employeeId})
      : super._();
  @override
  ApiV1SalonsIdAvailabilityGet200ResponseInner rebuild(
          void Function(ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder toBuilder() =>
      ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1SalonsIdAvailabilityGet200ResponseInner &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt &&
        employeeId == other.employeeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jc(_$hash, employeeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1SalonsIdAvailabilityGet200ResponseInner')
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt)
          ..add('employeeId', employeeId))
        .toString();
  }
}

class ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder
    implements
        Builder<ApiV1SalonsIdAvailabilityGet200ResponseInner,
            ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder> {
  _$ApiV1SalonsIdAvailabilityGet200ResponseInner? _$v;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  String? _employeeId;
  String? get employeeId => _$this._employeeId;
  set employeeId(String? employeeId) => _$this._employeeId = employeeId;

  ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder() {
    ApiV1SalonsIdAvailabilityGet200ResponseInner._defaults(this);
  }

  ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _employeeId = $v.employeeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1SalonsIdAvailabilityGet200ResponseInner other) {
    _$v = other as _$ApiV1SalonsIdAvailabilityGet200ResponseInner;
  }

  @override
  void update(
      void Function(ApiV1SalonsIdAvailabilityGet200ResponseInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1SalonsIdAvailabilityGet200ResponseInner build() => _build();

  _$ApiV1SalonsIdAvailabilityGet200ResponseInner _build() {
    final _$result = _$v ??
        _$ApiV1SalonsIdAvailabilityGet200ResponseInner._(
          startsAt: BuiltValueNullFieldError.checkNotNull(startsAt,
              r'ApiV1SalonsIdAvailabilityGet200ResponseInner', 'startsAt'),
          endsAt: BuiltValueNullFieldError.checkNotNull(endsAt,
              r'ApiV1SalonsIdAvailabilityGet200ResponseInner', 'endsAt'),
          employeeId: employeeId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
