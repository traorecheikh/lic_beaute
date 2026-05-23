//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_staff_member.g.dart';

/// ProStaffMember
///
/// Properties:
/// * [id] 
/// * [userId] 
/// * [displayName] 
/// * [email] 
/// * [phone] 
/// * [role] 
/// * [avatarUrl] 
/// * [description] 
/// * [isActive] 
/// * [schedulingEnabled] 
/// * [serviceIds] 
@BuiltValue()
abstract class ProStaffMember implements Built<ProStaffMember, ProStaffMemberBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'userId')
  String get userId;

  @BuiltValueField(wireName: r'displayName')
  String get displayName;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'role')
  ProStaffMemberRoleEnum get role;
  // enum roleEnum {  salon_staff,  salon_manager,  salon_owner,  };

  @BuiltValueField(wireName: r'avatarUrl')
  String? get avatarUrl;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'isActive')
  bool get isActive;

  @BuiltValueField(wireName: r'schedulingEnabled')
  bool get schedulingEnabled;

  @BuiltValueField(wireName: r'serviceIds')
  BuiltList<String> get serviceIds;

  ProStaffMember._();

  factory ProStaffMember([void updates(ProStaffMemberBuilder b)]) = _$ProStaffMember;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProStaffMemberBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProStaffMember> get serializer => _$ProStaffMemberSerializer();
}

class _$ProStaffMemberSerializer implements PrimitiveSerializer<ProStaffMember> {
  @override
  final Iterable<Type> types = const [ProStaffMember, _$ProStaffMember];

  @override
  final String wireName = r'ProStaffMember';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProStaffMember object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'userId';
    yield serializers.serialize(
      object.userId,
      specifiedType: const FullType(String),
    );
    yield r'displayName';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield object.email == null ? null : serializers.serialize(
      object.email,
      specifiedType: const FullType.nullable(String),
    );
    yield r'phone';
    yield object.phone == null ? null : serializers.serialize(
      object.phone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(ProStaffMemberRoleEnum),
    );
    yield r'avatarUrl';
    yield object.avatarUrl == null ? null : serializers.serialize(
      object.avatarUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'isActive';
    yield serializers.serialize(
      object.isActive,
      specifiedType: const FullType(bool),
    );
    yield r'schedulingEnabled';
    yield serializers.serialize(
      object.schedulingEnabled,
      specifiedType: const FullType(bool),
    );
    yield r'serviceIds';
    yield serializers.serialize(
      object.serviceIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProStaffMember object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProStaffMemberBuilder result,
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
        case r'userId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.userId = valueDes;
          break;
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProStaffMemberRoleEnum),
          ) as ProStaffMemberRoleEnum;
          result.role = valueDes;
          break;
        case r'avatarUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatarUrl = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'isActive':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isActive = valueDes;
          break;
        case r'schedulingEnabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.schedulingEnabled = valueDes;
          break;
        case r'serviceIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.serviceIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProStaffMember deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProStaffMemberBuilder();
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

class ProStaffMemberRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'salon_staff')
  static const ProStaffMemberRoleEnum salonStaff = _$proStaffMemberRoleEnum_salonStaff;
  @BuiltValueEnumConst(wireName: r'salon_manager')
  static const ProStaffMemberRoleEnum salonManager = _$proStaffMemberRoleEnum_salonManager;
  @BuiltValueEnumConst(wireName: r'salon_owner')
  static const ProStaffMemberRoleEnum salonOwner = _$proStaffMemberRoleEnum_salonOwner;

  static Serializer<ProStaffMemberRoleEnum> get serializer => _$proStaffMemberRoleEnumSerializer;

  const ProStaffMemberRoleEnum._(String name): super(name);

  static BuiltSet<ProStaffMemberRoleEnum> get values => _$proStaffMemberRoleEnumValues;
  static ProStaffMemberRoleEnum valueOf(String name) => _$proStaffMemberRoleEnumValueOf(name);
}

