part './apis/auth_api.dart';
part './apis/customer_api.dart';
part './apis/guest_api.dart';

const int kPORT = 8585;
const String kDOMAIN = '172.16.20.232';
String devDOMAIN = '172.16.20.232'; // NOTE: For development purposes
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
  required String path,
  Map<String, dynamic>? queryParameters,
}) =>
    Uri(
      scheme: 'http',
      host: devDOMAIN,
      port: kPORT,
      path: '/api$path',
      queryParameters: queryParameters,
    );

