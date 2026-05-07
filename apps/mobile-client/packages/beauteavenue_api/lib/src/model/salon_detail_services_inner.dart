//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'salon_detail_services_inner.g.dart';

/// SalonDetailServicesInner
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [category] 
/// * [durationMinutes] 
/// * [priceXof] 
/// * [depositRequiredXof] 
@BuiltValue()
abstract class SalonDetailServicesInner implements Built<SalonDetailServicesInner, SalonDetailServicesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'durationMinutes')
  int get durationMinutes;

  @BuiltValueField(wireName: r'priceXof')
  num get priceXof;

  @BuiltValueField(wireName: r'depositRequiredXof')
  num? get depositRequiredXof;

  SalonDetailServicesInner._();

  factory SalonDetailServicesInner([void updates(SalonDetailServicesInnerBuilder b)]) = _$SalonDetailServicesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SalonDetailServicesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SalonDetailServicesInner> get serializer => _$SalonDetailServicesInnerSerializer();
}

class _$SalonDetailServicesInnerSerializer implements PrimitiveSerializer<SalonDetailServicesInner> {
  @override
  final Iterable<Type> types = const [SalonDetailServicesInner, _$SalonDetailServicesInner];

  @override
  final String wireName = r'SalonDetailServicesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SalonDetailServicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'durationMinutes';
    yield serializers.serialize(
      object.durationMinutes,
      specifiedType: const FullType(int),
    );
    yield r'priceXof';
    yield serializers.serialize(
      object.priceXof,
      specifiedType: const FullType(num),
    );
    yield r'depositRequiredXof';
    yield object.depositRequiredXof == null ? null : serializers.serialize(
      object.depositRequiredXof,
      specifiedType: const FullType.nullable(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SalonDetailServicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SalonDetailServicesInnerBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'durationMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationMinutes = valueDes;
          break;
        case r'priceXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.priceXof = valueDes;
          break;
        case r'depositRequiredXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.depositRequiredXof = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SalonDetailServicesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SalonDetailServicesInnerBuilder();
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

