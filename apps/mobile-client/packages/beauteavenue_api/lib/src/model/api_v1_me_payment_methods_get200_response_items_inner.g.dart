// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_me_payment_methods_get200_response_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum
    _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum_intech =
    const ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum._('intech');

ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum
    _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnumValueOf(
        String name) {
  switch (name) {
    case 'intech':
      return _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum_intech;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum>
    _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnumValues =
    BuiltSet<
        ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum>(const <ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum>[
  _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum_intech,
]);

Serializer<ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum>
    _$apiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnumSerializer =
    _$ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnumSerializer();

class _$ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnumSerializer
    implements
        PrimitiveSerializer<
            ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'intech': 'intech',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'intech': 'intech',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum
  ];
  @override
  final String wireName =
      'ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum';

  @override
  Object serialize(Serializers serializers,
          ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiV1MePaymentMethodsGet200ResponseItemsInner
    extends ApiV1MePaymentMethodsGet200ResponseItemsInner {
  @override
  final String id;
  @override
  final ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum provider;
  @override
  final String phoneNumber;
  @override
  final String? label;
  @override
  final bool isDefault;
  @override
  final String? lastUsedAt;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  factory _$ApiV1MePaymentMethodsGet200ResponseItemsInner(
          [void Function(ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder)?
              updates]) =>
      (ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder()..update(updates))
          ._build();

  _$ApiV1MePaymentMethodsGet200ResponseItemsInner._(
      {required this.id,
      required this.provider,
      required this.phoneNumber,
      this.label,
      required this.isDefault,
      this.lastUsedAt,
      required this.createdAt,
      required this.updatedAt})
      : super._();
  @override
  ApiV1MePaymentMethodsGet200ResponseItemsInner rebuild(
          void Function(ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder toBuilder() =>
      ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1MePaymentMethodsGet200ResponseItemsInner &&
        id == other.id &&
        provider == other.provider &&
        phoneNumber == other.phoneNumber &&
        label == other.label &&
        isDefault == other.isDefault &&
        lastUsedAt == other.lastUsedAt &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, provider.hashCode);
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, isDefault.hashCode);
    _$hash = $jc(_$hash, lastUsedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1MePaymentMethodsGet200ResponseItemsInner')
          ..add('id', id)
          ..add('provider', provider)
          ..add('phoneNumber', phoneNumber)
          ..add('label', label)
          ..add('isDefault', isDefault)
          ..add('lastUsedAt', lastUsedAt)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder
    implements
        Builder<ApiV1MePaymentMethodsGet200ResponseItemsInner,
            ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder> {
  _$ApiV1MePaymentMethodsGet200ResponseItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum? _provider;
  ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum? get provider =>
      _$this._provider;
  set provider(
          ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum?
              provider) =>
      _$this._provider = provider;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _isDefault;
  bool? get isDefault => _$this._isDefault;
  set isDefault(bool? isDefault) => _$this._isDefault = isDefault;

  String? _lastUsedAt;
  String? get lastUsedAt => _$this._lastUsedAt;
  set lastUsedAt(String? lastUsedAt) => _$this._lastUsedAt = lastUsedAt;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder() {
    ApiV1MePaymentMethodsGet200ResponseItemsInner._defaults(this);
  }

  ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _provider = $v.provider;
      _phoneNumber = $v.phoneNumber;
      _label = $v.label;
      _isDefault = $v.isDefault;
      _lastUsedAt = $v.lastUsedAt;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1MePaymentMethodsGet200ResponseItemsInner other) {
    _$v = other as _$ApiV1MePaymentMethodsGet200ResponseItemsInner;
  }

  @override
  void update(
      void Function(ApiV1MePaymentMethodsGet200ResponseItemsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1MePaymentMethodsGet200ResponseItemsInner build() => _build();

  _$ApiV1MePaymentMethodsGet200ResponseItemsInner _build() {
    final _$result = _$v ??
        _$ApiV1MePaymentMethodsGet200ResponseItemsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'ApiV1MePaymentMethodsGet200ResponseItemsInner', 'id'),
          provider: BuiltValueNullFieldError.checkNotNull(provider,
              r'ApiV1MePaymentMethodsGet200ResponseItemsInner', 'provider'),
          phoneNumber: BuiltValueNullFieldError.checkNotNull(phoneNumber,
              r'ApiV1MePaymentMethodsGet200ResponseItemsInner', 'phoneNumber'),
          label: label,
          isDefault: BuiltValueNullFieldError.checkNotNull(isDefault,
              r'ApiV1MePaymentMethodsGet200ResponseItemsInner', 'isDefault'),
          lastUsedAt: lastUsedAt,
          createdAt: BuiltValueNullFieldError.checkNotNull(createdAt,
              r'ApiV1MePaymentMethodsGet200ResponseItemsInner', 'createdAt'),
          updatedAt: BuiltValueNullFieldError.checkNotNull(updatedAt,
              r'ApiV1MePaymentMethodsGet200ResponseItemsInner', 'updatedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
