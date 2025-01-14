import 'package:flutter_riverpod/flutter_riverpod.dart'
    show AsyncValueX, StateProvider;

import '../../chats/controllers/notifiers/chats_notifier.dart';
import '../../chats/controllers/providers/new_messages_count_provider.dart';

final chatsWithNewMessagesProvider = StateProvider.autoDispose<int>((ref) {
  final chats = ref.watch(chatsNotifierProvider);
  if (chats.hasValue) {
    int chatWithNewMessages = 0;
    for (final chat in chats.requireValue) {
      final count = ref.watch(newMessagesCountProvider(chat.doc));
      if (count > 0) chatWithNewMessages++;
    }
    return chatWithNewMessages;
  }
  return 0;
});
