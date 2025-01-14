import 'package:flutter_riverpod/flutter_riverpod.dart'
    show StateNotifierProvider;

import '../../../core/constants/key_enums.dart';
import '../../../core/utils/helpers/string_cases_converter.dart';
import '../../product_details/data/models/product_model.dart';
import '../../store_details/data/models/store_model.dart';
import '../controllers/notifiers/offer_notifier.dart';
import 'offer_state.dart';
import 'order_user_model.dart';

final class OrderOfferModel {
  const OrderOfferModel({
    required this.id,
    required this.date,
    required this.store,
    required this.product,
    required this.chatDoc,
    required this.orderUser,
    required this.offerNotifierProvider,
  });

  final int id;
  final String date;
  final StoreModel store;
  final ProductModel product;
  final String chatDoc;
  final OrderUserModel orderUser;
  final StateNotifierProvider<OfferNotifier, OfferState> offerNotifierProvider;

  factory OrderOfferModel.fromMap(Map<String, dynamic> map, [int? orderId]) {
    final id = map['id'];
    final status = OrderOfferStatus.values.byName(
      snakeToCamelCase(map['status']),
    );
    return OrderOfferModel(
      id: id,
      date: map['date'],
      store: StoreModel.fromMap(map['store']),
      product: ProductModel.fromMap(map),
      chatDoc: map['chat_doc'],
      orderUser: OrderUserModel.fromMap(map['request_user']),
      offerNotifierProvider:
          StateNotifierProvider<OfferNotifier, OfferState>((ref) {
        return OfferNotifier(
          ref,
          id,
          orderId,
          OfferState(map['price_with_vat'], map['price'], status),
        );
      }),
    );
  }
}
