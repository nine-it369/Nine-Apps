import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._();

  static final DateFormat _displayDateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
  static final DateFormat _shortDateFormat = DateFormat('d MMM yyyy', 'id_ID');
  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');

  static String formatDisplayDate(DateTime dateTime) {
    try {
      return _displayDateFormat.format(dateTime);
    } catch (_) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  static String formatShortDate(DateTime dateTime) {
    try {
      return _shortDateFormat.format(dateTime);
    } catch (_) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  static String formatForApi(DateTime dateTime) {
    return _apiDateFormat.format(dateTime);
  }
}
