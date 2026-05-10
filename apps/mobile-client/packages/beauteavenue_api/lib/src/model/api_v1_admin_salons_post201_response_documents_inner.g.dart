// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_v1_admin_salons_post201_response_documents_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum
    _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum_received =
    const ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum._('received');
const ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum
    _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum_missing =
    const ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum._('missing');
const ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum
    _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum_invalid =
    const ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum._('invalid');

ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum
    _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnumValueOf(
        String name) {
  switch (name) {
    case 'received':
      return _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum_received;
    case 'missing':
      return _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum_missing;
    case 'invalid':
      return _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum_invalid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum>
    _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnumValues = BuiltSet<
        ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum>(const <ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum>[
  _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum_received,
  _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum_missing,
  _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum_invalid,
]);

Serializer<ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum>
    _$apiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnumSerializer =
    _$ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnumSerializer();

class _$ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
            ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'received': 'received',
    'missing': 'missing',
    'invalid': 'invalid',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'received': 'received',
    'missing': 'missing',
    'invalid': 'invalid',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum
  ];
  @override
  final String wireName =
      'ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ApiV1AdminSalonsPost201ResponseDocumentsInner
    extends ApiV1AdminSalonsPost201ResponseDocumentsInner {
  @override
  final String label;
  @override
  final ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum status;
  @override
  final String? note;
  @override
  final String? fileUrl;

  factory _$ApiV1AdminSalonsPost201ResponseDocumentsInner(
          [void Function(ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder)?
              updates]) =>
      (ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder()..update(updates))
          ._build();

  _$ApiV1AdminSalonsPost201ResponseDocumentsInner._(
      {required this.label, required this.status, this.note, this.fileUrl})
      : super._();
  @override
  ApiV1AdminSalonsPost201ResponseDocumentsInner rebuild(
          void Function(ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder toBuilder() =>
      ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiV1AdminSalonsPost201ResponseDocumentsInner &&
        label == other.label &&
        status == other.status &&
        note == other.note &&
        fileUrl == other.fileUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, fileUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ApiV1AdminSalonsPost201ResponseDocumentsInner')
          ..add('label', label)
          ..add('status', status)
          ..add('note', note)
          ..add('fileUrl', fileUrl))
        .toString();
  }
}

class ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder
    implements
        Builder<ApiV1AdminSalonsPost201ResponseDocumentsInner,
            ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder> {
  _$ApiV1AdminSalonsPost201ResponseDocumentsInner? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum? _status;
  ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum? get status =>
      _$this._status;
  set status(ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _fileUrl;
  String? get fileUrl => _$this._fileUrl;
  set fileUrl(String? fileUrl) => _$this._fileUrl = fileUrl;

  ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder() {
    ApiV1AdminSalonsPost201ResponseDocumentsInner._defaults(this);
  }

  ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _status = $v.status;
      _note = $v.note;
      _fileUrl = $v.fileUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiV1AdminSalonsPost201ResponseDocumentsInner other) {
    _$v = other as _$ApiV1AdminSalonsPost201ResponseDocumentsInner;
  }

  @override
  void update(
      void Function(ApiV1AdminSalonsPost201ResponseDocumentsInnerBuilder)?
          updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiV1AdminSalonsPost201ResponseDocumentsInner build() => _build();

  _$ApiV1AdminSalonsPost201ResponseDocumentsInner _build() {
    final _$result = _$v ??
        _$ApiV1AdminSalonsPost201ResponseDocumentsInner._(
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'ApiV1AdminSalonsPost201ResponseDocumentsInner', 'label'),
          status: BuiltValueNullFieldError.checkNotNull(status,
              r'ApiV1AdminSalonsPost201ResponseDocumentsInner', 'status'),
          note: note,
          fileUrl: fileUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
