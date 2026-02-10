import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/session_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../widgets/sessions/session_list_item.dart';
import '../../screens/schedule/add_session_dialog.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final sessions = sessionProvider.sessions;

    // Group sessions by week
    final groupedSessions = _groupSessionsByWeek(sessions);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side - Icon and Text
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: AppColors.textWhite,
                          size: 28,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Schedule',
                                style: TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_getMarkedSessionsCount(sessions)}/${sessions.length} sessions marked',
                                style: const TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Right side - Add button
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add,
                          color: AppColors.textWhite, size: 26),
                      padding: const EdgeInsets.all(12),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black54,
                          builder: (context) => const AddSessionDialog(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Sessions List
            Expanded(
              child: sessions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_note,
                            size: 80,
                            color: AppColors.textSecondary.withValues(),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No sessions yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap + to add your first session',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary.withValues(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: groupedSessions.length,
                      itemBuilder: (context, index) {
                        final weekGroup = groupedSessions[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Week header
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 12, top: 8),
                              child: Text(
                                weekGroup['week'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            // Sessions in this week
                            ...weekGroup['sessions'].map<Widget>((session) {
                              return SessionListItem(session: session);
                            }).toList(),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Group sessions by week
  List<Map<String, dynamic>> _groupSessionsByWeek(List sessions) {
    if (sessions.isEmpty) return [];

    // Sort sessions by date
    final sortedSessions = List.from(sessions)
      ..sort((a, b) => a.date.compareTo(b.date));

    final Map<String, List> weekGroups = {};

    for (var session in sortedSessions) {
      final weekLabel = _getWeekLabel(session.date);
      if (!weekGroups.containsKey(weekLabel)) {
        weekGroups[weekLabel] = [];
      }
      weekGroups[weekLabel]!.add(session);
    }

    return weekGroups.entries.map((entry) {
      return {
        'week': entry.key,
        'sessions': entry.value,
      };
    }).toList();
  }

  // Helper: Get week label
  String _getWeekLabel(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return 'WEEK OF ${_getMonthAbbr(startOfWeek.month)} ${startOfWeek.day}';
  }

  // Helper: Get month abbreviation
  String _getMonthAbbr(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[month - 1];
  }

  // Helper: Count sessions with attendance marked
  int _getMarkedSessionsCount(List sessions) {
    return sessions.where((s) => s.attendanceStatus.isNotEmpty).length;
  }
}
