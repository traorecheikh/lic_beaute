// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_subscription_execute_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProSubscriptionExecuteResponse extends ProSubscriptionExecuteResponse {
  @override
  final bool success;
  @override
  final String status;
  @override
  final String? providerTxId;
  @override
  final String? message;
  @override
  final String? url;
  @override
  final PaydunyaExecutePaymentResponseOtherUrl? otherUrl;
  @override
  final BuiltMap<String, JsonObject?>? data;

  factory _$ProSubscriptionExecuteResponse(
          [void Function(ProSubscriptionExecuteResponseBuilder)? updates]) =>
      (ProSubscriptionExecuteResponseBuilder()..update(updates))._build();

  _$ProSubscriptionExecuteResponse._(
      {required this.success,
      required this.status,
      this.providerTxId,
      this.message,
      this.url,
      this.otherUrl,
      this.data})
      : super._();
  @override
  ProSubscriptionExecuteResponse rebuild(
          void Function(ProSubscriptionExecuteResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProSubscriptionExecuteResponseBuilder toBuilder() =>
      ProSubscriptionExecuteResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProSubscriptionExecuteResponse &&
        success == other.success &&
        status == other.status &&
        providerTxId == other.providerTxId &&
        message == other.message &&
        url == other.url &&
        otherUrl == other.otherUrl &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, providerTxId.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, otherUrl.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProSubscriptionExecuteResponse')
          ..add('success', success)
          ..add('status', status)
          ..add('providerTxId', providerTxId)
          ..add('message', message)
          ..add('url', url)
          ..add('otherUrl', otherUrl)
          ..add('data', data))
        .toString();
  }
}

class ProSubscriptionExecuteResponseBuilder
    implements
        Builder<ProSubscriptionExecuteResponse,
            ProSubscriptionExecuteResponseBuilder> {
  _$ProSubscriptionExecuteResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _providerTxId;
  String? get providerTxId => _$this._providerTxId;
  set providerTxId(String? providerTxId) => _$this._providerTxId = providerTxId;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  PaydunyaExecutePaymentResponseOtherUrlBuilder? _otherUrl;
  PaydunyaExecutePaymentResponseOtherUrlBuilder get otherUrl =>
      _$this._otherUrl ??= PaydunyaExecutePaymentResponseOtherUrlBuilder();
  set otherUrl(PaydunyaExecutePaymentResponseOtherUrlBuilder? otherUrl) =>
      _$this._otherUrl = otherUrl;

  MapBuilder<String, JsonObject?>? _data;
  MapBuilder<String, JsonObject?> get data =>
      _$this._data ??= MapBuilder<String, JsonObject?>();
  set data(MapBuilder<String, JsonObject?>? data) => _$this._data = data;

  ProSubscriptionExecuteResponseBuilder() {
    ProSubscriptionExecuteResponse._defaults(this);
  }

  ProSubscriptionExecuteResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _status = $v.status;
      _providerTxId = $v.providerTxId;
      _message = $v.message;
      _url = $v.url;
      _otherUrl = $v.otherUrl?.toBuilder();
      _data = $v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProSubscriptionExecuteResponse other) {
    _$v = other as _$ProSubscriptionExecuteResponse;
  }

  @override
  void update(void Function(ProSubscriptionExecuteResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProSubscriptionExecuteResponse build() => _build();

  _$ProSubscriptionExecuteResponse _build() {
    _$ProSubscriptionExecuteResponse _$result;
    try {
      _$result = _$v ??
          _$ProSubscriptionExecuteResponse._(
            success: BuiltValueNullFieldError.checkNotNull(
                success, r'ProSubscriptionExecuteResponse', 'success'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ProSubscriptionExecuteResponse', 'status'),
            providerTxId: providerTxId,
            message: message,
            url: url,
            otherUrl: _otherUrl?.build(),
            data: _data?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'otherUrl';
        _otherUrl?.build();
        _$failedField = 'data';
        _data?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProSubscriptionExecuteResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
