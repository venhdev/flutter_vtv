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
