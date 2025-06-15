import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('MMM dd, yyyy').format(date);
}

String formatTimeOfDay(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return DateFormat('h:mm a').format(dt);
}
