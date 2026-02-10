import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/assignment_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/session_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../attendance/attendance_screen.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final assignmentProvider = Provider.of<AssignmentProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header - Matching Reference Design
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 24),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row - Icon and Week
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.home,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Week ${Helpers.getCurrentWeek()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Welcome Message
                  const Text(
                    'Welcome back, Bonae! 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Date
                  Text(
                    Helpers.formatDate(DateTime.now()),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildAttendanceCard(context, attendanceProvider),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildTasksCard(assignmentProvider),
                      ),
                    ],
                  ),

                  // At-Risk Warning
                  if (attendanceProvider.isBelowMinimum)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withOpacity(0.1),
                        border: Border.all(color: AppColors.danger),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'AT RISK: Keep attendance above 75%!',
                              style: TextStyle(
                                color: AppColors.danger,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Today's Schedule
                  const SizedBox(height: 24),
                  _buildSectionHeader("Today's Schedule"),
                  const SizedBox(height: 12),
                  _buildTodaySchedule(sessionProvider),

                  // Due This Week
                  const SizedBox(height: 24),
                  _buildSectionHeader('Due This Week'),
                  const SizedBox(height: 12),
                  _buildDueThisWeek(assignmentProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Attendance Card
  Widget _buildAttendanceCard(BuildContext context, AttendanceProvider provider) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AttendanceScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: provider.isBelowMinimum ? AppColors.danger : AppColors.success,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Icon(Icons.calendar_today, color: Colors.white, size: 22),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${provider.attendancePercentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Attendance Rate',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tasks Card
  Widget _buildTasksCard(AssignmentProvider provider) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.assignment, color: Colors.white, size: 22),
          const SizedBox(height: 12),
          Text(
            '${provider.pendingCount}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${provider.completedCount} of ${provider.assignments.length} complete',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // Section Header
  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const Icon(Icons.more_horiz, color: AppColors.textSecondary, size: 20),
      ],
    );
  }

  // Today's Schedule
  Widget _buildTodaySchedule(SessionProvider provider) {
    final sessions = provider.todaySessions;

    if (sessions.isEmpty) {
      return _buildEmptyState('No sessions scheduled for today', Icons.event_note);
    }

    return Column(
      children: sessions.map((session) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getSessionColor(session.sessionType),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          '${session.startTime} - ${session.endTime}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        if (session.location.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          const Icon(Icons.location_on, size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              session.location,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _getSessionColor(session.sessionType),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  session.sessionType,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Due This Week
  Widget _buildDueThisWeek(AssignmentProvider provider) {
    final assignments = provider.upcomingAssignments.take(3).toList();

    if (assignments.isEmpty) {
      return _buildEmptyState('No assignments due this week', Icons.assignment_outlined);
    }

    return Column(
      children: assignments.map((assignment) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getPriorityColor(assignment.priority),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.book, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          assignment.courseName,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.calendar_today, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          Helpers.formatDate(assignment.dueDate),
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _getPriorityColor(assignment.priority),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  assignment.priority,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Empty State
  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 40, color: AppColors.textSecondary.withOpacity(0.5)),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Get Session Color
  Color _getSessionColor(String type) {
    switch (type) {
      case 'Class': return AppColors.classSession;
      case 'Mastery Session': return AppColors.masterySession;
      case 'Study Group': return AppColors.studyGroup;
      case 'PSL Meeting': return AppColors.pslMeeting;
      default: return AppColors.primary;
    }
  }

  // Helper: Get Priority Color
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High': return AppColors.highPriority;
      case 'Medium': return AppColors.mediumPriority;
      case 'Low': return AppColors.lowPriority;
      default: return AppColors.textSecondary;
    }
  }
}