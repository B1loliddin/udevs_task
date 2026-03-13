class CalendarEventEntity {
  final String id;
  final String title;
  final String description;
  final String location;
  final int priorityColor;
  final String startTime;
  final String endTime;
  final String date;

  const CalendarEventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.priorityColor,
    required this.startTime,
    required this.endTime,
    required this.date,
  });
}
