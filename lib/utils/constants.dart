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