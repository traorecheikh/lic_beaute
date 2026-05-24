// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paydunya_execute_payment_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaydunyaExecutePaymentResponse extends PaydunyaExecutePaymentResponse {
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

  factory _$PaydunyaExecutePaymentResponse(
          [void Function(PaydunyaExecutePaymentResponseBuilder)? updates]) =>
      (PaydunyaExecutePaymentResponseBuilder()..update(updates))._build();

  _$PaydunyaExecutePaymentResponse._(
      {required this.success,
      required this.status,
      this.providerTxId,
      this.message,
      this.url,
      this.otherUrl,
      this.data})
      : super._();
  @override
  PaydunyaExecutePaymentResponse rebuild(
          void Function(PaydunyaExecutePaymentResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaydunyaExecutePaymentResponseBuilder toBuilder() =>
      PaydunyaExecutePaymentResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaydunyaExecutePaymentResponse &&
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
    return (newBuiltValueToStringHelper(r'PaydunyaExecutePaymentResponse')
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

class PaydunyaExecutePaymentResponseBuilder
    implements
        Builder<PaydunyaExecutePaymentResponse,
            PaydunyaExecutePaymentResponseBuilder> {
  _$PaydunyaExecutePaymentResponse? _$v;

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

  PaydunyaExecutePaymentResponseBuilder() {
    PaydunyaExecutePaymentResponse._defaults(this);
  }

  PaydunyaExecutePaymentResponseBuilder get _$this {
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
  void replace(PaydunyaExecutePaymentResponse other) {
    _$v = other as _$PaydunyaExecutePaymentResponse;
  }

  @override
  void update(void Function(PaydunyaExecutePaymentResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaydunyaExecutePaymentResponse build() => _build();

  _$PaydunyaExecutePaymentResponse _build() {
    _$PaydunyaExecutePaymentResponse _$result;
    try {
      _$result = _$v ??
          _$PaydunyaExecutePaymentResponse._(
            success: BuiltValueNullFieldError.checkNotNull(
                success, r'PaydunyaExecutePaymentResponse', 'success'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PaydunyaExecutePaymentResponse', 'status'),
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
            r'PaydunyaExecutePaymentResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
