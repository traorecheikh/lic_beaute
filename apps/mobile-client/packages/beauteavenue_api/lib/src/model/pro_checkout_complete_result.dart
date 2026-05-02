//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_checkout_complete_result.g.dart';

/// ProCheckoutCompleteResult
///
/// Properties:
/// * [completed]
/// * [bookingId]
/// * [status]
/// * [chargedXof]
@BuiltValue()
abstract class ProCheckoutCompleteResult
    implements
        Built<ProCheckoutCompleteResult, ProCheckoutCompleteResultBuilder> {
  @BuiltValueField(wireName: r'completed')
  bool get completed;

  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'status')
  ProCheckoutCompleteResultStatusEnum get status;
  // enum statusEnum {  pending,  confirmed,  in_progress,  completed,  cancelled,  };

  @BuiltValueField(wireName: r'chargedXof')
  int get chargedXof;

  ProCheckoutCompleteResult._();

  factory ProCheckoutCompleteResult(
          [void updates(ProCheckoutCompleteResultBuilder b)]) =
      _$ProCheckoutCompleteResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProCheckoutCompleteResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProCheckoutCompleteResult> get serializer =>
      _$ProCheckoutCompleteResultSerializer();
}

class _$ProCheckoutCompleteResultSerializer
    implements PrimitiveSerializer<ProCheckoutCompleteResult> {
  @override
  final Iterable<Type> types = const [
    ProCheckoutCompleteResult,
    _$ProCheckoutCompleteResult
  ];

  @override
  final String wireName = r'ProCheckoutCompleteResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProCheckoutCompleteResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'completed';
    yield serializers.serialize(
      object.completed,
      specifiedType: const FullType(bool),
    );
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ProCheckoutCompleteResultStatusEnum),
    );
    yield r'chargedXof';
    yield serializers.serialize(
      object.chargedXof,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProCheckoutCompleteResult object, {
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
    required ProCheckoutCompleteResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'completed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.completed = valueDes;
          break;
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProCheckoutCompleteResultStatusEnum),
          ) as ProCheckoutCompleteResultStatusEnum;
          result.status = valueDes;
          break;
        case r'chargedXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.chargedXof = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProCheckoutCompleteResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProCheckoutCompleteResultBuilder();
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

class ProCheckoutCompleteResultStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const ProCheckoutCompleteResultStatusEnum pending =
      _$proCheckoutCompleteResultStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const ProCheckoutCompleteResultStatusEnum confirmed =
      _$proCheckoutCompleteResultStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const ProCheckoutCompleteResultStatusEnum inProgress =
      _$proCheckoutCompleteResultStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'completed')
  static const ProCheckoutCompleteResultStatusEnum completed =
      _$proCheckoutCompleteResultStatusEnum_completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const ProCheckoutCompleteResultStatusEnum cancelled =
      _$proCheckoutCompleteResultStatusEnum_cancelled;

  static Serializer<ProCheckoutCompleteResultStatusEnum> get serializer =>
      _$proCheckoutCompleteResultStatusEnumSerializer;

  const ProCheckoutCompleteResultStatusEnum._(String name) : super(name);

  static BuiltSet<ProCheckoutCompleteResultStatusEnum> get values =>
      _$proCheckoutCompleteResultStatusEnumValues;
  static ProCheckoutCompleteResultStatusEnum valueOf(String name) =>
      _$proCheckoutCompleteResultStatusEnumValueOf(name);
}
