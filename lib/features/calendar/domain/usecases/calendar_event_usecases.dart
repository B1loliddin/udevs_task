import 'package:udevs_task/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:udevs_task/features/calendar/domain/repositories/calendar_event_repository.dart';

class GetCalendarEventsByDateUseCase {
  final CalendarEventRepository repository;

  const GetCalendarEventsByDateUseCase(this.repository);

  Future<List<CalendarEventEntity>> call(
    String date, {
    required int limit,
    required int offset,
  }) => repository.getEventsByDate(date, limit: limit, offset: offset);
}

class GetCalendarEventsByMonthUseCase {
  final CalendarEventRepository repository;

  GetCalendarEventsByMonthUseCase(this.repository);

  Future<List<CalendarEventEntity>> call(String yearMonth) =>
      repository.getEventsByMonth(yearMonth);
}

class AddCalendarEventUseCase {
  final CalendarEventRepository repository;

  AddCalendarEventUseCase(this.repository);

  Future<void> call(CalendarEventEntity event) => repository.addEvent(event);
}

class UpdateCalendarEventUseCase {
  final CalendarEventRepository repository;

  UpdateCalendarEventUseCase(this.repository);

  Future<void> call(CalendarEventEntity event) => repository.updateEvent(event);
}

class DeleteCalendarEventUseCase {
  final CalendarEventRepository repository;

  DeleteCalendarEventUseCase(this.repository);

  Future<void> call(String id) => repository.deleteEvent(id);
}
