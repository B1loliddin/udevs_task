import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:udevs_task/core/constants/app_colors.dart';
import 'package:udevs_task/core/constants/app_icons.dart';
import 'package:udevs_task/core/constants/app_strings.dart';
import 'package:udevs_task/core/utils/snackbar_utils.dart';
import 'package:udevs_task/core/utils/time_utils.dart';
import 'package:udevs_task/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:udevs_task/features/calendar/presentation/bloc/calendar_event_bloc.dart';
import 'package:udevs_task/features/calendar/presentation/widgets/custom_button_widget.dart';
import 'package:udevs_task/features/calendar/presentation/widgets/custom_text_field_widget.dart';
import 'package:udevs_task/features/calendar/presentation/widgets/priority_color_picker_widget.dart';
import 'package:udevs_task/features/calendar/presentation/widgets/start_and_end_time_pickers_widget.dart';

class AddEventPage extends StatefulWidget {
  final DateTime selectedDate;

  const AddEventPage({super.key, required this.selectedDate});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Color _selectedPriorityColor = AppColors.FF009FEE;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool _showTimeError = false;

  @override
  void initState() {
    super.initState();
    _initAllControllers();
  }

  @override
  void dispose() {
    _disposeAllControllers();
    super.dispose();
  }

  void _initAllControllers() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
  }

  void _disposeAllControllers() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
  }

  Future<void> _pickStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    final bool conflictsWithEnd =
        _endTime != null &&
        picked.hour * 60 + picked.minute >=
            _endTime!.hour * 60 + _endTime!.minute;

    setState(() {
      _startTime = picked;
      if (conflictsWithEnd) _endTime = null;
    });

    if (conflictsWithEnd && mounted) {
      SnackbarUtils.showSnackBar(context, AppStrings.endTimeResetMessage);
    }
  }

  Future<void> _pickEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked == null) return;

    final bool conflictsWithStart =
        _startTime != null &&
        picked.hour * 60 + picked.minute <=
            _startTime!.hour * 60 + _startTime!.minute;

    if (conflictsWithStart && mounted) {
      SnackbarUtils.showSnackBar(context, AppStrings.endTimeMustBeAfter);
      return;
    }

    setState(() => _endTime = picked);
  }

  Future<void> _saveEvent() async {
    final bool isFormValid = _formKey.currentState!.validate();
    final bool didSetTime = _startTime != null && _endTime != null;

    setState(() => _showTimeError = !didSetTime);

    if (!isFormValid || !didSetTime) return;

    final CalendarEventEntity event = CalendarEventEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      priorityColor: _selectedPriorityColor.toARGB32(),
      startTime: TimeUtils.formatTime(_startTime),
      endTime: TimeUtils.formatTime(_endTime),
      date: TimeUtils.formatDate(widget.selectedDate),
    );

    if (mounted) {
      context.read<CalendarEventBloc>().add(
        AddCalendarEventEvent(event: event),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets devicePadding = MediaQuery.paddingOf(context);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.only(
              left: 28,
              right: 28,
              top: devicePadding.top + 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    AppIcons.arrowBackTwo,
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(height: 36),

                /// all text fields
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(AppStrings.eventName),
                      const SizedBox(height: 6),
                      CustomTextFieldWidget(controller: _titleController),
                      const SizedBox(height: 16),

                      const Text(AppStrings.eventDescription),
                      const SizedBox(height: 6),
                      CustomTextFieldWidget(
                        controller: _descriptionController,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 16),

                      const Text(AppStrings.eventLocation),
                      const SizedBox(height: 6),
                      CustomTextFieldWidget(
                        controller: _locationController,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: SvgPicture.asset(
                            AppIcons.location,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF2196F3),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                /// priority color picker
                const Text(AppStrings.priorityColor),
                const SizedBox(height: 6),
                PriorityColorPickerWidget(
                  selectedColor: _selectedPriorityColor,
                  onColorChanged: (Color color) =>
                      setState(() => _selectedPriorityColor = color),
                ),
                const SizedBox(height: 16),

                /// start and end time picker
                const Text(AppStrings.eventTime),
                const SizedBox(height: 6),
                StartAndEndTimePickersWidget(
                  startTime: _startTime,
                  endTime: _endTime,
                  onStartTimeTap: _pickStartTime,
                  onEndTimeTap: () {
                    if (_startTime == null) {
                      SnackbarUtils.showSnackBar(
                        context,
                        AppStrings.pleaseSelectStartTimeFirst,
                      );
                      return;
                    }
                    _pickEndTime();
                  },
                  showTimeError: _showTimeError,
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        /// add event button
        bottomNavigationBar: CustomButtonWidget(
          onDeleteTap: _saveEvent,
          backgroundColor: AppColors.FF009FEE,
          title: AppStrings.addEventButton,
          titleColor: AppColors.FFFFFFFF,
        ),
      ),
    );
  }
}
