import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/request_state.dart';
import '../../../../core/models/state_request_mixin.dart';
import '../../../core/utils/helpers/exception_handler.dart';
import '../../my_orders/data/repositories/order_repository.dart';

final class RateTraderNotifier extends StateNotifier<RequestState<void>>
    with StateRequestMixin {
  RateTraderNotifier(Ref ref)
      : _repo = ref.read(orderRepoProvider),
        super(const InitState()) {
    super.initializeRef(ref);
  }

  final OrderRepository _repo;

  late double rateValue;

  void rate(int traderId, double value) async {
    _loadingState();
    rateValue = value;
    try {
      await _repo.rateTrader(traderId, value);
      _successState('تم تقييم المتجر بنجاح');
    } catch (e) {
      _errorState(e);
    }
  }

  void _loadingState() {
    super.loading();
    state = const LoadingState();
  }

  void _successState([String? message]) {
    super.success(message);
    state = const SuccessState();
  }

  void _errorState(Object error) {
    super.error(error, exceptionHandler(error));
    state = ErrorState(error);
  }
}

final rateTraderNotifierProvider =
    StateNotifierProvider.autoDispose<RateTraderNotifier, RequestState<void>>(
        RateTraderNotifier.new);
