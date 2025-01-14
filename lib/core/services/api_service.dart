import 'dart:convert' show jsonEncode;

import 'package:flutter/rendering.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider, Ref;
import 'package:http/http.dart' as http;

import '../constants/key_enums.dart';
import '../models/response_model.dart';
import '../providers/response_provider.dart';

final apiProvider = Provider.autoDispose<ApiService>(ApiService.new);

final class ApiService {
  const ApiService(this._ref);

  final Ref _ref;

  static String? token;
  static const String baseUrl = 'https://tashleh.app/api/v2';
  static const _timeout = Duration(seconds: 20);

  Future<ResponseModel> get(
    String endPoint, {
    Map<String, String>? parameters,
  }) async {
    debugPrint('HTTPS GET');
    final response = await http
        .get(_getUri(endPoint, parameters), headers: _requestHeaders())
        .timeout(_timeout);
    return _setAndReturnResponse(response);
  }

  Future<ResponseModel> post(
    String endPoint, {
    Map<String, String>? parameters,
    Map<String, dynamic>? body,
  }) async {
    debugPrint('HTTPS POST');
    debugPrint('body => $body');
    final response = await http
        .post(
          _getUri(endPoint, parameters),
          headers: _requestHeaders(),
          body: jsonEncode(body),
        )
        .timeout(_timeout);
    return _setAndReturnResponse(response);
  }

  Future<ResponseModel> put(
    String endPoint, {
    Map<String, String>? parameters,
    Map<String, dynamic>? body,
  }) async {
    debugPrint('HTTPS PUT');
    debugPrint('body => $body');
    final response = await http
        .put(
          _getUri(endPoint, parameters),
          headers: _requestHeaders(),
          body: jsonEncode(body),
        )
        .timeout(_timeout);
    return _setAndReturnResponse(response);
  }

  Future<ResponseModel> patch(
    String endPoint, {
    Map<String, String>? parameters,
    Map<String, dynamic>? body,
  }) async {
    debugPrint('HTTPS PATCH');
    debugPrint('body => $body');
    final response = await http
        .patch(
          _getUri(endPoint, parameters),
          headers: _requestHeaders(),
          body: jsonEncode(body),
        )
        .timeout(_timeout);
    return _setAndReturnResponse(response);
  }

  Future<ResponseModel> delete(
    String endPoint, {
    Map<String, String>? parameters,
    Map<String, dynamic>? body,
  }) async {
    debugPrint('HTTPS DELETE');
    debugPrint('body => $body');
    final response = await http
        .delete(
          _getUri(endPoint, parameters),
          headers: _requestHeaders(),
          body: jsonEncode(body),
        )
        .timeout(_timeout);
    return _setAndReturnResponse(response);
  }

  Future<ResponseModel> postWithFile(
    String endPoint, {
    required Map<String, String> body,
    required Map<String, String>? files,
    Map<String, String>? parameters,
  }) async {
    debugPrint('HTTPS POST FILE');
    debugPrint('body => $body');
    debugPrint('files => $files');
    return _fileRequest(ApiMethod.post, endPoint, parameters, body, files);
  }

  Future<ResponseModel> putWithFile(
    String endPoint, {
    required Map<String, String> body,
    required Map<String, String>? files,
    Map<String, String>? parameters,
  }) async {
    debugPrint('HTTPS PUT FILE');
    debugPrint('body => $body');
    debugPrint('files => $files');
    return _fileRequest(ApiMethod.put, endPoint, parameters, body, files);
  }

  Future<ResponseModel> patchWithFile(
    String endPoint, {
    required Map<String, String> body,
    required Map<String, String> files,
    Map<String, String>? parameters,
  }) async {
    debugPrint('HTTPS PATCH FILE');
    debugPrint('body => $body');
    debugPrint('files => $files');
    return _fileRequest(ApiMethod.patch, endPoint, parameters, body, files);
  }

  static Uri _getUri(String endPoint, [Map<String, String>? parameters]) {
    final String url = '$baseUrl/$endPoint';
    debugPrint('url => $url');
    debugPrint('parameters => $parameters');
    return Uri.parse(url).replace(queryParameters: parameters);
  }

  static Map<String, String> _requestHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Map<String, String> _multipartHeaders() {
    return {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<ResponseModel> _fileRequest(
    ApiMethod method,
    String endPoint,
    Map<String, String>? parameters,
    Map<String, String> body,
    Map<String, String>? files,
  ) async {
    final request = http.MultipartRequest("POST", _getUri(endPoint, parameters))
      ..headers.addAll(_multipartHeaders())
      ..fields.addAll({...body, '_method': method.name});
    files?.forEach((key, value) async {
      request.files.add(await http.MultipartFile.fromPath(key, value));
    });

    final responses = await request.send();
    final response = await http.Response.fromStream(responses);

    return _setAndReturnResponse(response);
  }

  ResponseModel _setAndReturnResponse(http.Response response) {
    final responseModel = ResponseModel.fromJson(response);
    _ref.read(responseProvider.notifier).state = responseModel;
    return responseModel;
  }
}
