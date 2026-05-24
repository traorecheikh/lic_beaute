// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_input_any_of1_documents_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterInputAnyOf1DocumentsInner
    extends RegisterInputAnyOf1DocumentsInner {
  @override
  final String label;
  @override
  final String fileUrl;

  factory _$RegisterInputAnyOf1DocumentsInner(
          [void Function(RegisterInputAnyOf1DocumentsInnerBuilder)? updates]) =>
      (RegisterInputAnyOf1DocumentsInnerBuilder()..update(updates))._build();

  _$RegisterInputAnyOf1DocumentsInner._(
      {required this.label, required this.fileUrl})
      : super._();
  @override
  RegisterInputAnyOf1DocumentsInner rebuild(
          void Function(RegisterInputAnyOf1DocumentsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterInputAnyOf1DocumentsInnerBuilder toBuilder() =>
      RegisterInputAnyOf1DocumentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterInputAnyOf1DocumentsInner &&
        label == other.label &&
        fileUrl == other.fileUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, fileUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterInputAnyOf1DocumentsInner')
          ..add('label', label)
          ..add('fileUrl', fileUrl))
        .toString();
  }
}

class RegisterInputAnyOf1DocumentsInnerBuilder
    implements
        Builder<RegisterInputAnyOf1DocumentsInner,
            RegisterInputAnyOf1DocumentsInnerBuilder> {
  _$RegisterInputAnyOf1DocumentsInner? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _fileUrl;
  String? get fileUrl => _$this._fileUrl;
  set fileUrl(String? fileUrl) => _$this._fileUrl = fileUrl;

  RegisterInputAnyOf1DocumentsInnerBuilder() {
    RegisterInputAnyOf1DocumentsInner._defaults(this);
  }

  RegisterInputAnyOf1DocumentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _fileUrl = $v.fileUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterInputAnyOf1DocumentsInner other) {
    _$v = other as _$RegisterInputAnyOf1DocumentsInner;
  }

  @override
  void update(
      void Function(RegisterInputAnyOf1DocumentsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterInputAnyOf1DocumentsInner build() => _build();

  _$RegisterInputAnyOf1DocumentsInner _build() {
    final _$result = _$v ??
        _$RegisterInputAnyOf1DocumentsInner._(
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'RegisterInputAnyOf1DocumentsInner', 'label'),
          fileUrl: BuiltValueNullFieldError.checkNotNull(
              fileUrl, r'RegisterInputAnyOf1DocumentsInner', 'fileUrl'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
