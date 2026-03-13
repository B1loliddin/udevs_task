import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udevs_task/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:udevs_task/features/calendar/presentation/bloc/calendar_event_bloc.dart';
import 'package:udevs_task/features/calendar/presentation/pages/add_event_page.dart';
import 'package:udevs_task/features/calendar/presentation/pages/calendar_page.dart';
import 'package:udevs_task/features/calendar/presentation/pages/event_details_page.dart';
import 'package:udevs_task/init_dependencies.dart';

class CalendarEventsApp extends StatelessWidget {
  const CalendarEventsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarEventBloc>(
      create: (_) => serviceLocator<CalendarEventBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const CalendarPage(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/calendar_page':
              return MaterialPageRoute<CalendarPage>(
                builder: (_) => const CalendarPage(),
              );

            case '/add_event_page':
              final DateTime selectedDate = settings.arguments as DateTime;

              return MaterialPageRoute<AddEventPage>(
                builder: (_) => AddEventPage(selectedDate: selectedDate),
              );

            case '/event_details_page':
              final CalendarEventEntity event =
                  settings.arguments as CalendarEventEntity;
              return MaterialPageRoute<EventDetailsPage>(
                builder: (_) => EventDetailsPage(event: event),
              );

            default:
              return MaterialPageRoute<CalendarPage>(
                builder: (_) => const CalendarPage(),
              );
          }
        },
      ),
    );
  }
}
