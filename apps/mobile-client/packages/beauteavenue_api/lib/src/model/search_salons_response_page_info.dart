//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_salons_response_page_info.g.dart';

/// SearchSalonsResponsePageInfo
///
/// Properties:
/// * [nextCursor] 
/// * [totalApprox] 
/// * [hasMore] 
@BuiltValue()
abstract class SearchSalonsResponsePageInfo implements Built<SearchSalonsResponsePageInfo, SearchSalonsResponsePageInfoBuilder> {
  @BuiltValueField(wireName: r'nextCursor')
  String? get nextCursor;

  @BuiltValueField(wireName: r'totalApprox')
  int get totalApprox;

  @BuiltValueField(wireName: r'hasMore')
  bool get hasMore;

  SearchSalonsResponsePageInfo._();

  factory SearchSalonsResponsePageInfo([void updates(SearchSalonsResponsePageInfoBuilder b)]) = _$SearchSalonsResponsePageInfo;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchSalonsResponsePageInfoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchSalonsResponsePageInfo> get serializer => _$SearchSalonsResponsePageInfoSerializer();
}

class _$SearchSalonsResponsePageInfoSerializer implements PrimitiveSerializer<SearchSalonsResponsePageInfo> {
  @override
  final Iterable<Type> types = const [SearchSalonsResponsePageInfo, _$SearchSalonsResponsePageInfo];

  @override
  final String wireName = r'SearchSalonsResponsePageInfo';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchSalonsResponsePageInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'nextCursor';
    yield object.nextCursor == null ? null : serializers.serialize(
      object.nextCursor,
      specifiedType: const FullType.nullable(String),
    );
    yield r'totalApprox';
    yield serializers.serialize(
      object.totalApprox,
      specifiedType: const FullType(int),
    );
    yield r'hasMore';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchSalonsResponsePageInfo object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchSalonsResponsePageInfoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'nextCursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        case r'totalApprox':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalApprox = valueDes;
          break;
        case r'hasMore':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchSalonsResponsePageInfo deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchSalonsResponsePageInfoBuilder();
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

