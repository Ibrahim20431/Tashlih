import 'package:flutter_riverpod/flutter_riverpod.dart'
    show AutoDisposeProvider, Ref;

import '../../../../core/constants/end_points.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/models/search_params_model.dart';
import '../../../../core/services/api_service.dart';
import '../../../store_details/data/models/store_model.dart';

final class HomeRepository {
  HomeRepository(Ref ref) {
    _api = ref.read(apiProvider);
  }

  late final ApiService _api;

  Future<PaginationModel<StoreModel>> getStores(
    int page,
    SearchParamsModel params,
  ) =>
      _getStores(EndPoints.store, page, params);

  Future<PaginationModel<StoreModel>> getSpecializedStores(
    int page,
    SearchParamsModel params,
  ) =>
      _getStores(EndPoints.storeSpecial, page, params);

  Future<List<String>> getSliderImages() async {
    final response = await _api.get('slider');
    if (response.success) {
      return List<Map<String, dynamic>>.from(response.data)
          .map((e) => e['image'] as String)
          .toList();
    }
    throw response.message;
  }

  Future<PaginationModel<StoreModel>> _getStores(
    String route,
    int page,
    SearchParamsModel params,
  ) async {
    final response = await _api.get(
      route,
      parameters: {
        'page': '$page',
        'searsh': params.search,
        for (int i = 0; i < params.cities.length; i++)
          'cities[$i]': '${params.cities[i]}'
      },
    );
    if (response.success) {
      final stores = PaginationModel<StoreModel>();
      stores.setData(
        map: response.data,
        fromJson: StoreModel.fromMap,
      );
      return stores;
    }
    throw response.message;
  }
}

final homeRepoProvider = AutoDisposeProvider(HomeRepository.new);
