// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_subscription_billing_method.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProSubscriptionBillingMethodProviderEnum
    _$proSubscriptionBillingMethodProviderEnum_paydunya =
    const ProSubscriptionBillingMethodProviderEnum._('paydunya');
const ProSubscriptionBillingMethodProviderEnum
    _$proSubscriptionBillingMethodProviderEnum_manual =
    const ProSubscriptionBillingMethodProviderEnum._('manual');

ProSubscriptionBillingMethodProviderEnum
    _$proSubscriptionBillingMethodProviderEnumValueOf(String name) {
  switch (name) {
    case 'paydunya':
      return _$proSubscriptionBillingMethodProviderEnum_paydunya;
    case 'manual':
      return _$proSubscriptionBillingMethodProviderEnum_manual;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProSubscriptionBillingMethodProviderEnum>
    _$proSubscriptionBillingMethodProviderEnumValues = BuiltSet<
        ProSubscriptionBillingMethodProviderEnum>(const <ProSubscriptionBillingMethodProviderEnum>[
  _$proSubscriptionBillingMethodProviderEnum_paydunya,
  _$proSubscriptionBillingMethodProviderEnum_manual,
]);

Serializer<ProSubscriptionBillingMethodProviderEnum>
    _$proSubscriptionBillingMethodProviderEnumSerializer =
    _$ProSubscriptionBillingMethodProviderEnumSerializer();

class _$ProSubscriptionBillingMethodProviderEnumSerializer
    implements PrimitiveSerializer<ProSubscriptionBillingMethodProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'paydunya': 'paydunya',
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'paydunya': 'paydunya',
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProSubscriptionBillingMethodProviderEnum
  ];
  @override
  final String wireName = 'ProSubscriptionBillingMethodProviderEnum';

  @override
  Object serialize(Serializers serializers,
          ProSubscriptionBillingMethodProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProSubscriptionBillingMethodProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProSubscriptionBillingMethodProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProSubscriptionBillingMethod extends ProSubscriptionBillingMethod {
  @override
  final ProSubscriptionBillingMethodProviderEnum provider;
  @override
  final String accountNumberMasked;
  @override
  final String? country;
  @override
  final String? method;

  factory _$ProSubscriptionBillingMethod(
          [void Function(ProSubscriptionBillingMethodBuilder)? updates]) =>
      (ProSubscriptionBillingMethodBuilder()..update(updates))._build();

  _$ProSubscriptionBillingMethod._(
      {required this.provider,
      required this.accountNumberMasked,
      this.country,
      this.method})
      : super._();
  @override
  ProSubscriptionBillingMethod rebuild(
          void Function(ProSubscriptionBillingMethodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProSubscriptionBillingMethodBuilder toBuilder() =>
      ProSubscriptionBillingMethodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProSubscriptionBillingMethod &&
        provider == other.provider &&
        accountNumberMasked == other.accountNumberMasked &&
        country == other.country &&
        method == other.method;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, accountNumberMasked.hashCode);
    _$hash = $jc(_$hash, country.hashCode);
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProSubscriptionBillingMethod')
          ..add('provider', provider)
          ..add('accountNumberMasked', accountNumberMasked)
          ..add('country', country)
          ..add('method', method))
        .toString();
  }
}

class ProSubscriptionBillingMethodBuilder
    implements
        Builder<ProSubscriptionBillingMethod,
            ProSubscriptionBillingMethodBuilder> {
  _$ProSubscriptionBillingMethod? _$v;

  ProSubscriptionBillingMethodProviderEnum? _provider;
  ProSubscriptionBillingMethodProviderEnum? get provider => _$this._provider;
  set provider(ProSubscriptionBillingMethodProviderEnum? provider) =>
      _$this._provider = provider;

  String? _accountNumberMasked;
  String? get accountNumberMasked => _$this._accountNumberMasked;
  set accountNumberMasked(String? accountNumberMasked) =>
      _$this._accountNumberMasked = accountNumberMasked;

  String? _country;
  String? get country => _$this._country;
  set country(String? country) => _$this._country = country;

  String? _method;
  String? get method => _$this._method;
  set method(String? method) => _$this._method = method;

  ProSubscriptionBillingMethodBuilder() {
    ProSubscriptionBillingMethod._defaults(this);
  }

  ProSubscriptionBillingMethodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _provider = $v.provider;
      _accountNumberMasked = $v.accountNumberMasked;
      _country = $v.country;
      _method = $v.method;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProSubscriptionBillingMethod other) {
    _$v = other as _$ProSubscriptionBillingMethod;
  }

  @override
  void update(void Function(ProSubscriptionBillingMethodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProSubscriptionBillingMethod build() => _build();

  _$ProSubscriptionBillingMethod _build() {
    final _$result = _$v ??
        _$ProSubscriptionBillingMethod._(
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'ProSubscriptionBillingMethod', 'provider'),
          accountNumberMasked: BuiltValueNullFieldError.checkNotNull(
              accountNumberMasked,
              r'ProSubscriptionBillingMethod',
              'accountNumberMasked'),
          country: country,
          method: method,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
