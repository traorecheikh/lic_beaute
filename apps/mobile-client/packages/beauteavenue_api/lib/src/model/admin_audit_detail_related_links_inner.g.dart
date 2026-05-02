// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_detail_related_links_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAuditDetailRelatedLinksInner
    extends AdminAuditDetailRelatedLinksInner {
  @override
  final String label;
  @override
  final String href;

  factory _$AdminAuditDetailRelatedLinksInner(
          [void Function(AdminAuditDetailRelatedLinksInnerBuilder)? updates]) =>
      (AdminAuditDetailRelatedLinksInnerBuilder()..update(updates))._build();

  _$AdminAuditDetailRelatedLinksInner._(
      {required this.label, required this.href})
      : super._();
  @override
  AdminAuditDetailRelatedLinksInner rebuild(
          void Function(AdminAuditDetailRelatedLinksInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAuditDetailRelatedLinksInnerBuilder toBuilder() =>
      AdminAuditDetailRelatedLinksInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAuditDetailRelatedLinksInner &&
        label == other.label &&
        href == other.href;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, href.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminAuditDetailRelatedLinksInner')
          ..add('label', label)
          ..add('href', href))
        .toString();
  }
}

class AdminAuditDetailRelatedLinksInnerBuilder
    implements
        Builder<AdminAuditDetailRelatedLinksInner,
            AdminAuditDetailRelatedLinksInnerBuilder> {
  _$AdminAuditDetailRelatedLinksInner? _$v;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  String? _href;
  String? get href => _$this._href;
  set href(String? href) => _$this._href = href;

  AdminAuditDetailRelatedLinksInnerBuilder() {
    AdminAuditDetailRelatedLinksInner._defaults(this);
  }

  AdminAuditDetailRelatedLinksInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _label = $v.label;
      _href = $v.href;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAuditDetailRelatedLinksInner other) {
    _$v = other as _$AdminAuditDetailRelatedLinksInner;
  }

  @override
  void update(
      void Function(AdminAuditDetailRelatedLinksInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAuditDetailRelatedLinksInner build() => _build();

  _$AdminAuditDetailRelatedLinksInner _build() {
    final _$result = _$v ??
        _$AdminAuditDetailRelatedLinksInner._(
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'AdminAuditDetailRelatedLinksInner', 'label'),
          href: BuiltValueNullFieldError.checkNotNull(
              href, r'AdminAuditDetailRelatedLinksInner', 'href'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
