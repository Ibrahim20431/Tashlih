import 'package:flutter_riverpod/flutter_riverpod.dart'
    show FutureProviderFamily;

import '../../../core/models/pagination_model.dart';
import '../../store_details/data/models/store_model.dart';
import '../../home/data/repositories/home_repository.dart';
import 'specialized_centers_filters_provider.dart';

final specializedCentersProvider =
    FutureProviderFamily<PaginationModel<StoreModel>, int>((ref, page) {
  final params = ref.read(specializedCentersFiltersProvider);
  final repo = ref.read(homeRepoProvider);
  return repo.getSpecializedStores(page, params);
});
