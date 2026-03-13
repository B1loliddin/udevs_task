import 'package:udevs_task/features/calendar/domain/entities/calendar_event_entity.dart';

abstract class CalendarEventRepository {
  Future<List<CalendarEventEntity>> getEventsByDate(
    String date, {
    required int limit,
    required int offset,
  });
  Future<List<CalendarEventEntity>> getEventsByMonth(String yearMonth);
  Future<void> addEvent(CalendarEventEntity event);
  Future<void> updateEvent(CalendarEventEntity event);
  Future<void> deleteEvent(String id);
}
