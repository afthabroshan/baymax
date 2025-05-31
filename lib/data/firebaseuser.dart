// class CurrentUser {
//   static final CurrentUser _instance = CurrentUser._internal();

//   // Private constructor
//   CurrentUser._internal();

//   // Factory constructor to return the same instance
//   factory CurrentUser() => _instance;

//   // User properties
//   String? uid;
//   String? email;
//   String? displayName;
//   String? photoURL;

//   // Method to set user details
//   void setUserDetails({
//     required String uid,
//     required String email,
//     required String displayName,
//     required String photoURL,
//   }) {
//     this.uid = uid;
//     this.email = email;
//     this.displayName = displayName;
//     this.photoURL = photoURL;
//   }

//   // Method to clear user details (e.g., during sign-out)
//   void clearUserDetails() {
//     uid = null;
//     email = null;
//     displayName = null;
//     photoURL = null;
//   }
// }
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();

  // Private constructor
  CurrentUser._internal();

  // Factory constructor
  factory CurrentUser() => _instance;

  // User properties
  String? uid;
  String? email;
  String? displayName;
  String? photoURL;

  // Keys for SharedPreferences
  static const _keyUid = 'uid';
  static const _keyEmail = 'email';
  static const _keyDisplayName = 'displayName';
  static const _keyPhotoURL = 'photoURL';

  // Set user details and save to SharedPreferences
  Future<void> setUserDetails({
    required String uid,
    required String email,
    required String displayName,
    required String photoURL,
  }) async {
    this.uid = uid;
    this.email = email;
    this.displayName = displayName;
    this.photoURL = photoURL;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUid, uid);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyDisplayName, displayName);
    await prefs.setString(_keyPhotoURL, photoURL);
  }

  // Load user details from SharedPreferences
  Future<void> loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString(_keyUid);
    email = prefs.getString(_keyEmail);
    displayName = prefs.getString(_keyDisplayName);
    photoURL = prefs.getString(_keyPhotoURL);
  }

  // Clear user details and remove from SharedPreferences
  Future<void> clearUserDetails() async {
    uid = null;
    email = null;
    displayName = null;
    photoURL = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUid);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyDisplayName);
    await prefs.remove(_keyPhotoURL);
    log("logged out shared pref");
  }
}
