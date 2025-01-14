import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;

import '../../../core/models/pagination_model.dart';
import '../data/models/order_model.dart';
import '../data/repositories/order_repository.dart';

final clientOrdersProvider =
    FutureProvider.family<PaginationModel<OrderModel>, int>((ref, page) {
  final repo = ref.read(orderRepoProvider);
  return repo.getClientOrders(page);
});
