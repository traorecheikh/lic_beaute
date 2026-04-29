//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/salon_summary_list_response_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'salon_summary_list_response.g.dart';

/// SalonSummaryListResponse
///
/// Properties:
/// * [items] 
/// * [total] 
@BuiltValue()
abstract class SalonSummaryListResponse implements Built<SalonSummaryListResponse, SalonSummaryListResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<SalonSummaryListResponseItemsInner> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  SalonSummaryListResponse._();

  factory SalonSummaryListResponse([void updates(SalonSummaryListResponseBuilder b)]) = _$SalonSummaryListResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SalonSummaryListResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SalonSummaryListResponse> get serializer => _$SalonSummaryListResponseSerializer();
}

class _$SalonSummaryListResponseSerializer implements PrimitiveSerializer<SalonSummaryListResponse> {
  @override
  final Iterable<Type> types = const [SalonSummaryListResponse, _$SalonSummaryListResponse];

  @override
  final String wireName = r'SalonSummaryListResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SalonSummaryListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(SalonSummaryListResponseItemsInner)]),
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
    SalonSummaryListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SalonSummaryListResponseBuilder result,
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
  SalonSummaryListResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SalonSummaryListResponseBuilder();
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

