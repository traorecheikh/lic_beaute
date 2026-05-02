// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_salon_detail_documents_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSalonDetailDocumentsInnerStatusEnum
    _$adminSalonDetailDocumentsInnerStatusEnum_received =
    const AdminSalonDetailDocumentsInnerStatusEnum._('received');
const AdminSalonDetailDocumentsInnerStatusEnum
    _$adminSalonDetailDocumentsInnerStatusEnum_missing =
    const AdminSalonDetailDocumentsInnerStatusEnum._('missing');
const AdminSalonDetailDocumentsInnerStatusEnum
    _$adminSalonDetailDocumentsInnerStatusEnum_invalid =
    const AdminSalonDetailDocumentsInnerStatusEnum._('invalid');

AdminSalonDetailDocumentsInnerStatusEnum
    _$adminSalonDetailDocumentsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'received':
      return _$adminSalonDetailDocumentsInnerStatusEnum_received;
    case 'missing':
      return _$adminSalonDetailDocumentsInnerStatusEnum_missing;
    case 'invalid':
      return _$adminSalonDetailDocumentsInnerStatusEnum_invalid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSalonDetailDocumentsInnerStatusEnum>
    _$adminSalonDetailDocumentsInnerStatusEnumValues = BuiltSet<
        AdminSalonDetailDocumentsInnerStatusEnum>(const <AdminSalonDetailDocumentsInnerStatusEnum>[
  _$adminSalonDetailDocumentsInnerStatusEnum_received,
  _$adminSalonDetailDocumentsInnerStatusEnum_missing,
  _$adminSalonDetailDocumentsInnerStatusEnum_invalid,
]);

Serializer<AdminSalonDetailDocumentsInnerStatusEnum>
    _$adminSalonDetailDocumentsInnerStatusEnumSerializer =
    _$AdminSalonDetailDocumentsInnerStatusEnumSerializer();

class _$AdminSalonDetailDocumentsInnerStatusEnumSerializer
    implements PrimitiveSerializer<AdminSalonDetailDocumentsInnerStatusEnum> {
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
    AdminSalonDetailDocumentsInnerStatusEnum
  ];
  @override
  final String wireName = 'AdminSalonDetailDocumentsInnerStatusEnum';

  @override
  Object serialize(Serializers serializers,
          AdminSalonDetailDocumentsInnerStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSalonDetailDocumentsInnerStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSalonDetailDocumentsInnerStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSalonDetailDocumentsInner extends AdminSalonDetailDocumentsInner {
  @override
  final String label;
  @override
  final AdminSalonDetailDocumentsInnerStatusEnum status;
  @override
  final String? note;
  @override
  final String? fileUrl;

  factory _$AdminSalonDetailDocumentsInner(
          [void Function(AdminSalonDetailDocumentsInnerBuilder)? updates]) =>
      (AdminSalonDetailDocumentsInnerBuilder()..update(updates))._build();

  _$AdminSalonDetailDocumentsInner._(
      {required this.label, required this.status, this.note, this.fileUrl})
      : super._();
  @override
  AdminSalonDetailDocumentsInner rebuild(
          void Function(AdminSalonDetailDocumentsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSalonDetailDocumentsInnerBuilder toBuilder() =>
      AdminSalonDetailDocumentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSalonDetailDocumentsInner &&
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
    return (newBuiltValueToStringHelper(r'AdminSalonDetailDocumentsInner')
          ..add('label', label)
          ..add('status', status)
          ..add('note', note)
          ..add('fileUrl', fileUrl))
        .toString();
  }
}

class AdminSalonDetailDocumentsInnerBuilder
    implements
        Builder<AdminSalonDetailDocumentsInner,
            AdminSalonDetailDocumentsInnerBuilder> {
  _$AdminSalonDetailDocumentsInner? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  AdminSalonDetailDocumentsInnerStatusEnum? _status;
  AdminSalonDetailDocumentsInnerStatusEnum? get status => _$this._status;
  set status(AdminSalonDetailDocumentsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _fileUrl;
  String? get fileUrl => _$this._fileUrl;
  set fileUrl(String? fileUrl) => _$this._fileUrl = fileUrl;

  AdminSalonDetailDocumentsInnerBuilder() {
    AdminSalonDetailDocumentsInner._defaults(this);
  }

  AdminSalonDetailDocumentsInnerBuilder get _$this {
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
  void replace(AdminSalonDetailDocumentsInner other) {
    _$v = other as _$AdminSalonDetailDocumentsInner;
  }

  @override
  void update(void Function(AdminSalonDetailDocumentsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSalonDetailDocumentsInner build() => _build();

  _$AdminSalonDetailDocumentsInner _build() {
    final _$result = _$v ??
        _$AdminSalonDetailDocumentsInner._(
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'AdminSalonDetailDocumentsInner', 'label'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'AdminSalonDetailDocumentsInner', 'status'),
          note: note,
          fileUrl: fileUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
