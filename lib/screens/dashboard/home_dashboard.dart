import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/assignment_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/session_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../attendance/attendance_screen.dart';
import '../auth/auth_screen.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AttendanceProvider>(context);
    final asp = Provider.of<AssignmentProvider>(context);
    final sp = Provider.of<SessionProvider>(context);
    final up = Provider.of<UserProvider>(context);
    
    final firstName = up.currentUser?.fullName.split(' ').first ?? 'Student';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 24),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                        child: const Center(child: Text('ALU', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                        child: Text('Week ${Helpers.getCurrentWeek()}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Welcome back, $firstName! 👋', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Helpers.formatDate(DateTime.now()), style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      GestureDetector(
                        onTap: () {
                          up.logout();
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const AuthScreen()), (route) => false);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Icon(Icons.logout, color: Colors.white, size: 16), SizedBox(width: 6), Text('Logout', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Cards
                  Row(
                    children: [
                      Expanded(child: _card(context, '${ap.attendancePercentage.toStringAsFixed(0)}%', 'Attendance Rate', ap.isBelowMinimum ? AppColors.danger : AppColors.success, Icons.calendar_today, true)),
                      const SizedBox(width: 15),
                      Expanded(child: _card(context, '${asp.pendingCount}', '${asp.completedCount} of ${asp.assignments.length} complete', AppColors.primary, Icons.assignment, false)),
                    ],
                  ),

                  if (ap.isBelowMinimum)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.1), border: Border.all(color: AppColors.danger), borderRadius: BorderRadius.circular(12)),
                      child: const Row(children: [Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 20), SizedBox(width: 10), Expanded(child: Text('AT RISK: Keep attendance above 75%!', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600, fontSize: 13)))]),
                    ),

                  const SizedBox(height: 24),
                  _header("Today's Schedule"),
                  const SizedBox(height: 12),
                  _sessions(sp.todaySessions),

                  const SizedBox(height: 24),
                  _header('Due This Week'),
                  const SizedBox(height: 12),
                  _tasks(asp.upcomingAssignments.take(3).toList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext ctx, String title, String subtitle, Color color, IconData icon, bool arrow) {
    return GestureDetector(
      onTap: arrow ? () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const AttendanceScreen())) : null,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(icon, color: Colors.white, size: 22), if (arrow) const Icon(Icons.arrow_forward, color: Colors.white, size: 20)]),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _header(String title) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: AppColors.primary, margin: const EdgeInsets.only(right: 10)),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const Spacer(),
        const Icon(Icons.more_horiz, color: AppColors.textSecondary, size: 20),
      ],
    );
  }

  Widget _sessions(List sessions) {
    if (sessions.isEmpty) return _empty('No sessions scheduled for today', Icons.event_note);
    return Column(
      children: sessions.map((s) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _sc(s.sessionType), width: 2)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text('${s.startTime} - ${s.endTime}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      if (s.location.isNotEmpty) ...[const SizedBox(width: 10), const Icon(Icons.location_on, size: 13, color: AppColors.textSecondary), const SizedBox(width: 4), Flexible(child: Text(s.location, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis))],
                    ],
                  ),
                ],
              ),
            ),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _sc(s.sessionType), borderRadius: BorderRadius.circular(6)), child: Text(s.sessionType, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white))),
          ],
        ),
      )).toList(),
    );
  }

  Widget _tasks(List assignments) {
    if (assignments.isEmpty) return _empty('No assignments due this week', Icons.assignment_outlined);
    return Column(
      children: assignments.map((a) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _pc(a.priority), width: 2)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.book, size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(a.courseName, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(width: 10),
                      const Icon(Icons.calendar_today, size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(Helpers.formatDate(a.dueDate), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _pc(a.priority), borderRadius: BorderRadius.circular(6)), child: Text(a.priority, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white))),
          ],
        ),
      )).toList(),
    );
  }

  Widget _empty(String msg, IconData icon) => Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)), child: Center(child: Column(children: [Icon(icon, size: 40, color: Colors.grey), const SizedBox(height: 8), Text(msg, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))])));

  Color _sc(String type) => type == 'Class' ? AppColors.classSession : type == 'Mastery Session' ? AppColors.masterySession : type == 'Study Group' ? AppColors.studyGroup : type == 'PSL Meeting' ? AppColors.pslMeeting : AppColors.primary;
  Color _pc(String priority) => priority == 'High' ? AppColors.highPriority : priority == 'Medium' ? AppColors.mediumPriority : AppColors.lowPriority;
}