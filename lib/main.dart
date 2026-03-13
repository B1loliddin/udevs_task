import 'dart:async';

import 'package:flutter/material.dart';
import 'package:udevs_task/app.dart';
import 'package:udevs_task/init_dependencies.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      /// catches flutter framework errors (widget build errors, rendering errors)
      FlutterError.onError = (FlutterErrorDetails details) {
        debugPrint('[FLUTTER ERROR]: ${details.exception}');
        debugPrint('[FLUTTER ERROR STACK]: ${details.stack}');
      };

      await initDependencies();
      runApp(const CalendarEventsApp());
    },

    /// catches all uncaught dart errors outside of flutter framework
    (Object error, StackTrace stack) {
      debugPrint('[ZONE ERROR] $error');
      debugPrint('[ZONE ERROR STACK] $stack');
    },
  );
}
