import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/key_enums.dart';
import '../../data/models/chat_collection_doc_model.dart';
import '../../data/models/message_model.dart';
import 'message_widget.dart';

class SenderMessageWidget extends ConsumerWidget {
  const SenderMessageWidget({
    super.key,
    required this.userImage,
    required this.message,
    required this.collectionDoc,
  });

  final String userImage;
  final MessageModel message;
  final ChatCollectionDocModel collectionDoc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MessageWidget(
      direction: TextDirection.rtl,
      userImage: userImage,
      cardColor: primaryColor,
      textColor: Colors.white,
      message: message,
      collectionDoc: collectionDoc,
      status: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 2),
          Icon(
            switch (message.status) {
              MessageStatus.sending => Icons.access_time_rounded,
              MessageStatus.sent => Icons.done_rounded,
              MessageStatus.read => Icons.done_all_rounded,
              MessageStatus.failed => Icons.cancel_outlined,
            },
            size: 12,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
