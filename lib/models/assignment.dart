import 'package:uuid/uuid.dart';

/// Model class for Assignment/Task
class Assignment {
  final String id;
  final String title;
  final String courseName;
  final DateTime dueDate;
  final String priority; // 'High', 'Medium', 'Low'
  bool isCompleted;
  final DateTime createdAt;

  Assignment({
    String? id,
    required this.title,
    required this.courseName,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Create a copy of this assignment with modified fields
  Assignment copyWith({
    String? title,
    String? courseName,
    DateTime? dueDate,
    String? priority,
    bool? isCompleted,
  }) {
    return Assignment(
      id: id,
      title: title ?? this.title,
      courseName: courseName ?? this.courseName,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }

  /// Convert to Map for storage (if needed later)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'courseName': courseName,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from Map (if needed later)
  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'],
      title: map['title'],
      courseName: map['courseName'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: map['priority'],
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}