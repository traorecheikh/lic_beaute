// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_client_benefit_create_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProClientBenefitCreateInputKindEnum
    _$proClientBenefitCreateInputKindEnum_membership =
    const ProClientBenefitCreateInputKindEnum._('membership');
const ProClientBenefitCreateInputKindEnum
    _$proClientBenefitCreateInputKindEnum_package =
    const ProClientBenefitCreateInputKindEnum._('package');

ProClientBenefitCreateInputKindEnum
    _$proClientBenefitCreateInputKindEnumValueOf(String name) {
  switch (name) {
    case 'membership':
      return _$proClientBenefitCreateInputKindEnum_membership;
    case 'package':
      return _$proClientBenefitCreateInputKindEnum_package;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProClientBenefitCreateInputKindEnum>
    _$proClientBenefitCreateInputKindEnumValues = BuiltSet<
        ProClientBenefitCreateInputKindEnum>(const <ProClientBenefitCreateInputKindEnum>[
  _$proClientBenefitCreateInputKindEnum_membership,
  _$proClientBenefitCreateInputKindEnum_package,
]);

Serializer<ProClientBenefitCreateInputKindEnum>
    _$proClientBenefitCreateInputKindEnumSerializer =
    _$ProClientBenefitCreateInputKindEnumSerializer();

class _$ProClientBenefitCreateInputKindEnumSerializer
    implements PrimitiveSerializer<ProClientBenefitCreateInputKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'membership': 'membership',
    'package': 'package',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'membership': 'membership',
    'package': 'package',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProClientBenefitCreateInputKindEnum
  ];
  @override
  final String wireName = 'ProClientBenefitCreateInputKindEnum';

  @override
  Object serialize(
          Serializers serializers, ProClientBenefitCreateInputKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProClientBenefitCreateInputKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProClientBenefitCreateInputKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProClientBenefitCreateInput extends ProClientBenefitCreateInput {
  @override
  final String clientId;
  @override
  final ProClientBenefitCreateInputKindEnum kind;
  @override
  final String name;
  @override
  final int? remainingUses;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? billingDate;

  factory _$ProClientBenefitCreateInput(
          [void Function(ProClientBenefitCreateInputBuilder)? updates]) =>
      (ProClientBenefitCreateInputBuilder()..update(updates))._build();

  _$ProClientBenefitCreateInput._(
      {required this.clientId,
      required this.kind,
      required this.name,
      this.remainingUses,
      this.expiresAt,
      this.billingDate})
      : super._();
  @override
  ProClientBenefitCreateInput rebuild(
          void Function(ProClientBenefitCreateInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProClientBenefitCreateInputBuilder toBuilder() =>
      ProClientBenefitCreateInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProClientBenefitCreateInput &&
        clientId == other.clientId &&
        kind == other.kind &&
        name == other.name &&
        remainingUses == other.remainingUses &&
        expiresAt == other.expiresAt &&
        billingDate == other.billingDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, clientId.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, remainingUses.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, billingDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProClientBenefitCreateInput')
          ..add('clientId', clientId)
          ..add('kind', kind)
          ..add('name', name)
          ..add('remainingUses', remainingUses)
          ..add('expiresAt', expiresAt)
          ..add('billingDate', billingDate))
        .toString();
  }
}

class ProClientBenefitCreateInputBuilder
    implements
        Builder<ProClientBenefitCreateInput,
            ProClientBenefitCreateInputBuilder> {
  _$ProClientBenefitCreateInput? _$v;

  String? _clientId;
  String? get clientId => _$this._clientId;
  set clientId(String? clientId) => _$this._clientId = clientId;

  ProClientBenefitCreateInputKindEnum? _kind;
  ProClientBenefitCreateInputKindEnum? get kind => _$this._kind;
  set kind(ProClientBenefitCreateInputKindEnum? kind) => _$this._kind = kind;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _remainingUses;
  int? get remainingUses => _$this._remainingUses;
  set remainingUses(int? remainingUses) =>
      _$this._remainingUses = remainingUses;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DateTime? _billingDate;
  DateTime? get billingDate => _$this._billingDate;
  set billingDate(DateTime? billingDate) => _$this._billingDate = billingDate;

  ProClientBenefitCreateInputBuilder() {
    ProClientBenefitCreateInput._defaults(this);
  }

  ProClientBenefitCreateInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _clientId = $v.clientId;
      _kind = $v.kind;
      _name = $v.name;
      _remainingUses = $v.remainingUses;
      _expiresAt = $v.expiresAt;
      _billingDate = $v.billingDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProClientBenefitCreateInput other) {
    _$v = other as _$ProClientBenefitCreateInput;
  }

  @override
  void update(void Function(ProClientBenefitCreateInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProClientBenefitCreateInput build() => _build();

  _$ProClientBenefitCreateInput _build() {
    final _$result = _$v ??
        _$ProClientBenefitCreateInput._(
          clientId: BuiltValueNullFieldError.checkNotNull(
              clientId, r'ProClientBenefitCreateInput', 'clientId'),
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'ProClientBenefitCreateInput', 'kind'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ProClientBenefitCreateInput', 'name'),
          remainingUses: remainingUses,
          expiresAt: expiresAt,
          billingDate: billingDate,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
