const int kPORT = 8585;
const String kDOMAIN = '172.16.20.199';
const String kAPIBaseURL = 'http://$kDOMAIN:$kPORT/api';
// const String kAPIBaseURL = 'https://$kDOMAIN/api';

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
      host: kDOMAIN,
      port: kPORT,
      path: '/api$path',
      queryParameters: queryParameters,
    );

//! Auth
const String kAPIAuthLoginURL = '/auth/login';
const String kAPIAuthRefreshTokenURL = '/auth/refresh-token';
const String kAPIAuthLogoutURL = '/auth/logout';
const String kAPIAuthRegisterURL = '/auth/register';

//! customer-controller
const String kAPICustomerForgotPasswordURL = '/customer/forgot-password';
const String kAPICustomerResetPasswordURL = '/customer/reset-password';
const String kAPICustomerChangePasswordURL = '/customer/change-password';
const String kAPICustomerProfileURL = '/customer/profile'; // GET, PUT