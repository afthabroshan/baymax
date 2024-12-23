// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class SignInScreen extends StatelessWidget {
//   final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Sign-In'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final account = await _googleSignInProvider.signIn();
//             if (account != null) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Signed in as ${account.displayName}'),
//                 ),
//               );
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('Sign-In Failed'),
//                 ),
//               );
//             }
//           },
//           child: Text('Sign in with Google'),
//         ),
//       ),
//     );
//   }
// }

// class GoogleSignInProvider {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<GoogleSignInAccount?> signIn() async {
//     try {
//       final account = await _googleSignIn.signIn();
//       if (account == null) {
//         print("Sign-In canceled by user");
//       } else {
//         print("Signed in successfully: ${account.displayName}");
//       }
//       return account;
//     } catch (error) {
//       print("Google Sign-In Error: $error");
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class SignInScreen extends StatelessWidget {
//   final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Sign-In with Firebase'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 final user = await _googleSignInProvider.signInWithFirebase();
//                 if (user != null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Signed in as ${user.displayName}'),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Sign-In Failed'),
//                     ),
//                   );
//                 }
//               },
//               child: Text('Sign in with Google'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await _googleSignInProvider.signOut();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Signed out successfully'),
//                   ),
//                 );
//               },
//               child: Text('Sign Out'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class GoogleSignInProvider {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   /// Signs in the user with Google and Firebase
//   Future<User?> signInWithFirebase() async {
//     try {
//       // Sign in with Google
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         print("Google Sign-In canceled by user");
//         return null; // The user canceled the sign-in
//       }

//       // Authenticate with Firebase
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential =
//           await _firebaseAuth.signInWithCredential(credential);
//            final user = userCredential.user;

//         if (user != null){
//                 // Capture user's login data
//       String uid = user.uid;
//       String email = user.email ?? 'No email';
//       String displayName = user.displayName ?? 'No display name';
//       String photoURL = user.photoURL ?? 'No photo URL';
//       DateTime loginTimestamp = DateTime.now();

//       // Send this data to your backend to store it in your database
//       await storeLoginInfo(uid, email, displayName, photoURL, loginTimestamp);
//         }
//       print("Firebase Sign-In successful: ${userCredential.user?.displayName}");
//       return userCredential.user;
//     } catch (error) {
//       print("Error during Firebase Sign-In: $error");
//       return null;
//     }
//   }

//   Future<void> storeLoginInfo(String uid, String email, String displayName, String photoURL, DateTime timestamp) async {
//         final addusers = await Supabase.instance.client.from('Users').insert({
//       'uid': uid,
//       'email': email,
//       'display_name': displayName,
//       'photo_url' : photoURL,
//       'created_at' : timestamp
// // Assuming an empty list for media URLs for ssimplicity
//     });

//     if (addusers.error != null) {
//       print('Error inserting data: ${addusers.error!.message}');
//     } else {
//       print('Data inserted successfully: ${addusers.data}');
//     }
//   // Your backend logic here: Send the data to your server
//   // For example, make an HTTP request to your server to store the data in your database
// }

//   /// Signs out the user from Google and Firebase
//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       await _firebaseAuth.signOut();
//       print("User signed out successfully");
//     } catch (error) {
//       print("Error during Sign-Out: $error");
//     }
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SignInScreen extends StatelessWidget {
  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In with Firebase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final firebaseUser =
                    await _googleSignInProvider.signInWithFirebase();
                if (firebaseUser != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Signed in as ${firebaseUser.displayName}'),
                    ),
                  );
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sign-In Failed'),
                    ),
                  );
                }
              },
              child: Text('Sign in with Google'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _googleSignInProvider.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Signed out successfully'),
                  ),
                );
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleSignInProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  /// Signs in the user with Google and Firebase
  Future<firebase_auth.User?> signInWithFirebase() async {
    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Google Sign-In canceled by user");
        return null; // The user canceled the sign-in
      }

      // Authenticate with Firebase
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebase_auth.User? user = userCredential.user;

      if (user != null) {
        // Capture user's login data
        String uid = user.uid;
        String email = user.email ?? 'No email';
        String displayName = user.displayName ?? 'No display name';
        String photoURL = user.photoURL ?? 'No photo URL';
        // DateTime loginTimestamp = DateTime.now();

        // Send this data to your backend to store it in your database
        await storeLoginInfo(uid, email, displayName, photoURL);
      }
      print("Firebase Sign-In successful: ${userCredential.user?.displayName}");
      return userCredential.user;
    } catch (error) {
      print("Error during Firebase Sign-In: $error");
      return null;
    }
  }

  Future<void> storeLoginInfo(
      String uid, String email, String displayName, String photoURL) async {
    try {
      final response =
          await supabase.Supabase.instance.client.from('Users').insert({
        'uid': uid,
        'email': email,
        'display_name': displayName,
        'photo_url': photoURL,
      });
      // log(response);
      // if (response.error != null) {
      //   print('Error inserting data: ${response.error!.message}');
      // } else {
      //   print('Data inserted successfully: ${response.data}');
      // }
    } catch (error) {
      print('Error storing login info: $error');
    }
  }

  /// Signs out the user from Google and Firebase
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      print("User signed out successfully");
    } catch (error) {
      print("Error during Sign-Out: $error");
    }
  }
}
