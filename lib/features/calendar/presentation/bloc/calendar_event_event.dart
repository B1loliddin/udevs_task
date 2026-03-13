part of 'calendar_event_bloc.dart';

@immutable
sealed class CalendarEventEvent {
  const CalendarEventEvent();
}

class GetCalendarEventsByDateEvent extends CalendarEventEvent {
  final String date;

  const GetCalendarEventsByDateEvent(this.date);
}

class LoadMoreCalendarEventsEvent extends CalendarEventEvent {
  final String date;
  const LoadMoreCalendarEventsEvent(this.date);
}

class GetCalendarEventsByMonthEvent extends CalendarEventEvent {
  final String yearMonth; // format: '2026-03'

  const GetCalendarEventsByMonthEvent(this.yearMonth);
}

class AddCalendarEventEvent extends CalendarEventEvent {
  final CalendarEventEntity event;

  const AddCalendarEventEvent({required this.event});
}

class UpdateCalendarEventEvent extends CalendarEventEvent {
  final CalendarEventEntity event;

  const UpdateCalendarEventEvent({required this.event});
}

class DeleteCalendarEventEvent extends CalendarEventEvent {
  final String id;
  final String date;

  const DeleteCalendarEventEvent({required this.id, required this.date});
}
