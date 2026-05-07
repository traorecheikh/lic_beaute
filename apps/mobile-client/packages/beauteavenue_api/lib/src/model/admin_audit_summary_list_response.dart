//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/admin_audit_summary_list_response_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_audit_summary_list_response.g.dart';

/// AdminAuditSummaryListResponse
///
/// Properties:
/// * [items] 
/// * [total] 
@BuiltValue()
abstract class AdminAuditSummaryListResponse implements Built<AdminAuditSummaryListResponse, AdminAuditSummaryListResponseBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<AdminAuditSummaryListResponseItemsInner> get items;

  @BuiltValueField(wireName: r'total')
  int get total;

  AdminAuditSummaryListResponse._();

  factory AdminAuditSummaryListResponse([void updates(AdminAuditSummaryListResponseBuilder b)]) = _$AdminAuditSummaryListResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAuditSummaryListResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAuditSummaryListResponse> get serializer => _$AdminAuditSummaryListResponseSerializer();
}

class _$AdminAuditSummaryListResponseSerializer implements PrimitiveSerializer<AdminAuditSummaryListResponse> {
  @override
  final Iterable<Type> types = const [AdminAuditSummaryListResponse, _$AdminAuditSummaryListResponse];

  @override
  final String wireName = r'AdminAuditSummaryListResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAuditSummaryListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(AdminAuditSummaryListResponseItemsInner)]),
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
    AdminAuditSummaryListResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminAuditSummaryListResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminAuditSummaryListResponseItemsInner)]),
          ) as BuiltList<AdminAuditSummaryListResponseItemsInner>;
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
  AdminAuditSummaryListResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAuditSummaryListResponseBuilder();
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

