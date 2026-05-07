// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_voucher.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ClientVoucherStatusEnum _$clientVoucherStatusEnum_active =
    const ClientVoucherStatusEnum._('active');
const ClientVoucherStatusEnum _$clientVoucherStatusEnum_used =
    const ClientVoucherStatusEnum._('used');
const ClientVoucherStatusEnum _$clientVoucherStatusEnum_expired =
    const ClientVoucherStatusEnum._('expired');

ClientVoucherStatusEnum _$clientVoucherStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$clientVoucherStatusEnum_active;
    case 'used':
      return _$clientVoucherStatusEnum_used;
    case 'expired':
      return _$clientVoucherStatusEnum_expired;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ClientVoucherStatusEnum> _$clientVoucherStatusEnumValues =
    BuiltSet<ClientVoucherStatusEnum>(const <ClientVoucherStatusEnum>[
  _$clientVoucherStatusEnum_active,
  _$clientVoucherStatusEnum_used,
  _$clientVoucherStatusEnum_expired,
]);

Serializer<ClientVoucherStatusEnum> _$clientVoucherStatusEnumSerializer =
    _$ClientVoucherStatusEnumSerializer();

class _$ClientVoucherStatusEnumSerializer
    implements PrimitiveSerializer<ClientVoucherStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'used': 'used',
    'expired': 'expired',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'used': 'used',
    'expired': 'expired',
  };

  @override
  final Iterable<Type> types = const <Type>[ClientVoucherStatusEnum];
  @override
  final String wireName = 'ClientVoucherStatusEnum';

  @override
  Object serialize(Serializers serializers, ClientVoucherStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ClientVoucherStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ClientVoucherStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ClientVoucher extends ClientVoucher {
  @override
  final String id;
  @override
  final String code;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String discountLabel;
  @override
  final ClientVoucherStatusEnum status;
  @override
  final String? expiresAt;
  @override
  final String redeemedAt;
  @override
  final String? usedAt;
  @override
  final String? salonId;
  @override
  final String? salonName;

  factory _$ClientVoucher([void Function(ClientVoucherBuilder)? updates]) =>
      (ClientVoucherBuilder()..update(updates))._build();

  _$ClientVoucher._(
      {required this.id,
      required this.code,
      required this.title,
      this.description,
      required this.discountLabel,
      required this.status,
      this.expiresAt,
      required this.redeemedAt,
      this.usedAt,
      this.salonId,
      this.salonName})
      : super._();
  @override
  ClientVoucher rebuild(void Function(ClientVoucherBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClientVoucherBuilder toBuilder() => ClientVoucherBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClientVoucher &&
        id == other.id &&
        code == other.code &&
        title == other.title &&
        description == other.description &&
        discountLabel == other.discountLabel &&
        status == other.status &&
        expiresAt == other.expiresAt &&
        redeemedAt == other.redeemedAt &&
        usedAt == other.usedAt &&
        salonId == other.salonId &&
        salonName == other.salonName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, discountLabel.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, redeemedAt.hashCode);
    _$hash = $jc(_$hash, usedAt.hashCode);
    _$hash = $jc(_$hash, salonId.hashCode);
    _$hash = $jc(_$hash, salonName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClientVoucher')
          ..add('id', id)
          ..add('code', code)
          ..add('title', title)
          ..add('description', description)
          ..add('discountLabel', discountLabel)
          ..add('status', status)
          ..add('expiresAt', expiresAt)
          ..add('redeemedAt', redeemedAt)
          ..add('usedAt', usedAt)
          ..add('salonId', salonId)
          ..add('salonName', salonName))
        .toString();
  }
}

class ClientVoucherBuilder
    implements Builder<ClientVoucher, ClientVoucherBuilder> {
  _$ClientVoucher? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _discountLabel;
  String? get discountLabel => _$this._discountLabel;
  set discountLabel(String? discountLabel) =>
      _$this._discountLabel = discountLabel;

  ClientVoucherStatusEnum? _status;
  ClientVoucherStatusEnum? get status => _$this._status;
  set status(ClientVoucherStatusEnum? status) => _$this._status = status;

  String? _expiresAt;
  String? get expiresAt => _$this._expiresAt;
  set expiresAt(String? expiresAt) => _$this._expiresAt = expiresAt;

  String? _redeemedAt;
  String? get redeemedAt => _$this._redeemedAt;
  set redeemedAt(String? redeemedAt) => _$this._redeemedAt = redeemedAt;

  String? _usedAt;
  String? get usedAt => _$this._usedAt;
  set usedAt(String? usedAt) => _$this._usedAt = usedAt;

  String? _salonId;
  String? get salonId => _$this._salonId;
  set salonId(String? salonId) => _$this._salonId = salonId;

  String? _salonName;
  String? get salonName => _$this._salonName;
  set salonName(String? salonName) => _$this._salonName = salonName;

  ClientVoucherBuilder() {
    ClientVoucher._defaults(this);
  }

  ClientVoucherBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _title = $v.title;
      _description = $v.description;
      _discountLabel = $v.discountLabel;
      _status = $v.status;
      _expiresAt = $v.expiresAt;
      _redeemedAt = $v.redeemedAt;
      _usedAt = $v.usedAt;
      _salonId = $v.salonId;
      _salonName = $v.salonName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClientVoucher other) {
    _$v = other as _$ClientVoucher;
  }

  @override
  void update(void Function(ClientVoucherBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClientVoucher build() => _build();

  _$ClientVoucher _build() {
    final _$result = _$v ??
        _$ClientVoucher._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ClientVoucher', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'ClientVoucher', 'code'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'ClientVoucher', 'title'),
          description: description,
          discountLabel: BuiltValueNullFieldError.checkNotNull(
              discountLabel, r'ClientVoucher', 'discountLabel'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ClientVoucher', 'status'),
          expiresAt: expiresAt,
          redeemedAt: BuiltValueNullFieldError.checkNotNull(
              redeemedAt, r'ClientVoucher', 'redeemedAt'),
          usedAt: usedAt,
          salonId: salonId,
          salonName: salonName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
