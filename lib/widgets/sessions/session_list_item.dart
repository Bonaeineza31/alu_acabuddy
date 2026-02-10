import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/session.dart';
import '../../providers/session_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import 'edit_session_dialog.dart';

class SessionListItem extends StatelessWidget {
  final Session session;

  const SessionListItem({
    super.key,
    required this.session,
  });

  Color _getSessionTypeColor() {
    switch (session.sessionType) {
      case 'Class':
        return AppColors.classSession;
      case 'Mastery Session':
        return AppColors.masterySession;
      case 'Study Group':
        return AppColors.studyGroup;
      case 'PSL Meeting':
        return AppColors.pslMeeting;
      default:
        return AppColors.primary;
    }
  }

  String _getDayAbbr(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _getMonthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Day and Date
                      Text(
                        '${_getDayAbbr(session.date)}, ${_getMonthAbbr(session.date.month)} ${session.date.day}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Session Title
                      Text(
                        session.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 10),

                      // Time
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${session.startTime} - ${session.endTime}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Session Type Badge and Location
                      Row(
                        children: [
                          // Session Type Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getSessionTypeColor(),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              session.sessionType,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textWhite,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Location (if available)
                          if (session.location.isNotEmpty) ...[
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                session.location,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Right side - Action Icons
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Edit Button
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black54,
                          builder: (context) => EditSessionDialog(
                            session: session,
                          ),
                        );
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Delete Button
                    GestureDetector(
                      onTap: () {
                        _showDeleteConfirmation(context, sessionProvider);
                      },
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Attendance Buttons
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            Row(
              children: [
                const Text(
                  'Attendance:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      _buildAttendanceButton(
                        context,
                        'Present',
                        AppColors.success,
                        Icons.check_circle,
                        AppConstants.attendancePresent,
                        sessionProvider,
                        attendanceProvider,
                      ),
                      const SizedBox(width: 6),
                      _buildAttendanceButton(
                        context,
                        'Late',
                        AppColors.warning,
                        Icons.schedule,
                        AppConstants.attendanceLate,
                        sessionProvider,
                        attendanceProvider,
                      ),
                      const SizedBox(width: 6),
                      _buildAttendanceButton(
                        context,
                        'Absent',
                        AppColors.danger,
                        Icons.cancel,
                        AppConstants.attendanceAbsent,
                        sessionProvider,
                        attendanceProvider,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceButton(
    BuildContext context,
    String label,
    Color color,
    IconData icon,
    String status,
    SessionProvider sessionProvider,
    AttendanceProvider attendanceProvider,
  ) {
    final bool isSelected = session.attendanceStatus == status;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Mark attendance
          sessionProvider.markAttendance(session.id, status);
          // Update attendance provider
          attendanceProvider.updateSessions(sessionProvider.sessions);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Marked as $label'),
              backgroundColor: color,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, SessionProvider provider) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => AlertDialog(
        title: const Text('Delete Session'),
        content: const Text('Are you sure you want to delete this session?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteSession(session.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Session deleted'),
                  backgroundColor: AppColors.danger,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.danger,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}