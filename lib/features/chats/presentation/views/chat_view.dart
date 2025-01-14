import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../../../../core/constants/globals.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/firebase/firebase_keys.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../data/models/chat_model.dart';
import '../widgets/chat_image.dart';
import '../widgets/conversation_widget.dart';

class ChatView extends StatefulWidget {
  const ChatView(this.chat, {super.key});

  final ChatModel chat;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    super.initState();
    openChatDoc = widget.chat.doc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppScaffold(
        centerTitle: false,
        leadingWidth: 90,
        leading: Row(
          children: [
            IconButton(
              icon: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Platform.isIOS
                      ? Icons.arrow_back_ios_rounded
                      : Icons.arrow_back_rounded,
                ),
              ),
              onPressed: context.pop,
            ),
            ChatImage(
              userId: widget.chat.id,
              radius: 20,
              image: widget.chat.image,
              bottomPosition: 2,
            ),
          ],
        ),
        title: widget.chat.name,
        body: ConversationWidget(widget.chat, FirebaseCollections.chats),
      ),
    );
  }

  @override
  void dispose() {
    openChatDoc = '';
    super.dispose();
  }
}
