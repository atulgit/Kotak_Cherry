import 'package:intl/intl.dart';

mixin KCUtility {
  static String getFormattedDateFromString(String date) {
    return DateFormat.yMMMEd().format(DateTime.parse(date));
  }

  static String getFormattedDate(DateTime date) {
    return DateFormat.yMMMEd().format(date);
  }
}
