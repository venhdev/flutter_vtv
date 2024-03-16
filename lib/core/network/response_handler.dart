import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' show Response;

import '../constants/typedef.dart';
import '../error/exceptions.dart';
import 'base_response.dart';

SuccessResponse handleResponseNoData(Response response, String url) {
  log('call API: $url');

  // decode response using utf8
  final utf8BodyMap = utf8.decode(response.bodyBytes);
  final decodedBody = jsonDecode(utf8BodyMap);

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return SuccessResponse(
      code: response.statusCode,
      message: decodedBody['message'],
      status: decodedBody['status'] ?? 'unknown status',
    );
  } else {
    throwResponseException(
      code: response.statusCode,
      message: decodedBody['message'],
      url: url,
    );
  }
}

DataResponse<T> handleResponseWithData<T>(
  Response response,
  String url,
  T Function(Map<String, dynamic> jsonMap) fromMap,
) {
  log('call API: $url');
  // decode response using utf8
  final utf8BodyMap = utf8.decode(response.bodyBytes);
  final decodedBodyMap = jsonDecode(utf8BodyMap);

  if (response.statusCode >= 200 && response.statusCode < 300) {
    final result = fromMap(decodedBodyMap);
    return DataResponse(
      result,
      code: response.statusCode,
      message: decodedBodyMap['message'],
    );
  } else {
    throwResponseException(
      code: response.statusCode,
      message: decodedBodyMap['message'],
      url: url,
    );
  }
}

Never throwResponseException({
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

// handle data response from data source
FRespData<T> handleDataResponseFromDataSource<T>({
  required Future<DataResponse<T>> Function() dataCallback,
}) async {
  try {
    return Right(await dataCallback());
  } on ClientException catch (e) {
    return Left(ClientError(code: e.code, message: e.message));
  } on ServerException catch (e) {
    return Left(ServerError(code: e.code, message: e.message));
  } catch (e) {
    return Left(UnexpectedError(message: e.toString()));
  }
}

// handle success response from data source
FResp handleSuccessResponseFromDataSource({
  // SuccessResponse? data,
  required Future<SuccessResponse> Function() noDataCallback,
}) async {
  try {
    return Right(await noDataCallback());
  } on ClientException catch (e) {
    return Left(ClientError(code: e.code, message: e.message));
  } on ServerException catch (e) {
    return Left(ServerError(code: e.code, message: e.message));
  } catch (e) {
    return Left(UnexpectedError(message: e.toString()));
  }
}
