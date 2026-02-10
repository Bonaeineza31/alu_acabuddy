import 'package:alu_acabuddy/models/session.dart';
import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';

/// Provider for managing assignments/tasks
class AssignmentProvider extends ChangeNotifier {
  // In-memory storage - data lives only during app session
  final List<Assignment> _assignments = [];

  /// Get all assignments
  List<Assignment> get assignments => _assignments;

  /// Get upcoming assignments (due within next 7 days)
  List<Assignment> get upcomingAssignments {
    return _assignments.where((assignment) {
      return !assignment.isCompleted && Helpers.isUpcoming(assignment.dueDate);
    }).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  /// Get assignments due today
  List<Assignment> get todayAssignments {
    return _assignments.where((assignment) {
      return !assignment.isCompleted && Helpers.isToday(assignment.dueDate);
    }).toList();
  }

  /// Get pending (incomplete) assignments count
  int get pendingCount {
    return _assignments.where((a) => !a.isCompleted).length;
  }

  /// Get completed assignments count
  int get completedCount {
    return _assignments.where((a) => a.isCompleted).length;
  }

  /// Get overdue assignments
  List<Assignment> get overdueAssignments {
    return _assignments.where((assignment) {
      return Helpers.isOverdue(assignment.dueDate, assignment.isCompleted);
    }).toList();
  }

  /// Add new assignment
  void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
    notifyListeners();
  }

  /// Update existing assignment
  void updateAssignment(String id, Assignment updatedAssignment) {
    final index = _assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _assignments[index] = updatedAssignment;
      notifyListeners();
    }
  }

  /// Toggle assignment completion status
  void toggleCompletion(String id) {
    final assignment = _assignments.firstWhere((a) => a.id == id);
    assignment.isCompleted = !assignment.isCompleted;
    notifyListeners();
  }

  /// Delete assignment
  void deleteAssignment(String id) {
    _assignments.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  /// Get assignment by ID
  Assignment? getAssignmentById(String id) {
    try {
      return _assignments.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get assignments sorted by due date
  List<Assignment> get assignmentsSortedByDate {
    final list = List<Assignment>.from(_assignments);
    list.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return list;
  }

  /// Get assignments by priority
  List<Assignment> getAssignmentsByPriority(String priority) {
    return _assignments
        .where((a) => a.priority == priority && !a.isCompleted)
        .toList();
  }

  void addSession(Session newSession) {}
}
