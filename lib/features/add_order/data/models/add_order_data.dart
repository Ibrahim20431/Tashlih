import '../../../../core/constants/key_enums.dart';
import '../../../../core/utils/helpers/string_cases_converter.dart';
import '../../../manage_product/data/models/base_product_model.dart';

final class AddOrderData {
  const AddOrderData({
    required this.storeType,
    required this.receivingCity,
    required this.product,
  });

  final StoreType? storeType;
  final int receivingCity;
  final BaseProductModel product;

  Map<String, String> toMap() {
    return {
      'type': storeType == null ? 'all' : camelToSnakeCase(storeType!.name),
      'city_id': '$receivingCity',
      ...product.toMap()
    };
  }
}
