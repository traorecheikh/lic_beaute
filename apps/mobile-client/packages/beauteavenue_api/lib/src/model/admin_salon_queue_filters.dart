//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_salon_queue_filters.g.dart';

/// AdminSalonQueueFilters
///
/// Properties:
/// * [search] 
/// * [category] 
/// * [city] 
/// * [status] 
@BuiltValue()
abstract class AdminSalonQueueFilters implements Built<AdminSalonQueueFilters, AdminSalonQueueFiltersBuilder> {
  @BuiltValueField(wireName: r'search')
  String? get search;

  @BuiltValueField(wireName: r'category')
  String? get category;

  @BuiltValueField(wireName: r'city')
  String? get city;

  @BuiltValueField(wireName: r'status')
  AdminSalonQueueFiltersStatusEnum? get status;
  // enum statusEnum {  pending_review,  needs_info,  approved,  rejected,  };

  AdminSalonQueueFilters._();

  factory AdminSalonQueueFilters([void updates(AdminSalonQueueFiltersBuilder b)]) = _$AdminSalonQueueFilters;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSalonQueueFiltersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSalonQueueFilters> get serializer => _$AdminSalonQueueFiltersSerializer();
}

class _$AdminSalonQueueFiltersSerializer implements PrimitiveSerializer<AdminSalonQueueFilters> {
  @override
  final Iterable<Type> types = const [AdminSalonQueueFilters, _$AdminSalonQueueFilters];

  @override
  final String wireName = r'AdminSalonQueueFilters';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSalonQueueFilters object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.search != null) {
      yield r'search';
      yield serializers.serialize(
        object.search,
        specifiedType: const FullType(String),
      );
    }
    if (object.category != null) {
      yield r'category';
      yield serializers.serialize(
        object.category,
        specifiedType: const FullType(String),
      );
    }
    if (object.city != null) {
      yield r'city';
      yield serializers.serialize(
        object.city,
        specifiedType: const FullType(String),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(AdminSalonQueueFiltersStatusEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSalonQueueFilters object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSalonQueueFiltersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'search':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.search = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.city = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSalonQueueFiltersStatusEnum),
          ) as AdminSalonQueueFiltersStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSalonQueueFilters deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSalonQueueFiltersBuilder();
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

class AdminSalonQueueFiltersStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending_review')
  static const AdminSalonQueueFiltersStatusEnum pendingReview = _$adminSalonQueueFiltersStatusEnum_pendingReview;
  @BuiltValueEnumConst(wireName: r'needs_info')
  static const AdminSalonQueueFiltersStatusEnum needsInfo = _$adminSalonQueueFiltersStatusEnum_needsInfo;
  @BuiltValueEnumConst(wireName: r'approved')
  static const AdminSalonQueueFiltersStatusEnum approved = _$adminSalonQueueFiltersStatusEnum_approved;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminSalonQueueFiltersStatusEnum rejected = _$adminSalonQueueFiltersStatusEnum_rejected;

  static Serializer<AdminSalonQueueFiltersStatusEnum> get serializer => _$adminSalonQueueFiltersStatusEnumSerializer;

  const AdminSalonQueueFiltersStatusEnum._(String name): super(name);

  static BuiltSet<AdminSalonQueueFiltersStatusEnum> get values => _$adminSalonQueueFiltersStatusEnumValues;
  static AdminSalonQueueFiltersStatusEnum valueOf(String name) => _$adminSalonQueueFiltersStatusEnumValueOf(name);
}

