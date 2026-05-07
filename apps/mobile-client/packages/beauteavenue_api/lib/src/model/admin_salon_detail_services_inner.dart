//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_salon_detail_services_inner.g.dart';

/// AdminSalonDetailServicesInner
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [durationMinutes] 
/// * [priceXof] 
/// * [depositMode] 
/// * [depositAmountXof] 
/// * [depositPercent] 
@BuiltValue()
abstract class AdminSalonDetailServicesInner implements Built<AdminSalonDetailServicesInner, AdminSalonDetailServicesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'durationMinutes')
  int get durationMinutes;

  @BuiltValueField(wireName: r'priceXof')
  int get priceXof;

  @BuiltValueField(wireName: r'depositMode')
  AdminSalonDetailServicesInnerDepositModeEnum get depositMode;
  // enum depositModeEnum {  none,  fixed,  percent,  };

  @BuiltValueField(wireName: r'depositAmountXof')
  int? get depositAmountXof;

  @BuiltValueField(wireName: r'depositPercent')
  int? get depositPercent;

  AdminSalonDetailServicesInner._();

  factory AdminSalonDetailServicesInner([void updates(AdminSalonDetailServicesInnerBuilder b)]) = _$AdminSalonDetailServicesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSalonDetailServicesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSalonDetailServicesInner> get serializer => _$AdminSalonDetailServicesInnerSerializer();
}

class _$AdminSalonDetailServicesInnerSerializer implements PrimitiveSerializer<AdminSalonDetailServicesInner> {
  @override
  final Iterable<Type> types = const [AdminSalonDetailServicesInner, _$AdminSalonDetailServicesInner];

  @override
  final String wireName = r'AdminSalonDetailServicesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSalonDetailServicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'durationMinutes';
    yield serializers.serialize(
      object.durationMinutes,
      specifiedType: const FullType(int),
    );
    yield r'priceXof';
    yield serializers.serialize(
      object.priceXof,
      specifiedType: const FullType(int),
    );
    yield r'depositMode';
    yield serializers.serialize(
      object.depositMode,
      specifiedType: const FullType(AdminSalonDetailServicesInnerDepositModeEnum),
    );
    yield r'depositAmountXof';
    yield object.depositAmountXof == null ? null : serializers.serialize(
      object.depositAmountXof,
      specifiedType: const FullType.nullable(int),
    );
    yield r'depositPercent';
    yield object.depositPercent == null ? null : serializers.serialize(
      object.depositPercent,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSalonDetailServicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSalonDetailServicesInnerBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'durationMinutes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationMinutes = valueDes;
          break;
        case r'priceXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.priceXof = valueDes;
          break;
        case r'depositMode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSalonDetailServicesInnerDepositModeEnum),
          ) as AdminSalonDetailServicesInnerDepositModeEnum;
          result.depositMode = valueDes;
          break;
        case r'depositAmountXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.depositAmountXof = valueDes;
          break;
        case r'depositPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.depositPercent = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSalonDetailServicesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSalonDetailServicesInnerBuilder();
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

class AdminSalonDetailServicesInnerDepositModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'none')
  static const AdminSalonDetailServicesInnerDepositModeEnum none = _$adminSalonDetailServicesInnerDepositModeEnum_none;
  @BuiltValueEnumConst(wireName: r'fixed')
  static const AdminSalonDetailServicesInnerDepositModeEnum fixed = _$adminSalonDetailServicesInnerDepositModeEnum_fixed;
  @BuiltValueEnumConst(wireName: r'percent')
  static const AdminSalonDetailServicesInnerDepositModeEnum percent = _$adminSalonDetailServicesInnerDepositModeEnum_percent;

  static Serializer<AdminSalonDetailServicesInnerDepositModeEnum> get serializer => _$adminSalonDetailServicesInnerDepositModeEnumSerializer;

  const AdminSalonDetailServicesInnerDepositModeEnum._(String name): super(name);

  static BuiltSet<AdminSalonDetailServicesInnerDepositModeEnum> get values => _$adminSalonDetailServicesInnerDepositModeEnumValues;
  static AdminSalonDetailServicesInnerDepositModeEnum valueOf(String name) => _$adminSalonDetailServicesInnerDepositModeEnumValueOf(name);
}

