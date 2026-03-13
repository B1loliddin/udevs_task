abstract class AppStrings {
  static const List<String> daysOfTheWeek = <String>[
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  static const List<String> daysOfTheMonth = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// calendar page
  static const String schedule = 'Schedule';
  static const String addEvent = '+ Add Event';
  static const String noMoreEvents = 'No more events';
  static const String oopsSomethingWrong = 'Oops, something is wrong!!!';

  /// add event page
  static const String eventName = 'Event name';
  static const String eventDescription = 'Event description';
  static const String eventLocation = 'Event location';
  static const String priorityColor = 'Priority color';
  static const String eventTime = 'Event time';
  static const String addEventButton = 'Add Event';
  static const String pleaseFillOutField = 'Please fill out this field';
  static const String pleaseSelectStartAndEndTime =
      'Please select start and end time';
  static const String pleaseSelectStartTimeFirst =
      'Please select start time first';
  static const String endTimeResetMessage =
      'End time was reset. Please pick a new end time';
  static const String endTimeMustBeAfter = 'End time must be after start time';

  /// event details page
  static const String description = 'Description';
  static const String deleteEvent = 'Delete Event';
  static const String edit = 'Edit';
  static const String save = 'Save';
  static const String titleCannotBeEmpty = 'Title cannot be empty';
  static const String descriptionCannotBeEmpty = 'Description cannot be empty';
  static const String locationCannotBeEmpty = 'Location cannot be empty';

  static const String zero = '0';

  /// error messages
  static const String sorryError = 'Sorry: ';
}
