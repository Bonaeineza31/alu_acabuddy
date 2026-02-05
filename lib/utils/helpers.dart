import 'package:intl/intl.dart';
import 'constants.dart';

/// Helper functions used throughout the app
class Helpers {
  /// Format date to readable string (e.g., "Jan 30, 2026")
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }
  
  /// Format time to readable string (e.g., "14:30")
  static String formatTime(DateTime time) {
    return DateFormat(AppConstants.timeFormat).format(time);
  }
  
  /// Format date and time together
  static String formatDateTime(DateTime dateTime) {
    return DateFormat(AppConstants.dateTimeFormat).format(dateTime);
  }
  
  /// Check if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  /// Check if a date is within the next 7 days
  static bool isUpcoming(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    return difference >= 0 && difference <= AppConstants.upcomingAssignmentDays;
  }
  
  /// Get the current academic week number
  /// (You can customize this based on ALU's academic calendar)
  static int getCurrentWeek() {
    final now = DateTime.now();
    // Example: Assuming term starts on January 13, 2026
    final termStart = DateTime(2026, 1, 13);
    final difference = now.difference(termStart).inDays;
    return (difference / 7).floor() + 1;
  }
  
  /// Calculate attendance percentage
  static double calculateAttendancePercentage(int present, int late, int absent) {
    final total = present + late + absent;
    if (total == 0) return 100.0;
    return ((present + late) / total) * 100;
  }
  
  /// Get days until a specific date
  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);
    return targetDate.difference(today).inDays;
  }
  
  /// Check if assignment is overdue
  static bool isOverdue(DateTime dueDate, bool isCompleted) {
    if (isCompleted) return false;
    return DateTime.now().isAfter(dueDate);
  }
}