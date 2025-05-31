// import 'dart:developer';

// import 'package:baymax/data/googleSignIn.dart';
// import 'package:baymax/data/store_login.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

// class SignInScreen extends StatelessWidget {
//   // final firebase_auth.User user;
//   //  SignInScreen({super.key, required this.user});
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
//                 final firebaseUser =
//                     await _googleSignInProvider.signInWithFirebase();
//                 if (firebaseUser != null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Signed in as ${firebaseUser.displayName}'),
//                     ),
//                   );
//                   Navigator.pushReplacementNamed(context, '/home');
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

// sign_in_screen.dart
// import 'package:baymax/Cubits/cubit/AuthCubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

// class SignInScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) =>
//           AuthCubit(GoogleSignIn(), firebase_auth.FirebaseAuth.instance),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Google Sign-In with Firebase'),
//         ),
//         body: Center(
//           child: BlocConsumer<AuthCubit, AuthState>(
//             listener: (context, state) {
//               if (state.errorMessage != null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(state.errorMessage!)),
//                 );
//               } else if (state.user != null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                       content: Text('Signed in as ${state.user!.displayName}')),
//                 );
//                 Navigator.pushReplacementNamed(context, '/home');
//               }
//             },
//             builder: (context, state) {
//               if (state.isLoading) {
//                 return const CircularProgressIndicator();
//               }
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       await context.read<AuthCubit>().signInWithGoogle();
//                     },
//                     child: const Text('Sign in with Google'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       await context.read<AuthCubit>().signOut();
//                     },
//                     child: const Text('Sign Out'),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:baymax/Cubits/cubit/AuthCubit.dart';
import 'package:baymax/Globals/fonts.dart';
import 'package:baymax/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

// Make sure to adjust this path based on your project structure.

// class SignInPage extends StatelessWidget {
//   const SignInPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) =>
//           AuthCubit(GoogleSignIn(), firebase_auth.FirebaseAuth.instance),
//       child: Scaffold(
//         backgroundColor: AppColors.bgcolor,
//         body: SafeArea(
//           child: Center(
//             child: BlocConsumer<AuthCubit, AuthState>(
//               listener: (context, state) {
//                 if (state.errorMessage != null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(state.errorMessage!)),
//                   );
//                 } else if (state.user != null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                         content:
//                             Text('Signed in as ${state.user!.displayName}')),
//                   );
//                   Navigator.pushReplacementNamed(context, '/home');
//                 }
//               },
//               builder: (context, state) {
//                 if (state.isLoading) {
//                   return const CircularProgressIndicator();
//                 }

//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       const Spacer(),
//                       // App Icon or Logo
//                       Image.asset(
//                         'assets/afthab.png', // Your logo here
//                         height: 200,
//                       ),
//                       const SizedBox(height: 24),
//                       Text('Welcome to Afu\'s',
//                           style: AppTextStyles.calendarHeaders),
//                       Text('BAYMAX',
//                           style: AppTextStyles.aiContent
//                               .copyWith(fontSize: 30, color: Colors.teal)),
//                       const SizedBox(height: 12),
//                       Text('Sign in with your Google account to continue',
//                           textAlign: TextAlign.center,
//                           style: AppTextStyles.medContent),
//                       const SizedBox(height: 20),
//                       InkWell(
//                         onTap: () async {
//                           await context.read<AuthCubit>().signInWithGoogle();
//                         },
//                         child: Image.asset(
//                           'assets/google.png',
//                           height: 60,
//                           width: 60,
//                         ),
//                       ),
//                       const Spacer(),
//                       const Text(
//                         'Powered by Firebase & Afu\'s intelligence',
//                         style: AppTextStyles.smallContent,
//                       ),
//                       const SizedBox(height: 12),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthCubit(GoogleSignIn(), firebase_auth.FirebaseAuth.instance),
      child: Scaffold(
        backgroundColor: AppColors.bgcolor,
        body: SafeArea(
          child: Center(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage!)),
                  );
                } else if (state.user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Signed in as ${state.user!.displayName}')),
                  );
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.introPageRoute);
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return const CustomCircularProgressIndicator();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Spacer(),
                      Image.asset(
                        'assets/afthab.png',
                        height: 250,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome to Afu\'s',
                        style: AppTextStyles.calendarHeaders.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Gradient-styled "BAYMAX" text
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            // Color(0xFF00ACC1), // Stronger cyan-teal
                            // Color(0xFF00838F), // Deep teal
                            // AppColors
                            //     .blue,
                            //Color(0xFF00bcd4), Color(0xFF3f51b5), Color(0xFF2196f3)
                            const Color.fromARGB(255, 3, 205, 205),
                            Colors.teal,
                            AppColors.blue,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          'BAYMAX',
                          style: AppTextStyles.aiContent.copyWith(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Sign in with your Google account to continue',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.medContent.copyWith(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Styled Google sign-in button
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () async {
                          await context.read<AuthCubit>().signInWithGoogle();
                        },
                        child: Image.asset(
                          'assets/google.png',
                          height: 70,
                          width: 70,
                        ),
                      ),

                      const Spacer(),
                      const Text(
                        'Powered by Firebase & Afu\'s intelligence',
                        style: AppTextStyles.smallContent,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
