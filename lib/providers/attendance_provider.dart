import 'package:flutter/material.dart';
import '../models/session.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';

class AttendanceProvider extends ChangeNotifier {
  List<Session> _sessions = [];

  // Update sessions list (called from SessionProvider)
  void updateSessions(List<Session> sessions) {
    _sessions = sessions;
    notifyListeners();
  }

  int get totalSessionsTracked {
    return _sessions.where((s) => s.attendanceStatus.isNotEmpty).length;
  }

  int get presentCount {
    return _sessions
        .where((s) => s.attendanceStatus == AppConstants.attendancePresent)
        .length;
  }

  int get lateCount {
    return _sessions
        .where((s) => s.attendanceStatus == AppConstants.attendanceLate)
        .length;
  }

  int get absentCount {
    return _sessions
        .where((s) => s.attendanceStatus == AppConstants.attendanceAbsent)
        .length;
  }

  double get attendancePercentage {
    return Helpers.calculateAttendancePercentage(
      presentCount,
      lateCount,
      absentCount,
    );
  }

  bool get isBelowMinimum {
    return attendancePercentage < AppConstants.minimumAttendancePercentage;
  }

  String get attendanceStatusMessage {
    if (totalSessionsTracked == 0) {
      return 'No attendance recorded yet';
    }
    if (isBelowMinimum) {
      return AppConstants.attendanceWarningMessage;
    }
    return 'Excellent! You meet the attendance requirement.';
  }

  int get weekAttendedCount {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return _sessions.where((session) {
      final isThisWeek = session.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
                         session.date.isBefore(endOfWeek.add(const Duration(days: 1)));
      final isAttended = session.attendanceStatus == AppConstants.attendancePresent ||
                        session.attendanceStatus == AppConstants.attendanceLate;
      return isThisWeek && isAttended;
    }).length;
  }

  List<Session> get attendanceHistory {
    return _sessions
        .where((s) => s.attendanceStatus.isNotEmpty)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}