import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:udevs_task/core/constants/app_colors.dart';
import 'package:udevs_task/core/constants/app_icons.dart';

class MonthNavigatorWidget extends StatelessWidget {
  final DateTime displayDate;
  final ValueChanged<DateTime> onDateChanged;

  const MonthNavigatorWidget({
    super.key,
    required this.displayDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        /// previous month button
        GestureDetector(
          onTap: () {
            final DateTime newDate = displayDate.month == 1
                ? (displayDate.year == 1950
                      ? displayDate
                      : DateTime(displayDate.year - 1, 12, 1))
                : DateTime(displayDate.year, displayDate.month - 1, 1);
            onDateChanged(newDate);
          },
          child: ClipOval(
            child: ColoredBox(
              color: AppColors.FFEFEFEF,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  AppIcons.arrowBack,
                  width: 12,
                  height: 12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        /// next month button
        GestureDetector(
          onTap: () {
            final DateTime newDate = displayDate.month == 12
                ? (displayDate.year == 2950
                      ? displayDate
                      : DateTime(displayDate.year + 1, 1, 1))
                : DateTime(displayDate.year, displayDate.month + 1, 1);
            onDateChanged(newDate);
          },
          child: ClipOval(
            child: ColoredBox(
              color: AppColors.FFEFEFEF,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  AppIcons.arrowForward,
                  width: 12,
                  height: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
