import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/assignment.dart';
import '../../providers/assignment_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../common/text_field.dart';
import '../common/button.dart';

class AddAssignmentDialog extends StatefulWidget {
  const AddAssignmentDialog({super.key});

  @override
  State<AddAssignmentDialog> createState() => _AddAssignmentDialogState();
}

class _AddAssignmentDialogState extends State<AddAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _courseController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedPriority = 'Medium';

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textWhite,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveAssignment() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final assignmentProvider =
          Provider.of<AssignmentProvider>(context, listen: false);

      final newAssignment = Assignment(
        title: _titleController.text.trim(),
        courseName: _courseController.text.trim(),
        dueDate: _selectedDate!,
        priority: _selectedPriority,
      );

      assignmentProvider.addAssignment(newAssignment);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Assignment added successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a due date'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  @override
Widget build(BuildContext context) {
  return Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
    child: Container(
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add New Assignment',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textWhite),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Assignment Title
                      CustomTextField(
                        label: 'Assignment Title *',
                        hint: 'Enter assignment title',
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter assignment title';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Course
                      CustomTextField(
                        label: 'Course *',
                        hint: 'Enter course name',
                        controller: _courseController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter course name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Due Date
                      const Text(
                        'Due Date *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.inputFill,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'Select due date'
                                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                style: TextStyle(
                                  color: _selectedDate == null
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
                                  fontSize: 16,
                                ),
                              ),
                              const Icon(
                                Icons.calendar_today,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Priority
                      const Text(
                        'Priority *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPriorityButton(
                                'High', AppColors.highPriority),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPriorityButton(
                                'Medium', AppColors.mediumPriority),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildPriorityButton(
                                'Low', AppColors.lowPriority),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Buttons
                      Row(
  children: [
    Expanded(
      child: CustomButton(
        text: 'Add Assignment',
        onPressed: _saveAssignment,
        icon: Icons.add_circle_outline,
      ),
    ),
    const SizedBox(width: 12),
    // Cancel button without Expanded - fixed width
    SizedBox(
      width: 100, 
      child: CustomButton(
        text: 'Cancel',
        onPressed: () => Navigator.pop(context),
        backgroundColor: AppColors.background,
        textColor: AppColors.textPrimary,
      ),
    ),
  ],
),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityButton(String priority, Color color) {
    final isSelected = _selectedPriority == priority;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            priority,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.textWhite : color,
            ),
          ),
        ),
      ),
    );
  }
}
