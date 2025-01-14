import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/firebase/firebase_firestore_service.dart';
import '../../../../core/models/state_request_mixin.dart';
import '../../../../core/utils/helpers/exception_handler.dart';
import '../../data/models/chat_model.dart';

final class StartChatNotifier extends StateNotifier<AsyncValue<ChatModel>>
    with StateRequestMixin {
  StartChatNotifier(Ref ref, String collection)
      : _firestore = FirebaseFirestoreService(ref, collection),
        super(const AsyncLoading()) {
    super.initializeRef(ref);
  }

  final FirebaseFirestoreService _firestore;

  void createChat(ChatModel chatUser) async {
    super.loading();
    state = const AsyncLoading();
    try {
      final chat = await _firestore.getOrCreateChat(chatUser);
      super.success();
      state = AsyncData(chat);
    } catch (error) {
      super.error(error, exceptionHandler(error));
      state = AsyncError(error, StackTrace.current);
    }
  }
}

final startChatNotifierProvider = StateNotifierProvider.family<
    StartChatNotifier, AsyncValue<ChatModel>, String>(StartChatNotifier.new);
