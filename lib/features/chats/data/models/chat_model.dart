import '../../../../core/firebase/firebase_keys.dart';

final class ChatModel {
  final String doc;
  final int id;
  final String name;
  final String image;

  const ChatModel({
    this.doc = '',
    required this.id,
    required this.name,
    required this.image,
  });

  factory ChatModel.fromFirebaseMap(
    String doc,
    int thisUserId,
    Map<String, dynamic> map,
  ) {
    final userData = _getUserData(thisUserId, map);
    return ChatModel(
      doc: doc,
      id: userData.id,
      name: userData.name,
      image: userData.image,
    );
  }

  factory ChatModel.fromApiMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() => {
        FirebaseFields.id: id,
        FirebaseFields.name: name,
        FirebaseFields.image: image,
      };

  static ({int id, String name, String image}) _getUserData(
    int thisUserId,
    Map<String, dynamic> map,
  ) {
    final users = map[FirebaseCollections.users];

    final firstUser = users[FirebaseFields.n1];
    final secondUser = users[FirebaseFields.n2];

    final firstUserId = firstUser[FirebaseFields.id];

    if (firstUserId != thisUserId) {
      return (
        id: firstUserId,
        name: firstUser[FirebaseFields.name],
        image: firstUser[FirebaseFields.image]
      );
    } else {
      return (
        id: secondUser[FirebaseFields.id],
        name: secondUser[FirebaseFields.name],
        image: secondUser[FirebaseFields.image]
      );
    }
  }
}
