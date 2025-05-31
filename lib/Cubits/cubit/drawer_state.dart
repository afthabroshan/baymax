part of 'drawer_cubit.dart';

@immutable
// sealed class DrawerState {}

final class DrawerInitial extends DrawerState {}

class DrawerState {
  final List<Map<String, dynamic>> users;
  final bool isLoading;
  final String? error;
  final String? pic;

  const DrawerState({
    this.users = const [],
    this.isLoading = false,
    this.pic,
    this.error,
  });

  DrawerState copyWith({
    List<Map<String, dynamic>>? users,
    bool? isLoading,
    String? pic,
    String? error,
  }) {
    return DrawerState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      pic: pic ?? this.pic,
      error: error ?? this.error,
    );
  }
}
