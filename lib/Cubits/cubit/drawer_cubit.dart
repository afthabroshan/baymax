import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(const DrawerState());
  final SupabaseClient _supabase = Supabase.instance.client;
  Future<void> fetchUsers() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await _supabase.from('Users').select();

      if (response.isNotEmpty) {
        emit(state.copyWith(
          users: List<Map<String, dynamic>>.from(response),
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
          users: [],
          isLoading: false,
        ));
        log("No users found");
      }
    } catch (e) {
      log('Error fetching users: $e');
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void setProfilePicture(String? pic) {
    emit(state.copyWith(pic: pic));
  }
}
