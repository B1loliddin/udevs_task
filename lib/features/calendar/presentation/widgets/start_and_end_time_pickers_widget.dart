import 'package:flutter/material.dart';
import 'package:udevs_task/core/constants/app_colors.dart';
import 'package:udevs_task/core/constants/app_strings.dart';
import 'package:udevs_task/features/calendar/presentation/widgets/time_picker_widget.dart';

class StartAndEndTimePickersWidget extends StatelessWidget {
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final VoidCallback onStartTimeTap;
  final VoidCallback onEndTimeTap;
  final bool showTimeError;

  const StartAndEndTimePickersWidget({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onStartTimeTap,
    required this.onEndTimeTap,
    required this.showTimeError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            /// start time picker
            TimePickerWidget(onPressed: onStartTimeTap, time: startTime),

            /// time divider
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('—', style: TextStyle(color: AppColors.FF9E9E9E)),
            ),

            /// end time picker
            TimePickerWidget(onPressed: onEndTimeTap, time: endTime),
          ],
        ),

        if (showTimeError)
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 4),
            child: Text(
              AppStrings.pleaseSelectStartAndEndTime,
              style: TextStyle(color: AppColors.FFEE2B00, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
