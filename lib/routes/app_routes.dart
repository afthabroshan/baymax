// import 'package:flutter/material.dart';
// import 'package:baymax/UI/calendar_page.dart';
// import 'package:baymax/UI/landing_page.dart';
// import 'package:baymax/data/AuthGate.dart';

// class AppRoutes {
//   static const String initialRoute = '/';
//   static const String homeRoute = '/home';
//   static const String calendarPageRoute = '/CalendarPage';

//   static Map<String, WidgetBuilder> get routes => {
//         initialRoute: (context) => const AuthGate(),
//         homeRoute: (context) => const LandingPage(),
//         calendarPageRoute: (context) => const CalendarPage(),
//       };
// }

import 'package:baymax/UI/AI.dart';
import 'package:baymax/UI/intro.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:baymax/UI/calendar_page.dart';
import 'package:baymax/UI/landing_page.dart';
import 'package:baymax/data/AuthGate.dart';

final Logger logger = Logger();

class AppRoutes {
  static const String initialRoute = '/';
  static const String homeRoute = '/home';
  static const String calendarPageRoute = '/CalendarPage';
  static const String aiPageRoute = '/AIPage';
  static const String introPageRoute = '/IntroPage';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case initialRoute:
          return MaterialPageRoute(builder: (_) => const AuthGate());
        case introPageRoute:
          return MaterialPageRoute(builder: (_) => const BaymaxIntro());
        case homeRoute:
          return MaterialPageRoute(builder: (_) => const LandingPage());
        case calendarPageRoute:
          return MaterialPageRoute(builder: (_) => const CalendarPage());
        case aiPageRoute:
          return MaterialPageRoute(builder: (_) => AIPage());
        default:
          throw Exception("Route not found: ${settings.name}");
      }
    } catch (e, stackTrace) {
      logger.e("Navigation error occurred", error: e, stackTrace: stackTrace);
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('An error occurred, please try again later.'),
          ),
        ),
      );
    }
  }
}
