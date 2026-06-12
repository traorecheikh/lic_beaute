// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_otp_accepted_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmailOtpAcceptedResponse extends EmailOtpAcceptedResponse {
  @override
  final bool accepted;
  @override
  final String destination;

  factory _$EmailOtpAcceptedResponse(
          [void Function(EmailOtpAcceptedResponseBuilder)? updates]) =>
      (EmailOtpAcceptedResponseBuilder()..update(updates))._build();

  _$EmailOtpAcceptedResponse._(
      {required this.accepted, required this.destination})
      : super._();
  @override
  EmailOtpAcceptedResponse rebuild(
          void Function(EmailOtpAcceptedResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmailOtpAcceptedResponseBuilder toBuilder() =>
      EmailOtpAcceptedResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmailOtpAcceptedResponse &&
        accepted == other.accepted &&
        destination == other.destination;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jc(_$hash, destination.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmailOtpAcceptedResponse')
          ..add('accepted', accepted)
          ..add('destination', destination))
        .toString();
  }
}

class EmailOtpAcceptedResponseBuilder
    implements
        Builder<EmailOtpAcceptedResponse, EmailOtpAcceptedResponseBuilder> {
  _$EmailOtpAcceptedResponse? _$v;

  bool? _accepted;
  bool? get accepted => _$this._accepted;
  set accepted(bool? accepted) => _$this._accepted = accepted;

  String? _destination;
  String? get destination => _$this._destination;
  set destination(String? destination) => _$this._destination = destination;

  EmailOtpAcceptedResponseBuilder() {
    EmailOtpAcceptedResponse._defaults(this);
  }

  EmailOtpAcceptedResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accepted = $v.accepted;
      _destination = $v.destination;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmailOtpAcceptedResponse other) {
    _$v = other as _$EmailOtpAcceptedResponse;
  }

  @override
  void update(void Function(EmailOtpAcceptedResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmailOtpAcceptedResponse build() => _build();

  _$EmailOtpAcceptedResponse _build() {
    final _$result = _$v ??
        _$EmailOtpAcceptedResponse._(
          accepted: BuiltValueNullFieldError.checkNotNull(
              accepted, r'EmailOtpAcceptedResponse', 'accepted'),
          destination: BuiltValueNullFieldError.checkNotNull(
              destination, r'EmailOtpAcceptedResponse', 'destination'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
