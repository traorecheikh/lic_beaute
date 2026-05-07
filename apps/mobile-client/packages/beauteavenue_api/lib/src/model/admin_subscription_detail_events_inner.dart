//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_subscription_detail_events_inner.g.dart';

/// AdminSubscriptionDetailEventsInner
///
/// Properties:
/// * [id] 
/// * [eventType] 
/// * [summary] 
/// * [createdAt] 
/// * [actorName] 
/// * [source_] 
/// * [payloadPreview] 
@BuiltValue()
abstract class AdminSubscriptionDetailEventsInner implements Built<AdminSubscriptionDetailEventsInner, AdminSubscriptionDetailEventsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'eventType')
  String get eventType;

  @BuiltValueField(wireName: r'summary')
  String get summary;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'actorName')
  String get actorName;

  @BuiltValueField(wireName: r'source')
  AdminSubscriptionDetailEventsInnerSource_Enum get source_;
  // enum source_Enum {  provider,  admin,  system,  };

  @BuiltValueField(wireName: r'payloadPreview')
  String? get payloadPreview;

  AdminSubscriptionDetailEventsInner._();

  factory AdminSubscriptionDetailEventsInner([void updates(AdminSubscriptionDetailEventsInnerBuilder b)]) = _$AdminSubscriptionDetailEventsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSubscriptionDetailEventsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSubscriptionDetailEventsInner> get serializer => _$AdminSubscriptionDetailEventsInnerSerializer();
}

class _$AdminSubscriptionDetailEventsInnerSerializer implements PrimitiveSerializer<AdminSubscriptionDetailEventsInner> {
  @override
  final Iterable<Type> types = const [AdminSubscriptionDetailEventsInner, _$AdminSubscriptionDetailEventsInner];

  @override
  final String wireName = r'AdminSubscriptionDetailEventsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSubscriptionDetailEventsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'eventType';
    yield serializers.serialize(
      object.eventType,
      specifiedType: const FullType(String),
    );
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'actorName';
    yield serializers.serialize(
      object.actorName,
      specifiedType: const FullType(String),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(AdminSubscriptionDetailEventsInnerSource_Enum),
    );
    yield r'payloadPreview';
    yield object.payloadPreview == null ? null : serializers.serialize(
      object.payloadPreview,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSubscriptionDetailEventsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSubscriptionDetailEventsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'eventType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.eventType = valueDes;
          break;
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.summary = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'actorName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actorName = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSubscriptionDetailEventsInnerSource_Enum),
          ) as AdminSubscriptionDetailEventsInnerSource_Enum;
          result.source_ = valueDes;
          break;
        case r'payloadPreview':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.payloadPreview = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSubscriptionDetailEventsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSubscriptionDetailEventsInnerBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class AdminSubscriptionDetailEventsInnerSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'provider')
  static const AdminSubscriptionDetailEventsInnerSource_Enum provider = _$adminSubscriptionDetailEventsInnerSourceEnum_provider;
  @BuiltValueEnumConst(wireName: r'admin')
  static const AdminSubscriptionDetailEventsInnerSource_Enum admin = _$adminSubscriptionDetailEventsInnerSourceEnum_admin;
  @BuiltValueEnumConst(wireName: r'system')
  static const AdminSubscriptionDetailEventsInnerSource_Enum system = _$adminSubscriptionDetailEventsInnerSourceEnum_system;

  static Serializer<AdminSubscriptionDetailEventsInnerSource_Enum> get serializer => _$adminSubscriptionDetailEventsInnerSourceEnumSerializer;

  const AdminSubscriptionDetailEventsInnerSource_Enum._(String name): super(name);

  static BuiltSet<AdminSubscriptionDetailEventsInnerSource_Enum> get values => _$adminSubscriptionDetailEventsInnerSourceEnumValues;
  static AdminSubscriptionDetailEventsInnerSource_Enum valueOf(String name) => _$adminSubscriptionDetailEventsInnerSourceEnumValueOf(name);
}

