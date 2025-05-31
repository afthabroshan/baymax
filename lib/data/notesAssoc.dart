import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> fetchUserNotes() async {
  final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;
  final fb.User? user = auth.currentUser;
  final String? userId = user?.uid;
  final oneWeekAgo = DateTime.now().subtract(Duration(days: 10));

  final SupabaseClient supabase = Supabase.instance.client;

  try {
    // Step 1: Get all associated note IDs for this user
    final associationResponse = await supabase
        .from('notes_ass')
        .select('note_id')
        .inFilter('user_id', [userId, 'Thisiseveryonedebug']);

    if (associationResponse.isEmpty) {
      log('No associated notes found for user.');
      return [];
    }

    final List<dynamic> noteIds =
        associationResponse.map((e) => e['note_id']).toList();

    log("Fetched associated note IDs: $noteIds");

    // Step 2: Fetch actual notes
    // final notesResponse = await supabase
    //     .from('notes')
    //     .select('note_id, note, created_at, user_id, Users(display_name)')
    //     .inFilter('note_id', noteIds)
    //     .order('created_at', ascending: false); // <-- sort by latest
    log('Date filter: ${oneWeekAgo.toIso8601String()}');
    final notesResponse = await supabase
        .from('notes')
        .select('note_id, note, created_at, user_id, Users(display_name)')
        .inFilter('note_id', noteIds)
        .gte('created_at',
            oneWeekAgo.toIso8601String()) // filter for last 1 week
        .order('created_at', ascending: false);
    log("Fetched notes: $notesResponse");

    return List<Map<String, dynamic>>.from(notesResponse);
  } catch (e) {
    log('Error fetching notes: $e');
    return [];
  }
}
