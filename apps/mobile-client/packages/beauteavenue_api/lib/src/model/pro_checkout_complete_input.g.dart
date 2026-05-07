// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_checkout_complete_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProCheckoutCompleteInputPaymentMethodEnum
    _$proCheckoutCompleteInputPaymentMethodEnum_cash =
    const ProCheckoutCompleteInputPaymentMethodEnum._('cash');
const ProCheckoutCompleteInputPaymentMethodEnum
    _$proCheckoutCompleteInputPaymentMethodEnum_intech =
    const ProCheckoutCompleteInputPaymentMethodEnum._('intech');
const ProCheckoutCompleteInputPaymentMethodEnum
    _$proCheckoutCompleteInputPaymentMethodEnum_other =
    const ProCheckoutCompleteInputPaymentMethodEnum._('other');

ProCheckoutCompleteInputPaymentMethodEnum
    _$proCheckoutCompleteInputPaymentMethodEnumValueOf(String name) {
  switch (name) {
    case 'cash':
      return _$proCheckoutCompleteInputPaymentMethodEnum_cash;
    case 'intech':
      return _$proCheckoutCompleteInputPaymentMethodEnum_intech;
    case 'other':
      return _$proCheckoutCompleteInputPaymentMethodEnum_other;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProCheckoutCompleteInputPaymentMethodEnum>
    _$proCheckoutCompleteInputPaymentMethodEnumValues = BuiltSet<
        ProCheckoutCompleteInputPaymentMethodEnum>(const <ProCheckoutCompleteInputPaymentMethodEnum>[
  _$proCheckoutCompleteInputPaymentMethodEnum_cash,
  _$proCheckoutCompleteInputPaymentMethodEnum_intech,
  _$proCheckoutCompleteInputPaymentMethodEnum_other,
]);

Serializer<ProCheckoutCompleteInputPaymentMethodEnum>
    _$proCheckoutCompleteInputPaymentMethodEnumSerializer =
    _$ProCheckoutCompleteInputPaymentMethodEnumSerializer();

class _$ProCheckoutCompleteInputPaymentMethodEnumSerializer
    implements PrimitiveSerializer<ProCheckoutCompleteInputPaymentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'cash': 'cash',
    'intech': 'intech',
    'other': 'other',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'cash': 'cash',
    'intech': 'intech',
    'other': 'other',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProCheckoutCompleteInputPaymentMethodEnum
  ];
  @override
  final String wireName = 'ProCheckoutCompleteInputPaymentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          ProCheckoutCompleteInputPaymentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProCheckoutCompleteInputPaymentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProCheckoutCompleteInputPaymentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProCheckoutCompleteInput extends ProCheckoutCompleteInput {
  @override
  final ProCheckoutCompleteInputPaymentMethodEnum paymentMethod;
  @override
  final BuiltList<ProCheckoutDetailsLineItemsInner> lineItems;
  @override
  final int? discountXof;

  factory _$ProCheckoutCompleteInput(
          [void Function(ProCheckoutCompleteInputBuilder)? updates]) =>
      (ProCheckoutCompleteInputBuilder()..update(updates))._build();

  _$ProCheckoutCompleteInput._(
      {required this.paymentMethod, required this.lineItems, this.discountXof})
      : super._();
  @override
  ProCheckoutCompleteInput rebuild(
          void Function(ProCheckoutCompleteInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProCheckoutCompleteInputBuilder toBuilder() =>
      ProCheckoutCompleteInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProCheckoutCompleteInput &&
        paymentMethod == other.paymentMethod &&
        lineItems == other.lineItems &&
        discountXof == other.discountXof;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jc(_$hash, lineItems.hashCode);
    _$hash = $jc(_$hash, discountXof.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProCheckoutCompleteInput')
          ..add('paymentMethod', paymentMethod)
          ..add('lineItems', lineItems)
          ..add('discountXof', discountXof))
        .toString();
  }
}

class ProCheckoutCompleteInputBuilder
    implements
        Builder<ProCheckoutCompleteInput, ProCheckoutCompleteInputBuilder> {
  _$ProCheckoutCompleteInput? _$v;

  ProCheckoutCompleteInputPaymentMethodEnum? _paymentMethod;
  ProCheckoutCompleteInputPaymentMethodEnum? get paymentMethod =>
      _$this._paymentMethod;
  set paymentMethod(ProCheckoutCompleteInputPaymentMethodEnum? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  ListBuilder<ProCheckoutDetailsLineItemsInner>? _lineItems;
  ListBuilder<ProCheckoutDetailsLineItemsInner> get lineItems =>
      _$this._lineItems ??= ListBuilder<ProCheckoutDetailsLineItemsInner>();
  set lineItems(ListBuilder<ProCheckoutDetailsLineItemsInner>? lineItems) =>
      _$this._lineItems = lineItems;

  int? _discountXof;
  int? get discountXof => _$this._discountXof;
  set discountXof(int? discountXof) => _$this._discountXof = discountXof;

  ProCheckoutCompleteInputBuilder() {
    ProCheckoutCompleteInput._defaults(this);
  }

  ProCheckoutCompleteInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _paymentMethod = $v.paymentMethod;
      _lineItems = $v.lineItems.toBuilder();
      _discountXof = $v.discountXof;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProCheckoutCompleteInput other) {
    _$v = other as _$ProCheckoutCompleteInput;
  }

  @override
  void update(void Function(ProCheckoutCompleteInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProCheckoutCompleteInput build() => _build();

  _$ProCheckoutCompleteInput _build() {
    _$ProCheckoutCompleteInput _$result;
    try {
      _$result = _$v ??
          _$ProCheckoutCompleteInput._(
            paymentMethod: BuiltValueNullFieldError.checkNotNull(
                paymentMethod, r'ProCheckoutCompleteInput', 'paymentMethod'),
            lineItems: lineItems.build(),
            discountXof: discountXof,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lineItems';
        lineItems.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProCheckoutCompleteInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
