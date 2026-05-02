// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_subscription_update_input_billing_method.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProSubscriptionUpdateInputBillingMethodProviderEnum
    _$proSubscriptionUpdateInputBillingMethodProviderEnum_wave =
    const ProSubscriptionUpdateInputBillingMethodProviderEnum._('wave');
const ProSubscriptionUpdateInputBillingMethodProviderEnum
    _$proSubscriptionUpdateInputBillingMethodProviderEnum_orangeMoney =
    const ProSubscriptionUpdateInputBillingMethodProviderEnum._('orangeMoney');

ProSubscriptionUpdateInputBillingMethodProviderEnum
    _$proSubscriptionUpdateInputBillingMethodProviderEnumValueOf(String name) {
  switch (name) {
    case 'wave':
      return _$proSubscriptionUpdateInputBillingMethodProviderEnum_wave;
    case 'orangeMoney':
      return _$proSubscriptionUpdateInputBillingMethodProviderEnum_orangeMoney;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProSubscriptionUpdateInputBillingMethodProviderEnum>
    _$proSubscriptionUpdateInputBillingMethodProviderEnumValues = BuiltSet<
        ProSubscriptionUpdateInputBillingMethodProviderEnum>(const <ProSubscriptionUpdateInputBillingMethodProviderEnum>[
  _$proSubscriptionUpdateInputBillingMethodProviderEnum_wave,
  _$proSubscriptionUpdateInputBillingMethodProviderEnum_orangeMoney,
]);

Serializer<ProSubscriptionUpdateInputBillingMethodProviderEnum>
    _$proSubscriptionUpdateInputBillingMethodProviderEnumSerializer =
    _$ProSubscriptionUpdateInputBillingMethodProviderEnumSerializer();

class _$ProSubscriptionUpdateInputBillingMethodProviderEnumSerializer
    implements
        PrimitiveSerializer<
            ProSubscriptionUpdateInputBillingMethodProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'wave': 'wave',
    'orangeMoney': 'orange_money',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'wave': 'wave',
    'orange_money': 'orangeMoney',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProSubscriptionUpdateInputBillingMethodProviderEnum
  ];
  @override
  final String wireName = 'ProSubscriptionUpdateInputBillingMethodProviderEnum';

  @override
  Object serialize(Serializers serializers,
          ProSubscriptionUpdateInputBillingMethodProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProSubscriptionUpdateInputBillingMethodProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProSubscriptionUpdateInputBillingMethodProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProSubscriptionUpdateInputBillingMethod
    extends ProSubscriptionUpdateInputBillingMethod {
  @override
  final ProSubscriptionUpdateInputBillingMethodProviderEnum provider;
  @override
  final String accountNumber;

  factory _$ProSubscriptionUpdateInputBillingMethod(
          [void Function(ProSubscriptionUpdateInputBillingMethodBuilder)?
              updates]) =>
      (ProSubscriptionUpdateInputBillingMethodBuilder()..update(updates))
          ._build();

  _$ProSubscriptionUpdateInputBillingMethod._(
      {required this.provider, required this.accountNumber})
      : super._();
  @override
  ProSubscriptionUpdateInputBillingMethod rebuild(
          void Function(ProSubscriptionUpdateInputBillingMethodBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProSubscriptionUpdateInputBillingMethodBuilder toBuilder() =>
      ProSubscriptionUpdateInputBillingMethodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProSubscriptionUpdateInputBillingMethod &&
        provider == other.provider &&
        accountNumber == other.accountNumber;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, accountNumber.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ProSubscriptionUpdateInputBillingMethod')
          ..add('provider', provider)
          ..add('accountNumber', accountNumber))
        .toString();
  }
}

class ProSubscriptionUpdateInputBillingMethodBuilder
    implements
        Builder<ProSubscriptionUpdateInputBillingMethod,
            ProSubscriptionUpdateInputBillingMethodBuilder> {
  _$ProSubscriptionUpdateInputBillingMethod? _$v;

  ProSubscriptionUpdateInputBillingMethodProviderEnum? _provider;
  ProSubscriptionUpdateInputBillingMethodProviderEnum? get provider =>
      _$this._provider;
  set provider(ProSubscriptionUpdateInputBillingMethodProviderEnum? provider) =>
      _$this._provider = provider;

  String? _accountNumber;
  String? get accountNumber => _$this._accountNumber;
  set accountNumber(String? accountNumber) =>
      _$this._accountNumber = accountNumber;

  ProSubscriptionUpdateInputBillingMethodBuilder() {
    ProSubscriptionUpdateInputBillingMethod._defaults(this);
  }

  ProSubscriptionUpdateInputBillingMethodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _provider = $v.provider;
      _accountNumber = $v.accountNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProSubscriptionUpdateInputBillingMethod other) {
    _$v = other as _$ProSubscriptionUpdateInputBillingMethod;
  }

  @override
  void update(
      void Function(ProSubscriptionUpdateInputBillingMethodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProSubscriptionUpdateInputBillingMethod build() => _build();

  _$ProSubscriptionUpdateInputBillingMethod _build() {
    final _$result = _$v ??
        _$ProSubscriptionUpdateInputBillingMethod._(
          provider: BuiltValueNullFieldError.checkNotNull(
              provider, r'ProSubscriptionUpdateInputBillingMethod', 'provider'),
          accountNumber: BuiltValueNullFieldError.checkNotNull(accountNumber,
              r'ProSubscriptionUpdateInputBillingMethod', 'accountNumber'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
