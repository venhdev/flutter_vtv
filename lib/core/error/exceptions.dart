const String serverExceptionMessage = 'Server Exception';
const String clientExceptionMessage = 'Client Exception';
const String cacheExceptionMessage = 'Cache Exception';
// const String formatExceptionMessage = 'Format Exception';

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

class ServerException implements Exception {
  ServerException({
    this.code = 500,
    this.message = serverExceptionMessage,
    this.uri,
  });

  final int code;
  final String message;

  /// The URL of the HTTP request or response that failed.
  final Uri? uri;

  @override
  String toString() {
    if (uri != null) {
      return 'ServerException: $message, uri=$uri';
    } else {
      return 'ServerException: $message';
    }
  }
}

class ClientException implements Exception {
  ClientException({
    this.code = 400,
    this.message = serverExceptionMessage,
    this.uri,
  });

  final int code;
  final String message;

  /// The URL of the HTTP request or response that failed.
  final Uri? uri;

  @override
  String toString() {
    if (uri != null) {
      return 'ClientException: $message, uri=$uri';
    } else {
      return 'ClientException: $message';
    }
  }
}

class CacheException implements Exception {
  CacheException({
    this.message = cacheExceptionMessage,
  });

  final String message;

  @override
  String toString() {
    return 'CacheException: $message';
  }
}
