//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_kpis_inner.g.dart';

/// AdminDashboardKpisInner
///
/// Properties:
/// * [label] 
/// * [value] 
/// * [displayValue] 
/// * [note] 
@BuiltValue()
abstract class AdminDashboardKpisInner implements Built<AdminDashboardKpisInner, AdminDashboardKpisInnerBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'value')
  num get value;

  @BuiltValueField(wireName: r'displayValue')
  String get displayValue;

  @BuiltValueField(wireName: r'note')
  String get note;

  AdminDashboardKpisInner._();

  factory AdminDashboardKpisInner([void updates(AdminDashboardKpisInnerBuilder b)]) = _$AdminDashboardKpisInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardKpisInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardKpisInner> get serializer => _$AdminDashboardKpisInnerSerializer();
}

class _$AdminDashboardKpisInnerSerializer implements PrimitiveSerializer<AdminDashboardKpisInner> {
  @override
  final Iterable<Type> types = const [AdminDashboardKpisInner, _$AdminDashboardKpisInner];

  @override
  final String wireName = r'AdminDashboardKpisInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardKpisInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(num),
    );
    yield r'displayValue';
    yield serializers.serialize(
      object.displayValue,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardKpisInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardKpisInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.value = valueDes;
          break;
        case r'displayValue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayValue = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardKpisInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardKpisInnerBuilder();
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

