import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udevs_task/core/constants/app_colors.dart';
import 'package:udevs_task/core/constants/app_icons.dart';
import 'package:udevs_task/core/constants/app_strings.dart';
import 'package:udevs_task/core/utils/snackbar_utils.dart';
import 'package:udevs_task/core/utils/time_utils.dart';
import 'package:udevs_task/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:udevs_task/features/calendar/presentation/bloc/calendar_event_bloc.dart';
import 'package:udevs_task/features/calendar/presentation/widgets/custom_button_widget.dart';
import 'package:udevs_task/features/calendar/presentation/widgets/event_description_widget.dart';
import 'package:udevs_task/features/calendar/presentation/widgets/event_header_widget.dart';

class EventDetailsPage extends StatefulWidget {
  final CalendarEventEntity event;

  const EventDetailsPage({super.key, required this.event});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;

  late TimeOfDay? _startTime;
  late TimeOfDay? _endTime;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isEditing = false;

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
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController = TextEditingController(
      text: widget.event.description,
    );
    _locationController = TextEditingController(text: widget.event.location);
    _startTime = _parseTime(widget.event.startTime);
    _endTime = _parseTime(widget.event.endTime);
  }

  void _disposeAllControllers() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
  }

  TimeOfDay _parseTime(String time) {
    final List<String> parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
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

  void _saveEvent() {
    if (!_formKey.currentState!.validate()) return;

    final CalendarEventEntity updated = CalendarEventEntity(
      id: widget.event.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      priorityColor: widget.event.priorityColor,
      startTime: TimeUtils.formatTime(_startTime),
      endTime: TimeUtils.formatTime(_endTime),
      date: widget.event.date,
    );

    context.read<CalendarEventBloc>().add(
      UpdateCalendarEventEvent(event: updated),
    );
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// event header
            EventHeaderWidget(
              event: widget.event,
              isEditing: _isEditing,
              formKey: _formKey,
              titleController: _titleController,
              descriptionController: _descriptionController,
              locationController: _locationController,
              startTime: _startTime,
              endTime: _endTime,
              onBackTap: () => Navigator.pop(context),
              onEditSaveTap: () {
                if (_isEditing) {
                  _saveEvent();
                } else {
                  setState(() => _isEditing = true);
                }
              },
              onStartTimeTap: () => _pickStartTime(),
              onEndTimeTap: () => _pickEndTime(),
            ),
            const SizedBox(height: 28),

            /// event description
            EventDescriptionWidget(
              isEditing: _isEditing,
              descriptionController: _descriptionController,
            ),
          ],
        ),
      ),

      /// event delete button
      bottomNavigationBar: CustomButtonWidget(
        backgroundColor: AppColors.FFFEE8E9,
        title: AppStrings.deleteEvent,
        titleColor: AppColors.FF292929,
        iconPath: AppIcons.delete,
        onDeleteTap: () {
          context.read<CalendarEventBloc>().add(
            DeleteCalendarEventEvent(
              id: widget.event.id,
              date: widget.event.date,
            ),
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
