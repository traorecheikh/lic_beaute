// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_config_pricing_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ConfigPricingGet200Response
    extends ApiV1ConfigPricingGet200Response {
  @override
  final ApiV1ConfigPricingGet200ResponseStandard standard;
  @override
  final ApiV1ConfigPricingGet200ResponseStandard premium;
  @override
  final num commissionPercent;

  factory _$ApiV1ConfigPricingGet200Response(
          [void Function(ApiV1ConfigPricingGet200ResponseBuilder)? updates]) =>
      (ApiV1ConfigPricingGet200ResponseBuilder()..update(updates))._build();

  _$ApiV1ConfigPricingGet200Response._(
      {required this.standard,
      required this.premium,
      required this.commissionPercent})
      : super._();
  @override
  ApiV1ConfigPricingGet200Response rebuild(
          void Function(ApiV1ConfigPricingGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1ConfigPricingGet200ResponseBuilder toBuilder() =>
      ApiV1ConfigPricingGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ConfigPricingGet200Response &&
        standard == other.standard &&
        premium == other.premium &&
        commissionPercent == other.commissionPercent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, standard.hashCode);
    _$hash = $jc(_$hash, premium.hashCode);
    _$hash = $jc(_$hash, commissionPercent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiV1ConfigPricingGet200Response')
          ..add('standard', standard)
          ..add('premium', premium)
          ..add('commissionPercent', commissionPercent))
        .toString();
  }
}

class ApiV1ConfigPricingGet200ResponseBuilder
    implements
        Builder<ApiV1ConfigPricingGet200Response,
            ApiV1ConfigPricingGet200ResponseBuilder> {
  _$ApiV1ConfigPricingGet200Response? _$v;

  ApiV1ConfigPricingGet200ResponseStandardBuilder? _standard;
  ApiV1ConfigPricingGet200ResponseStandardBuilder get standard =>
      _$this._standard ??= ApiV1ConfigPricingGet200ResponseStandardBuilder();
  set standard(ApiV1ConfigPricingGet200ResponseStandardBuilder? standard) =>
      _$this._standard = standard;

  ApiV1ConfigPricingGet200ResponseStandardBuilder? _premium;
  ApiV1ConfigPricingGet200ResponseStandardBuilder get premium =>
      _$this._premium ??= ApiV1ConfigPricingGet200ResponseStandardBuilder();
  set premium(ApiV1ConfigPricingGet200ResponseStandardBuilder? premium) =>
      _$this._premium = premium;

  num? _commissionPercent;
  num? get commissionPercent => _$this._commissionPercent;
  set commissionPercent(num? commissionPercent) =>
      _$this._commissionPercent = commissionPercent;

  ApiV1ConfigPricingGet200ResponseBuilder() {
    ApiV1ConfigPricingGet200Response._defaults(this);
  }

  ApiV1ConfigPricingGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _standard = $v.standard.toBuilder();
      _premium = $v.premium.toBuilder();
      _commissionPercent = $v.commissionPercent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1ConfigPricingGet200Response other) {
    _$v = other as _$ApiV1ConfigPricingGet200Response;
  }

  @override
  void update(void Function(ApiV1ConfigPricingGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ConfigPricingGet200Response build() => _build();

  _$ApiV1ConfigPricingGet200Response _build() {
    _$ApiV1ConfigPricingGet200Response _$result;
    try {
      _$result = _$v ??
          _$ApiV1ConfigPricingGet200Response._(
            standard: standard.build(),
            premium: premium.build(),
            commissionPercent: BuiltValueNullFieldError.checkNotNull(
                commissionPercent,
                r'ApiV1ConfigPricingGet200Response',
                'commissionPercent'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'standard';
        standard.build();
        _$failedField = 'premium';
        premium.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ApiV1ConfigPricingGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
