import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/key_enums.dart';
import '../../../../core/models/state_request_mixin.dart';
import '../../../../core/models/status_code_exception.dart';
import '../../../../core/utils/helpers/exception_handler.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../../my_orders/data/models/order_model.dart';
import '../../../my_orders/data/repositories/order_repository.dart';
import '../../../my_orders/providers/client_orders_provider.dart';
import '../../../order_offers/providers/order_offers_provider.dart';
import '../../models/offer_state.dart';

final class OfferNotifier extends StateNotifier<OfferState>
    with StateRequestMixin {
  OfferNotifier(this._ref, this._id, this._orderId, this._offerState)
      : _repo = _ref.read(orderRepoProvider),
        super(_offerState) {
    super.initializeRef(_ref);
  }

  final Ref _ref;
  final OrderRepository _repo;
  final int _id;
  final int? _orderId;
  OfferState _offerState;

  Future<void> updatePrice(String price) async {
    _loadingState();
    try {
      final priceWithVat = await _repo.updateOfferPrice(_id, price);
      _offerState = _offerState.copyWith(
        priceWithVat: priceWithVat,
        priceBeforeVat: num.parse(price),
      );
      _successState();
    } catch (e) {
      _errorState(e);
    }
  }

  Future<void> accept() async {
    _loadingState();
    try {
      await _repo.updateOfferStatus(_id, 'payment-waiting');
      _offerState = _offerState.copyWith(
        status: OrderOfferStatus.paymentWaiting,
      );
      _successState();
      _changeOtherOffersToRejected();
      _syncClientOfferOrderStatus(OrderOfferStatus.paymentWaiting);
    } on StatusCodeException catch (e) {
      _errorState(e.message);
      final status = e.data as OrderOfferStatus;
      updateState(_offerState.copyWith(status: status));
      _syncClientOfferOrderStatus(status);
    } catch (e) {
      _errorState(e);
    }
  }

  Future<void> paymentSent() async {
    _loadingState();
    try {
      await _repo.updateOfferStatus(_id, 'payment-verifying');
      _offerState = _offerState.copyWith(
        status: OrderOfferStatus.paymentVerifying,
      );
      _successState();
      _syncClientOfferOrderStatus(OrderOfferStatus.paymentVerifying);
    } on StatusCodeException catch (e) {
      _errorState(e.message);
      final status = e.data as OrderOfferStatus;
      updateState(_offerState.copyWith(status: status));
      _syncClientOfferOrderStatus(status);
    } catch (e) {
      _errorState(e);
    }
  }

  Future<void> paymentVerified() async {
    _loadingState();
    try {
      await _repo.updateOfferStatus(_id, 'payed');
      _offerState = _offerState.copyWith(
        status: OrderOfferStatus.payed,
      );
      _successState();
    } on StatusCodeException catch (e) {
      _errorState(e.message);
      final status = e.data as OrderOfferStatus;
      updateState(_offerState.copyWith(status: status));
    } catch (e) {
      _errorState(e);
    }
  }

  Future<void> shipping() async {
    _loadingState();
    try {
      await _repo.updateOfferStatus(_id, 'shipping');
      _offerState = _offerState.copyWith(
        status: OrderOfferStatus.shipping,
      );
      _successState();
    } on StatusCodeException catch (e) {
      _errorState(e.message);
      final status = e.data as OrderOfferStatus;
      updateState(_offerState.copyWith(status: status));
    } catch (e) {
      _errorState(e);
    }
  }

  Future<void> completed() async {
    _loadingState();
    try {
      await _repo.updateOfferStatus(_id, 'completed');
      _offerState = _offerState.copyWith(
        status: OrderOfferStatus.completed,
      );
      _successState();
      _syncClientOfferOrderStatus(OrderOfferStatus.completed);
    } on StatusCodeException catch (e) {
      _errorState(e.message);
      final status = e.data as OrderOfferStatus;
      updateState(_offerState.copyWith(status: status));
      _syncClientOfferOrderStatus(status);
    } catch (e) {
      _errorState(e);
    }
  }

  void refreshState() async {
    _loadingState();
    try {
      final data = await _repo.refreshOfferState(_id);
      final status = data.status;
      _offerState = _offerState.copyWith(
        priceWithVat: data.price,
        status: status,
      );
      _successState('تم تحديث البيانات بنجاح');
      final isClient = _ref.read(userProvider)!.type == UserType.client;
      if (isClient) _syncClientOfferOrderStatus(status);
    } catch (e) {
      _errorState(e);
    }
  }

  void updateState(OfferState offerState) {
    _offerState = offerState;
    state = offerState;
  }

  void _syncClientOfferOrderStatus(OrderOfferStatus status) {
    if (_orderId != null) {
      OrderModel? offerOrder;
      int i = 1;
      while (offerOrder == null) {
        _ref.read(clientOrdersProvider(i)).requireValue.list.forEach((order) {
          if (_orderId == order.id) offerOrder = order;
        });
        i++;
      }
      _ref.read(offerOrder!.statusProvider.notifier).state = status;
    }
  }

  void _changeOtherOffersToRejected() {
    if (_orderId != null) {
      _ref.read(orderOffersProvider(_orderId)).requireValue.forEach((offer) {
        if (offer.id != _id) {
          final offerState = _ref.read(offer.offerNotifierProvider);
          final notifier = _ref.read(offer.offerNotifierProvider.notifier);
          notifier.updateState(
            offerState.copyWith(status: OrderOfferStatus.rejected),
          );
        }
      });
    }
  }

  void _loadingState() {
    super.loading();
  }

  void _successState([String message = 'تمت العملية بنجاح']) {
    super.success(message);
    state = _offerState;
  }

  void _errorState(Object error) {
    super.error(error, exceptionHandler(error));
  }
}
