import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/helpers/format_date_time.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../controllers/notifiers/chat_notifier.dart';
import '../../data/models/chat_collection_doc_model.dart';
import '../../data/models/chat_model.dart';
import 'message_input_field/message_input_widget.dart';
import 'receiver_message_widget.dart';
import 'sender_message_widget.dart';

class ConversationWidget extends ConsumerStatefulWidget {
  const ConversationWidget(
    this.chat,
    this.collection, {
    super.key,
    this.orderName,
  });

  final String collection;
  final ChatModel chat;
  final String? orderName;

  @override
  ConsumerState<ConversationWidget> createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends ConsumerState<ConversationWidget> {
  final _ensureVisibleKey = GlobalKey();

  late final ChatModel _chat;
  late final ChatCollectionDocModel _collectionDoc;
  late final int _thisUserId;
  late final String _thisUserImage;
  late final String? _orderName;

  @override
  void initState() {
    super.initState();
    _chat = widget.chat;
    _collectionDoc = ChatCollectionDocModel(widget.collection, _chat.doc);
    final user = ref.read(userProvider)!;
    _thisUserId = user.id;
    _thisUserImage = user.image;
    _orderName = widget.orderName;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPadding,
      ),
      child: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (_, WidgetRef ref, __) {
                final messages =
                    ref.watch(chatNotifierProvider(_collectionDoc));
                if (messages.isNotEmpty) {
                  final count = messages.length;
                  return SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      children: [
                        _DateDivider(messages.first.sentAt),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(
                            AppDimensions.screenPadding,
                          ),
                          itemBuilder: (_, int index) {
                            final message = messages[index];
                            if (message.senderId == _thisUserId) {
                              return SenderMessageWidget(
                                userImage: _thisUserImage,
                                message: message,
                                collectionDoc: _collectionDoc,
                              );
                            } else {
                              return ReceiverMessageWidget(
                                collectionDoc: _collectionDoc,
                                userImage: _chat.image,
                                message: message,
                              );
                            }
                          },
                          separatorBuilder: (_, int index) {
                            final messageAt = messages[index].sentAt;
                            final nextMessageAt = messages[index + 1].sentAt;
                            if (nextMessageAt.day == messageAt.day) {
                              return const SizedBox();
                            } else {
                              return _DateDivider(nextMessageAt);
                            }
                          },
                          itemCount: count,
                        ),
                        SizedBox(key: _ensureVisibleKey)
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'تحل بآداب المحادثة \nابدأ محادثتك بشكل لطيف',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),
          ),
          MessageInputWidget(
            _ensureVisibleKey,
            _chat.doc,
            _chat.id,
            _collectionDoc,
            _orderName,
          ),
          SizedBox(height: context.navigationBarHeight),
          if (Platform.isAndroid) const SizedBox(height: 8)
        ],
      ),
    );
  }
}

class _DateDivider extends StatelessWidget {
  const _DateDivider(this.date);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(formatDate(date)),
      ),
    );
  }
}
