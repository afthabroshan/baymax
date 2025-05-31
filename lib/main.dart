import 'dart:developer';
import 'package:baymax/Config/supa.dart';
import 'package:baymax/UI/Perski.dart';
import 'package:baymax/data/firebaseuser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  final Logger logger = Logger();
  WidgetsFlutterBinding.ensureInitialized();
  await CurrentUser().loadUserDetails();
  // await deletenoteEntries();
  // // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // await Supabase.initialize(url: SupabaseConfig.supabaseUrl, anonKey: SupabaseConfig.supabaseKey);
  // runApp(const Perski());
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    log("Firebase initialized successfully.");
  } catch (e) {
    log("Error initializing Firebase: $e");
  }

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseKey,
    );
    log("Supabase initialized successfully.");
  } catch (e) {
    log("Error initializing Supabase: $e");
  }
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final fCMtoken = await messaging.getToken();
      log(fCMtoken.toString());
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification != null) {
          log('Message received: ${message.notification!.title}');
        }
      });
      log(fCMtoken.toString());
      log('User granted permission');
    } else {
      log('User denied permission');
    }
  } catch (e) {
    log("$e");
  }
  // Run Application
  log("Starting application...");
  try {
    logger.i("Application Started");
    runApp(const Perski());
  } catch (e, stackTrace) {
    logger.e("Unhandled exception", error: e, stackTrace: stackTrace);
  }
}
