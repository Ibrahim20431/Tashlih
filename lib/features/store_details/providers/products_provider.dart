import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/pagination_model.dart';
import '../../../core/models/pagination_params_model.dart';
import '../../product_details/data/models/product_model.dart';
import '../data/repositories/store_details_repository.dart';

final productsProvider = FutureProvider.family
    .autoDispose<PaginationModel<ProductModel>, PaginationParamsModel>(
        (ref, params) {
  final repo = ref.read(storeDetailsRepoProvider);
  return repo.getProducts(params);
});
