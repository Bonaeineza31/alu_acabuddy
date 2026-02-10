import 'package:alu_acabuddy/models/session.dart';
import 'package:alu_acabuddy/widgets/sessions/session_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/assignment_provider.dart';
import '../../providers/session_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/assignments/assignment_list_item.dart';
import 'add_session_dialog.dart';
import 'edit_session_dialog.dart';

class SchedulingScreen extends StatefulWidget {
  const SchedulingScreen({super.key});

  @override
  State<SchedulingScreen> createState() => _SchedulingScreenState();
}

class _SchedulingScreenState extends State<SchedulingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SessionProvider>(
        builder: (context, sessionProvider, child) {
      final sessions = sessionProvider.sessions;

      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.list_alt,
                          color: AppColors.textWhite,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Schedule',
                              style: TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${sessionProvider.completedCount} of ${sessions.length} completed',
                              style: const TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: AppColors.textWhite),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddSessionDialog(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Task List
              Expanded(
                child: Session.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 80,
                              color: const Color.fromARGB(255, 0, 0, 0),
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
                            const Text(
                              'Tap + to add your first session',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          return SessionListItem(
                            session: sessions[index],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
