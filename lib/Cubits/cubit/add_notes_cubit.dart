// add_note_cubit.dart
import 'dart:developer';

import 'package:baymax/Cubits/cubit/add_notes_state.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddNoteCubit extends Cubit<AddNoteState> {
  AddNoteCubit() : super(AddNoteState());

  void updateNote(String text) {
    emit(state.copyWith(noteText: text));
  }

  void clearNote() {
    emit(state.copyWith(noteText: ''));
  }

  Future<void> fetchUsers() async {
    try {
      final supabase = Supabase.instance.client;
      emit(state.copyWith(isLoading: true));
      log('Fetching users...');
      final response = await supabase
          .from('Users')
          .select('display_name, uid')
          .not('uid', 'eq', 'Thisiseveryonedebug');
      if (response.isNotEmpty) {
        log('Users fetched successfully: ${response.length} users found.');
        emit(state.copyWith(
          users: List<Map<String, dynamic>>.from(response),
          isLoading: false,
        ));
      } else {
        log('No users found.');
        emit(state.copyWith(users: [], isLoading: false));
      }
    } catch (e) {
      log('Error fetching users: $e');
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  void updateSelectedUsers(List<String> selectedUsers) {
    log('Updating selected users: ${selectedUsers.join(', ')}');
    emit(state.copyWith(selectedUsers: selectedUsers));
  }

  Future<void> saveNote() async {
    final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;
    final fb.User? user = auth.currentUser;
    final String? userId = user?.uid;
    final String notes = state.noteText.trim();
    final supabase = Supabase.instance.client;
    final selectedUserIDs = state.selectedUsers.isEmpty
        ? ['Thisiseveryonedebug']
        : state.selectedUsers;

    if (notes.isEmpty || userId == null) {
      log("Cannot save note: Empty summary or unauthenticated user.");
      return;
    }

    emit(state.copyWith(isSaving: true));

    try {
      log("Saving note for user $userId: $notes");

      // Insert the note
      final response = await supabase.from('notes').insert({
        'note': notes,
        'user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      }).select();
      log("reached here too");
      if (response.isNotEmpty) {
        final noteId = response[0]['note_id'];
        log("Note inserted with ID: $noteId");

        // Associate users
        for (final userUID in selectedUserIDs) {
          log("Associating note $noteId with user $userUID");
          await supabase.from('notes_ass').insert({
            'note_id': noteId,
            'user_id': userUID,
          });
        }
      } else {
        log("No response after inserting note.");
      }

      emit(state.copyWith(isSaving: false, noteText: "", selectedUsers: []));
    } catch (e) {
      log("Error saving note: $e");
      emit(state.copyWith(
        isSaving: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
