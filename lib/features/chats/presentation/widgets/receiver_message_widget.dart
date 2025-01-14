import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../controllers/notifiers/chat_notifier.dart';
import '../../data/models/chat_collection_doc_model.dart';
import '../../data/models/message_model.dart';
import 'message_widget.dart';

class ReceiverMessageWidget extends ConsumerStatefulWidget {
  const ReceiverMessageWidget({
    super.key,
    required this.userImage,
    required this.collectionDoc,
    required this.message,
  });

  final String userImage;
  final ChatCollectionDocModel collectionDoc;
  final MessageModel message;

  @override
  ConsumerState<ReceiverMessageWidget> createState() => _ReceiverMessageWidgetState();
}

class _ReceiverMessageWidgetState extends ConsumerState<ReceiverMessageWidget> {
  @override
  void initState() {
    super.initState();
    final message = widget.message;
    if(message.isUnread){
        ref
            .read(chatNotifierProvider(widget.collectionDoc).notifier)
            .updateMessageReadStatus(message.doc);
    }
  }
  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    return MessageWidget(
      direction: TextDirection.ltr,
      userImage: widget.userImage,
      cardColor: AppColors.grey,
      textColor: Colors.black,
      collectionDoc: widget.collectionDoc,
      message: message,
    );
  }
}
