import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Future<Map<DateTime, String>> fetchDatesWithData() async {
//   final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;
//   final fb.User? user = auth.currentUser;
//   final String? username = user!.displayName;
//   final String userId = user.uid;
//   final SupabaseClient supabase = Supabase.instance.client;
//   try {
//     // Query the calendar table to get the distinct dates with data
//     // final response = await supabase.from('calendar').select('date_cal');
//     final associationResponse = await supabase
//         .from('Cal_Assocaitation')
//         .select('cal_id')
//         .inFilter('useruid', [userId, 'Thisiseveryonedebug']);
//     // .eq('useruid', userId);

//     log("Fetched associations for user $username: $associationResponse");

//     final List<dynamic> calendarIds =
//         associationResponse.map((e) => e['cal_id']).toList();

//     // Query the calendar table to get the dates associated with these calendar IDs
//     final calendarResponse = await supabase
//         .from('calendar')
//         .select('date_cal, media_urls')
//         .inFilter('id', calendarIds); // Filter by calendar IDs

//     log("Fetched calendar data: $calendarResponse");
//     // .neq('date_cal', Null); // Ensure that the date is not null
//     log("32 $calendarResponse");
//     if (calendarResponse.isEmpty) {
//       throw Exception('Error fetching calendar data');
//     }

//     // Extract the dates from the response
//     final List<dynamic> data = calendarResponse as List<dynamic>;
//     log("19 ${data.toString()}");

//     // // Convert the date strings to DateTime objects
//     // final Set<DateTime> datesWithData = data.map((e) {
//     //   final date = e['date_cal'] as String;
//     //   // final pic = e['media_urls'] as String;
//     //   final dateTime =
//     //       DateTime.parse(date); // Parse the date string into DateTime
//     //   return DateTime(dateTime.year, dateTime.month,
//     //       dateTime.day); // assuming date is stored as a string
//     //   // return DateTime(
//     //   //     date.year, date.month, date.day); // Remove time for comparison
//     // }).toSet();
//     try {
//       final Map<DateTime, String> datesWithData = {
//         for (var e in data)
//           DateTime.parse(e['date_cal']): e['media_urls'] ?? 'No URL'
//       };
//       log("27 $datesWithData");
//       return datesWithData;
//     } catch (e) {
//       log("error gwting something $e");
//     }
//     return {};
//   } catch (e) {
//     log('Error fetching dates: $e');
//     return {};
//   }
// }
