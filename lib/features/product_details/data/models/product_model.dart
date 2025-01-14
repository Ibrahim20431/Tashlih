import '../../../auth/data/models/id_name_model.dart';
import '../../../manage_product/data/models/base_product_model.dart';

base class ProductModel extends BaseProductModel {
  const ProductModel({
    super.id,
    super.image,
    required super.name,
    required super.note,
    required super.price,
    required super.company,
    required super.brand,
    required super.part,
    required super.model,
    required this.conditionEn,
    required this.warranty,
  });

  final String conditionEn;
  final String warranty;

  String get conditionAr => conditionEn == 'used' ? 'مستخدم' : 'جديد';

  bool get hasWarranty => warranty != 'غير محدد';

  bool get hasPrice => price != null;

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
        id: map['id'],
        image: map['image'],
        name: map['name'],
        note: map['content'],
        price: map['price'],
        company: IdNameModel.fromMap(map['category']),
        brand: IdNameModel.fromMap(map['model']),
        part: IdNameModel.fromMap(map['part']),
        model: '${map['year']}',
        conditionEn: map['product_condition'],
        warranty: map['warranty'],
      );

  @override
  Map<String, String> toMap() => {
        'name': name,
        'category_id': '${company.id}',
        'model_id': '${brand.id}',
        'year': model,
        'part_id': '${part.id}',
        if (note != null) 'content': note!,
        if (price != null) 'price': '$price',
        'warranty': warranty,
        'product_condition': conditionEn,
      };
}
