import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tashlihi/core/firebase/firebase_keys.dart';
import 'package:tashlihi/features/chats/presentation/views/image_gallery_view.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/utils/helpers/format_date_time.dart';
import '../../data/models/chat_collection_doc_model.dart';
import '../../data/models/message_model.dart';
import 'audio_message_widget.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.direction,
    required this.userImage,
    required this.cardColor,
    required this.textColor,
    required this.message,
    required this.collectionDoc,
    this.status = const SizedBox(),
  });

  final TextDirection direction;
  final String userImage;
  final MaterialColor cardColor;
  final Color textColor;
  final MessageModel message;
  final ChatCollectionDocModel collectionDoc;
  final Widget status;

  @override
  Widget build(BuildContext context) {
    final type = message.type;
    return Directionality(
      textDirection: direction,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundImage: CachedNetworkImageProvider(userImage),
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(top: 20, start: 2),
            padding: EdgeInsets.symmetric(
              vertical: type == MessageType.text ? 4 : 8,
              horizontal: 8,
            ),
            constraints: BoxConstraints(
              maxWidth: (context.width * .9) - AppDimensions.chatMessagePadding,
            ),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(5),
                bottomStart: Radius.circular(5),
                topEnd: Radius.circular(5),
              ),
            ),
            child: Directionality(
              textDirection: Directionality.of(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  switch (type) {
                    MessageType.text => Text(
                        message.content,
                        style: TextStyles.mediumRegular.copyWith(
                          color: textColor,
                        ),
                      ),
                    MessageType.image => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                          child: AspectRatio(
                            aspectRatio: message.imageAspectRatio!,
                            child: message.status != MessageStatus.sending
                                ? GestureDetector(
                                    onTap: () => context.push(
                                      ImageGalleryView(message.content, false),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: message.content,
                                      fit: BoxFit.cover,
                                      placeholder: (_, __) =>
                                          ColoredBox(color: cardColor[400]!),
                                      errorWidget: (_, __, ___) => const Icon(
                                        Icons.image,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => context.push(
                                      ImageGalleryView(message.content, true),
                                    ),
                                    child: Image.file(
                                      File(message.content),
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.image,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    MessageType.audio => AudioMessageWidget(
                        '${FirebaseCollections.localeAudiosPath}/${message.content}',
                        message.audioSeconds!,
                        firebasePath:
                            '${collectionDoc.collection}/${FirebaseCollections.audios}/${collectionDoc.doc}/${message.content}',
                        foregroundColor: textColor,
                        backgroundColor: cardColor,
                      )
                  },
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formatTime(message.sentAt),
                        style: TextStyles.xSmallRegular.copyWith(
                          color: textColor,
                        ),
                      ),
                      status
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
