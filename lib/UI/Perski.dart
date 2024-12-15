import 'package:baymax/UI/landing_page.dart';
import 'package:baymax/UI/mainpage.dart';
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
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 101, 101, 101)),
          useMaterial3: true,
        ),
        // home: const MainPage(),
        home: const LandingPage(),
      ),
    );
  }
}
