import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:udevs_task/core/constants/app_colors.dart';
import 'package:udevs_task/core/constants/app_icons.dart';
import 'package:udevs_task/core/constants/app_strings.dart';
import 'package:udevs_task/core/utils/time_utils.dart';
import 'package:udevs_task/features/calendar/presentation/bloc/calendar_event_bloc.dart';
import 'package:udevs_task/features/calendar/presentation/widgets/calendar_day_grid_widget.dart';
import 'package:udevs_task/features/calendar/presentation/widgets/event_list_widget.dart';
import 'package:udevs_task/features/calendar/presentation/widgets/month_navigator_widget.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final ScrollController _scrollController = ScrollController();

  late DateTime selectedDate;
  late DateTime displayDate;

  /// prevents duplicate calls
  bool _isPaginating = false;

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
    _scrollController.addListener(_onScroll);
    selectedDate = DateTime.now();
    displayDate = DateTime.now();
    _loadEvents();
    _loadMonthDots();
  }

  void _disposeAllControllers() {
    _scrollController.dispose();
  }

  void _loadEvents() {
    _isPaginating = false;
    context.read<CalendarEventBloc>().add(
      GetCalendarEventsByDateEvent(TimeUtils.formatDate(selectedDate)),
    );
  }

  void _loadMonthDots() {
    context.read<CalendarEventBloc>().add(
      GetCalendarEventsByMonthEvent(TimeUtils.formatYearMonth(displayDate)),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isPaginating) return;

    final bool isNearBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;

    if (!isNearBottom) return;

    final CalendarEventState state = context.read<CalendarEventBloc>().state;
    if (state is! CalendarEventLoaded || !state.hasMore) return;

    _isPaginating = true;
    context.read<CalendarEventBloc>().add(
      LoadMoreCalendarEventsEvent(TimeUtils.formatDate(selectedDate)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /// displayed day of the week
            Text(
              AppStrings.daysOfTheWeek[selectedDate.weekday % 7],
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.FF292929,
              ),
            ),

            /// displayed day, month, and year
            Text(
              '${selectedDate.day} ${AppStrings.daysOfTheMonth[selectedDate.month - 1]} ${selectedDate.year}',
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                color: AppColors.FF292929,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          /// notification icon
          Badge(
            smallSize: 10,
            backgroundColor: AppColors.FF009FEE,
            child: SvgPicture.asset(AppIcons.notification),
          ),
          const SizedBox(width: 28),
        ],
      ),

      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              /// selected month and month navigator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  /// selected month
                  Text(
                    AppStrings.daysOfTheMonth[displayDate.month - 1],
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: AppColors.FF292929,
                    ),
                  ),

                  /// month navigator
                  MonthNavigatorWidget(
                    displayDate: displayDate,
                    onDateChanged: (DateTime newDate) {
                      setState(() => displayDate = newDate);
                      _loadMonthDots();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// days of the week
              Row(
                children: AppStrings.daysOfTheWeek.map((String label) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          color: AppColors.FF969696,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              /// days of the month
              BlocBuilder<CalendarEventBloc, CalendarEventState>(
                buildWhen:
                    (CalendarEventState previous, CalendarEventState current) {
                      if (previous is CalendarEventLoaded &&
                          current is CalendarEventLoaded) {
                        return previous.monthDotColors !=
                            current.monthDotColors;
                      }
                      return true;
                    },
                builder: (BuildContext context, CalendarEventState state) {
                  final Map<String, List<int>> dotColors =
                      state is CalendarEventLoaded
                      ? state.monthDotColors
                      : <String, List<int>>{};

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.05, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                    child: CalendarDayGrid(
                      key: ValueKey<DateTime>(
                        DateTime(displayDate.year, displayDate.month),
                      ),
                      selectedDate: selectedDate,
                      displayDate: DateTime(
                        displayDate.year,
                        displayDate.month,
                      ),
                      dotColors: dotColors,
                      onDaySelected: (DateTime date) {
                        setState(() => selectedDate = date);
                        _loadEvents();
                        _loadMonthDots();
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              /// schedule text and add event button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  /// schedule text
                  const Text(
                    AppStrings.schedule,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: AppColors.FF292929,
                    ),
                  ),

                  /// add event button
                  AddEventButtonWidget(
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        '/add_event_page',
                        arguments: selectedDate,
                      );
                      _loadEvents();
                      _loadMonthDots();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 18),

              /// all events for displayed day
              BlocConsumer<CalendarEventBloc, CalendarEventState>(
                listenWhen:
                    (CalendarEventState previous, CalendarEventState current) {
                      if (current is! CalendarEventLoaded) return false;
                      if (previous is! CalendarEventLoaded) return true;
                      return previous.isLoadingMore && !current.isLoadingMore;
                    },
                listener: (BuildContext context, CalendarEventState state) {
                  _isPaginating = false;
                },
                buildWhen:
                    (CalendarEventState previous, CalendarEventState current) {
                      if (previous is CalendarEventLoaded &&
                          current is CalendarEventLoaded) {
                        return previous.events != current.events ||
                            previous.isLoadingMore != current.isLoadingMore ||
                            previous.hasMore != current.hasMore;
                      }
                      return true;
                    },
                builder: (BuildContext context, CalendarEventState state) {
                  if (state is CalendarEventLoading) {
                    return const CircularProgressIndicator.adaptive();
                  } else if (state is CalendarEventLoaded) {
                    return EventListWidget(
                      events: state.events,
                      isLoadingMore: state.isLoadingMore,
                      hasMore: state.hasMore,
                      onLoadEvents: _loadEvents,
                      onLoadMonthDots: _loadMonthDots,
                    );
                  } else if (state is CalendarEventError) {
                    return Text('${AppStrings.sorryError}${state.message}');
                  } else {
                    return const Text(AppStrings.oopsSomethingWrong);
                  }
                },
              ),

              SizedBox(height: bottomPadding > 0 ? bottomPadding : 16),
            ],
          ),
        ),
      ),
    );
  }
}

class AddEventButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const AddEventButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: ColoredBox(
          color: AppColors.FF009FEE,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 22),
            child: Text(
              AppStrings.addEvent,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.FFFFFFFF,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
