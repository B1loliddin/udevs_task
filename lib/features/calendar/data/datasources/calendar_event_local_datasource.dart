import 'package:sqflite/sqflite.dart';
import 'package:udevs_task/core/database/database_helper.dart';
import 'package:udevs_task/features/calendar/data/models/calendar_event_model.dart';

class CalendarEventLocalDatasource {
  final DatabaseHelper dbHelper;

  const CalendarEventLocalDatasource(this.dbHelper);

  /// fetches all events added by user based on given date from sqflite local storage
  Future<List<CalendarEventModel>> getEventsByDate(
    String date, {
    required int limit,
    required int offset,
  }) async {
    final Database db = await dbHelper.database;
    final List<Map<String, Object?>> maps = await db.query(
      'events',
      where: 'date = ?',
      whereArgs: <Object?>[date],
      orderBy: 'start_time ASC',
      limit: limit,
      offset: offset,
    );

    return maps
        .map((Map<String, Object?> m) => CalendarEventModel.fromJson(m))
        .toList();
  }

  /// fetches all events added by user for a specific month from sqflite local storage
  Future<List<CalendarEventModel>> getEventsByMonth(String yearMonth) async {
    final Database db = await dbHelper.database;
    final List<Map<String, Object?>> maps = await db.query(
      'events',
      where: 'date LIKE ?',
      whereArgs: <Object?>['$yearMonth%'],
    );

    return maps
        .map((Map<String, Object?> m) => CalendarEventModel.fromJson(m))
        .toList();
  }

  /// adds an event to sqflite local storage
  Future<void> addEvent(CalendarEventModel event) async {
    final Database db = await dbHelper.database;

    await db.insert(
      'events',
      event.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// updates a particular event from sqflite local storage
  Future<void> updateEvent(CalendarEventModel event) async {
    final Database db = await dbHelper.database;

    await db.update(
      'events',
      event.toJson(),
      where: 'id = ?',
      whereArgs: <Object?>[event.id],
    );
  }

  /// totally deletes an event from sqflite local storage
  Future<void> deleteEvent(String id) async {
    final Database db = await dbHelper.database;

    await db.delete('events', where: 'id = ?', whereArgs: <Object?>[id]);
  }
}
