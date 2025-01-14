import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/firebase/firebase_firestore_service.dart';
import '../../../../core/firebase/firebase_keys.dart';
import '../../../../core/models/request_state.dart';
import '../../../../core/models/state_request_mixin.dart';
import '../../../../core/utils/helpers/exception_handler.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../../chats/data/models/chat_model.dart';
import '../../../my_orders/data/repositories/order_repository.dart';
import '../../../orders/models/bank_model.dart';
import '../../data/models/add_order_data.dart';

final class OrderNotifier extends StateNotifier<RequestState<BankModel?>>
    with StateRequestMixin {
  OrderNotifier(this._ref) : super(const InitState()) {
    _repo = _ref.read(orderRepoProvider);
    super.initializeRef(_ref);
  }

  final Ref _ref;
  late final OrderRepository _repo;

  Future<void> addOrder(AddOrderData order) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.addOrder(order);
      _successState();
    } catch (e) {
      _errorState(e);
    }
  }

  Future<void> deleteOrder(int id) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      await _repo.deleteOrder(id);
      _successState('تم حذف الطلب بنجاح');
    } catch (e) {
      _errorState(e);
    }
  }

  Future<void> addOrderOffer({
    required int orderId,
    required String price,
    required String warranty,
    required String note,
    required String condition,
  }) async {
    if (state.isLoading) return;
    _loadingState();
    try {
      final chatDoc = await _createOfferChat();

      await _repo.addOrderOffer(
        orderId: orderId,
        price: price,
        warranty: warranty,
        note: note,
        condition: condition,
        chatDoc: chatDoc,
      );

      _successState('تم إضافة العرض بنجاح');
    } catch (e) {
      _errorState(e);
    }
  }

  void getBank() async {
    if (state.isLoading) return;
    _loadingState();
    try {
      final bank = await _repo.getBank();
      _successState(null, bank);
    } catch (e) {
      _errorState(e);
    }
  }

  Future<String> _createOfferChat() async {
    final firestore = FirebaseFirestoreService(
      _ref,
      FirebaseCollections.offerChats,
    );

    final thisUser = _ref.read(userProvider)!;

    final chat = await firestore.createOfferChat(
      ChatModel(
        id: thisUser.id,
        name: thisUser.storeName!,
        image: thisUser.image,
      ),
    );

    return chat.doc;
  }

  void _loadingState() {
    super.loading();
    state = const LoadingState();
  }

  void _successState([String? message, BankModel? bank]) {
    super.success(message);
    state = SuccessState(data: bank);
  }

  void _errorState(Object error) {
    super.error(error, exceptionHandler(error));
    state = ErrorState(error);
  }
}

final orderNotifierProvider =
    StateNotifierProvider.autoDispose<OrderNotifier, RequestState<BankModel?>>(
        OrderNotifier.new);
