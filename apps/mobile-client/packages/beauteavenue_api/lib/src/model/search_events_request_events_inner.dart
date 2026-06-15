//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_events_request_events_inner.g.dart';

/// SearchEventsRequestEventsInner
///
/// Properties:
/// * [sessionKey] 
/// * [eventType] 
/// * [query] 
/// * [salonId] 
/// * [category] 
/// * [city] 
/// * [position] 
/// * [metadata] 
@BuiltValue()
abstract class SearchEventsRequestEventsInner implements Built<SearchEventsRequestEventsInner, SearchEventsRequestEventsInnerBuilder> {
  @BuiltValueField(wireName: r'sessionKey')
  String get sessionKey;

  @BuiltValueField(wireName: r'eventType')
  SearchEventsRequestEventsInnerEventTypeEnum get eventType;
  // enum eventTypeEnum {  search_submitted,  suggestion_tapped,  filter_applied,  result_opened,  module_item_opened,  };

  @BuiltValueField(wireName: r'query')
  String? get query;

  @BuiltValueField(wireName: r'salonId')
  String? get salonId;

  @BuiltValueField(wireName: r'category')
  String? get category;

  @BuiltValueField(wireName: r'city')
  String? get city;

  @BuiltValueField(wireName: r'position')
  int? get position;

  @BuiltValueField(wireName: r'metadata')
  BuiltMap<String, JsonObject?>? get metadata;

  SearchEventsRequestEventsInner._();

  factory SearchEventsRequestEventsInner([void updates(SearchEventsRequestEventsInnerBuilder b)]) = _$SearchEventsRequestEventsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchEventsRequestEventsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchEventsRequestEventsInner> get serializer => _$SearchEventsRequestEventsInnerSerializer();
}

class _$SearchEventsRequestEventsInnerSerializer implements PrimitiveSerializer<SearchEventsRequestEventsInner> {
  @override
  final Iterable<Type> types = const [SearchEventsRequestEventsInner, _$SearchEventsRequestEventsInner];

  @override
  final String wireName = r'SearchEventsRequestEventsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchEventsRequestEventsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sessionKey';
    yield serializers.serialize(
      object.sessionKey,
      specifiedType: const FullType(String),
    );
    yield r'eventType';
    yield serializers.serialize(
      object.eventType,
      specifiedType: const FullType(SearchEventsRequestEventsInnerEventTypeEnum),
    );
    if (object.query != null) {
      yield r'query';
      yield serializers.serialize(
        object.query,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.salonId != null) {
      yield r'salonId';
      yield serializers.serialize(
        object.salonId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.category != null) {
      yield r'category';
      yield serializers.serialize(
        object.category,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.city != null) {
      yield r'city';
      yield serializers.serialize(
        object.city,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.position != null) {
      yield r'position';
      yield serializers.serialize(
        object.position,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.metadata != null) {
      yield r'metadata';
      yield serializers.serialize(
        object.metadata,
        specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchEventsRequestEventsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchEventsRequestEventsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sessionKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sessionKey = valueDes;
          break;
        case r'eventType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SearchEventsRequestEventsInnerEventTypeEnum),
          ) as SearchEventsRequestEventsInnerEventTypeEnum;
          result.eventType = valueDes;
          break;
        case r'query':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.query = valueDes;
          break;
        case r'salonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.salonId = valueDes;
          break;
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.category = valueDes;
          break;
        case r'city':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.city = valueDes;
          break;
        case r'position':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.position = valueDes;
          break;
        case r'metadata':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.metadata.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchEventsRequestEventsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchEventsRequestEventsInnerBuilder();
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

class SearchEventsRequestEventsInnerEventTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'search_submitted')
  static const SearchEventsRequestEventsInnerEventTypeEnum searchSubmitted = _$searchEventsRequestEventsInnerEventTypeEnum_searchSubmitted;
  @BuiltValueEnumConst(wireName: r'suggestion_tapped')
  static const SearchEventsRequestEventsInnerEventTypeEnum suggestionTapped = _$searchEventsRequestEventsInnerEventTypeEnum_suggestionTapped;
  @BuiltValueEnumConst(wireName: r'filter_applied')
  static const SearchEventsRequestEventsInnerEventTypeEnum filterApplied = _$searchEventsRequestEventsInnerEventTypeEnum_filterApplied;
  @BuiltValueEnumConst(wireName: r'result_opened')
  static const SearchEventsRequestEventsInnerEventTypeEnum resultOpened = _$searchEventsRequestEventsInnerEventTypeEnum_resultOpened;
  @BuiltValueEnumConst(wireName: r'module_item_opened')
  static const SearchEventsRequestEventsInnerEventTypeEnum moduleItemOpened = _$searchEventsRequestEventsInnerEventTypeEnum_moduleItemOpened;

  static Serializer<SearchEventsRequestEventsInnerEventTypeEnum> get serializer => _$searchEventsRequestEventsInnerEventTypeEnumSerializer;

  const SearchEventsRequestEventsInnerEventTypeEnum._(String name): super(name);

  static BuiltSet<SearchEventsRequestEventsInnerEventTypeEnum> get values => _$searchEventsRequestEventsInnerEventTypeEnumValues;
  static SearchEventsRequestEventsInnerEventTypeEnum valueOf(String name) => _$searchEventsRequestEventsInnerEventTypeEnumValueOf(name);
}

