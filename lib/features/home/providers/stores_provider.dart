import 'package:flutter_riverpod/flutter_riverpod.dart'
    show FutureProviderFamily;

import '../../../core/models/pagination_model.dart';
import '../../store_details/data/models/store_model.dart';
import '../data/repositories/home_repository.dart';
import 'city_filters_provider.dart';

final storesProvider =
    FutureProviderFamily<PaginationModel<StoreModel>, int>((ref, page) {
  final params = ref.read(cityFiltersProvider);
  final repo = ref.read(homeRepoProvider);
  return repo.getStores(page, params);
});
