import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../chats/controllers/notifiers/start_chat_notifier.dart';
import '../../../chats/data/models/chat_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/firebase/firebase_keys.dart';

class OpenChatIcon extends ConsumerWidget {
  const OpenChatIcon(this.chat, {super.key});

  final ChatModel chat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      style: IconButton.styleFrom(
          foregroundColor: primaryColor,
          visualDensity: const VisualDensity(
            vertical: VisualDensity.minimumDensity,
            horizontal: VisualDensity.minimumDensity,
          )),
      onPressed: () {
        ref
            .read(startChatNotifierProvider(FirebaseCollections.chats).notifier)
            .createChat(chat);
      },
      icon: const Icon(Icons.chat),
    );
  }
}
