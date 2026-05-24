// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paydunya_method_list_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PaydunyaMethodListResponse extends PaydunyaMethodListResponse {
  @override
  final BuiltList<PaydunyaMethodListResponseMethodsInner> methods;

  factory _$PaydunyaMethodListResponse(
          [void Function(PaydunyaMethodListResponseBuilder)? updates]) =>
      (PaydunyaMethodListResponseBuilder()..update(updates))._build();

  _$PaydunyaMethodListResponse._({required this.methods}) : super._();
  @override
  PaydunyaMethodListResponse rebuild(
          void Function(PaydunyaMethodListResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaydunyaMethodListResponseBuilder toBuilder() =>
      PaydunyaMethodListResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaydunyaMethodListResponse && methods == other.methods;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, methods.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaydunyaMethodListResponse')
          ..add('methods', methods))
        .toString();
  }
}

class PaydunyaMethodListResponseBuilder
    implements
        Builder<PaydunyaMethodListResponse, PaydunyaMethodListResponseBuilder> {
  _$PaydunyaMethodListResponse? _$v;

  ListBuilder<PaydunyaMethodListResponseMethodsInner>? _methods;
  ListBuilder<PaydunyaMethodListResponseMethodsInner> get methods =>
      _$this._methods ??= ListBuilder<PaydunyaMethodListResponseMethodsInner>();
  set methods(ListBuilder<PaydunyaMethodListResponseMethodsInner>? methods) =>
      _$this._methods = methods;

  PaydunyaMethodListResponseBuilder() {
    PaydunyaMethodListResponse._defaults(this);
  }

  PaydunyaMethodListResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _methods = $v.methods.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaydunyaMethodListResponse other) {
    _$v = other as _$PaydunyaMethodListResponse;
  }

  @override
  void update(void Function(PaydunyaMethodListResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaydunyaMethodListResponse build() => _build();

  _$PaydunyaMethodListResponse _build() {
    _$PaydunyaMethodListResponse _$result;
    try {
      _$result = _$v ??
          _$PaydunyaMethodListResponse._(
            methods: methods.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'methods';
        methods.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PaydunyaMethodListResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
