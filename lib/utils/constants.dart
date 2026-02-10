import 'package:flutter/material.dart';

/// App-wide constants
class AppConstants {
  // App Info
  static const String appName = 'ALU AcaBuddy';
  static const String appVersion = '1.0.0';
  
  // Attendance logic
  static const double minimumAttendancePercentage = 75.0;
  static const String attendanceWarningMessage = 
      'AT RISK: Keep attendance above 75%!'; // Matches your Figma
  
  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'HH:mm';
  
  // Assignment Priority Levels
  static const String priorityHigh = 'High';
  static const String priorityMedium = 'Medium';
  static const String priorityLow = 'Low';
  
  // Attendance Status (Used by AttendanceProvider)
  static const String attendancePresent = 'Present';
  static const String attendanceAbsent = 'Absent';
  static const String attendanceLate = 'Late';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  
  // FIXED: Instead of 'null', link these to your real colors or standard Flutter colors
  static const Color successColor = Colors.green;
  static const Color dangerColor = Colors.red;
  static const Color warningColor = Colors.orange;
}
