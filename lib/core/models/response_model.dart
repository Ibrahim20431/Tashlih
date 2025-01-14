import 'dart:convert' show jsonDecode;

import 'package:flutter/rendering.dart' show debugPrint;
import 'package:http/http.dart' show Response;

final class ResponseModel {
  const ResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.errors,
  });

  final bool success;
  final int statusCode;
  final String message;
  final dynamic data;
  final Map<String, List> errors;

  factory ResponseModel.fromJson(Response response) {
    const error = 'حصل خطأ ما في الوجهه';
    Map<String, dynamic> body = {};
    if (response.body.isNotEmpty) body = jsonDecode(response.body);
    debugPrint('response => $body');
    Map<String, dynamic> errs = body['errors'] ?? {};
    return ResponseModel(
      success: body['success'] ?? false,
      statusCode: response.statusCode,
      data: body['data'],
      message: body['message'] ?? error,
      errors: Map<String, List>.from(errs),
    );
  }
}
