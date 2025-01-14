
import '../../../chats/data/models/chat_model.dart';

final class StoreModel {
  const StoreModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.image,
    required this.city,
    required this.rate,
    required this.mobile,
    required this.specialties,
  });

  final int id;
  final int userId;
  final String name;
  final String image;
  final String city;
  final double rate;
  final String mobile;
  final List? specialties;

  bool get isSpecialist => specialties != null;

  ChatModel toChat() => ChatModel(
        id: userId,
        name: name,
        image: image,
      );

  factory StoreModel.fromMap(Map<String, dynamic> map) => StoreModel(
        id: map['id'],
        userId: map['user_id'],
        name: map['name'],
        image: map['image'],
        city: map['city'],
        rate: map['rate'] + .0,
        mobile: map['mobile'],
        specialties: map['specialities'],
      );
}
