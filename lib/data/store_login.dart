import 'dart:developer' as lg;
import 'dart:math';

import 'package:baymax/data/firebaseuser.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Future<void> storeLoginInfo(
//     String uid, String email, String displayName, String photoURL) async {
//   try {
//     final response = await Supabase.instance.client.from('Users').insert({
//       'uid': uid,
//       'email': email,
//       'display_name': displayName,
//       'photo_url': photoURL,
//     });
//     log("Login data saved succesfully");
//   } catch (error) {
//     log('Error storing login info: $error');
//   }
// }
// Future<void> storeLoginInfo(
//   String uid,
//   String email,
//   String displayName,
//   String photoURL,
// ) async {
//   try {
//     final client = Supabase.instance.client;

//     // Check if user already exists
//     final existingUser =
//         await client.from('Users').select().eq('uid', uid).maybeSingle();

//     if (existingUser != null) {
//       // User already exists - just update CurrentUser instance
//       CurrentUser().setUserDetails(
//         uid: uid,
//         email: email,
//         displayName: displayName,
//         photoURL: photoURL,
//       );
//       log('User already exists. CurrentUser updated: '
//           'uid=${CurrentUser().uid}, '
//           'email=${CurrentUser().email}, '
//           'displayName=${CurrentUser().displayName}, '
//           'photoURL=${CurrentUser().photoURL}');
//       return;
//     }

//     // User does not exist, insert new record
//     final response = await client.from('Users').insert({
//       'uid': uid,
//       'email': email,
//       'display_name': displayName,
//       'photo_url': photoURL,
//     }).select();

//     if (response == null) {
//       log('Error inserting user: ${response}');
//       return;
//     }

//     // Successfully inserted, update CurrentUser singleton
//     CurrentUser().setUserDetails(
//       uid: uid,
//       email: email,
//       displayName: displayName,
//       photoURL: photoURL,
//     );

//     log("Login data saved successfully and CurrentUser updated");
//   } catch (error) {
//     log('Error storing login info: $error');
//   }
// }
// Future<void> storeLoginInfo(
//   String uid,
//   String email,
//   String displayName,
//   // String photoURL,
// ) async {
//   try {
//     final client = Supabase.instance.client;

//     // Check if user already exists
//     final existingUser =
//         await client.from('Users').select().eq('uid', uid).maybeSingle();

//     // Update CurrentUser and SharedPreferences in both cases
//     final currentUser = CurrentUser();

//     if (existingUser != null) {
//       // User exists – no need to insert
//       await currentUser.setUserDetails(
//         uid: uid,
//         email: email,
//         displayName: displayName,
//         // photoURL: photoURL,
//       );
//       log('User already exists. CurrentUser updated: '
//           'uid=${currentUser.uid}, '
//           'email=${currentUser.email}, '
//           'displayName=${currentUser.displayName}, '
//           'photoURL=${currentUser.photoURL}');
//       return;
//     }

//     // User does not exist – insert new record
//     final response = await client.from('Users').insert({
//       'uid': uid,
//       'email': email,
//       'display_name': displayName,
//       'photo_url': photoURL,
//     }).select();

//     if (response == null || response.isEmpty) {
//       log('Error inserting user: $response');
//       return;
//     }

//     await currentUser.setUserDetails(
//       uid: uid,
//       email: email,
//       displayName: displayName,
//       photoURL: photoURL,
//     );

//     log("Login data saved successfully and CurrentUser updated");
//   } catch (error) {
//     log('Error storing login info: $error');
//   }
// }
// Future<String> getRandomAvatarUrl() async {
//   final storage = Supabase.instance.client.storage;

//   final response = await storage.from('images/avatars').list();
//   lg.log("this si the avatar response $response");
//   if (response.isEmpty) {
//     throw Exception('No avatars found in Supabase');
//   }

//   final random = Random();
//   final randomAvatar = response[random.nextInt(response.length)];

//   final publicUrl =
//       storage.from('images/avatars').getPublicUrl(randomAvatar.name);
//   lg.log("random avatar set");

//   return publicUrl;
// }
Future<String> getRandomAvatarUrl() async {
  final storage = Supabase.instance.client.storage;

  // ✅ List files in the 'avatars' folder inside the 'images' bucket
  final response = await storage.from('images').list(path: 'avatars');
  lg.log("📦 Avatar list response: $response");

  if (response.isEmpty) {
    throw Exception('No avatars found in Supabase');
  }

  // ✅ Pick a random file
  final random = Random();
  final randomAvatar = response[random.nextInt(response.length)];

  // ✅ Generate the public URL
  final publicUrl =
      storage.from('images').getPublicUrl('avatars/${randomAvatar.name}');
  lg.log("🎯 Selected random avatar: $publicUrl");

  return publicUrl;
}

Future<void> storeLoginInfo(
  String uid,
  String email,
  String displayName,
) async {
  try {
    final client = Supabase.instance.client;

    // Check if user already exists
    final existingUser =
        await client.from('Users').select().eq('uid', uid).maybeSingle();

    final currentUser = CurrentUser();

    if (existingUser != null) {
      // User exists – use existing avatar
      final existingPhotoURL = existingUser['photo_url'] ?? '';
      // String photoURL = await getRandomAvatarUrl(); //debugging purposes

      await currentUser.setUserDetails(
        uid: uid,
        email: email,
        displayName: displayName,
        photoURL: existingPhotoURL,
        // photoURL: photoURL, for debugging purposes
      );

      lg.log('User already exists. CurrentUser updated: '
          'uid=${currentUser.uid}, '
          'email=${currentUser.email}, '
          'displayName=${currentUser.displayName}, '
          'photoURL=${currentUser.photoURL}');
      return;
    }

    // User does not exist – assign random avatar
    String photoURL = await getRandomAvatarUrl();

    final response = await client.from('Users').insert({
      'uid': uid,
      'email': email,
      'display_name': displayName,
      'photo_url': photoURL,
    }).select();

    if (response == null || response.isEmpty) {
      lg.log('Error inserting user: $response');
      return;
    }

    await currentUser.setUserDetails(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
    );

    lg.log(
        "New user inserted. Login data saved successfully and CurrentUser updated");
  } catch (error) {
    lg.log('Error storing login info: $error');
  }
}
