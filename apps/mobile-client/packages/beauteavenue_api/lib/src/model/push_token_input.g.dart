// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_token_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PushTokenInputPlatformEnum _$pushTokenInputPlatformEnum_ios =
    const PushTokenInputPlatformEnum._('ios');
const PushTokenInputPlatformEnum _$pushTokenInputPlatformEnum_android =
    const PushTokenInputPlatformEnum._('android');

PushTokenInputPlatformEnum _$pushTokenInputPlatformEnumValueOf(String name) {
  switch (name) {
    case 'ios':
      return _$pushTokenInputPlatformEnum_ios;
    case 'android':
      return _$pushTokenInputPlatformEnum_android;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PushTokenInputPlatformEnum> _$pushTokenInputPlatformEnumValues =
    BuiltSet<PushTokenInputPlatformEnum>(const <PushTokenInputPlatformEnum>[
  _$pushTokenInputPlatformEnum_ios,
  _$pushTokenInputPlatformEnum_android,
]);

Serializer<PushTokenInputPlatformEnum> _$pushTokenInputPlatformEnumSerializer =
    _$PushTokenInputPlatformEnumSerializer();

class _$PushTokenInputPlatformEnumSerializer
    implements PrimitiveSerializer<PushTokenInputPlatformEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ios': 'ios',
    'android': 'android',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ios': 'ios',
    'android': 'android',
  };

  @override
  final Iterable<Type> types = const <Type>[PushTokenInputPlatformEnum];
  @override
  final String wireName = 'PushTokenInputPlatformEnum';

  @override
  Object serialize(Serializers serializers, PushTokenInputPlatformEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PushTokenInputPlatformEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PushTokenInputPlatformEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PushTokenInput extends PushTokenInput {
  @override
  final String token;
  @override
  final PushTokenInputPlatformEnum platform;
  @override
  final String deviceId;

  factory _$PushTokenInput([void Function(PushTokenInputBuilder)? updates]) =>
      (PushTokenInputBuilder()..update(updates))._build();

  _$PushTokenInput._(
      {required this.token, required this.platform, required this.deviceId})
      : super._();
  @override
  PushTokenInput rebuild(void Function(PushTokenInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PushTokenInputBuilder toBuilder() => PushTokenInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PushTokenInput &&
        token == other.token &&
        platform == other.platform &&
        deviceId == other.deviceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PushTokenInput')
          ..add('token', token)
          ..add('platform', platform)
          ..add('deviceId', deviceId))
        .toString();
  }
}

class PushTokenInputBuilder
    implements Builder<PushTokenInput, PushTokenInputBuilder> {
  _$PushTokenInput? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  PushTokenInputPlatformEnum? _platform;
  PushTokenInputPlatformEnum? get platform => _$this._platform;
  set platform(PushTokenInputPlatformEnum? platform) =>
      _$this._platform = platform;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  PushTokenInputBuilder() {
    PushTokenInput._defaults(this);
  }

  PushTokenInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _platform = $v.platform;
      _deviceId = $v.deviceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PushTokenInput other) {
    _$v = other as _$PushTokenInput;
  }

  @override
  void update(void Function(PushTokenInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PushTokenInput build() => _build();

  _$PushTokenInput _build() {
    final _$result = _$v ??
        _$PushTokenInput._(
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'PushTokenInput', 'token'),
          platform: BuiltValueNullFieldError.checkNotNull(
              platform, r'PushTokenInput', 'platform'),
          deviceId: BuiltValueNullFieldError.checkNotNull(
              deviceId, r'PushTokenInput', 'deviceId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
