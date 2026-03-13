import 'package:get_it/get_it.dart';
import 'package:udevs_task/core/database/database_helper.dart';
import 'package:udevs_task/features/calendar/data/datasources/calendar_event_local_datasource.dart';
import 'package:udevs_task/features/calendar/data/repositories/calendar_event_repository_impl.dart';
import 'package:udevs_task/features/calendar/domain/repositories/calendar_event_repository.dart';
import 'package:udevs_task/features/calendar/domain/usecases/calendar_event_usecases.dart';
import 'package:udevs_task/features/calendar/presentation/bloc/calendar_event_bloc.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  serviceLocator.registerSingleton<DatabaseHelper>(DatabaseHelper.instance);

  serviceLocator.registerLazySingleton<CalendarEventLocalDatasource>(
    () => CalendarEventLocalDatasource(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<CalendarEventRepository>(
    () => CalendarEventRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => GetCalendarEventsByDateUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetCalendarEventsByMonthUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => AddCalendarEventUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateCalendarEventUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteCalendarEventUseCase(serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => CalendarEventBloc(
      getEventsByDate: serviceLocator(),
      getEventsByMonth: serviceLocator(),
      addEvent: serviceLocator(),
      updateEvent: serviceLocator(),
      deleteEvent: serviceLocator(),
    ),
  );
}
