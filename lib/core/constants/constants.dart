part 'constant_messages.dart';

// <https://api.flutter.dev/flutter/intl/DateFormat-class.html>
// const String kDateFormatPattern = 'yyyyMMdd';
const String kTimeFormatPattern = 'hh:mm a'; //use to display time in app
const String kDateFormatPattern = 'dd-MM-yyyy'; //use to display date in app

// ------------------  Firebase Constants ------------------
//! Authentication
// The first time run app, user not login
const String kUserNotLogin = 'You must login first!';

const String kSignInFailMessage = 'Login failed';
const String kSignInSuccessMessage = 'Login failed';

const String kSignUpFailMessage = 'Sign up failed';
const String kSignUpSuccessMessage = 'Sign up success';

const String kSignOutFailMessage = 'Sign out failed';
const String kSignOutSuccessMessage = 'Sign out success';

//* Auth Message
// invalid-email-password
const String kAuthInvalidEmail = 'Invalid email address';
const String kAuthInvalidCredential = 'Your email or password is incorrect';
const String kAuthUserDisabled = 'The given email has been disabled';
const String kAuthUserNotFound = 'User not found';
const String kAuthWrongPassword = 'Your password is incorrect';
// INVALID_LOGIN_CREDENTIALS -- wrong email/password
const String kAuthInvalidLoginCredentials = 'Invalid login credentials';
// too-many-requests
const String kAuthTooManyRequests = 'You have tried too many times. Please try again later';
// network-request-failed
const String kAuthNetworkRequestFailed = 'Your network is not stable';

//? ----------- has not been caught yet -----------
// // user-not-found
// const String kAuthUserNotFound = 'User not found';

// ! Notification channel id
const String kDefaultNotificationChannelId = 'default_notification';
const String kScheduleNotificationChannelId = 'schedule_notification';
const String kDailyNotificationChannelId = 'daily_notification';
