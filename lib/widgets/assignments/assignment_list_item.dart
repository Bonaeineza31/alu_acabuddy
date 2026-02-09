import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/assignment.dart';
import '../../providers/assignment_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../screens/assignments/edit_assignment_screen.dart';

class AssignmentListItem extends StatelessWidget {
  final Assignment assignment;

  const AssignmentListItem({
    super.key,
    required this.assignment,
  });

  Color _getPriorityColor() {
    switch (assignment.priority) {
      case 'High':
        return AppColors.highPriority;
      case 'Medium':
        return AppColors.mediumPriority;
      case 'Low':
        return AppColors.lowPriority;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getBorderColor() {
    if (assignment.isCompleted) {
      return AppColors.success;
    }
    switch (assignment.priority) {
      case 'High':
        return AppColors.highPriority;
      case 'Medium':
        return AppColors.mediumPriority;
      default:
        return AppColors.lowPriority;
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignmentProvider = Provider.of<AssignmentProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            GestureDetector(
              onTap: () {
                assignmentProvider.toggleCompletion(assignment.id);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: assignment.isCompleted 
                      ? AppColors.success 
                      : Colors.transparent,
                  border: Border.all(
                    color: assignment.isCompleted 
                        ? AppColors.success 
                        : AppColors.textSecondary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: assignment.isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.textWhite,
                      )
                    : null,
              ),
            ),

            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    assignment.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      decoration: assignment.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Course
                  Row(
                    children: [
                      const Icon(
                        Icons.book,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        assignment.courseName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Due Date and Priority
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        Helpers.formatDate(assignment.dueDate),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          assignment.priority,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Action Buttons
            Column(
              children: [
                // Edit Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAssignmentDialog(
                          assignment: assignment,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
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
                const SizedBox(height: 8),

                // Delete Button
                GestureDetector(
                  onTap: () {
                    _showDeleteConfirmation(context, assignmentProvider);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
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
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AssignmentProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: const Text('Are you sure you want to delete this assignment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteAssignment(assignment.id);
              Navigator.pop(context);
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