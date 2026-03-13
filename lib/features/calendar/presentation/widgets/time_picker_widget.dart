import 'package:flutter/material.dart';
import 'package:udevs_task/core/constants/app_colors.dart';
import 'package:udevs_task/core/utils/time_utils.dart';

class TimePickerWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final TimeOfDay? time;

  const TimePickerWidget({super.key, required this.onPressed, this.time});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color(0xFFF3F4F6),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Text(
              TimeUtils.formatTime(time),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: time == null
                    ? AppColors.FF9E9E9E
                    : const Color(0xFF212121),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
