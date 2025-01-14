final class StatusCodeException implements Exception {
  const StatusCodeException({
    required this.statusCode,
    required this.message,
    this.data,
  });

  final int statusCode;
  final String message;
  final dynamic data;
}
