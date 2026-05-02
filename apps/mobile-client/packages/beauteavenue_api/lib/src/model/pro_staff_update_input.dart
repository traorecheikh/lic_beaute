//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pro_staff_update_input.g.dart';

/// ProStaffUpdateInput
///
/// Properties:
/// * [displayName]
/// * [avatarUrl]
/// * [description]
/// * [isActive]
/// * [schedulingEnabled]
/// * [serviceIds]
@BuiltValue()
abstract class ProStaffUpdateInput
    implements Built<ProStaffUpdateInput, ProStaffUpdateInputBuilder> {
  @BuiltValueField(wireName: r'displayName')
  String? get displayName;

  @BuiltValueField(wireName: r'avatarUrl')
  String? get avatarUrl;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'isActive')
  bool? get isActive;

  @BuiltValueField(wireName: r'schedulingEnabled')
  bool? get schedulingEnabled;

  @BuiltValueField(wireName: r'serviceIds')
  BuiltList<String>? get serviceIds;

  ProStaffUpdateInput._();

  factory ProStaffUpdateInput([void updates(ProStaffUpdateInputBuilder b)]) =
      _$ProStaffUpdateInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProStaffUpdateInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProStaffUpdateInput> get serializer =>
      _$ProStaffUpdateInputSerializer();
}

class _$ProStaffUpdateInputSerializer
    implements PrimitiveSerializer<ProStaffUpdateInput> {
  @override
  final Iterable<Type> types = const [
    ProStaffUpdateInput,
    _$ProStaffUpdateInput
  ];

  @override
  final String wireName = r'ProStaffUpdateInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProStaffUpdateInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.displayName != null) {
      yield r'displayName';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType(String),
      );
    }
    if (object.avatarUrl != null) {
      yield r'avatarUrl';
      yield serializers.serialize(
        object.avatarUrl,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.isActive != null) {
      yield r'isActive';
      yield serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      );
    }
    if (object.schedulingEnabled != null) {
      yield r'schedulingEnabled';
      yield serializers.serialize(
        object.schedulingEnabled,
        specifiedType: const FullType(bool),
      );
    }
    if (object.serviceIds != null) {
      yield r'serviceIds';
      yield serializers.serialize(
        object.serviceIds,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProStaffUpdateInput object, {
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
    required ProStaffUpdateInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'displayName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
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
  ProStaffUpdateInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProStaffUpdateInputBuilder();
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
