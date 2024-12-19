import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // // Perform async initialization tasks like Supabase queries
    // final data = await Supabase.instance.client.from('calendar').select();
    // log("This is the data: $data");

    // Simulate a delay to show the Lottie animation
    await Future.delayed(const Duration(seconds: 4));

    // Navigate to the main app screen
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Customize background color
      body: Center(
        child: Lottie.asset(
          'assets/cooking.json', // Add your Lottie file path here
          repeat: true,
          animate: true,
        ),
      ),
    );
  }
}
