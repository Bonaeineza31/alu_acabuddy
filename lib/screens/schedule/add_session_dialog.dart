import 'package:alu_acabuddy/widgets/common/button.dart';
import 'package:alu_acabuddy/widgets/common/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/session.dart';
import '../../providers/session_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';

class AddSessionDialog extends StatefulWidget {
  const AddSessionDialog({super.key});

  @override
  State<AddSessionDialog> createState() => _AddSessionDialogState();
}

class _AddSessionDialogState extends State<AddSessionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _selectedSessionType = 'Class';

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
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

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
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
        _endTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _saveSession() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _startTime != null &&
        _endTime != null) {
     
      final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

      final newSession = Session(
        title: _titleController.text.trim(),
        date: _selectedDate!,
        startTime: _formatTime(_startTime!),
        endTime: _formatTime(_endTime!),
        location: _locationController.text.trim(),
        sessionType: _selectedSessionType,
      );

      sessionProvider.addSession(newSession);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session added successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      String message = 'Please fill all required fields';
      if (_selectedDate == null) message = 'Please select a date';
      if (_startTime == null) message = 'Please select start time';
      if (_endTime == null) message = 'Please select end time';
     
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 650),
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
                    'Add New Session',
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
                      // Session Title
                      CustomTextField(
                        label: 'Session Title *',
                        hint: 'Enter session title',
                        controller: _titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter session title';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Session Type Dropdown
                      const Text(
                        'Session Type *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedSessionType,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.inputFill,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.border, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        items: AppConstants.sessionTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSessionType = value!;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Date
                      const Text(
                        'Date *',
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
                                    ? 'Select date'
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

                      // Start Time and End Time (side by side)
                      Row(
                        children: [
                          // Start Time
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Start Time *',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: _selectStartTime,
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
                                          _startTime == null
                                              ? 'Select'
                                              : _formatTime(_startTime!),
                                          style: TextStyle(
                                            color: _startTime == null
                                                ? AppColors.textSecondary
                                                : AppColors.textPrimary,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.access_time,
                                          color: AppColors.textSecondary,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          // End Time
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'End Time *',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: _selectEndTime,
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
                                          _endTime == null
                                              ? 'Select'
                                              : _formatTime(_endTime!),
                                          style: TextStyle(
                                            color: _endTime == null
                                                ? AppColors.textSecondary
                                                : AppColors.textPrimary,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.access_time,
                                          color: AppColors.textSecondary,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Location (Optional)
                      CustomTextField(
                        label: 'Location',
                        hint: 'Enter location (optional)',
                        controller: _locationController,
                      ),

                      const SizedBox(height: 24),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Add Session',
                              onPressed: _saveSession,
                              icon: Icons.add_circle_outline,
                            ),
                          ),
                          const SizedBox(width: 12),
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
}