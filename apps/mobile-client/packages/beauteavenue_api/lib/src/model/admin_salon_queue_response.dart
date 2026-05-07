//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/admin_salon_queue_response_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_salon_queue_response.g.dart';

/// AdminSalonQueueResponse
///
/// Properties:
/// * [items] 
/// * [total] 
@BuiltValue()
abstract class AdminSalonQueueResponse implements Built<AdminSalonQueueResponse, AdminSalonQueueResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminSalonQueueResponseItemsInner> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  AdminSalonQueueResponse._();

  factory AdminSalonQueueResponse([void updates(AdminSalonQueueResponseBuilder b)]) = _$AdminSalonQueueResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSalonQueueResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSalonQueueResponse> get serializer => _$AdminSalonQueueResponseSerializer();
}

class _$AdminSalonQueueResponseSerializer implements PrimitiveSerializer<AdminSalonQueueResponse> {
  @override
  final Iterable<Type> types = const [AdminSalonQueueResponse, _$AdminSalonQueueResponse];

  @override
  final String wireName = r'AdminSalonQueueResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSalonQueueResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminSalonQueueResponseItemsInner)]),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSalonQueueResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSalonQueueResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminSalonQueueResponseItemsInner)]),
          ) as BuiltList<AdminSalonQueueResponseItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSalonQueueResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSalonQueueResponseBuilder();
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

