import 'dart:convert';

import 'package:http/http.dart' show Response;

import '../error/exceptions.dart';
import 'base_response.dart';

SuccessResponse handleResponseNoData(Response response, String url) {
  // decode response using utf8
  final utf8BodyMap = utf8.decode(response.bodyBytes);
  final decodedBody = jsonDecode(utf8BodyMap);

  if (response.statusCode == 200 && decodedBody['code'] == 200) {
    return SuccessResponse(
      code: response.statusCode,
      message: decodedBody['message'],
    );
  } else {
    throwException(
      code: response.statusCode,
      message: decodedBody['message'],
      url: url,
    );
  }
}

Never throwException({
  required String message,
  required int code,
  String? url,
}) {
  if (code >= 500) {
    throw ServerException(
      code: code,
      message: message,
      uri: url != null ? Uri.parse(url) : null,
    );
  } else if (code >= 400) {
    throw ClientException(
      code: code,
      message: message,
      uri: url != null ? Uri.parse(url) : null,
    );
  } else {
    throw Exception(message);
  }
}
