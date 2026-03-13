import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:udevs_task/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:udevs_task/features/calendar/domain/usecases/calendar_event_usecases.dart';

part 'calendar_event_event.dart';
part 'calendar_event_state.dart';

class CalendarEventBloc extends Bloc<CalendarEventEvent, CalendarEventState> {
  final GetCalendarEventsByDateUseCase getEventsByDate;
  final GetCalendarEventsByMonthUseCase getEventsByMonth;
  final AddCalendarEventUseCase addEvent;
  final UpdateCalendarEventUseCase updateEvent;
  final DeleteCalendarEventUseCase deleteEvent;

  static const int _pageSize = 10;

  /// defines display order for priority color dots and event list: blue → red → orange
  static const List<int> _colorPriority = <int>[
    0xFF009FEE,
    0xFFEE2B00,
    0xFFEE8F00,
  ];

  CalendarEventBloc({
    required this.getEventsByDate,
    required this.getEventsByMonth,
    required this.addEvent,
    required this.updateEvent,
    required this.deleteEvent,
  }) : super(CalendarEventInitial()) {
    on<GetCalendarEventsByDateEvent>(_onGetEventsByDate);
    on<LoadMoreCalendarEventsEvent>(_onLoadMoreEvents);
    on<GetCalendarEventsByMonthEvent>(_onGetEventsByMonth);
    on<AddCalendarEventEvent>(_onAddEvent);
    on<UpdateCalendarEventEvent>(_onUpdateEvent);
    on<DeleteCalendarEventEvent>(_onDeleteEvent);
  }

  /// returns a sorted copy of events by defined priority color order
  static List<CalendarEventEntity> _sortByColor(
    List<CalendarEventEntity> events,
  ) {
    final List<CalendarEventEntity> sorted = List<CalendarEventEntity>.from(
      events,
    );
    sorted.sort(
      (CalendarEventEntity a, CalendarEventEntity b) => _colorPriority
          .indexOf(a.priorityColor)
          .compareTo(_colorPriority.indexOf(b.priorityColor)),
    );
    return sorted;
  }

  /// fetches first page of events for selected date
  Future<void> _onGetEventsByDate(
    GetCalendarEventsByDateEvent event,
    Emitter<CalendarEventState> emit,
  ) async {
    try {
      emit(CalendarEventLoading());

      final List<CalendarEventEntity> events = await getEventsByDate(
        event.date,
        limit: _pageSize,
        offset: 0,
      );

      final Map<String, List<int>> currentDotColors =
          state is CalendarEventLoaded
          ? (state as CalendarEventLoaded).monthDotColors
          : <String, List<int>>{};

      emit(
        CalendarEventLoaded(
          _sortByColor(events),
          monthDotColors: currentDotColors,
          hasMore: events.length == _pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(CalendarEventError(e.toString()));
    }
  }

  /// fetches next page and appends to existing events list
  Future<void> _onLoadMoreEvents(
    LoadMoreCalendarEventsEvent event,
    Emitter<CalendarEventState> emit,
  ) async {
    if (state is! CalendarEventLoaded) return;

    final CalendarEventLoaded current = state as CalendarEventLoaded;

    /// guard: do not load if already loading more or no more pages
    if (current.isLoadingMore || !current.hasMore) return;

    try {
      emit(current.copyWith(isLoadingMore: true));

      final List<CalendarEventEntity> newEvents = await getEventsByDate(
        event.date,
        limit: _pageSize,
        offset: current.events.length,
      );

      final List<CalendarEventEntity> merged = <CalendarEventEntity>[
        ...current.events,
        ...newEvents,
      ];

      emit(
        current.copyWith(
          events: _sortByColor(merged),
          hasMore: newEvents.length == _pageSize,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(CalendarEventError(e.toString()));
    }
  }

  /// fetches all events for the displayed month to show dots on calendar
  Future<void> _onGetEventsByMonth(
    GetCalendarEventsByMonthEvent event,
    Emitter<CalendarEventState> emit,
  ) async {
    try {
      final List<CalendarEventEntity> monthEvents = await getEventsByMonth(
        event.yearMonth,
      );

      /// build dot colors map: date → list of unique priority colors
      final Map<String, List<int>> dotColors = <String, List<int>>{};
      for (final CalendarEventEntity e in monthEvents) {
        dotColors.putIfAbsent(e.date, () => <int>[]);
        if (!dotColors[e.date]!.contains(e.priorityColor)) {
          dotColors[e.date]!.add(e.priorityColor);
        }
      }

      /// sort each day's colors by defined priority order: blue → red → orange
      for (final List<int> colors in dotColors.values) {
        colors.sort(
          (int a, int b) =>
              _colorPriority.indexOf(a).compareTo(_colorPriority.indexOf(b)),
        );
      }

      if (state is CalendarEventLoaded) {
        emit(
          (state as CalendarEventLoaded).copyWith(monthDotColors: dotColors),
        );
      }
    } catch (e) {
      emit(CalendarEventError(e.toString()));
    }
  }

  /// adds event then resets to first page
  Future<void> _onAddEvent(
    AddCalendarEventEvent event,
    Emitter<CalendarEventState> emit,
  ) async {
    try {
      await addEvent(event.event);
      await _onGetEventsByDate(
        GetCalendarEventsByDateEvent(event.event.date),
        emit,
      );
    } catch (e) {
      emit(CalendarEventError(e.toString()));
    }
  }

  /// updates event then resets to first page
  Future<void> _onUpdateEvent(
    UpdateCalendarEventEvent event,
    Emitter<CalendarEventState> emit,
  ) async {
    try {
      await updateEvent(event.event);
      await _onGetEventsByDate(
        GetCalendarEventsByDateEvent(event.event.date),
        emit,
      );
    } catch (e) {
      emit(CalendarEventError(e.toString()));
    }
  }

  /// deletes event then resets to first page
  Future<void> _onDeleteEvent(
    DeleteCalendarEventEvent event,
    Emitter<CalendarEventState> emit,
  ) async {
    try {
      await deleteEvent(event.id);
      await _onGetEventsByDate(GetCalendarEventsByDateEvent(event.date), emit);
    } catch (e) {
      emit(CalendarEventError(e.toString()));
    }
  }
}
