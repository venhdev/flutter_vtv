import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/auth_cubit.dart';

DateTime getToday() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// use to get {day month year} from DateTime
///
/// => yyyy-MM-dd : 00:00:00.000
DateTime getDate(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

/// use to check if the user is logged in or not
bool isLogin(BuildContext context) {
  return context.read<AuthCubit>().state.status == AuthStatus.authenticated;
}

bool isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}
