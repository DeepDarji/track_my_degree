import 'package:flutter/material.dart';

class TimetableEntry {
  final String id;
  final String subjectId;
  final String day;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String location;

  TimetableEntry({
    required this.id,
    required this.subjectId,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'day': day,
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'location': location,
    };
  }

  factory TimetableEntry.fromMap(Map<String, dynamic> map) {
    final startTimeParts = map['startTime'].split(':');
    final endTimeParts = map['endTime'].split(':');
    return TimetableEntry(
      id: map['id'],
      subjectId: map['subjectId'],
      day: map['day'],
      startTime: TimeOfDay(
        hour: int.parse(startTimeParts[0]),
        minute: int.parse(startTimeParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endTimeParts[0]),
        minute: int.parse(endTimeParts[1]),
      ),
      location: map['location'],
    );
  }
}
