//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_voucher_create_input.g.dart';

/// ProVoucherCreateInput
///
/// Properties:
/// * [code] 
/// * [title] 
/// * [description] 
/// * [discountLabel] 
/// * [expiresAt] 
/// * [maxRedemptions] 
@BuiltValue()
abstract class ProVoucherCreateInput implements Built<ProVoucherCreateInput, ProVoucherCreateInputBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'discountLabel')
  String get discountLabel;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime? get expiresAt;

  @BuiltValueField(wireName: r'maxRedemptions')
  int? get maxRedemptions;

  ProVoucherCreateInput._();

  factory ProVoucherCreateInput([void updates(ProVoucherCreateInputBuilder b)]) = _$ProVoucherCreateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProVoucherCreateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProVoucherCreateInput> get serializer => _$ProVoucherCreateInputSerializer();
}

class _$ProVoucherCreateInputSerializer implements PrimitiveSerializer<ProVoucherCreateInput> {
  @override
  final Iterable<Type> types = const [ProVoucherCreateInput, _$ProVoucherCreateInput];

  @override
  final String wireName = r'ProVoucherCreateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProVoucherCreateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'discountLabel';
    yield serializers.serialize(
      object.discountLabel,
      specifiedType: const FullType(String),
    );
    if (object.expiresAt != null) {
      yield r'expiresAt';
      yield serializers.serialize(
        object.expiresAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.maxRedemptions != null) {
      yield r'maxRedemptions';
      yield serializers.serialize(
        object.maxRedemptions,
        specifiedType: const FullType.nullable(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProVoucherCreateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProVoucherCreateInputBuilder result,
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
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'discountLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.discountLabel = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'maxRedemptions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.maxRedemptions = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProVoucherCreateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProVoucherCreateInputBuilder();
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

