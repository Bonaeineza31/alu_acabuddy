<<<<<<< christian
import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = "ALU Attendance";
  
  // Colors
  static const Color primaryColor = Color(0xFF1A237E);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color dangerColor = Color(0xFFF44336);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color greyColor = Color(0xFF757575);
  
  // Text Styles
  static const TextStyle headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  
  static const TextStyle subHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );
  
  static const TextStyle metricStyle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  
  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );
}
=======
/// App-wide constants
class AppConstants {
  // App Info
  static const String appName = 'ALU AcaBuddy';
  static const String appVersion = '1.0.0';
  
  // Attendance
  static const double minimumAttendancePercentage = 75.0;
  static const String attendanceWarningMessage = 
      'Warning: Your attendance is below 75%';
  
  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'MMM dd, yyyy HH:mm';
  
  // Assignment Priority Levels
  static const String priorityHigh = 'High';
  static const String priorityMedium = 'Medium';
  static const String priorityLow = 'Low';
  
  static const List<String> priorityLevels = [
    priorityHigh,
    priorityMedium,
    priorityLow,
  ];
  
  // Session Types
  static const String sessionTypeClass = 'Class';
  static const String sessionTypeMastery = 'Mastery Session';
  static const String sessionTypeStudyGroup = 'Study Group';
  static const String sessionTypePSL = 'PSL Meeting';
  
  static const List<String> sessionTypes = [
    sessionTypeClass,
    sessionTypeMastery,
    sessionTypeStudyGroup,
    sessionTypePSL,
  ];
  
  // Attendance Status
  static const String attendancePresent = 'Present';
  static const String attendanceAbsent = 'Absent';
  static const String attendanceLate = 'Late';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Days to show upcoming assignments
  static const int upcomingAssignmentDays = 7;
}
>>>>>>> main
