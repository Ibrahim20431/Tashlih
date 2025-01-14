import 'package:cloud_firestore/cloud_firestore.dart' show FieldValue;

import '../../../../core/constants/key_enums.dart';
import '../../../../core/firebase/firebase_keys.dart';

final class MessageModel {
  MessageModel({
    required this.receiverId,
    this.content = '',
    this.imageAspectRatio,
    this.audioSeconds,
  });

  late final String doc;
  late final int senderId;
  final int receiverId;
  final String content;
  late final DateTime sentAt;
  late final MessageType type;
  late final MessageStatus status;
  final double? imageAspectRatio;
  final int? audioSeconds;

  bool get isStartChat => senderId == receiverId;

  bool get isUnread => status == MessageStatus.sent;

  factory MessageModel.init() => MessageModel(receiverId: 0)
    ..senderId = 0
    ..sentAt = DateTime.now()
    ..status = MessageStatus.sent
    ..type = MessageType.text;

  factory MessageModel.fromMap(String doc, Map<String, dynamic> map) {
    final sentDate = map[FirebaseFields.sentAt]?.toDate();
    final type = MessageType.values.byName(map[FirebaseFields.type]);
    final MessageStatus status;
    if (map[FirebaseFields.failed] == null) {
      final fileUploaded = map[FirebaseFields.fileUploaded] ?? false;
      if (sentDate == null || (type != MessageType.text && !fileUploaded)) {
        status = MessageStatus.sending;
      } else {
        status = map[FirebaseFields.readAt] != null
            ? MessageStatus.read
            : MessageStatus.sent;
      }
    } else {
      status = MessageStatus.failed;
    }
    int? audioLength;
    if (type == MessageType.audio) {
      audioLength = map[FirebaseFields.audioSeconds];
    }
    return MessageModel(
        receiverId: map[FirebaseFields.receiverId],
        content: map[FirebaseFields.content],
        imageAspectRatio: map[FirebaseFields.imageAspectRatio],
        audioSeconds: audioLength)
      ..doc = doc
      ..senderId = map[FirebaseFields.senderId]
      ..sentAt = sentDate ?? DateTime.now()
      ..type = MessageType.values.byName(map[FirebaseFields.type])
      ..status = status;
  }

  Map<String, dynamic> textToMap(int senderId) => {
        FirebaseFields.senderId: senderId,
        FirebaseFields.receiverId: receiverId,
        FirebaseFields.content: content,
        FirebaseFields.sentAt: FieldValue.serverTimestamp(),
        FirebaseFields.type: MessageType.text.name,
      };

  Map<String, dynamic> imageToMap(int senderId, String imagePath) => {
        FirebaseFields.senderId: senderId,
        FirebaseFields.receiverId: receiverId,
        FirebaseFields.content: imagePath,
        FirebaseFields.sentAt: FieldValue.serverTimestamp(),
        FirebaseFields.type: MessageType.image.name,
        FirebaseFields.imageAspectRatio: imageAspectRatio,
      };

  Map<String, dynamic> audioToMap(int senderId, String name) => {
        FirebaseFields.senderId: senderId,
        FirebaseFields.receiverId: receiverId,
        FirebaseFields.content: name,
        FirebaseFields.sentAt: FieldValue.serverTimestamp(),
        FirebaseFields.type: MessageType.audio.name,
        FirebaseFields.audioSeconds: audioSeconds,
      };
}
