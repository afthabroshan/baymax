import 'package:baymax/Globals/fonts.dart';
import 'package:baymax/UI/AI.dart';
import 'package:baymax/UI/calendar_page.dart';
import 'package:baymax/UI/intro.dart';
import 'package:baymax/UI/landing_page.dart';
import 'package:baymax/data/AuthGate.dart';
import 'package:baymax/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Perski extends StatelessWidget {
  const Perski({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Perski',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.initialRoute,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        routes: {
          AppRoutes.initialRoute: (context) => const AuthGate(),
          AppRoutes.introPageRoute: (context) => const BaymaxIntro(),
          // AppRoutes.initialRoute: (context) => AIPage(),
          AppRoutes.homeRoute: (context) => const LandingPage(),
          // AppRoutes.homeRoute: (context) => AIPage(),
          AppRoutes.calendarPageRoute: (context) => const CalendarPage(),
          AppRoutes.aiPageRoute: (context) => AIPage(),
        },
      ),
    );
  }
}
