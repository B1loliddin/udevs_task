import 'package:flutter/material.dart';

abstract class TimeUtils {
  static String formatDate(DateTime date) =>
      '${date.year}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  static String formatYearMonth(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  static String formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
