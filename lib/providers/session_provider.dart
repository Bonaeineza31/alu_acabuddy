import 'package:flutter/material.dart';
import '../models/session.dart';
import '../utils/helpers.dart';

/// Provider for managing academic sessions (classes, study groups, etc.)
class SessionProvider extends ChangeNotifier {
  // Use a Capital 'S' for Session
  final List<Session> _sessions = [
    Session( // Changed 'session' to 'Session'
      id: '1',
      title: 'Entrepreneurial Leadership',
      startTime: '09:00',
      endTime: '10:30',
      location: 'Room 301',
      type: 'Class',
      date: DateTime.now(),
      attendanceStatus: '', // Add this if your model requires it
    ),
    Session(
      id: '2',
      title: 'Computer Science Lab',
      startTime: '14:00',
      endTime: '16:00',
      location: 'Computer Lab',
      type: 'Class',
      date: DateTime.now(),
      attendanceStatus: '', // Add this if your model requires it
    ),
  ];

  // I added this getter so the Dashboard can actually see the list
  List<Session> get sessions => _sessions;

  // I added this getter so the Dashboard code uses 'todaySessions'
  List<Session> get todaySessions => _sessions;
}