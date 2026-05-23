//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_input_any_of1_documents_inner.g.dart';

/// RegisterInputAnyOf1DocumentsInner
///
/// Properties:
/// * [label] 
/// * [fileUrl] 
@BuiltValue()
abstract class RegisterInputAnyOf1DocumentsInner implements Built<RegisterInputAnyOf1DocumentsInner, RegisterInputAnyOf1DocumentsInnerBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'fileUrl')
  String get fileUrl;

  RegisterInputAnyOf1DocumentsInner._();

  factory RegisterInputAnyOf1DocumentsInner([void updates(RegisterInputAnyOf1DocumentsInnerBuilder b)]) = _$RegisterInputAnyOf1DocumentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterInputAnyOf1DocumentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterInputAnyOf1DocumentsInner> get serializer => _$RegisterInputAnyOf1DocumentsInnerSerializer();
}

class _$RegisterInputAnyOf1DocumentsInnerSerializer implements PrimitiveSerializer<RegisterInputAnyOf1DocumentsInner> {
  @override
  final Iterable<Type> types = const [RegisterInputAnyOf1DocumentsInner, _$RegisterInputAnyOf1DocumentsInner];

  @override
  final String wireName = r'RegisterInputAnyOf1DocumentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterInputAnyOf1DocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'fileUrl';
    yield serializers.serialize(
      object.fileUrl,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterInputAnyOf1DocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterInputAnyOf1DocumentsInnerBuilder result,
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
        case r'fileUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fileUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegisterInputAnyOf1DocumentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterInputAnyOf1DocumentsInnerBuilder();
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

