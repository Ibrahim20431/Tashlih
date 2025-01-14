import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/firebase/firebase_keys.dart';
import '../../../../core/utils/helpers/format_date_time.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../controllers/notifiers/chat_notifier.dart';
import '../../controllers/providers/new_messages_count_provider.dart';
import '../../data/models/chat_collection_doc_model.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/message_model.dart';
import '../views/chat_view.dart';
import 'chat_image.dart';

class ChatWidget extends ConsumerWidget {
  ChatWidget(this.chat, {super.key})
      : collectionDocModel = ChatCollectionDocModel(
          FirebaseCollections.chats,
          chat.doc,
        );

  final ChatModel chat;
  final ChatCollectionDocModel collectionDocModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatNotifierProvider(collectionDocModel));
    final lastMessage =
        messages.isNotEmpty ? messages.last : MessageModel.init();
    final isMyMessage = ref.read(userProvider)!.id == lastMessage.senderId;
    final sentAt = lastMessage.sentAt;
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () => context.push(ChatView(chat)),
      leading: ChatImage(
        userId: chat.id,
        radius: 30,
        image: chat.image,
        bottomPosition: 10,
      ),
      title: Text(chat.name, style: TextStyles.largeBold),
      subtitle: Row(
        children: [
          Text(
            '${isMyMessage ? 'أنا' : 'هو'}: ',
            style: TextStyles.smallRegular.copyWith(
              color: Colors.grey,
            ),
          ),
          switch (lastMessage.type) {
            MessageType.text => Expanded(
                child: Text(
                  lastMessage.content,
                  style: TextStyles.mediumRegular,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            MessageType.image => const Icon(Icons.image_rounded, size: 14),
            MessageType.audio => const Icon(Icons.mic_rounded, size: 14),
          }
        ],
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatDate(sentAt), style: TextStyles.xSmallRegular),
                Text(formatTime(sentAt), style: TextStyles.xSmallRegular),
              ],
            ),
            Consumer(
              builder: (_, WidgetRef ref, __) {
                final count = ref.watch(newMessagesCountProvider(chat.doc));
                if (count > 0) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      child: Text(
                        '$count',
                        style: TextStyles.smallBold,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
