//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/pro_client_detail_recent_bookings_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_client_detail.g.dart';

/// ProClientDetail
///
/// Properties:
/// * [id] 
/// * [fullName] 
/// * [phone] 
/// * [email] 
/// * [visitCount] 
/// * [totalSpentXof] 
/// * [lastVisitAt] 
/// * [recentBookings] 
@BuiltValue()
abstract class ProClientDetail implements Built<ProClientDetail, ProClientDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'visitCount')
  int get visitCount;

  @BuiltValueField(wireName: r'totalSpentXof')
  int get totalSpentXof;

  @BuiltValueField(wireName: r'lastVisitAt')
  DateTime? get lastVisitAt;

  @BuiltValueField(wireName: r'recentBookings')
  BuiltList<ProClientDetailRecentBookingsInner> get recentBookings;

  ProClientDetail._();

  factory ProClientDetail([void updates(ProClientDetailBuilder b)]) = _$ProClientDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProClientDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProClientDetail> get serializer => _$ProClientDetailSerializer();
}

class _$ProClientDetailSerializer implements PrimitiveSerializer<ProClientDetail> {
  @override
  final Iterable<Type> types = const [ProClientDetail, _$ProClientDetail];

  @override
  final String wireName = r'ProClientDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProClientDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'email';
    yield object.email == null ? null : serializers.serialize(
      object.email,
      specifiedType: const FullType.nullable(String),
    );
    yield r'visitCount';
    yield serializers.serialize(
      object.visitCount,
      specifiedType: const FullType(int),
    );
    yield r'totalSpentXof';
    yield serializers.serialize(
      object.totalSpentXof,
      specifiedType: const FullType(int),
    );
    yield r'lastVisitAt';
    yield object.lastVisitAt == null ? null : serializers.serialize(
      object.lastVisitAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'recentBookings';
    yield serializers.serialize(
      object.recentBookings,
      specifiedType: const FullType(BuiltList, [FullType(ProClientDetailRecentBookingsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProClientDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProClientDetailBuilder result,
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
        case r'fullName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        case r'visitCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.visitCount = valueDes;
          break;
        case r'totalSpentXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalSpentXof = valueDes;
          break;
        case r'lastVisitAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastVisitAt = valueDes;
          break;
        case r'recentBookings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProClientDetailRecentBookingsInner)]),
          ) as BuiltList<ProClientDetailRecentBookingsInner>;
          result.recentBookings.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProClientDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProClientDetailBuilder();
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

