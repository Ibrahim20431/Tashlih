import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider, Ref;

import '../../../../core/constants/api_keys.dart';
import '../../../../core/constants/end_points.dart';
import '../../../../core/services/api_service.dart';
import '../../../auth/data/models/trader_data_validation_model.dart';
import '../../../product_details/data/models/product_model.dart';
import '../../../store_details/data/models/store_model.dart';

final class ProfileRepository {
  ProfileRepository(Ref ref) : _api = ref.read(apiProvider);

  final ApiService _api;

  Future<String> updateProfile({
    required String name,
    required int city,
    required String? image,
  }) async {
    final response = await _api.postWithFile(
      EndPoints.profile,
      body: {'name': name, 'city': '$city'},
      files: image != null ? {'image': image} : null,
    );

    if (response.success) return response.data['image'];
    throw response.message;
  }

  Future<StoreModel> getMyStore() async {
    final response = await _api.get(EndPoints.storeMyStore);
    if (response.success) return StoreModel.fromMap(response.data);
    throw response.message;
  }

  Future<TraderDataValidationModel> getMyStoreDetails() async {
    final response = await _api.get(EndPoints.storeShow);
    if (response.success) {
      return TraderDataValidationModel.fromMap(response.data);
    }
    throw response.message;
  }

  Future<void> addProduct(ProductModel product) async {
    final response = await _api.postWithFile(
      EndPoints.traderProducts,
      body: product.toMap(),
      files: {'image': product.image!},
    );
    if (response.success) return;
    throw response.message;
  }

  Future<void> updateProduct(ProductModel product) async {
    final image = product.image;
    final response = await _api.putWithFile(
      '${EndPoints.traderProducts}/${product.id}',
      body: product.toMap(),
      files: image != null ? {'image': image} : null,
    );
    if (response.success) return;
    throw response.message;
  }

  Future<void> deleteProduct(int id) async {
    final response = await _api.delete('${EndPoints.traderProducts}/$id');
    if (response.success) return;
    throw response.message;
  }

  Future<bool> changeNotificationStatus(bool status) async {
    final response = await _api.post(
      EndPoints.notificationStatus,
      body: {ApiKeys.notificationStatus: status},
    );

    if (response.success) return response.data[ApiKeys.notificationStatus];

    throw response.message;
  }
}

final profileRepoProvider = Provider.autoDispose(ProfileRepository.new);
