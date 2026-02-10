import 'package:flutter/material.dart';
import '../models/session.dart';
import '../utils/helpers.dart';

/// Provider for managing academic sessions (classes, study groups, etc.)
class SessionProvider extends ChangeNotifier {
  final List<Session> _sessions = [];

  var sessionsSortedByDate;

  var completedCount;

  /// Get all sessions
  List<Session> get sessions => _sessions;

  /// Get today's sessions
  List<Session> get todaySessions {
    return _sessions.where((session) => session.isToday).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Get this week's sessions
  List<Session> get weekSessions {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return _sessions.where((session) {
      return session.date
              .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          session.date.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Get sessions for a specific date
  List<Session> getSessionsByDate(DateTime date) {
    return _sessions.where((session) {
      return session.date.year == date.year &&
          session.date.month == date.month &&
          session.date.day == date.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Add new session
  void addSession(Session session) {
    _sessions.add(session);
    notifyListeners();
  }

  /// Update session
  void updateSession(String id, Session updatedSession) {
    final index = _sessions.indexWhere((s) => s.id == id);
    if (index != -1) {
      _sessions[index] = updatedSession;
      notifyListeners();
    }
  }

  /// Delete session
  void deleteSession(String id) {
    _sessions.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  /// Mark attendance for a session
  void markAttendance(String sessionId, String status) {
    final session = _sessions.firstWhere((s) => s.id == sessionId);
    session.attendanceStatus = status;
    notifyListeners();
  }

  /// Get session by ID
  Session? getSessionById(String id) {
    try {
      return _sessions.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get total sessions count
  int get totalSessions => _sessions.length;

  /// Get sessions this week count
  int get weekSessionsCount => weekSessions.length;
}
