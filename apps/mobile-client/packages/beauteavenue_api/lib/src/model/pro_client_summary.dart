//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_client_summary.g.dart';

/// ProClientSummary
///
/// Properties:
/// * [id]
/// * [fullName]
/// * [phone]
/// * [email]
/// * [visitCount]
/// * [totalSpentXof]
/// * [lastVisitAt]
@BuiltValue()
abstract class ProClientSummary
    implements Built<ProClientSummary, ProClientSummaryBuilder> {
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

  ProClientSummary._();

  factory ProClientSummary([void updates(ProClientSummaryBuilder b)]) =
      _$ProClientSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProClientSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProClientSummary> get serializer =>
      _$ProClientSummarySerializer();
}

class _$ProClientSummarySerializer
    implements PrimitiveSerializer<ProClientSummary> {
  @override
  final Iterable<Type> types = const [ProClientSummary, _$ProClientSummary];

  @override
  final String wireName = r'ProClientSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProClientSummary object, {
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
    yield object.phone == null
        ? null
        : serializers.serialize(
            object.phone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'email';
    yield object.email == null
        ? null
        : serializers.serialize(
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
    yield object.lastVisitAt == null
        ? null
        : serializers.serialize(
            object.lastVisitAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProClientSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProClientSummaryBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProClientSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProClientSummaryBuilder();
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
