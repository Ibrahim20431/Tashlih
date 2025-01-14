import 'dart:convert' show jsonDecode, jsonEncode;

import '../../../../core/constants/key_enums.dart';
import 'id_name_model.dart';

final class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.image,
    required this.mobile,
    required this.storeName,
    required this.city,
    required this.type,
    required this.notificationStatus,
  });

  final int id;
  final String name;
  final String image;
  final String mobile;
  final String? storeName;
  final IdNameModel city;
  final UserType type;
  final bool notificationStatus;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      mobile: map['mobile'],
      storeName: map['store_name'],
      city: IdNameModel.fromMap(map['city']),
      type: UserType.values.byName(map['type']),
      notificationStatus: map['notification_status'],
    );
  }

  String toJson() {
    final user = {
      'id': id,
      'name': name,
      'image': image,
      'mobile': mobile,
      'store_name': storeName,
      'city': city.toMap(),
      'type': type.name,
      'notification_status': notificationStatus,
    };
    return jsonEncode(user);
  }

  factory UserModel.fromString(String mapString) {
    return UserModel.fromMap(jsonDecode(mapString));
  }

  UserModel copyWith({
    String? name,
    IdNameModel? city,
    String? image,
    bool? notificationStatus,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        image: image ?? this.image,
        mobile: mobile,
        storeName: storeName,
        city: city ?? this.city,
        type: type,
        notificationStatus: notificationStatus ?? this.notificationStatus,
      );
}
