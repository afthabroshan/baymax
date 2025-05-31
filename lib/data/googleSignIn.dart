// import 'dart:developer';

// import 'package:baymax/data/firebaseuser.dart';
// import 'package:baymax/data/store_login.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleSignInProvider {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   String? currentUserId;

//   /// Signs in the user with Google and Firebase
//   Future<User?> signInWithFirebase() async {
//     try {
//       // Sign in with Google
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         log("Google Sign-In canceled by user");
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
//       final User? user = userCredential.user;

//       if (user != null) {
//         // Capture user's login data
//         currentUserId = user.uid;
//         String uid = user.uid;
//         String email = user.email ?? 'No email';
//         String displayName = user.displayName ?? 'No display name';
//         String photoURL = user.photoURL ?? 'No photo URL';
//         // DateTime loginTimestamp = DateTime.now();
//         CurrentUser().setUserDetails(
//           uid: uid,
//           email: email,
//           displayName: displayName,
//           photoURL: photoURL,
//         );
//         // Send this data to your backend to store it in your database
//         await storeLoginInfo(uid, email, displayName, photoURL);
//       }
//       log("Firebase Sign-In successful: ${userCredential.user?.displayName}");
//       return userCredential.user;
//     } catch (error) {
//       log("Error during Firebase Sign-In: $error");
//       return null;
//     }
//   }
// }
