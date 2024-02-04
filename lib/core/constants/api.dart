const String kPORT = '8585';
const String kDOMAIN = '192.168.1.7';
const String kAPIBaseURL = 'http://$kDOMAIN:$kPORT/api';

// Http Headers
const Map<String, String> baseHeaders = {
  'Content-Type': 'application/json; charset=utf-8',
  'Accept': 'application/json',
};
Map<String, String> headersWithRefreshToken(String refreshToken) {
  return {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
    'Cookie': 'refreshToken=$refreshToken',
  };
}


//! Auth
const String kAPIAuthLoginURL = '$kAPIBaseURL/auth/login';
const String kAPIAuthRefreshTokenURL = '$kAPIBaseURL/auth/refresh-token';
const String kAPIAuthLogoutURL = '$kAPIBaseURL/auth/logout';
const String kAPIAuthRegisterURL = '$kAPIBaseURL/auth/register';
