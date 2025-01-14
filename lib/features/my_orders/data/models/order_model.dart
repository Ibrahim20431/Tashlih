import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;

import '../../../../core/constants/key_enums.dart';
import '../../../../core/utils/helpers/string_cases_converter.dart';
import '../../../auth/data/models/id_name_model.dart';
import '../../../chats/data/models/chat_model.dart';
import '../../../manage_product/data/models/base_product_model.dart';

final class OrderModel extends BaseProductModel {
  OrderModel({
    required super.id,
    required super.image,
    required super.name,
    required super.note,
    required super.company,
    required super.brand,
    required super.model,
    required super.part,
    required this.city,
    required this.statusProvider,
    required this.offersCountProvider,
    required this.isOffered,
    required this.chat,
  });

  final String city;
  final StateProvider<OrderOfferStatus> statusProvider;
  final StateProvider<int> offersCountProvider;
  final ChatModel chat;

  // This only on trader get orders
  bool? isOffered;

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final user = map['user'];
    return OrderModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      company: IdNameModel(map['category']),
      brand: IdNameModel(map['model']),
      part: IdNameModel(map['part']),
      model: map['year'],
      note: map['content'],
      city: map['city'],
      statusProvider: StateProvider((_) {
        return OrderOfferStatus.values.byName(
          snakeToCamelCase(map['status']),
        );
      }),
      offersCountProvider: StateProvider((_) => map['offers_count']),
      isOffered: map['is_offered'],
      chat: ChatModel(id: user['id'], name: user['name'], image: user['image']),
    );
  }
}
