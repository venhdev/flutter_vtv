const String serverExceptionMessage = 'Server Exception';
const String clientExceptionMessage = 'Client Exception';
const String cacheExceptionMessage = 'Cache Exception';
// const String formatExceptionMessage = 'Format Exception';

class ServerException implements Exception {
  ServerException({
    this.code = 500,
    this.message = serverExceptionMessage,
  });

  final int code;
  final String message;

  @override
  String toString() {
    return 'ServerException: $message';
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
