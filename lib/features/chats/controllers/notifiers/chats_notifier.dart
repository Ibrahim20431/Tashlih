import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/firebase/firebase_firestore_service.dart';
import '../../../../core/firebase/firebase_keys.dart';
import '../../data/models/chat_model.dart';

final class ChatsNotifier extends StateNotifier<AsyncValue<List<ChatModel>>> {
  ChatsNotifier(this._ref)
      : firestore = FirebaseFirestoreService(_ref, FirebaseCollections.chats),
        super(const AsyncLoading());

  final Ref _ref;
  final FirebaseFirestoreService firestore;

  String _searchText = '';

  Future<void> getChats() async {
    firestore.getChats(
      onData: (chats) {
        if (mounted) {
          state = AsyncData(chats);
          search(_searchText);
        }
      },
      onError: (error) => state = AsyncError(error, StackTrace.current),
    );
  }

  void search(String text) {
    _searchText = text.toLowerCase();
    final filteredNotifier = _ref.read(filteredChatsProvider.notifier);
    if (state.hasValue) {
      filteredNotifier.state = AsyncData(
        state.requireValue
            .where(
              (chat) => chat.name.toLowerCase().contains(_searchText),
            )
            .toList(),
      );
    } else {
      filteredNotifier.state = state;
    }
  }

  Future<void> reloadChats() {
    state = const AsyncLoading();
    _ref.read(filteredChatsProvider.notifier).state = state;
    return getChats();
  }
}

final chatsNotifierProvider = StateNotifierProvider.autoDispose<ChatsNotifier,
    AsyncValue<List<ChatModel>>>(ChatsNotifier.new);

final filteredChatsProvider =
    StateProvider.autoDispose<AsyncValue<List<ChatModel>>>((ref) {
  return ref.watch(chatsNotifierProvider);
});
