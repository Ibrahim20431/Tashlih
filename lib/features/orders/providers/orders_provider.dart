import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;

import '../../../core/models/pagination_model.dart';
import '../../home/providers/city_filters_provider.dart';
import '../../my_orders/data/models/order_model.dart';
import '../../my_orders/data/repositories/order_repository.dart';

final ordersProvider =
    FutureProvider.family<PaginationModel<OrderModel>, int>((ref, page) {
  final repo = ref.read(orderRepoProvider);
  final params = ref.read(cityFiltersProvider);
  return repo.getOrders(page, params);
});
