abstract final class FirebaseFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String image = 'image';
  static const String n1 = '1';
  static const String n2 = '2';
  static const String lastMessage = 'last_message';
  static const String lastMessageAt = 'last_message_at';
  static const String senderId = 'sender_id';
  static const String receiverId = 'receiver_id';
  static const String sentAt = 'sent_at';
  static const String readAt = 'read_at';
  static const String content = 'content';
  static const String audioSeconds = 'audio_seconds';
  static const String imageAspectRatio = 'image_aspect_ratio';
  static const String fileUploaded = 'file_uploaded';
  static const String type = 'type';
  static const String presence = 'presence';
  static const String createdAt = 'created_at';
   static const String failed = 'failed';

  static String chatUserId(String doc) {
    return '${FirebaseCollections.users}.$doc.${FirebaseFields.id}';
  }
}

abstract final class FirebaseCollections {
  static const String chats = 'chats';
  static const String offerChats = 'offer_chats';
  static const String messages = 'messages';
  static const String images = 'images';
  static const String audios = 'audios';
  static const String users = 'users';

  static late final String localeAudiosPath;
  static late final String localeImagesPath;
}

