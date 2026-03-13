part of 'calendar_event_bloc.dart';

@immutable
sealed class CalendarEventState {
  const CalendarEventState();
}

final class CalendarEventInitial extends CalendarEventState {}

final class CalendarEventLoading extends CalendarEventState {}

final class CalendarEventLoaded extends CalendarEventState {
  final List<CalendarEventEntity> events;
  final Map<String, List<int>> monthDotColors;
  final bool hasMore;
  final bool isLoadingMore;

  const CalendarEventLoaded(
    this.events, {
    this.monthDotColors = const <String, List<int>>{},
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  CalendarEventLoaded copyWith({
    List<CalendarEventEntity>? events,
    Map<String, List<int>>? monthDotColors,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CalendarEventLoaded(
      events ?? this.events,
      monthDotColors: monthDotColors ?? this.monthDotColors,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final class CalendarEventError extends CalendarEventState {
  final String message;

  const CalendarEventError(this.message);
}
