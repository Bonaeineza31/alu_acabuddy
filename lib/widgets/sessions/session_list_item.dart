import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/session.dart';
import '../../providers/session_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';

class SessionListItem extends StatelessWidget {
  final Session session;

  const SessionListItem({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: session.isCompleted ? AppColors.success : AppColors.primary,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Course: ${session.course}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${formatDate(session.date)}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Icon(
                session.isCompleted
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: session.isCompleted
                    ? AppColors.success
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ));
  }

  String formatDate(DateTime date) {
    //  formatting: "MMM dd, yyyy"
    return "${date.month}/${date.day}/${date.year}";
  }
}
