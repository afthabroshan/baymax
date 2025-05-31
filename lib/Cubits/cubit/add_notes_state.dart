// add_note_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNoteState {
  final String noteText;
  final bool isLoading;
  final List<Map<String, dynamic>> users;
  final String? errorMessage;
  final List<String> selectedUsers;
  final bool isSaving;

  AddNoteState({
    this.noteText = '',
    this.isLoading = false,
    this.users = const [],
    this.errorMessage,
    this.selectedUsers = const [],
    this.isSaving = false,
  });

  AddNoteState copyWith({
    String? noteText,
    bool? isLoading,
    List<Map<String, dynamic>>? users,
    String? errorMessage,
    List<String>? selectedUsers,
    bool? isSaving,
  }) {
    return AddNoteState(
      noteText: noteText ?? this.noteText,
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedUsers: selectedUsers ?? this.selectedUsers,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
