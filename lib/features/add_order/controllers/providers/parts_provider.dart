import 'package:flutter_riverpod/flutter_riverpod.dart' show FutureProvider;

import '../../../my_orders/data/repositories/order_repository.dart';

final partsProvider = FutureProvider((ref) {
  final repo = ref.read(orderRepoProvider);
  return repo.getParts();
});
