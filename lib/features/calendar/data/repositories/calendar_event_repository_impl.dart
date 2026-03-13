import 'package:udevs_task/features/calendar/data/datasources/calendar_event_local_datasource.dart';
import 'package:udevs_task/features/calendar/data/models/calendar_event_model.dart';
import 'package:udevs_task/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:udevs_task/features/calendar/domain/repositories/calendar_event_repository.dart';

class CalendarEventRepositoryImpl implements CalendarEventRepository {
  final CalendarEventLocalDatasource datasource;

  const CalendarEventRepositoryImpl(this.datasource);

  @override
  Future<List<CalendarEventEntity>> getEventsByDate(
    String date, {
    required int limit,
    required int offset,
  }) => datasource.getEventsByDate(date, limit: limit, offset: offset);

  @override
  Future<List<CalendarEventEntity>> getEventsByMonth(String yearMonth) =>
      datasource.getEventsByMonth(yearMonth);

  @override
  Future<void> addEvent(CalendarEventEntity event) =>
      datasource.addEvent(CalendarEventModel.fromEntity(event));

  @override
  Future<void> updateEvent(CalendarEventEntity event) =>
      datasource.updateEvent(CalendarEventModel.fromEntity(event));

  @override
  Future<void> deleteEvent(String id) => datasource.deleteEvent(id);
}
