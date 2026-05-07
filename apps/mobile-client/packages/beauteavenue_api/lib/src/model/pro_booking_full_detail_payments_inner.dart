//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_booking_full_detail_payments_inner.g.dart';

/// ProBookingFullDetailPaymentsInner
///
/// Properties:
/// * [id] 
/// * [status] 
/// * [amountXof] 
/// * [provider] 
@BuiltValue()
abstract class ProBookingFullDetailPaymentsInner implements Built<ProBookingFullDetailPaymentsInner, ProBookingFullDetailPaymentsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'amountXof')
  int get amountXof;

  @BuiltValueField(wireName: r'provider')
  String get provider;

  ProBookingFullDetailPaymentsInner._();

  factory ProBookingFullDetailPaymentsInner([void updates(ProBookingFullDetailPaymentsInnerBuilder b)]) = _$ProBookingFullDetailPaymentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProBookingFullDetailPaymentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProBookingFullDetailPaymentsInner> get serializer => _$ProBookingFullDetailPaymentsInnerSerializer();
}

class _$ProBookingFullDetailPaymentsInnerSerializer implements PrimitiveSerializer<ProBookingFullDetailPaymentsInner> {
  @override
  final Iterable<Type> types = const [ProBookingFullDetailPaymentsInner, _$ProBookingFullDetailPaymentsInner];

  @override
  final String wireName = r'ProBookingFullDetailPaymentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProBookingFullDetailPaymentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'amountXof';
    yield serializers.serialize(
      object.amountXof,
      specifiedType: const FullType(int),
    );
    yield r'provider';
    yield serializers.serialize(
      object.provider,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProBookingFullDetailPaymentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProBookingFullDetailPaymentsInnerBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'amountXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountXof = valueDes;
          break;
        case r'provider':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provider = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProBookingFullDetailPaymentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProBookingFullDetailPaymentsInnerBuilder();
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

