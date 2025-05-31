// import 'package:equatable/equatable.dart';

import 'package:equatable/equatable.dart';
// part of 'memories_cubit.dart';

class MemoryState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>> users;
  final List<String> selectedUsers;
  final List<String> imagePaths;
  final String? errorMessage;
  final bool isSaving;

  const MemoryState({
    this.isLoading = true,
    this.users = const [],
    this.selectedUsers = const [],
    this.imagePaths = const [],
    this.errorMessage,
    this.isSaving = false,
  });

  @override
  List<Object?> get props =>
      [isLoading, users, selectedUsers, imagePaths, errorMessage];

  MemoryState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? users,
    List<String>? selectedUsers,
    List<String>? imagePaths,
    String? errorMessage,
    bool? isSaving,
  }) {
    return MemoryState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      selectedUsers: selectedUsers ?? this.selectedUsers,
      imagePaths: imagePaths ?? this.imagePaths,
      errorMessage: errorMessage ?? this.errorMessage,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
