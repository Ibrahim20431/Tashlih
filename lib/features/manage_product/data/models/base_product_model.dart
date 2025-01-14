import '../../../auth/data/models/id_name_model.dart';

base class BaseProductModel {
  const BaseProductModel({
    this.id,
    this.image,
    required this.name,
    required this.company,
    required this.brand,
    required this.model,
    required this.part,
    required this.note,
    this.price,
  });

  final int? id;
  final String? image;
  final String name;
  final IdNameModel company;
  final IdNameModel brand;
  final String model;
  final IdNameModel part;
  final String? note;
  final num? price;

  bool get hasNote => note != null;

  Map<String, String> toMap() {
    return {
      'name': name,
      'category_id': '${company.id}',
      'model_id': '${brand.id}',
      'year': model,
      'part_id': '${part.id}',
      if (hasNote) 'content': note!,
    };
  }
}
