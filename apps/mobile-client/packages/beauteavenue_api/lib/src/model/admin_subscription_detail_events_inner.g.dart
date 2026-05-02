// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_subscription_detail_events_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSubscriptionDetailEventsInnerSource_Enum
    _$adminSubscriptionDetailEventsInnerSourceEnum_provider =
    const AdminSubscriptionDetailEventsInnerSource_Enum._('provider');
const AdminSubscriptionDetailEventsInnerSource_Enum
    _$adminSubscriptionDetailEventsInnerSourceEnum_admin =
    const AdminSubscriptionDetailEventsInnerSource_Enum._('admin');
const AdminSubscriptionDetailEventsInnerSource_Enum
    _$adminSubscriptionDetailEventsInnerSourceEnum_system =
    const AdminSubscriptionDetailEventsInnerSource_Enum._('system');

AdminSubscriptionDetailEventsInnerSource_Enum
    _$adminSubscriptionDetailEventsInnerSourceEnumValueOf(String name) {
  switch (name) {
    case 'provider':
      return _$adminSubscriptionDetailEventsInnerSourceEnum_provider;
    case 'admin':
      return _$adminSubscriptionDetailEventsInnerSourceEnum_admin;
    case 'system':
      return _$adminSubscriptionDetailEventsInnerSourceEnum_system;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSubscriptionDetailEventsInnerSource_Enum>
    _$adminSubscriptionDetailEventsInnerSourceEnumValues = BuiltSet<
        AdminSubscriptionDetailEventsInnerSource_Enum>(const <AdminSubscriptionDetailEventsInnerSource_Enum>[
  _$adminSubscriptionDetailEventsInnerSourceEnum_provider,
  _$adminSubscriptionDetailEventsInnerSourceEnum_admin,
  _$adminSubscriptionDetailEventsInnerSourceEnum_system,
]);

Serializer<AdminSubscriptionDetailEventsInnerSource_Enum>
    _$adminSubscriptionDetailEventsInnerSourceEnumSerializer =
    _$AdminSubscriptionDetailEventsInnerSource_EnumSerializer();

class _$AdminSubscriptionDetailEventsInnerSource_EnumSerializer
    implements
        PrimitiveSerializer<AdminSubscriptionDetailEventsInnerSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'provider': 'provider',
    'admin': 'admin',
    'system': 'system',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'provider': 'provider',
    'admin': 'admin',
    'system': 'system',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSubscriptionDetailEventsInnerSource_Enum
  ];
  @override
  final String wireName = 'AdminSubscriptionDetailEventsInnerSource_Enum';

  @override
  Object serialize(Serializers serializers,
          AdminSubscriptionDetailEventsInnerSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AdminSubscriptionDetailEventsInnerSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AdminSubscriptionDetailEventsInnerSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AdminSubscriptionDetailEventsInner
    extends AdminSubscriptionDetailEventsInner {
  @override
  final String id;
  @override
  final String eventType;
  @override
  final String summary;
  @override
  final DateTime createdAt;
  @override
  final String actorName;
  @override
  final AdminSubscriptionDetailEventsInnerSource_Enum source_;
  @override
  final String? payloadPreview;

  factory _$AdminSubscriptionDetailEventsInner(
          [void Function(AdminSubscriptionDetailEventsInnerBuilder)?
              updates]) =>
      (AdminSubscriptionDetailEventsInnerBuilder()..update(updates))._build();

  _$AdminSubscriptionDetailEventsInner._(
      {required this.id,
      required this.eventType,
      required this.summary,
      required this.createdAt,
      required this.actorName,
      required this.source_,
      this.payloadPreview})
      : super._();
  @override
  AdminSubscriptionDetailEventsInner rebuild(
          void Function(AdminSubscriptionDetailEventsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSubscriptionDetailEventsInnerBuilder toBuilder() =>
      AdminSubscriptionDetailEventsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSubscriptionDetailEventsInner &&
        id == other.id &&
        eventType == other.eventType &&
        summary == other.summary &&
        createdAt == other.createdAt &&
        actorName == other.actorName &&
        source_ == other.source_ &&
        payloadPreview == other.payloadPreview;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, eventType.hashCode);
    _$hash = $jc(_$hash, summary.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, payloadPreview.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSubscriptionDetailEventsInner')
          ..add('id', id)
          ..add('eventType', eventType)
          ..add('summary', summary)
          ..add('createdAt', createdAt)
          ..add('actorName', actorName)
          ..add('source_', source_)
          ..add('payloadPreview', payloadPreview))
        .toString();
  }
}

class AdminSubscriptionDetailEventsInnerBuilder
    implements
        Builder<AdminSubscriptionDetailEventsInner,
            AdminSubscriptionDetailEventsInnerBuilder> {
  _$AdminSubscriptionDetailEventsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _eventType;
  String? get eventType => _$this._eventType;
  set eventType(String? eventType) => _$this._eventType = eventType;

  String? _summary;
  String? get summary => _$this._summary;
  set summary(String? summary) => _$this._summary = summary;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  AdminSubscriptionDetailEventsInnerSource_Enum? _source_;
  AdminSubscriptionDetailEventsInnerSource_Enum? get source_ => _$this._source_;
  set source_(AdminSubscriptionDetailEventsInnerSource_Enum? source_) =>
      _$this._source_ = source_;

  String? _payloadPreview;
  String? get payloadPreview => _$this._payloadPreview;
  set payloadPreview(String? payloadPreview) =>
      _$this._payloadPreview = payloadPreview;

  AdminSubscriptionDetailEventsInnerBuilder() {
    AdminSubscriptionDetailEventsInner._defaults(this);
  }

  AdminSubscriptionDetailEventsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _eventType = $v.eventType;
      _summary = $v.summary;
      _createdAt = $v.createdAt;
      _actorName = $v.actorName;
      _source_ = $v.source_;
      _payloadPreview = $v.payloadPreview;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSubscriptionDetailEventsInner other) {
    _$v = other as _$AdminSubscriptionDetailEventsInner;
  }

  @override
  void update(
      void Function(AdminSubscriptionDetailEventsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSubscriptionDetailEventsInner build() => _build();

  _$AdminSubscriptionDetailEventsInner _build() {
    final _$result = _$v ??
        _$AdminSubscriptionDetailEventsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'AdminSubscriptionDetailEventsInner', 'id'),
          eventType: BuiltValueNullFieldError.checkNotNull(
              eventType, r'AdminSubscriptionDetailEventsInner', 'eventType'),
          summary: BuiltValueNullFieldError.checkNotNull(
              summary, r'AdminSubscriptionDetailEventsInner', 'summary'),
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'AdminSubscriptionDetailEventsInner', 'createdAt'),
          actorName: BuiltValueNullFieldError.checkNotNull(
              actorName, r'AdminSubscriptionDetailEventsInner', 'actorName'),
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'AdminSubscriptionDetailEventsInner', 'source_'),
          payloadPreview: payloadPreview,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
