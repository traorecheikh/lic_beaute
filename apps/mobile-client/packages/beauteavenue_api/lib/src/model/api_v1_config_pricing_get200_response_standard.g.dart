// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_config_pricing_get200_response_standard.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1ConfigPricingGet200ResponseStandard
    extends ApiV1ConfigPricingGet200ResponseStandard {
  @override
  final String tier;
  @override
  final int priceXof;
  @override
  final String label;

  factory _$ApiV1ConfigPricingGet200ResponseStandard(
          [void Function(ApiV1ConfigPricingGet200ResponseStandardBuilder)?
              updates]) =>
      (ApiV1ConfigPricingGet200ResponseStandardBuilder()..update(updates))
          ._build();

  _$ApiV1ConfigPricingGet200ResponseStandard._(
      {required this.tier, required this.priceXof, required this.label})
      : super._();
  @override
  ApiV1ConfigPricingGet200ResponseStandard rebuild(
          void Function(ApiV1ConfigPricingGet200ResponseStandardBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1ConfigPricingGet200ResponseStandardBuilder toBuilder() =>
      ApiV1ConfigPricingGet200ResponseStandardBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1ConfigPricingGet200ResponseStandard &&
        tier == other.tier &&
        priceXof == other.priceXof &&
        label == other.label;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, tier.hashCode);
    _$hash = $jc(_$hash, priceXof.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1ConfigPricingGet200ResponseStandard')
          ..add('tier', tier)
          ..add('priceXof', priceXof)
          ..add('label', label))
        .toString();
  }
}

class ApiV1ConfigPricingGet200ResponseStandardBuilder
    implements
        Builder<ApiV1ConfigPricingGet200ResponseStandard,
            ApiV1ConfigPricingGet200ResponseStandardBuilder> {
  _$ApiV1ConfigPricingGet200ResponseStandard? _$v;

  String? _tier;
  String? get tier => _$this._tier;
  set tier(String? tier) => _$this._tier = tier;

  int? _priceXof;
  int? get priceXof => _$this._priceXof;
  set priceXof(int? priceXof) => _$this._priceXof = priceXof;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ApiV1ConfigPricingGet200ResponseStandardBuilder() {
    ApiV1ConfigPricingGet200ResponseStandard._defaults(this);
  }

  ApiV1ConfigPricingGet200ResponseStandardBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _tier = $v.tier;
      _priceXof = $v.priceXof;
      _label = $v.label;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1ConfigPricingGet200ResponseStandard other) {
    _$v = other as _$ApiV1ConfigPricingGet200ResponseStandard;
  }

  @override
  void update(
      void Function(ApiV1ConfigPricingGet200ResponseStandardBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1ConfigPricingGet200ResponseStandard build() => _build();

  _$ApiV1ConfigPricingGet200ResponseStandard _build() {
    final _$result = _$v ??
        _$ApiV1ConfigPricingGet200ResponseStandard._(
          tier: BuiltValueNullFieldError.checkNotNull(
              tier, r'ApiV1ConfigPricingGet200ResponseStandard', 'tier'),
          priceXof: BuiltValueNullFieldError.checkNotNull(priceXof,
              r'ApiV1ConfigPricingGet200ResponseStandard', 'priceXof'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'ApiV1ConfigPricingGet200ResponseStandard', 'label'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
