part './apis/auth_api.dart';
part './apis/customer_api.dart';
part './apis/guest_api.dart';

const int kPORT = 8585;
// const String kDOMAIN = '172.16.20.208';
String devDOMAIN = '192.168.1.8'; // NOTE: dev
// const String kAPIBaseURL = 'http://$kDOMAIN:$kPORT/api';

// Http Headers
Map<String, String> baseHttpHeaders({
  String? refreshToken,
  String? accessToken,
}) =>
    {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      if (refreshToken != null) 'Cookie': 'refreshToken=$refreshToken',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

// Uri Endpoints
Uri baseUri({
  String? path,
  Map<String, dynamic>? queryParameters,
}) =>
    Uri(
      scheme: 'http',
      host: devDOMAIN, // change to kDOMAIN for production
      port: kPORT,
      path: '/api$path',
      queryParameters: queryParameters,
    );
