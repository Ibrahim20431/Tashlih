import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;

import '../../features/auth/controllers/providers/user_provider.dart';
import '../../features/chats/data/models/chat_model.dart';
import '../../features/chats/data/models/message_model.dart';
import '../constants/key_enums.dart';
import 'firebase_keys.dart';

final class FirebaseFirestoreService {
  FirebaseFirestoreService(Ref ref, String collection) {
    final user = ref.read(userProvider)!;
    _thisUser = ChatModel(
      id: user.id,
      name: user.name,
      image: user.image,
    );
    _chatsRef = FirebaseFirestore.instance.collection(collection);
    _storageRef = FirebaseStorage.instance.ref(collection);
    _hasLastMessageAt = collection == FirebaseCollections.chats;
  }

  late final CollectionReference<Map<String, dynamic>> _chatsRef;
  late final Reference _storageRef;
  late final ChatModel _thisUser;
  late final bool _hasLastMessageAt;
  late String _chatDoc;

  Future<ChatModel> getOrCreateChat(ChatModel chatUser) async {
    final chat = await _getChat(chatUser.id);
    if (chat != null) return chat;
    return _createChat(chatUser);
  }

  Future<ChatModel> createOfferChat(ChatModel chatUser) {
    return _createChat(chatUser);
  }

  Future<ChatModel?> _getChat(int receiverId) {
    return _chatsRef
        .where(Filter.and(
          Filter(
            FirebaseFields.chatUserId(FirebaseFields.n1),
            whereIn: [_thisUser.id, receiverId],
          ),
          Filter(
            FirebaseFields.chatUserId(FirebaseFields.n2),
            whereIn: [_thisUser.id, receiverId],
          ),
        ))
        .limit(1)
        .get()
        .then((chats) {
      final docs = chats.docs;
      if (docs.isNotEmpty) {
        final doc = docs.first;
        return ChatModel.fromFirebaseMap(doc.id, _thisUser.id, doc.data());
      } else {
        return null;
      }
    });
  }

  Future<ChatModel> _createChat(ChatModel chatUser) {
    return _chatsRef.add({
      FirebaseFields.createdAt: FieldValue.serverTimestamp(),
      FirebaseCollections.users: {
        FirebaseFields.n1: _thisUser.toMap(),
        FirebaseFields.n2: chatUser.toMap(),
      },
    }).then((chat) {
      return ChatModel(
        doc: chat.id,
        id: chatUser.id,
        name: chatUser.name,
        image: chatUser.image,
      );
    });
  }

  void getChats({
    required void Function(List<ChatModel>) onData,
    void Function(Object)? onError,
  }) {
    return _chatsRef
        .where(
          Filter.or(
            Filter(
              FirebaseFields.chatUserId(FirebaseFields.n1),
              isEqualTo: _thisUser.id,
            ),
            Filter(
              FirebaseFields.chatUserId(FirebaseFields.n2),
              isEqualTo: _thisUser.id,
            ),
          ),
        )
        .orderBy(FirebaseFields.lastMessageAt, descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((chats) {
      onData(chats.docs
          .map((doc) =>
              ChatModel.fromFirebaseMap(doc.id, _thisUser.id, doc.data()))
          .toList());
    }).onError(onError);
  }

  void getChatMessages(
    String doc, {
    required void Function(List<MessageModel>) onData,
    void Function(Object)? onError,
  }) {
    _chatDoc = doc;
    return _chatsRef
        .doc(_chatDoc)
        .collection(FirebaseCollections.messages)
        .where(
          Filter.or(
            Filter(FirebaseFields.type, isEqualTo: MessageType.text.name),
            Filter(FirebaseFields.senderId, isEqualTo: _thisUser.id),
            Filter(FirebaseFields.fileUploaded, isEqualTo: true),
          ),
        )
        .orderBy(FirebaseFields.sentAt)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      onData(messages.docs
          .map((doc) => MessageModel.fromMap(doc.id, doc.data()))
          .toList());
    }).onError(onError);
  }

  Future<DocumentReference<Map<String, dynamic>>> sendChatMessage(
      MessageModel message) {
    return _sendMessage(message.textToMap);
  }

  Future<void> sendChatImage(
    MessageModel message,
    File image,
  ) async {
    final fileData = await _saveFile(
      FirebaseCollections.localeImagesPath,
      image,
    );
    final file = fileData.file;
    _sendMessage((userId) => message.imageToMap(userId, file.path)).then((doc) {
      message.doc = doc.id;
    });
    final ref = _fileRef(FirebaseCollections.images, fileData.name);
    await ref.putData(
      image.readAsBytesSync(),
      SettableMetadata(contentType: 'image/${fileData.ext}'),
    );
    file.delete();
    final imageUrl = await ref.getDownloadURL();
    return _updateMessage(message.doc, {
      FirebaseFields.fileUploaded: true,
      FirebaseFields.sentAt: FieldValue.serverTimestamp(),
      FirebaseFields.content: imageUrl,
    });
  }

  Future<void> sendChatAudio(MessageModel message) async {
    final audio = File(message.content);
    final fileData = await _saveFile(
      FirebaseCollections.localeAudiosPath,
      audio,
    );
    final name = fileData.name;
    _sendMessage((userId) => message.audioToMap(userId, name)).then((doc) {
      message.doc = doc.id;
    });
    final ref = _fileRef(FirebaseCollections.audios, name);
    await ref.putData(
      audio.readAsBytesSync(),
      SettableMetadata(contentType: 'audio/${fileData.ext}'),
    );
    return _updateMessage(message.doc, {
      FirebaseFields.fileUploaded: true,
      FirebaseFields.sentAt: FieldValue.serverTimestamp(),
    });
  }

  Reference _fileRef(String directory, String name) {
    return _storageRef.child(directory).child(_chatDoc).child(name);
  }

  Future<DocumentReference<Map<String, dynamic>>> _sendMessage(
      Map<String, dynamic> Function(int) message) {
    final chatDoc = _chatsRef.doc(_chatDoc);
    final messageDoc = chatDoc
        .collection(FirebaseCollections.messages)
        .add(message(_thisUser.id));
    if (_hasLastMessageAt) {
      chatDoc.update({
        FirebaseFields.lastMessageAt: FieldValue.serverTimestamp(),
      });
    }
    return messageDoc;
  }

  void setMessageFailed(String doc) {
    _updateMessage(doc, {FirebaseFields.failed: true});
  }

  Future<void> updateMessageReadStatus(String doc) {
    return _updateMessage(
      doc,
      {FirebaseFields.readAt: FieldValue.serverTimestamp()},
    );
  }

  Future<void> _updateMessage(String doc, Map<Object, Object?> data) {
    return _chatsRef
        .doc(_chatDoc)
        .collection(FirebaseCollections.messages)
        .doc(doc)
        .update(data);
  }

  Future<({File file, String ext, String name})> _saveFile(
      String directory, File file) async {
    final ext = file.path.split('.').last;
    final name =
        '${_thisUser.id}-${DateTime.now().millisecondsSinceEpoch}.$ext';
    final savedFile = await _saveFileLocally(
      '$directory/$name',
      file.readAsBytesSync(),
    );
    return (file: savedFile, ext: ext, name: name);
  }

  Future<File> _saveFileLocally(String path, List<int> bytes) async {
    final file = await File(path).create(recursive: true);
    return file.writeAsBytes(bytes);
  }
}
