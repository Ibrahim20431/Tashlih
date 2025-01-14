import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;

import '../../../my_orders/data/repositories/order_repository.dart';
import 'search_offers_provider.dart';

final offersProvider = FutureProvider.autoDispose((ref) {
  final repo = ref.read(orderRepoProvider);
  final search = ref.read(searchOffersProvider);
  return repo.getOffers(search.text);
});
