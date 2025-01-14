import 'dart:io' show File;

import 'package:flutter/rendering.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/end_points.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/firebase/firebase_firestore_service.dart';
import '../../../../core/services/api_service.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/chat_collection_doc_model.dart';
import '../../data/models/message_model.dart';
import 'active_status_notifier.dart';

final class ChatNotifier extends StateNotifier<List<MessageModel>> {
  ChatNotifier(this._ref, ChatCollectionDocModel data)
      : _chatDoc = data.doc,
        _collection = data.collection,
        _firestore = FirebaseFirestoreService(_ref, data.collection),
        _api = _ref.read(apiProvider),
        _thisUser = _ref.read(userProvider)!,
        super([]) {
    _chatName = _thisUser.type == UserType.client
        ? _thisUser.name
        : _thisUser.storeName!;
    _getChatMessages();
  }
  final Ref _ref;
  final ApiService _api;
  final FirebaseFirestoreService _firestore;
  final String _chatDoc;
  final String _collection;
  final UserModel _thisUser;

  late final String _chatName;

  void _getChatMessages() {
    _firestore.getChatMessages(
      _chatDoc,
      onData: (messages) => state = messages,
    );
  }

  Future<void> sendChatMessage(MessageModel message, String? orderName) {
    return _firestore.sendChatMessage(message).then((_) {
      _sendNotification(message.receiverId, message.content, orderName);
    });
  }

  Future<void> sendChatImage(
      MessageModel message, File image, String? orderName) {
    return _firestore.sendChatImage(message, image).then((_) {
      _sendNotification(message.receiverId, 'أرسل لك صورة 🖼️', orderName);
    });
  }

  Future<void> sendChatAudio(MessageModel message, String? orderName) {
    return _firestore.sendChatAudio(message).then((_) {
      _sendNotification(message.receiverId, 'أرسل لك صوت 🎙️', orderName);
    });
  }

  Future<void> updateMessageReadStatus(String messageDoc) {
    return _firestore.updateMessageReadStatus(messageDoc);
  }

  void _sendNotification(
      int recieverId, String message, String? orderName) async {
    final presence = _ref.read(activeStatusNotifierProvider(recieverId));
    if (presence == UserPresence.offline) {
      try {
        await _api.post(
          EndPoints.notification,
          body: {'title': orderName = _thisUser.name,
            // 'title': orderName == null
            //     ? _thisUser.name
            //     : '${_thisUser.name} - عرض $orderName',
            'message': message,
            'receiver_id': recieverId,
            'doc': _chatDoc,
            'id': _thisUser.id,
            'name': _chatName,
            'image': _thisUser.image,
            'type': _collection,
          },
        );
        debugPrint('Success send chat notification => $message');
      } catch (e) {
        debugPrint('Failed send chat notification => $e');
      }
    }
  }
}

final chatNotifierProvider = StateNotifierProvider.autoDispose
    .family<ChatNotifier, List<MessageModel>, ChatCollectionDocModel>(
        ChatNotifier.new);
