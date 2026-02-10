import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/session.dart';
import '../../providers/session_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/common/text_field.dart';
import '../../widgets/common/button.dart';

class EditSessionDialog extends StatefulWidget {
  final Session session;

  const EditSessionDialog({
    super.key,
    required this.session,
  });

  @override
  State<EditSessionDialog> createState() => _EditSessionDialogState();
}

class _EditSessionDialogState extends State<EditSessionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late String _selectedSessionType;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.session.title);
    _locationController = TextEditingController(text: widget.session.location);
    _selectedDate = widget.session.date;
    _selectedSessionType = widget.session.sessionType;

    // Parse time strings
    final startParts = widget.session.startTime.split(':');
    _startTime = TimeOfDay(
      hour: int.parse(startParts[0]),
      minute: int.parse(startParts[1]),
    );

    final endParts = widget.session.endTime.split(':');
    _endTime = TimeOfDay(
      hour: int.parse(endParts[0]),
      minute: int.parse(endParts[1]),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
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

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
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
      initialTime: _endTime,
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

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final sessionProvider =
          Provider.of<SessionProvider>(context, listen: false);

      final updatedSession = widget.session.copyWith(
        title: _titleController.text.trim(),
        date: _selectedDate,
        startTime: _formatTime(_startTime),
        endTime: _formatTime(_endTime),
        location: _locationController.text.trim(),
        sessionType: _selectedSessionType,
      );

      sessionProvider.updateSession(widget.session.id, updatedSession);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session updated successfully!'),
          backgroundColor: AppColors.success,
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
              color: Colors.black,
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
                    'Edit Session',
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

            // Form Content (same as Add Session, but with Save Changes button)
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
                            borderSide: const BorderSide(
                                color: AppColors.border, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 2),
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

                      // Start Time and End Time
                      Row(
                        children: [
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
                                      border:
                                          Border.all(color: AppColors.border),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatTime(_startTime),
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
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
                                      border:
                                          Border.all(color: AppColors.border),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatTime(_endTime),
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
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

                      // Location
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
                              text: 'Save Changes',
                              onPressed: _saveChanges,
                              icon: Icons.check_circle_outline,
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
