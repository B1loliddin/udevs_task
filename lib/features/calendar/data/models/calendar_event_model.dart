import 'package:udevs_task/features/calendar/domain/entities/calendar_event_entity.dart';

class CalendarEventModel extends CalendarEventEntity {
  const CalendarEventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.location,
    required super.priorityColor,
    required super.startTime,
    required super.endTime,
    required super.date,
  });

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'title': title,
    'description': description,
    'location': location,
    'priority_color': priorityColor,
    'start_time': startTime,
    'end_time': endTime,
    'date': date,
  };

  factory CalendarEventModel.fromJson(Map<String, Object?> json) =>
      CalendarEventModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        location: json['location'] as String,
        priorityColor: json['priority_color'] as int,
        startTime: json['start_time'] as String,
        endTime: json['end_time'] as String,
        date: json['date'] as String,
      );

  factory CalendarEventModel.fromEntity(CalendarEventEntity entity) =>
      CalendarEventModel(
        id: entity.id,
        title: entity.title,
        description: entity.description,
        location: entity.location,
        priorityColor: entity.priorityColor,
        startTime: entity.startTime,
        endTime: entity.endTime,
        date: entity.date,
      );

  CalendarEventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    int? priorityColor,
    String? startTime,
    String? endTime,
    String? date,
  }) {
    return CalendarEventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      priorityColor: priorityColor ?? this.priorityColor,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'CalendarEventModel(id: $id, title: $title, description: $description, '
        'location: $location, priorityColor: $priorityColor, '
        'startTime: $startTime, endTime: $endTime, date: $date)';
  }
}
