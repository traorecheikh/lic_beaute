//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:beauteavenue_api/src/model/admin_subscription_list_response_summary.dart';
import 'package:beauteavenue_api/src/model/admin_subscription_list_response_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_subscription_list_response.g.dart';

/// AdminSubscriptionListResponse
///
/// Properties:
/// * [summary] 
/// * [items] 
/// * [total] 
@BuiltValue()
abstract class AdminSubscriptionListResponse implements Built<AdminSubscriptionListResponse, AdminSubscriptionListResponseBuilder> {
  @BuiltValueField(wireName: r'summary')
  AdminSubscriptionListResponseSummary get summary;

  @BuiltValueField(wireName: r'items')
  BuiltList<AdminSubscriptionListResponseItemsInner> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  AdminSubscriptionListResponse._();

  factory AdminSubscriptionListResponse([void updates(AdminSubscriptionListResponseBuilder b)]) = _$AdminSubscriptionListResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSubscriptionListResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSubscriptionListResponse> get serializer => _$AdminSubscriptionListResponseSerializer();
}

class _$AdminSubscriptionListResponseSerializer implements PrimitiveSerializer<AdminSubscriptionListResponse> {
  @override
  final Iterable<Type> types = const [AdminSubscriptionListResponse, _$AdminSubscriptionListResponse];

  @override
  final String wireName = r'AdminSubscriptionListResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSubscriptionListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(AdminSubscriptionListResponseSummary),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminSubscriptionListResponseItemsInner)]),
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
    AdminSubscriptionListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSubscriptionListResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSubscriptionListResponseSummary),
          ) as AdminSubscriptionListResponseSummary;
          result.summary.replace(valueDes);
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminSubscriptionListResponseItemsInner)]),
          ) as BuiltList<AdminSubscriptionListResponseItemsInner>;
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
  AdminSubscriptionListResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSubscriptionListResponseBuilder();
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

