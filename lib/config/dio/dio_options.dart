import 'package:dio/dio.dart';

final dioOptions = BaseOptions(
  connectTimeout: const Duration(seconds: 3),
  receiveTimeout: const Duration(seconds: 3),
  contentType: Headers.jsonContentType,
);
