import 'package:intl/intl.dart';

mixin KCUtility {
  static String getFormattedDate(String date) {
    return DateFormat.yMMMEd().format(DateTime.parse(date));
  }
}
