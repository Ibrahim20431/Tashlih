final class OrderUserModel {
  const OrderUserModel({
    required this.id,
    required this.name,
    required this.image,
  });

  final int id;
  final String name;
  final String image;

  factory OrderUserModel.fromMap(Map<String, dynamic> map) => OrderUserModel(
        id: map['id'],
        name: map['name'],
        image: map['image'],
      );
}
