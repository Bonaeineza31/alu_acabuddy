import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/assignment.dart';
import '../utils/helpers.dart';

class AssignmentProvider extends ChangeNotifier {
  List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  // Load assignments from storage
  Future<void> loadAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final String? assignmentsJson = prefs.getString('assignments');
    
    if (assignmentsJson != null) {
      final List<dynamic> decoded = json.decode(assignmentsJson);
      _assignments = decoded.map((item) => Assignment.fromMap(item)).toList();
      notifyListeners();
    }
  }

  // Save assignments to storage
  Future<void> _saveAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_assignments.map((a) => a.toMap()).toList());
    await prefs.setString('assignments', encoded);
  }

  List<Assignment> get upcomingAssignments {
    return _assignments.where((assignment) {
      return !assignment.isCompleted && Helpers.isUpcoming(assignment.dueDate);
    }).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  List<Assignment> get todayAssignments {
    return _assignments.where((assignment) {
      return !assignment.isCompleted && Helpers.isToday(assignment.dueDate);
    }).toList();
  }

  int get pendingCount {
    return _assignments.where((a) => !a.isCompleted).length;
  }

  int get completedCount {
    return _assignments.where((a) => a.isCompleted).length;
  }

  List<Assignment> get overdueAssignments {
    return _assignments.where((assignment) {
      return Helpers.isOverdue(assignment.dueDate, assignment.isCompleted);
    }).toList();
  }

  void addAssignment(Assignment assignment) {
    _assignments.add(assignment);
    _saveAssignments();
    notifyListeners();
  }

  void updateAssignment(String id, Assignment updatedAssignment) {
    final index = _assignments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _assignments[index] = updatedAssignment;
      _saveAssignments();
      notifyListeners();
    }
  }

  void toggleCompletion(String id) {
    final assignment = _assignments.firstWhere((a) => a.id == id);
    assignment.isCompleted = !assignment.isCompleted;
    _saveAssignments();
    notifyListeners();
  }

  void deleteAssignment(String id) {
    _assignments.removeWhere((a) => a.id == id);
    _saveAssignments();
    notifyListeners();
  }

  Assignment? getAssignmentById(String id) {
    try {
      return _assignments.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Assignment> get assignmentsSortedByDate {
    final list = List<Assignment>.from(_assignments);
    list.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return list;
  }

  List<Assignment> getAssignmentsByPriority(String priority) {
    return _assignments
        .where((a) => a.priority == priority && !a.isCompleted)
        .toList();
  }
}