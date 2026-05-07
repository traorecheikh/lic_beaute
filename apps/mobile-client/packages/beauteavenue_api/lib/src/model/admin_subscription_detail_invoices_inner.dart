//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_subscription_detail_invoices_inner.g.dart';

/// AdminSubscriptionDetailInvoicesInner
///
/// Properties:
/// * [id] 
/// * [invoiceNumber] 
/// * [amountXof] 
/// * [status] 
/// * [createdAt] 
/// * [pdfUrl] 
@BuiltValue()
abstract class AdminSubscriptionDetailInvoicesInner implements Built<AdminSubscriptionDetailInvoicesInner, AdminSubscriptionDetailInvoicesInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'invoiceNumber')
  String get invoiceNumber;

  @BuiltValueField(wireName: r'amountXof')
  int get amountXof;

  @BuiltValueField(wireName: r'status')
  AdminSubscriptionDetailInvoicesInnerStatusEnum get status;
  // enum statusEnum {  issued,  void,  paid,  comped,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'pdfUrl')
  String get pdfUrl;

  AdminSubscriptionDetailInvoicesInner._();

  factory AdminSubscriptionDetailInvoicesInner([void updates(AdminSubscriptionDetailInvoicesInnerBuilder b)]) = _$AdminSubscriptionDetailInvoicesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSubscriptionDetailInvoicesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSubscriptionDetailInvoicesInner> get serializer => _$AdminSubscriptionDetailInvoicesInnerSerializer();
}

class _$AdminSubscriptionDetailInvoicesInnerSerializer implements PrimitiveSerializer<AdminSubscriptionDetailInvoicesInner> {
  @override
  final Iterable<Type> types = const [AdminSubscriptionDetailInvoicesInner, _$AdminSubscriptionDetailInvoicesInner];

  @override
  final String wireName = r'AdminSubscriptionDetailInvoicesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSubscriptionDetailInvoicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'invoiceNumber';
    yield serializers.serialize(
      object.invoiceNumber,
      specifiedType: const FullType(String),
    );
    yield r'amountXof';
    yield serializers.serialize(
      object.amountXof,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminSubscriptionDetailInvoicesInnerStatusEnum),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'pdfUrl';
    yield serializers.serialize(
      object.pdfUrl,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSubscriptionDetailInvoicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSubscriptionDetailInvoicesInnerBuilder result,
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
        case r'invoiceNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.invoiceNumber = valueDes;
          break;
        case r'amountXof':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.amountXof = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminSubscriptionDetailInvoicesInnerStatusEnum),
          ) as AdminSubscriptionDetailInvoicesInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'createdAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'pdfUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pdfUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSubscriptionDetailInvoicesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSubscriptionDetailInvoicesInnerBuilder();
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

class AdminSubscriptionDetailInvoicesInnerStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'issued')
  static const AdminSubscriptionDetailInvoicesInnerStatusEnum issued = _$adminSubscriptionDetailInvoicesInnerStatusEnum_issued;
  @BuiltValueEnumConst(wireName: r'void')
  static const AdminSubscriptionDetailInvoicesInnerStatusEnum void_ = _$adminSubscriptionDetailInvoicesInnerStatusEnum_void_;
  @BuiltValueEnumConst(wireName: r'paid')
  static const AdminSubscriptionDetailInvoicesInnerStatusEnum paid = _$adminSubscriptionDetailInvoicesInnerStatusEnum_paid;
  @BuiltValueEnumConst(wireName: r'comped')
  static const AdminSubscriptionDetailInvoicesInnerStatusEnum comped = _$adminSubscriptionDetailInvoicesInnerStatusEnum_comped;

  static Serializer<AdminSubscriptionDetailInvoicesInnerStatusEnum> get serializer => _$adminSubscriptionDetailInvoicesInnerStatusEnumSerializer;

  const AdminSubscriptionDetailInvoicesInnerStatusEnum._(String name): super(name);

  static BuiltSet<AdminSubscriptionDetailInvoicesInnerStatusEnum> get values => _$adminSubscriptionDetailInvoicesInnerStatusEnumValues;
  static AdminSubscriptionDetailInvoicesInnerStatusEnum valueOf(String name) => _$adminSubscriptionDetailInvoicesInnerStatusEnumValueOf(name);
}

