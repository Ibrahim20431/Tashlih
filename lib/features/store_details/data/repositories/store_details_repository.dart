import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/end_points.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/models/pagination_params_model.dart';
import '../../../../core/services/api_service.dart';
import '../../../product_details/data/models/product_model.dart';

final class StoreDetailsRepository {
  StoreDetailsRepository(Ref ref) : _api = ref.read(apiProvider);
  final ApiService _api;

  Future<PaginationModel<ProductModel>> getProducts(
      PaginationParamsModel params) async {
    final response = await _api.get(
      '${EndPoints.products}/${params.id}',
      parameters: {'page': '${params.page}'},
    );
    if (response.success) {
      final stores = PaginationModel<ProductModel>();
      stores.setData(
        map: response.data,
        fromJson: ProductModel.fromMap,
      );
      return stores;
    }
    throw response.message;
  }
}

final storeDetailsRepoProvider =
    Provider.autoDispose(StoreDetailsRepository.new);
