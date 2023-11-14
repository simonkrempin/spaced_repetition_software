import "package:intl/intl.dart";

String getCurrentDate({int daysToAdd = 0}) {
  DateFormat formatter = DateFormat("yyyy-MM-dd");
  return formatter.format(DateTime.now().add(Duration(days: daysToAdd)));
}