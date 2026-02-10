import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/assignment.dart';
import '../../providers/assignment_provider.dart';
import '../../utils/app_colors.dart';
import '../common/text_field.dart';
import '../common/button.dart';

class EditAssignmentDialog extends StatefulWidget {
  final Assignment assignment;

  const EditAssignmentDialog({
    super.key,
    required this.assignment,
  });

  @override
  State<EditAssignmentDialog> createState() => _EditAssignmentDialogState();
}

class _EditAssignmentDialogState extends State<EditAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _courseController;
  late DateTime _selectedDate;
  late String _selectedPriority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.assignment.title);
    _courseController =
        TextEditingController(text: widget.assignment.courseName);
    _selectedDate = widget.assignment.dueDate;
    _selectedPriority = widget.assignment.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final assignmentProvider =
          Provider.of<AssignmentProvider>(context, listen: false);

      final updatedAssignment = widget.assignment.copyWith(
        title: _titleController.text.trim(),
        courseName: _courseController.text.trim(),
        dueDate: _selectedDate,
        priority: _selectedPriority,
      );

      assignmentProvider.updateAssignment(
          widget.assignment.id, updatedAssignment);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Assignment updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
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
                    'Edit Assignment',
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
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
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
                              text: 'Save Changes',
                              onPressed: _saveChanges,
                              icon: Icons.save,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
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
