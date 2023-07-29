import 'package:intl/intl.dart';

mixin KCCommon {
  static String getFormattedDate(String date) {
    return DateFormat.yMMMEd().format(DateTime.parse(date));
  }
}
