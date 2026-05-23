//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_subscription_override_input_metadata.g.dart';

/// AdminSubscriptionOverrideInputMetadata
///
/// Properties:
/// * [internalTicket] 
/// * [subscriptionChargeId] 
/// * [providerReference] 
@BuiltValue()
abstract class AdminSubscriptionOverrideInputMetadata implements Built<AdminSubscriptionOverrideInputMetadata, AdminSubscriptionOverrideInputMetadataBuilder> {
  @BuiltValueField(wireName: r'internalTicket')
  String? get internalTicket;

  @BuiltValueField(wireName: r'subscriptionChargeId')
  String? get subscriptionChargeId;

  @BuiltValueField(wireName: r'providerReference')
  String? get providerReference;

  AdminSubscriptionOverrideInputMetadata._();

  factory AdminSubscriptionOverrideInputMetadata([void updates(AdminSubscriptionOverrideInputMetadataBuilder b)]) = _$AdminSubscriptionOverrideInputMetadata;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSubscriptionOverrideInputMetadataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSubscriptionOverrideInputMetadata> get serializer => _$AdminSubscriptionOverrideInputMetadataSerializer();
}

class _$AdminSubscriptionOverrideInputMetadataSerializer implements PrimitiveSerializer<AdminSubscriptionOverrideInputMetadata> {
  @override
  final Iterable<Type> types = const [AdminSubscriptionOverrideInputMetadata, _$AdminSubscriptionOverrideInputMetadata];

  @override
  final String wireName = r'AdminSubscriptionOverrideInputMetadata';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSubscriptionOverrideInputMetadata object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.internalTicket != null) {
      yield r'internalTicket';
      yield serializers.serialize(
        object.internalTicket,
        specifiedType: const FullType(String),
      );
    }
    if (object.subscriptionChargeId != null) {
      yield r'subscriptionChargeId';
      yield serializers.serialize(
        object.subscriptionChargeId,
        specifiedType: const FullType(String),
      );
    }
    if (object.providerReference != null) {
      yield r'providerReference';
      yield serializers.serialize(
        object.providerReference,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSubscriptionOverrideInputMetadata object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSubscriptionOverrideInputMetadataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'internalTicket':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.internalTicket = valueDes;
          break;
        case r'subscriptionChargeId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.subscriptionChargeId = valueDes;
          break;
        case r'providerReference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.providerReference = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSubscriptionOverrideInputMetadata deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSubscriptionOverrideInputMetadataBuilder();
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

