import 'package:intl/intl.dart';

extension FormattedDate on DateTime {
  String toSmartDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(year, month, day);

    final diff = target.difference(today).inDays;

    if (diff == 0) return "Today";
    if (diff == -1) return "Yesterday";
    if (diff == 1) return "Tomorrow";

    return DateFormat("MMM dd, yyyy").format(this);
  }
}

extension SmartDateFromString on String {
  String toSmartDate() {
    try {
      final date = DateTime.parse(this);
      return date.toSmartDate();
    } catch (_) {
      return this;
    }
  }
}
