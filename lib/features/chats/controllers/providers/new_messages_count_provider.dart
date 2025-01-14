import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/firebase/firebase_keys.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../data/models/chat_collection_doc_model.dart';
import '../notifiers/chat_notifier.dart';

final newMessagesCountProvider =
    StateProvider.autoDispose.family<int, String>((ref, chatDoc) {
  int count = 0;
  final thisUserId = ref.read(userProvider)!.id;
  final collDoc = ChatCollectionDocModel(FirebaseCollections.chats, chatDoc);
  ref.watch(chatNotifierProvider(collDoc)).forEach((message) {
    if (message.receiverId == thisUserId) {
      if (message.isUnread) count++;
    }
  });
  return count < 100 ? count : 99;
});
