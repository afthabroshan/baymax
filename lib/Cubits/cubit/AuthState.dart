part of 'AuthCubit.dart';

@immutable
sealed class SignInState {}

final class SignInInitial extends SignInState {}

class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final firebase_auth.User? user;

  AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });
}
