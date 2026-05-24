// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_subscription_execute_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProSubscriptionExecuteInput extends ProSubscriptionExecuteInput {
  @override
  final String method;
  @override
  final BuiltMap<String, JsonObject?>? details;

  factory _$ProSubscriptionExecuteInput(
          [void Function(ProSubscriptionExecuteInputBuilder)? updates]) =>
      (ProSubscriptionExecuteInputBuilder()..update(updates))._build();

  _$ProSubscriptionExecuteInput._({required this.method, this.details})
      : super._();
  @override
  ProSubscriptionExecuteInput rebuild(
          void Function(ProSubscriptionExecuteInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProSubscriptionExecuteInputBuilder toBuilder() =>
      ProSubscriptionExecuteInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProSubscriptionExecuteInput &&
        method == other.method &&
        details == other.details;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, method.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProSubscriptionExecuteInput')
          ..add('method', method)
          ..add('details', details))
        .toString();
  }
}

class ProSubscriptionExecuteInputBuilder
    implements
        Builder<ProSubscriptionExecuteInput,
            ProSubscriptionExecuteInputBuilder> {
  _$ProSubscriptionExecuteInput? _$v;

  String? _method;
  String? get method => _$this._method;
  set method(String? method) => _$this._method = method;

  MapBuilder<String, JsonObject?>? _details;
  MapBuilder<String, JsonObject?> get details =>
      _$this._details ??= MapBuilder<String, JsonObject?>();
  set details(MapBuilder<String, JsonObject?>? details) =>
      _$this._details = details;

  ProSubscriptionExecuteInputBuilder() {
    ProSubscriptionExecuteInput._defaults(this);
  }

  ProSubscriptionExecuteInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _method = $v.method;
      _details = $v.details?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProSubscriptionExecuteInput other) {
    _$v = other as _$ProSubscriptionExecuteInput;
  }

  @override
  void update(void Function(ProSubscriptionExecuteInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProSubscriptionExecuteInput build() => _build();

  _$ProSubscriptionExecuteInput _build() {
    _$ProSubscriptionExecuteInput _$result;
    try {
      _$result = _$v ??
          _$ProSubscriptionExecuteInput._(
            method: BuiltValueNullFieldError.checkNotNull(
                method, r'ProSubscriptionExecuteInput', 'method'),
            details: _details?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'details';
        _details?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProSubscriptionExecuteInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
