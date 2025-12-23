import 'package:intl/intl.dart';
import 'constants.dart';

String dayKey(DateTime dt) {
  final d = DateFormat('yyyyMMdd').format(DateTime(dt.year, dt.month, dt.day));
  return d;
}

int minutesSinceMidnight(DateTime dt) => dt.hour * 60 + dt.minute;

List<String> slotKeysForRange(DateTime start, DateTime end) {
  // Assume same-day windows; clamp to the same day
  final s = DateTime(start.year, start.month, start.day, start.hour, start.minute);
  final e = DateTime(end.year, end.month, end.day, end.hour, end.minute);
  if (e.isBefore(s)) return [];

  final dk = dayKey(s);
  final startMin = minutesSinceMidnight(s);
  final endMin = minutesSinceMidnight(e);
  final slot = AppConstants.slotMinutes;

  final startIndex = startMin ~/ slot;
  final endIndex = endMin ~/ slot;

  final keys = <String>[];
  for (int i = startIndex; i <= endIndex; i++) {
    keys.add('$dk-$i'); // e.g., 20251222-48
  }
  return keys;
}

bool is18Plus(DateTime dob) {
  final today = DateTime.now();
  final eighteen = DateTime(today.year - 18, today.month, today.day);
  return !dob.isAfter(eighteen);
}