//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_subscription_detail_entitlements_inner.g.dart';

/// AdminSubscriptionDetailEntitlementsInner
///
/// Properties:
/// * [label]
/// * [enabled]
/// * [note]
@BuiltValue()
abstract class AdminSubscriptionDetailEntitlementsInner
    implements
        Built<AdminSubscriptionDetailEntitlementsInner,
            AdminSubscriptionDetailEntitlementsInnerBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'note')
  String? get note;

  AdminSubscriptionDetailEntitlementsInner._();

  factory AdminSubscriptionDetailEntitlementsInner(
          [void updates(AdminSubscriptionDetailEntitlementsInnerBuilder b)]) =
      _$AdminSubscriptionDetailEntitlementsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSubscriptionDetailEntitlementsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSubscriptionDetailEntitlementsInner> get serializer =>
      _$AdminSubscriptionDetailEntitlementsInnerSerializer();
}

class _$AdminSubscriptionDetailEntitlementsInnerSerializer
    implements PrimitiveSerializer<AdminSubscriptionDetailEntitlementsInner> {
  @override
  final Iterable<Type> types = const [
    AdminSubscriptionDetailEntitlementsInner,
    _$AdminSubscriptionDetailEntitlementsInner
  ];

  @override
  final String wireName = r'AdminSubscriptionDetailEntitlementsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSubscriptionDetailEntitlementsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSubscriptionDetailEntitlementsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSubscriptionDetailEntitlementsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSubscriptionDetailEntitlementsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSubscriptionDetailEntitlementsInnerBuilder();
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
