import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../controllers/notifiers/chat_notifier.dart';
import '../../data/models/chat_collection_doc_model.dart';
import '../../data/models/message_model.dart';
import 'send_message_widget.dart';

class ChatPickedImageView extends ConsumerWidget {
  const ChatPickedImageView(
    this.image,
    this.collectionDocModel,
    this.receiverId,
    this.orderName, {
    super.key,
  });

  final File image;
  final ChatCollectionDocModel collectionDocModel;
  final int receiverId;
  final String? orderName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Column(
        children: [
          Expanded(child: Center(child: Image.file(image))),
          const SizedBox(height: 8),
          SendMessageWidget(
            onTap: () async {
              decodeImageFromList(image.readAsBytesSync()).then((decodedImage) {
                final message = MessageModel(
                  receiverId: receiverId,
                  imageAspectRatio: decodedImage.width / decodedImage.height,
                  content: image.path,
                );
                ref
                    .read(chatNotifierProvider(collectionDocModel).notifier)
                    .sendChatImage(message, image, orderName);
                context.pop();
              });
            },
          ),
          SizedBox(height: context.navigationBarHeight + 16),
        ],
      ),
    );
  }
}
