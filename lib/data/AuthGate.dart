import 'package:baymax/UI/GSign_In.dart';
import 'package:baymax/UI/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      return SignInPage();
    }
  }
}
