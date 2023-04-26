import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  static final DateFormat dateFormatter = DateFormat('dd.MM.yyyy');
  static final DateFormat timeFormatter = DateFormat.Hm();

  String getDateTimeString() {
    var formattedDate = dateFormatter.format(this);
    if (dateFormatter.format(DateTime.now()) == formattedDate) {
      return timeFormatter.format(this);
    }
    return formattedDate;
  }
}
