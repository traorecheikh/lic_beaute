// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_subscription_checkout_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProSubscriptionCheckoutInputActionEnum
    _$proSubscriptionCheckoutInputActionEnum_upgrade =
    const ProSubscriptionCheckoutInputActionEnum._('upgrade');
const ProSubscriptionCheckoutInputActionEnum
    _$proSubscriptionCheckoutInputActionEnum_renewal =
    const ProSubscriptionCheckoutInputActionEnum._('renewal');

ProSubscriptionCheckoutInputActionEnum
    _$proSubscriptionCheckoutInputActionEnumValueOf(String name) {
  switch (name) {
    case 'upgrade':
      return _$proSubscriptionCheckoutInputActionEnum_upgrade;
    case 'renewal':
      return _$proSubscriptionCheckoutInputActionEnum_renewal;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProSubscriptionCheckoutInputActionEnum>
    _$proSubscriptionCheckoutInputActionEnumValues = BuiltSet<
        ProSubscriptionCheckoutInputActionEnum>(const <ProSubscriptionCheckoutInputActionEnum>[
  _$proSubscriptionCheckoutInputActionEnum_upgrade,
  _$proSubscriptionCheckoutInputActionEnum_renewal,
]);

const ProSubscriptionCheckoutInputProviderEnum
    _$proSubscriptionCheckoutInputProviderEnum_paydunya =
    const ProSubscriptionCheckoutInputProviderEnum._('paydunya');
const ProSubscriptionCheckoutInputProviderEnum
    _$proSubscriptionCheckoutInputProviderEnum_intech =
    const ProSubscriptionCheckoutInputProviderEnum._('intech');
const ProSubscriptionCheckoutInputProviderEnum
    _$proSubscriptionCheckoutInputProviderEnum_manual =
    const ProSubscriptionCheckoutInputProviderEnum._('manual');

ProSubscriptionCheckoutInputProviderEnum
    _$proSubscriptionCheckoutInputProviderEnumValueOf(String name) {
  switch (name) {
    case 'paydunya':
      return _$proSubscriptionCheckoutInputProviderEnum_paydunya;
    case 'intech':
      return _$proSubscriptionCheckoutInputProviderEnum_intech;
    case 'manual':
      return _$proSubscriptionCheckoutInputProviderEnum_manual;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProSubscriptionCheckoutInputProviderEnum>
    _$proSubscriptionCheckoutInputProviderEnumValues = BuiltSet<
        ProSubscriptionCheckoutInputProviderEnum>(const <ProSubscriptionCheckoutInputProviderEnum>[
  _$proSubscriptionCheckoutInputProviderEnum_paydunya,
  _$proSubscriptionCheckoutInputProviderEnum_intech,
  _$proSubscriptionCheckoutInputProviderEnum_manual,
]);

Serializer<ProSubscriptionCheckoutInputActionEnum>
    _$proSubscriptionCheckoutInputActionEnumSerializer =
    _$ProSubscriptionCheckoutInputActionEnumSerializer();
Serializer<ProSubscriptionCheckoutInputProviderEnum>
    _$proSubscriptionCheckoutInputProviderEnumSerializer =
    _$ProSubscriptionCheckoutInputProviderEnumSerializer();

class _$ProSubscriptionCheckoutInputActionEnumSerializer
    implements PrimitiveSerializer<ProSubscriptionCheckoutInputActionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'upgrade': 'upgrade',
    'renewal': 'renewal',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'upgrade': 'upgrade',
    'renewal': 'renewal',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProSubscriptionCheckoutInputActionEnum
  ];
  @override
  final String wireName = 'ProSubscriptionCheckoutInputActionEnum';

  @override
  Object serialize(Serializers serializers,
          ProSubscriptionCheckoutInputActionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProSubscriptionCheckoutInputActionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProSubscriptionCheckoutInputActionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProSubscriptionCheckoutInputProviderEnumSerializer
    implements PrimitiveSerializer<ProSubscriptionCheckoutInputProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'paydunya': 'paydunya',
    'intech': 'intech',
    'manual': 'manual',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'paydunya': 'paydunya',
    'intech': 'intech',
    'manual': 'manual',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProSubscriptionCheckoutInputProviderEnum
  ];
  @override
  final String wireName = 'ProSubscriptionCheckoutInputProviderEnum';

  @override
  Object serialize(Serializers serializers,
          ProSubscriptionCheckoutInputProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProSubscriptionCheckoutInputProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProSubscriptionCheckoutInputProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProSubscriptionCheckoutInput extends ProSubscriptionCheckoutInput {
  @override
  final ProSubscriptionCheckoutInputActionEnum action;
  @override
  final ProSubscriptionCheckoutInputProviderEnum? provider;

  factory _$ProSubscriptionCheckoutInput(
          [void Function(ProSubscriptionCheckoutInputBuilder)? updates]) =>
      (ProSubscriptionCheckoutInputBuilder()..update(updates))._build();

  _$ProSubscriptionCheckoutInput._({required this.action, this.provider})
      : super._();
  @override
  ProSubscriptionCheckoutInput rebuild(
          void Function(ProSubscriptionCheckoutInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProSubscriptionCheckoutInputBuilder toBuilder() =>
      ProSubscriptionCheckoutInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProSubscriptionCheckoutInput &&
        action == other.action &&
        provider == other.provider;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, action.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProSubscriptionCheckoutInput')
          ..add('action', action)
          ..add('provider', provider))
        .toString();
  }
}

class ProSubscriptionCheckoutInputBuilder
    implements
        Builder<ProSubscriptionCheckoutInput,
            ProSubscriptionCheckoutInputBuilder> {
  _$ProSubscriptionCheckoutInput? _$v;

  ProSubscriptionCheckoutInputActionEnum? _action;
  ProSubscriptionCheckoutInputActionEnum? get action => _$this._action;
  set action(ProSubscriptionCheckoutInputActionEnum? action) =>
      _$this._action = action;

  ProSubscriptionCheckoutInputProviderEnum? _provider;
  ProSubscriptionCheckoutInputProviderEnum? get provider => _$this._provider;
  set provider(ProSubscriptionCheckoutInputProviderEnum? provider) =>
      _$this._provider = provider;

  ProSubscriptionCheckoutInputBuilder() {
    ProSubscriptionCheckoutInput._defaults(this);
  }

  ProSubscriptionCheckoutInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _action = $v.action;
      _provider = $v.provider;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProSubscriptionCheckoutInput other) {
    _$v = other as _$ProSubscriptionCheckoutInput;
  }

  @override
  void update(void Function(ProSubscriptionCheckoutInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProSubscriptionCheckoutInput build() => _build();

  _$ProSubscriptionCheckoutInput _build() {
    final _$result = _$v ??
        _$ProSubscriptionCheckoutInput._(
          action: BuiltValueNullFieldError.checkNotNull(
              action, r'ProSubscriptionCheckoutInput', 'action'),
          provider: provider,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
