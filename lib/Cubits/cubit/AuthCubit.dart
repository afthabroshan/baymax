import 'package:baymax/data/firebaseuser.dart';
import 'package:baymax/data/store_login.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'AuthState.dart';

// class AuthCubit extends Cubit<AuthState> {
//   final GoogleSignIn _googleSignIn;
//   final firebase_auth.FirebaseAuth _firebaseAuth;

//   AuthCubit(this._googleSignIn, this._firebaseAuth) : super(AuthState());

//   Future<void> signInWithGoogle() async {
//     try {
//       emit(AuthState(isLoading: true)); // Set loading state
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser == null) {
//         emit(AuthState(errorMessage: "Google Sign-In failed"));
//         return;
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final firebase_auth.AuthCredential credential =
//           firebase_auth.GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final firebase_auth.UserCredential userCredential =
//           await _firebaseAuth.signInWithCredential(credential);

//       emit(AuthState(user: userCredential.user));
//     } catch (e) {
//       emit(AuthState(errorMessage: e.toString()));
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       await _firebaseAuth.signOut();
//       emit(AuthState(user: null)); // Reset user after sign-out
//     } catch (e) {
//       emit(AuthState(errorMessage: e.toString()));
//     }
//   }
// }

class AuthCubit extends Cubit<AuthState> {
  final GoogleSignIn _googleSignIn;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  String? currentUserId;

  AuthCubit(this._googleSignIn, this._firebaseAuth) : super(AuthState());

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthState(isLoading: true)); // Set loading state
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        emit(AuthState(errorMessage: "Google Sign-In failed"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user != null) {
        // Capture user's login data
        currentUserId = user.uid;
        String uid = user.uid;
        String email = user.email ?? 'No email';
        String displayName = user.displayName ?? 'No display name';
        // String photoURL = user.photoURL ?? 'No photo URL';

        // String photoURL =
        //     "https://gijezcvasikjnukyognj.supabase.co/storage/v1/object/public/images/avatars/afthab.jpg";

        // Update CurrentUser singleton or manager
        // CurrentUser().setUserDetails(
        //   uid: uid,
        //   email: email,
        //   displayName: displayName,
        //   // photoURL: photoURL,
        // );

        // Store login info to your backend or DB
        await storeLoginInfo(uid, email, displayName);
      }

      emit(AuthState(user: user));
    } catch (e) {
      emit(AuthState(errorMessage: e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      emit(AuthState(user: null)); // Reset user after sign-out
    } catch (e) {
      emit(AuthState(errorMessage: e.toString()));
    }
  }
}
