import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:udevs_task/core/constants/app_colors.dart';
import 'package:udevs_task/core/constants/app_icons.dart';
import 'package:udevs_task/core/constants/app_strings.dart';
import 'package:udevs_task/core/utils/color_utils.dart';
import 'package:udevs_task/features/calendar/domain/entities/calendar_event_entity.dart';

class EventListWidget extends StatelessWidget {
  final List<CalendarEventEntity> events;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onLoadEvents;
  final VoidCallback onLoadMonthDots;

  const EventListWidget({
    super.key,
    required this.events,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadEvents,
    required this.onLoadMonthDots,
  });

  @override
  Widget build(BuildContext context) {
    /// read once instead of calling MediaQuery multiple times
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Column(
      children: <Widget>[
        ListView.separated(
          shrinkWrap: true,
          itemCount: events.length,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (BuildContext context, int index) {
            final CalendarEventEntity event = events[index];
            final Color textColor = ColorUtils.getTextColor(
              event.priorityColor,
            );

            return GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  '/event_details_page',
                  arguments: event,
                );
                onLoadEvents();
                onLoadMonthDots();
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: ColoredBox(
                  color: Color(event.priorityColor).withValues(alpha: 0.2),
                  child: SizedBox(
                    width: screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ColoredBox(
                          color: Color(event.priorityColor),
                          child: SizedBox(height: 10, width: screenWidth),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              /// event title
                              Text(
                                event.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),

                              /// event description
                              Text(
                                event.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: <Widget>[
                                  /// clock icon
                                  SvgPicture.asset(
                                    AppIcons.clock,
                                    width: 18,
                                    height: 18,
                                    colorFilter: ColorFilter.mode(
                                      Color(event.priorityColor),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 6),

                                  /// start and end time of an event
                                  Text(
                                    '${event.startTime} - ${event.endTime}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  /// location icon
                                  SvgPicture.asset(
                                    AppIcons.location,
                                    width: 18,
                                    height: 18,
                                    colorFilter: ColorFilter.mode(
                                      Color(event.priorityColor),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 6),

                                  /// event location text
                                  Expanded(
                                    child: Text(
                                      event.location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        /// spinner shown while next page is loading
        if (isLoadingMore)
          const Center(child: CircularProgressIndicator.adaptive()),

        /// shown when all pages have been loaded
        if (!hasMore && events.isNotEmpty)
          const Center(
            child: Text(
              AppStrings.noMoreEvents,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: AppColors.FF9E9E9E,
              ),
            ),
          ),
      ],
    );
  }
}
