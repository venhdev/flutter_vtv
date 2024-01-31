const String kPORT = '8585';
const String kDOMAIN = '192.168.1.8';
const String kAPIBaseURL = 'http://$kDOMAIN:$kPORT/api';

//! Auth
const String kAPIAuthLoginURL = '$kAPIBaseURL/auth/login';
const String kAPIAuthRefreshTokenURL = '$kAPIBaseURL/auth/refresh-token';
const String kAPIAuthLogoutURL = '$kAPIBaseURL/auth/logout';
const String kAPIAuthRegisterURL = '$kAPIBaseURL/auth/register';