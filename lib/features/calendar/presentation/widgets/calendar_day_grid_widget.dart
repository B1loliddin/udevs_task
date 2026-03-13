import 'package:flutter/material.dart';
import 'package:udevs_task/core/constants/app_colors.dart';
import 'package:udevs_task/core/utils/time_utils.dart';

class CalendarDayGrid extends StatelessWidget {
  final DateTime displayDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  final Map<String, List<int>> dotColors;

  const CalendarDayGrid({
    super.key,
    required this.displayDate,
    required this.selectedDate,
    required this.onDaySelected,
    required this.dotColors,
  });

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final int firstWeekday =
        DateTime(displayDate.year, displayDate.month, 1).weekday % 7;
    final int daysInMonth = DateUtils.getDaysInMonth(
      displayDate.year,
      displayDate.month,
    );
    final int rowCount = ((firstWeekday + daysInMonth) / 7).ceil();

    return Column(
      children: List<Widget>.generate(rowCount, (int row) {
        return Row(
          children: List<Widget>.generate(7, (int col) {
            final int day = row * 7 + col - firstWeekday + 1;

            if (day < 1 || day > daysInMonth) {
              return const Expanded(child: SizedBox(height: 52));
            }

            final DateTime date = DateTime(
              displayDate.year,
              displayDate.month,
              day,
            );

            final bool isSelected = _isSameDay(date, selectedDate);
            final List<int> dots =
                dotColors[TimeUtils.formatDate(date)] ?? <int>[];

            return Expanded(
              child: GestureDetector(
                onTap: () => onDaySelected(date),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  height: 52,
                  child: Column(
                    children: <Widget>[
                      DecoratedBox(
                        decoration: isSelected
                            ? const BoxDecoration(
                                color: AppColors.FF009FEE,
                                shape: BoxShape.circle,
                              )
                            : const BoxDecoration(),
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: Center(
                            child: Text(
                              '$day',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? AppColors.FFFFFFFF
                                    : AppColors.FF292929,
                              ),
                            ),
                          ),
                        ),
                      ),

                      if (dots.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: dots.map((int color) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 1.5,
                              ),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color(color),
                                  shape: BoxShape.circle,
                                ),
                                child: const SizedBox(width: 5, height: 5),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
