import 'dart:async' show TimeoutException;
import 'dart:io' show HandshakeException, SocketException;

String exceptionHandler(Object? e) {
  if (e is SocketException || e is HandshakeException) {
    return 'لا يوجد اتصال بالإنترنت';
  } else if (e is TimeoutException ||
      e.toString().contains('Connection closed')) {
    return 'يبدو أن اتصالك بلإنترنت ضعيف';
  } else {
    return '$e';
  }
}
