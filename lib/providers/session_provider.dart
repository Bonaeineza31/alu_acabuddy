import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/session.dart';
import '../utils/helpers.dart';

class SessionProvider extends ChangeNotifier {
  List<Session> _sessions = [];

  List<Session> get sessions => _sessions;

  // Load sessions from storage
  Future<void> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? sessionsJson = prefs.getString('sessions');
    
    if (sessionsJson != null) {
      final List<dynamic> decoded = json.decode(sessionsJson);
      _sessions = decoded.map((item) => Session.fromMap(item)).toList();
      notifyListeners();
    }
  }

  // Save sessions to storage
  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_sessions.map((s) => s.toMap()).toList());
    await prefs.setString('sessions', encoded);
  }

  List<Session> get todaySessions {
    return _sessions.where((session) => session.isToday).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  List<Session> get weekSessions {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return _sessions.where((session) {
      return session.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
             session.date.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<Session> getSessionsByDate(DateTime date) {
    return _sessions.where((session) {
      return session.date.year == date.year &&
             session.date.month == date.month &&
             session.date.day == date.day;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  void addSession(Session session) {
    _sessions.add(session);
    _saveSessions();
    notifyListeners();
  }

  void updateSession(String id, Session updatedSession) {
    final index = _sessions.indexWhere((s) => s.id == id);
    if (index != -1) {
      _sessions[index] = updatedSession;
      _saveSessions();
      notifyListeners();
    }
  }

  void deleteSession(String id) {
    _sessions.removeWhere((s) => s.id == id);
    _saveSessions();
    notifyListeners();
  }

  // Mark attendance for a session
  void markAttendance(String sessionId, String status) {
    final index = _sessions.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      _sessions[index].attendanceStatus = status;
      _saveSessions();
      notifyListeners();
    }
  }

  Session? getSessionById(String id) {
    try {
      return _sessions.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  int get totalSessions => _sessions.length;
  int get weekSessionsCount => weekSessions.length;
}