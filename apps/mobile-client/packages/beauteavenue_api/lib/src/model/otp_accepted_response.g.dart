// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_accepted_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OtpAcceptedResponse extends OtpAcceptedResponse {
  @override
  final bool accepted;
  @override
  final String channel;
  @override
  final String destination;

  factory _$OtpAcceptedResponse(
          [void Function(OtpAcceptedResponseBuilder)? updates]) =>
      (OtpAcceptedResponseBuilder()..update(updates))._build();

  _$OtpAcceptedResponse._(
      {required this.accepted,
      required this.channel,
      required this.destination})
      : super._();
  @override
  OtpAcceptedResponse rebuild(
          void Function(OtpAcceptedResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OtpAcceptedResponseBuilder toBuilder() =>
      OtpAcceptedResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OtpAcceptedResponse &&
        accepted == other.accepted &&
        channel == other.channel &&
        destination == other.destination;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jc(_$hash, channel.hashCode);
    _$hash = $jc(_$hash, destination.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OtpAcceptedResponse')
          ..add('accepted', accepted)
          ..add('channel', channel)
          ..add('destination', destination))
        .toString();
  }
}

class OtpAcceptedResponseBuilder
    implements Builder<OtpAcceptedResponse, OtpAcceptedResponseBuilder> {
  _$OtpAcceptedResponse? _$v;

  bool? _accepted;
  bool? get accepted => _$this._accepted;
  set accepted(bool? accepted) => _$this._accepted = accepted;

  String? _channel;
  String? get channel => _$this._channel;
  set channel(String? channel) => _$this._channel = channel;

  String? _destination;
  String? get destination => _$this._destination;
  set destination(String? destination) => _$this._destination = destination;

  OtpAcceptedResponseBuilder() {
    OtpAcceptedResponse._defaults(this);
  }

  OtpAcceptedResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accepted = $v.accepted;
      _channel = $v.channel;
      _destination = $v.destination;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OtpAcceptedResponse other) {
    _$v = other as _$OtpAcceptedResponse;
  }

  @override
  void update(void Function(OtpAcceptedResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OtpAcceptedResponse build() => _build();

  _$OtpAcceptedResponse _build() {
    final _$result = _$v ??
        _$OtpAcceptedResponse._(
          accepted: BuiltValueNullFieldError.checkNotNull(
              accepted, r'OtpAcceptedResponse', 'accepted'),
          channel: BuiltValueNullFieldError.checkNotNull(
              channel, r'OtpAcceptedResponse', 'channel'),
          destination: BuiltValueNullFieldError.checkNotNull(
              destination, r'OtpAcceptedResponse', 'destination'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
