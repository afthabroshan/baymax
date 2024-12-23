import 'dart:developer';
import 'package:baymax/UI/Perski.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:google_sign_in/google_sign_in.dart';

const supabaseUrl = 'https://gijezcvasikjnukyognj.supabase.co';
const supabaseKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdpamV6Y3Zhc2lram51a3lvZ25qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM5ODcxOTgsImV4cCI6MjA0OTU2MzE5OH0.cSKYPycBDeGaJ4TFHWVnf8k9MR9ftSBxI40JP8LXPtQ";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const Perski());
  // final data = await Supabase.instance.client.from('calendar').select();
  // log("this is the data $data");
}
