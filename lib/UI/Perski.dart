import 'package:baymax/UI/GSign_In.dart';
import 'package:baymax/UI/SideBarLayoutL.dart';
import 'package:baymax/UI/calendar_page.dart';
import 'package:baymax/UI/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthGate(),
          '/home': (context) => const LandingPage(),
          '/CalendarPage': (context) => const CalendarPage(),
        },
        // home: Sidebarlayoutl(),
        // home: const CalendarPage(),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    // Check if a user is already signed in
    if (user != null) {
      // If signed in, navigate to LandingPage
      return const LandingPage();
    } else {
      // Otherwise, show the SignInScreen
      return SignInScreen();
    }
  }
}
