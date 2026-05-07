//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:beauteavenue_api/src/model/pro_checkout_details_line_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_checkout_details.g.dart';

/// ProCheckoutDetails
///
/// Properties:
/// * [bookingId] 
/// * [status] 
/// * [clientName] 
/// * [serviceName] 
/// * [startsAt] 
/// * [staffName] 
/// * [subtotalXof] 
/// * [depositPaidXof] 
/// * [balanceXof] 
/// * [lineItems] 
@BuiltValue()
abstract class ProCheckoutDetails implements Built<ProCheckoutDetails, ProCheckoutDetailsBuilder> {
  @BuiltValueField(wireName: r'bookingId')
  String get bookingId;

  @BuiltValueField(wireName: r'status')
  ProCheckoutDetailsStatusEnum get status;
  // enum statusEnum {  pending,  confirmed,  in_progress,  completed,  cancelled,  };

  @BuiltValueField(wireName: r'clientName')
  String? get clientName;

  @BuiltValueField(wireName: r'serviceName')
  String get serviceName;

  @BuiltValueField(wireName: r'startsAt')
  DateTime get startsAt;

  @BuiltValueField(wireName: r'staffName')
  String? get staffName;

  @BuiltValueField(wireName: r'subtotalXof')
  int get subtotalXof;

  @BuiltValueField(wireName: r'depositPaidXof')
  int get depositPaidXof;

  @BuiltValueField(wireName: r'balanceXof')
  int get balanceXof;

  @BuiltValueField(wireName: r'lineItems')
  BuiltList<ProCheckoutDetailsLineItemsInner> get lineItems;

  ProCheckoutDetails._();

  factory ProCheckoutDetails([void updates(ProCheckoutDetailsBuilder b)]) = _$ProCheckoutDetails;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProCheckoutDetailsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProCheckoutDetails> get serializer => _$ProCheckoutDetailsSerializer();
}

class _$ProCheckoutDetailsSerializer implements PrimitiveSerializer<ProCheckoutDetails> {
  @override
  final Iterable<Type> types = const [ProCheckoutDetails, _$ProCheckoutDetails];

  @override
  final String wireName = r'ProCheckoutDetails';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProCheckoutDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'bookingId';
    yield serializers.serialize(
      object.bookingId,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ProCheckoutDetailsStatusEnum),
    );
    yield r'clientName';
    yield object.clientName == null ? null : serializers.serialize(
      object.clientName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'serviceName';
    yield serializers.serialize(
      object.serviceName,
      specifiedType: const FullType(String),
    );
    yield r'startsAt';
    yield serializers.serialize(
      object.startsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'staffName';
    yield object.staffName == null ? null : serializers.serialize(
      object.staffName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'subtotalXof';
    yield serializers.serialize(
      object.subtotalXof,
      specifiedType: const FullType(int),
    );
    yield r'depositPaidXof';
    yield serializers.serialize(
      object.depositPaidXof,
      specifiedType: const FullType(int),
    );
    yield r'balanceXof';
    yield serializers.serialize(
      object.balanceXof,
      specifiedType: const FullType(int),
    );
    yield r'lineItems';
    yield serializers.serialize(
      object.lineItems,
      specifiedType: const FullType(BuiltList, [FullType(ProCheckoutDetailsLineItemsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProCheckoutDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProCheckoutDetailsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'bookingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.bookingId = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProCheckoutDetailsStatusEnum),
          ) as ProCheckoutDetailsStatusEnum;
          result.status = valueDes;
          break;
        case r'clientName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.clientName = valueDes;
          break;
        case r'serviceName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.serviceName = valueDes;
          break;
        case r'startsAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.startsAt = valueDes;
          break;
        case r'staffName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.staffName = valueDes;
          break;
        case r'subtotalXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.subtotalXof = valueDes;
          break;
        case r'depositPaidXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.depositPaidXof = valueDes;
          break;
        case r'balanceXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.balanceXof = valueDes;
          break;
        case r'lineItems':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProCheckoutDetailsLineItemsInner)]),
          ) as BuiltList<ProCheckoutDetailsLineItemsInner>;
          result.lineItems.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProCheckoutDetails deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProCheckoutDetailsBuilder();
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

class ProCheckoutDetailsStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'pending')
  static const ProCheckoutDetailsStatusEnum pending = _$proCheckoutDetailsStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'confirmed')
  static const ProCheckoutDetailsStatusEnum confirmed = _$proCheckoutDetailsStatusEnum_confirmed;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const ProCheckoutDetailsStatusEnum inProgress = _$proCheckoutDetailsStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'completed')
  static const ProCheckoutDetailsStatusEnum completed = _$proCheckoutDetailsStatusEnum_completed;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const ProCheckoutDetailsStatusEnum cancelled = _$proCheckoutDetailsStatusEnum_cancelled;

  static Serializer<ProCheckoutDetailsStatusEnum> get serializer => _$proCheckoutDetailsStatusEnumSerializer;

  const ProCheckoutDetailsStatusEnum._(String name): super(name);

  static BuiltSet<ProCheckoutDetailsStatusEnum> get values => _$proCheckoutDetailsStatusEnumValues;
  static ProCheckoutDetailsStatusEnum valueOf(String name) => _$proCheckoutDetailsStatusEnumValueOf(name);
}

