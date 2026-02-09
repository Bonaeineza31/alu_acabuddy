import 'package:uuid/uuid.dart';

/// Model class for Academic Session (Class, Study Group, etc.)
class Session {
  final String id;
  final String title;
  final DateTime date;
  final String startTime; // Format: "HH:mm"
  final String endTime;   // Format: "HH:mm"
  final String location;
  final String sessionType; // 'Class', 'Mastery Session', etc.
  String attendanceStatus; // 'Present', 'Absent', 'Late', or empty
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

  /// Create a copy with modified fields
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

  /// Check if session is today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  /// Convert to Map
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

  /// Create from Map
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