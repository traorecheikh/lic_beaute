// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_payments_webhooks_paydunya_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiV1PaymentsWebhooksPaydunyaPost200Response
    extends ApiV1PaymentsWebhooksPaydunyaPost200Response {
  @override
  final bool received;

  factory _$ApiV1PaymentsWebhooksPaydunyaPost200Response(
          [void Function(ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder)?
              updates]) =>
      (ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder()..update(updates))
          ._build();

  _$ApiV1PaymentsWebhooksPaydunyaPost200Response._({required this.received})
      : super._();
  @override
  ApiV1PaymentsWebhooksPaydunyaPost200Response rebuild(
          void Function(ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder toBuilder() =>
      ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1PaymentsWebhooksPaydunyaPost200Response &&
        received == other.received;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1PaymentsWebhooksPaydunyaPost200Response')
          ..add('received', received))
        .toString();
  }
}

class ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder
    implements
        Builder<ApiV1PaymentsWebhooksPaydunyaPost200Response,
            ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder> {
  _$ApiV1PaymentsWebhooksPaydunyaPost200Response? _$v;

  bool? _received;
  bool? get received => _$this._received;
  set received(bool? received) => _$this._received = received;

  ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder() {
    ApiV1PaymentsWebhooksPaydunyaPost200Response._defaults(this);
  }

  ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _received = $v.received;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1PaymentsWebhooksPaydunyaPost200Response other) {
    _$v = other as _$ApiV1PaymentsWebhooksPaydunyaPost200Response;
  }

  @override
  void update(
      void Function(ApiV1PaymentsWebhooksPaydunyaPost200ResponseBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1PaymentsWebhooksPaydunyaPost200Response build() => _build();

  _$ApiV1PaymentsWebhooksPaydunyaPost200Response _build() {
    final _$result = _$v ??
        _$ApiV1PaymentsWebhooksPaydunyaPost200Response._(
          received: BuiltValueNullFieldError.checkNotNull(received,
              r'ApiV1PaymentsWebhooksPaydunyaPost200Response', 'received'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
