import 'package:flutter/material.dart';
import 'package:alu_acabuddy/utils/app_colors.dart'; // ← Changed import

enum AttendanceStatus { present, late, absent }

class AttendanceRecord {
  final String id;
  final String courseName;
  final DateTime dateTime;
  final AttendanceStatus status;
  
  AttendanceRecord({
    required this.id,
    required this.courseName,
    required this.dateTime,
    required this.status,
  });
  
  String get statusText {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.absent:
        return 'Absent';
    }
  }
  
  Color get statusColor {  // ← Removed nullable (?)
    switch (status) {
      case AttendanceStatus.present:
        return AppColors.success;  // ← Changed from AppConstants.successColor
      case AttendanceStatus.late:
        return AppColors.warning;  // ← Changed to use AppColors
      case AttendanceStatus.absent:
        return AppColors.danger;   // ← Changed from AppConstants.dangerColor
    }
  }
  
  IconData get statusIcon {
    switch (status) {
      case AttendanceStatus.present:
        return Icons.check_circle;
      case AttendanceStatus.late:
        return Icons.watch_later;
      case AttendanceStatus.absent:
        return Icons.cancel;
    }
  }
}

class AttendanceMetrics {
  final int totalSessions;
  final int sessionsThisWeek;
  final int totalAttended;
  final double attendanceRate;
  
  AttendanceMetrics({
    required this.totalSessions,
    required this.sessionsThisWeek,
    required this.totalAttended,
    required this.attendanceRate,
  });
  
  bool get isBelowThreshold => attendanceRate < 75;
  bool get isExcellent => attendanceRate >= 95;
}