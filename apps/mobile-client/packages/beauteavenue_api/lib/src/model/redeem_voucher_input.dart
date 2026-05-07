//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'redeem_voucher_input.g.dart';

/// RedeemVoucherInput
///
/// Properties:
/// * [code] 
@BuiltValue()
abstract class RedeemVoucherInput implements Built<RedeemVoucherInput, RedeemVoucherInputBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  RedeemVoucherInput._();

  factory RedeemVoucherInput([void updates(RedeemVoucherInputBuilder b)]) = _$RedeemVoucherInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RedeemVoucherInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RedeemVoucherInput> get serializer => _$RedeemVoucherInputSerializer();
}

class _$RedeemVoucherInputSerializer implements PrimitiveSerializer<RedeemVoucherInput> {
  @override
  final Iterable<Type> types = const [RedeemVoucherInput, _$RedeemVoucherInput];

  @override
  final String wireName = r'RedeemVoucherInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RedeemVoucherInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RedeemVoucherInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RedeemVoucherInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RedeemVoucherInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RedeemVoucherInputBuilder();
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

