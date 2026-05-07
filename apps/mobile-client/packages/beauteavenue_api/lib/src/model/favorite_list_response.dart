//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/salon_summary_list_response_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'favorite_list_response.g.dart';

/// FavoriteListResponse
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class FavoriteListResponse implements Built<FavoriteListResponse, FavoriteListResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<SalonSummaryListResponseItemsInner> get items;

  FavoriteListResponse._();

  factory FavoriteListResponse([void updates(FavoriteListResponseBuilder b)]) = _$FavoriteListResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FavoriteListResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FavoriteListResponse> get serializer => _$FavoriteListResponseSerializer();
}

class _$FavoriteListResponseSerializer implements PrimitiveSerializer<FavoriteListResponse> {
  @override
  final Iterable<Type> types = const [FavoriteListResponse, _$FavoriteListResponse];

  @override
  final String wireName = r'FavoriteListResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FavoriteListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(SalonSummaryListResponseItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FavoriteListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FavoriteListResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SalonSummaryListResponseItemsInner)]),
          ) as BuiltList<SalonSummaryListResponseItemsInner>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FavoriteListResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FavoriteListResponseBuilder();
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

