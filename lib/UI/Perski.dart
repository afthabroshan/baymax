import 'package:baymax/UI/calendar_page.dart';
import 'package:baymax/UI/landing_page.dart';
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
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(192, 68, 137, 255)),
          useMaterial3: true,
        ),
        // initialRoute: '/splash',
        // routes: {
        //   '/splash': (context) => const SplashScreen(),
        //   '/home': (context) => const LandingPage(),
        // },
        home: const LandingPage(),
        // home: const CalendarPage(),
      ),
    );
  }
}
