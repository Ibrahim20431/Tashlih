import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/end_points.dart';
import '../../../../core/services/api_service.dart';
import '../models/more_page_model.dart';

final class MoreRepository {
  MoreRepository(Ref ref) : _api = ref.read(apiProvider);

  final ApiService _api;

  Future<List<MorePageModel>> getPages() async {
    final response = await _api.get(EndPoints.pages);
    if (response.success) {
      return List<Map<String, dynamic>>.from(response.data)
          .map(MorePageModel.fromMap)
          .toList();
    }
    throw response.message;
  }

  Future<MorePageModel> getPage(String endPoint) async {
    final response = await _api.get('${EndPoints.pages}/$endPoint');
    if (response.success) return MorePageModel.fromMap(response.data);
    throw response.message;
  }
}

final moreRepoProvider = Provider.autoDispose(MoreRepository.new);
