enum UserType { client, trader }

enum StoreType { notSpecial, special }

enum AuthType { login, signup }

enum OrderOfferStatus {
  waiting,
  paymentWaiting,
  paymentVerifying,
  payed,
  shipping,
  completed,
  rejected
}

enum ApiMethod { get, post, put, patch }

enum MessageType { text, image, audio }

enum MessageStatus { sending, sent, read, failed }

enum UserPresence { online, offline }

enum AudioPlayerState { paused, playing, notExist, loading }

enum MessageSenderType { send, record, recording }

enum DownloadStatus { init, loading, downloading, complete, failed }