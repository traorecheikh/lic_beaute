//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'client_voucher.g.dart';

/// ClientVoucher
///
/// Properties:
/// * [id] 
/// * [code] 
/// * [title] 
/// * [description] 
/// * [discountLabel] 
/// * [status] 
/// * [expiresAt] 
/// * [redeemedAt] 
/// * [usedAt] 
/// * [salonId] 
/// * [salonName] 
@BuiltValue()
abstract class ClientVoucher implements Built<ClientVoucher, ClientVoucherBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'discountLabel')
  String get discountLabel;

  @BuiltValueField(wireName: r'status')
  ClientVoucherStatusEnum get status;
  // enum statusEnum {  active,  used,  expired,  };

  @BuiltValueField(wireName: r'expiresAt')
  String? get expiresAt;

  @BuiltValueField(wireName: r'redeemedAt')
  String get redeemedAt;

  @BuiltValueField(wireName: r'usedAt')
  String? get usedAt;

  @BuiltValueField(wireName: r'salonId')
  String? get salonId;

  @BuiltValueField(wireName: r'salonName')
  String? get salonName;

  ClientVoucher._();

  factory ClientVoucher([void updates(ClientVoucherBuilder b)]) = _$ClientVoucher;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ClientVoucherBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ClientVoucher> get serializer => _$ClientVoucherSerializer();
}

class _$ClientVoucherSerializer implements PrimitiveSerializer<ClientVoucher> {
  @override
  final Iterable<Type> types = const [ClientVoucher, _$ClientVoucher];

  @override
  final String wireName = r'ClientVoucher';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ClientVoucher object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'discountLabel';
    yield serializers.serialize(
      object.discountLabel,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ClientVoucherStatusEnum),
    );
    yield r'expiresAt';
    yield object.expiresAt == null ? null : serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'redeemedAt';
    yield serializers.serialize(
      object.redeemedAt,
      specifiedType: const FullType(String),
    );
    yield r'usedAt';
    yield object.usedAt == null ? null : serializers.serialize(
      object.usedAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'salonId';
    yield object.salonId == null ? null : serializers.serialize(
      object.salonId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'salonName';
    yield object.salonName == null ? null : serializers.serialize(
      object.salonName,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ClientVoucher object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ClientVoucherBuilder result,
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'discountLabel':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.discountLabel = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ClientVoucherStatusEnum),
          ) as ClientVoucherStatusEnum;
          result.status = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.expiresAt = valueDes;
          break;
        case r'redeemedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.redeemedAt = valueDes;
          break;
        case r'usedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.usedAt = valueDes;
          break;
        case r'salonId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.salonId = valueDes;
          break;
        case r'salonName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.salonName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ClientVoucher deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClientVoucherBuilder();
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

class ClientVoucherStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'active')
  static const ClientVoucherStatusEnum active = _$clientVoucherStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'used')
  static const ClientVoucherStatusEnum used = _$clientVoucherStatusEnum_used;
  @BuiltValueEnumConst(wireName: r'expired')
  static const ClientVoucherStatusEnum expired = _$clientVoucherStatusEnum_expired;

  static Serializer<ClientVoucherStatusEnum> get serializer => _$clientVoucherStatusEnumSerializer;

  const ClientVoucherStatusEnum._(String name): super(name);

  static BuiltSet<ClientVoucherStatusEnum> get values => _$clientVoucherStatusEnumValues;
  static ClientVoucherStatusEnum valueOf(String name) => _$clientVoucherStatusEnumValueOf(name);
}

