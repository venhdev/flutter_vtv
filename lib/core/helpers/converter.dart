import 'package:intl/intl.dart';

import '../constants/constants.dart';
import 'helpers.dart';

/// When specify [pattern], it must have separator like "dd-MM-yyyy"
DateTime convertStringToDateTime(
  String date, {
  DateFormat? pattern,
}) {
  if (pattern != null) {
    if (RegExp(r'\W').hasMatch(pattern.pattern!)) {
      return pattern.parse(date);
    } else {
      throw const FormatException(
          '{pattern} must have separator. ex: "dd-MM-yyyy"');
    }
  }
  return DateTime.parse(date);
}

/// Change [pattern] to change the format, default is 'dd-MM-yyyy'
///
/// {defaultValue} will return if [date] is null
String convertDateTimeToString(
  DateTime date, {
  String pattern = kDateFormatPattern,
  bool useTextValue = false,
}) {
  DateTime today = getToday();
  DateTime tomorrow = today.add(const Duration(days: 1));
  DateTime yesterday = today.subtract(const Duration(days: 1));

  if (useTextValue) {
    if (date == today) {
      return 'Today';
    } else if (date == tomorrow) {
      return 'Tomorrow';
    } else if (date == yesterday) {
      return 'Yesterday';
    }
  }

  return DateFormat(pattern).format(date);
}

/// Convert DateTime to int --hour (HHmm) 24h format. Ex: 12:30 -> 1230
int convertDateTimeToInt(DateTime date, {String pattern = 'Hm'}) {
  return int.parse(DateFormat(pattern).format(date).replaceAll(':', ''));
}

/// Convert int to DateTime
/// Ex: 1230 -> 12:30
DateTime convertIntToDateTime(int time) {
  return DateFormat('Hm').parse(time.toString().padLeft(4, '0'));
}

