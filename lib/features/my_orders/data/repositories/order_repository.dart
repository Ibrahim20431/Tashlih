import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/end_points.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/models/pagination_model.dart';
import '../../../../core/models/search_params_model.dart';
import '../../../../core/models/status_code_exception.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/utils/helpers/get_model_list.dart';
import '../../../../core/utils/helpers/string_cases_converter.dart';
import '../../../add_order/data/models/add_order_data.dart';
import '../../../auth/data/models/id_name_model.dart';
import '../../../offers/models/order_offer_model.dart';
import '../../../orders/models/bank_model.dart';
import '../models/order_model.dart';

final class OrderRepository {
  OrderRepository(Ref ref) : _api = ref.read(apiProvider);

  final ApiService _api;

  Future<PaginationModel<OrderModel>> getClientOrders(int page) async {
    final response = await _api.get(
      EndPoints.requests,
      parameters: {'page': '$page'},
    );
    if (response.success) {
      final orders = PaginationModel<OrderModel>();
      orders.setData(
        map: response.data,
        fromJson: OrderModel.fromMap,
      );
      return orders;
    }
    throw response.message;
  }

  Future<PaginationModel<OrderModel>> getOrders(
    int page,
    SearchParamsModel params,
  ) async {
    final response = await _api.get(
      EndPoints.requestsTrader,
      parameters: {
        'page': '$page',
        'search': params.search,
        for (int i = 0; i < params.cities.length; i++)
          'cities[$i]': '${params.cities[i]}'
      },
    );
    if (response.success) {
      final orders = PaginationModel<OrderModel>();
      orders.setData(
        map: response.data,
        fromJson: OrderModel.fromMap,
      );
      return orders;
    }
    throw response.message;
  }

  Future<void> addOrder(AddOrderData order) async {
    final image = order.product.image;
    final response = await _api.postWithFile(
      EndPoints.requests,
      body: order.toMap(),
      files: image != null ? {'image': image} : null,
    );
    if (response.success) return;
    throw response.message;
  }

  Future<List<OrderOfferModel>> getOrderOffers(int id) {
    return _getOffers('${EndPoints.offers}/$id', orderId: id);
  }

  Future<List<OrderOfferModel>> getOffers(String search) {
    return _getOffers(EndPoints.traderOffers, parameters: {'search': search});
  }

  Future<List<OrderOfferModel>> _getOffers(
    String endPoint, {
    int orderId = 0,
    Map<String, String>? parameters,
  }) async {
    final response = await _api.get(endPoint, parameters: parameters);
    if (response.success) {
      return getModelList(
        response.data,
        (map) => OrderOfferModel.fromMap(map, orderId),
      );
    }
    throw response.message;
  }

  Future<OrderOfferModel> getOffer(int offerId) async {
    final response = await _api.get('${EndPoints.traderOffers}/$offerId');
    if (response.success) return OrderOfferModel.fromMap(response.data);
    throw response.message;
  }

  Future<List<IdNameModel>> getCompanies() async {
    final response = await _api.get(EndPoints.categoriesList);
    if (response.success) return _getIdNameList(response.data);
    throw response.message;
  }

  Future<List<IdNameModel>> getBrands(int companyId) async {
    final response = await _api.get(
      EndPoints.models,
      parameters: {'category_id': '$companyId'},
    );
    if (response.success) return _getIdNameList(response.data);
    throw response.message;
  }

  Future<List<IdNameModel>> getParts() async {
    final response = await _api.get(EndPoints.parts);
    if (response.success) return _getIdNameList(response.data);
    throw response.message;
  }

  List<IdNameModel> _getIdNameList(dynamic data) {
    return getModelList(data, IdNameModel.fromMap);
  }

  Future<void> deleteOrder(int id) async {
    final response = await _api.delete('${EndPoints.requests}/$id');
    if (response.success) return;
    throw response.message;
  }

  Future<void> addOrderOffer({
    required int orderId,
    required String price,
    required String warranty,
    required String note,
    required String condition,
    required String chatDoc,
  }) async {
    final response = await _api.post(
      EndPoints.traderOffers,
      body: {
        'request_id': orderId,
        'price': price,
        'warranty': warranty,
        'note': note,
        'condition': condition,
        'chat_doc': chatDoc,
      },
    );
    if (response.success) return;
    throw response.message;
  }

  Future<num> updateOfferPrice(int id, String price) async {
    final response = await _api.patch(
      '${EndPoints.traderOffers}/$id',
      body: {'price': price},
    );
    if (response.success) return response.data['price_with_vat'];
    throw response.message;
  }

  Future<void> updateOfferStatus(int id, String status) async {
    final response = await _api.post(
      '${EndPoints.offersStatus}/$status',
      body: {'offer_id': id},
    );
    if (response.success) return;

    if (response.statusCode == 422) {
      // Means the offer status is updated and this [status] can not set to offer
      throw StatusCodeException(
        statusCode: 422,
        message: response.message,
        data: OrderOfferStatus.values.byName(
          snakeToCamelCase(response.data['status']),
        ),
      );
    }
    throw response.message;
  }

  Future<void> rateTrader(int traderId, double rate) async {
    final response = await _api.post(
      EndPoints.rate,
      body: {'trader_id': traderId, 'rate': rate},
    );
    if (response.success) return;
    throw response.message;
  }

  Future<({num price, OrderOfferStatus status})> refreshOfferState(
      int id) async {
    final response = await _api.get('${EndPoints.offersStatus}/$id');
    if (response.success) {
      final data = response.data;
      return (
        price: data['price_with_vat'] as num,
        status: OrderOfferStatus.values.byName(
          snakeToCamelCase(data['status']),
        ),
      );
    }
    throw response.message;
  }

  Future<BankModel> getBank() async {
    final response = await _api.get(EndPoints.settingsBank);
    if (response.success) return BankModel.fromMap(response.data);
    throw response.message;
  }
}

final orderRepoProvider = Provider.autoDispose(OrderRepository.new);
