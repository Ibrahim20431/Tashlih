import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/firebase/firebase_keys.dart';
import '../../../../core/widgets/login_card.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../../chats/controllers/notifiers/start_chat_notifier.dart';
import '../../../chats/data/models/chat_model.dart';

class StartChatButton extends ConsumerWidget {
  const StartChatButton(this.chat, {super.key, this.fixedSize});

  final ChatModel chat;
  final Size? fixedSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(fixedSize: fixedSize),
      onPressed: () {
        final isLogged = ref.read(userProvider) != null;
        if (isLogged) {
          ref
              .read(
                  startChatNotifierProvider(FirebaseCollections.chats).notifier)
              .createChat(chat);
        } else {
          showDialog(
            context: context,
            builder: (_) => const Dialog(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.padding32),
                child: LoginCard(),
              ),
            ),
          );
        }
      },
      child: const Text('محادثة'),
    );
  }
}
