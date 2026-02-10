import 'package:uuid/uuid.dart';

class Session {
  final String id;
  final String title;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String location;
  final String sessionType;
  String attendanceStatus;
  final DateTime createdAt;

  Session({
    String? id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location = '',
    required this.sessionType,
    this.attendanceStatus = '',
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Session copyWith({
    String? title,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    String? sessionType,
    String? attendanceStatus,
  }) {
    return Session(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      sessionType: sessionType ?? this.sessionType,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      createdAt: createdAt,
    );
  }

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'sessionType': sessionType,
      'attendanceStatus': attendanceStatus,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      startTime: map['startTime'],
      endTime: map['endTime'],
      location: map['location'] ?? '',
      sessionType: map['sessionType'],
      attendanceStatus: map['attendanceStatus'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}