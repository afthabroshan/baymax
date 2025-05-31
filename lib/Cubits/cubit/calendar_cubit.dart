// // import 'package:baymax/data/association.dart';
// // import 'package:bloc/bloc.dart';
// // import 'package:equatable/equatable.dart';

// // part 'calendar_state.dart';

// // class CalendarCubit extends Cubit<CalendarState> {
// //   final CalendarResository _calendarRepository;

// //   CalendarCubit(this._calendarRepository) : super(CalendarInitial());

// //   Future<void> fetchDates() async {
// //     try {
// //       emit(CalendarLoading());
// //       final datesWithData = await _calendarRepository.fetchDatesWithData();
// //       emit(CalendarLoaded(datesWithData));
// //     } catch (e) {
// //       emit(CalendarError('Failed to load dates'));
// //     }
// //   }
// // }

import 'dart:developer';

import 'package:baymax/UI/reminders.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:baymax/data/association.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'calendar_state.dart';

// class CalendarCubit extends Cubit<CalendarState> {
//   CalendarCubit() : super(CalendarState.initial()) {
//     _fetchDates();
//   }

//   Future<void> _fetchDates() async {
//     final datesWithData = await fetchDatesWithData();
//     emit(state.copyWith(datesWithData: datesWithData));
//   }

//   void selectDay(DateTime date) {
//     emit(state.copyWith(selectedDay: date));
//   }

//   bool hasData(DateTime date) {
//     return state.datesWithData.keys.any(
//       (key) =>
//           key.year == date.year &&
//           key.month == date.month &&
//           key.day == date.day,
//     );
//   }
// }

// class CalendarCubit extends Cubit<CalendarState> {
//   CalendarCubit() : super(CalendarLoading()) {
//     _fetchDates();
//   }

//   Future<void> _fetchDates() async {
//     try {
//       emit(CalendarLoading()); // Emit loading state
//       final datesWithData = await fetchDatesWithData(); // Fetch data
//       emit(CalendarLoaded(
//           selectedDay: DateTime.now(),
//           datesWithData: datesWithData)); // Emit loaded state
//     } catch (e) {
//       emit(CalendarError("Failed to load calendar data"));
//     }
//   }

//   void selectDay(DateTime date) {
//     if (state is CalendarLoaded) {
//       emit((state as CalendarLoaded).copyWith(selectedDay: date));
//     }
//   }

//   bool hasData(DateTime date) {
//     if (state is CalendarLoaded) {
//       return (state as CalendarLoaded).datesWithData.containsKey(date);
//     }
//     return false;
//   }
// }

// class CalendarCubit extends Cubit<CalendarState> {
//   CalendarCubit() : super(CalendarLoading()) {
//     _initCalendar();
//   }
//   // late final ValueNotifier<List<DateTime>> selectedDays;

//   Future<void> _initCalendar() async {
//     final FocusedDay = ValueNotifier(DateTime.now());
//     final SelectedDays = ValueNotifier([DateTime.now()]);
//     final datesWithData = await fetchDatesWithData();
//     emit(CalendarLoaded(
//       datesWithData: datesWithData,
//       selectedDays: SelectedDays,
//       focusedDay: FocusedDay,
//     ));
//   }

//   void selectDay(DateTime date) {
//     if (state is CalendarLoaded) {
//       final currentState = state as CalendarLoaded;
//       // currentState.selectedDays.value = [date];
//       // currentState.focusedDay.value = date;
//       emit(currentState.copyWith(
//         selectedDays: ValueNotifier([date]), // Ensure this is a ValueNotifier
//         focusedDay: ValueNotifier(date),
//       ));
//     }
//   }

//   bool hasData(DateTime date) {
//     if (state is CalendarLoaded) {
//       return (state as CalendarLoaded).datesWithData.keys.any(
//             (key) =>
//                 key.year == date.year &&
//                 key.month == date.month &&
//                 key.day == date.day,
//           );
//     }
//     return false;
//   }
// }

// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'package:intl/intl.dart';

// part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarInitial());

  Map<DateTime, String> datesWithData = {};
  late ValueNotifier<List<DateTime>> selectedDays;
  late ValueNotifier<DateTime> focusedDay;

  void initialize() {
    selectedDays = ValueNotifier([DateTime.now()]);
    focusedDay = ValueNotifier(DateTime.now());
    _fetchDates();
  }

  Future<Map<DateTime, String>> fetchDatesWithData() async {
    final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;
    final fb.User? user = auth.currentUser;
    final String? username = user!.displayName;
    final String userId = user.uid;
    final SupabaseClient supabase = Supabase.instance.client;
    try {
      // Query the calendar table to get the distinct dates with data
      // final response = await supabase.from('calendar').select('date_cal');
      final associationResponse = await supabase
          .from('Cal_Assocaitation')
          .select('cal_id')
          .inFilter('useruid', [userId, 'Thisiseveryonedebug']);
      // .eq('useruid', userId);

      log("Fetched associations for user $username: $associationResponse");

      final List<dynamic> calendarIds =
          associationResponse.map((e) => e['cal_id']).toList();

      // Query the calendar table to get the dates associated with these calendar IDs
      final calendarResponse = await supabase
          .from('calendar')
          .select('date_cal, media_urls')
          .inFilter('id', calendarIds); // Filter by calendar IDs

      log("Fetched calendar data: $calendarResponse");
      // .neq('date_cal', Null); // Ensure that the date is not null
      log("32 $calendarResponse");
      if (calendarResponse.isEmpty) {
        throw Exception('Error fetching calendar data');
      }

      // Extract the dates from the response
      final List<dynamic> data = calendarResponse as List<dynamic>;
      log("19 ${data.toString()}");

      // // Convert the date strings to DateTime objects
      // final Set<DateTime> datesWithData = data.map((e) {
      //   final date = e['date_cal'] as String;
      //   // final pic = e['media_urls'] as String;
      //   final dateTime =
      //       DateTime.parse(date); // Parse the date string into DateTime
      //   return DateTime(dateTime.year, dateTime.month,
      //       dateTime.day); // assuming date is stored as a string
      //   // return DateTime(
      //   //     date.year, date.month, date.day); // Remove time for comparison
      // }).toSet();
      try {
        final Map<DateTime, String> datesWithData = {
          for (var e in data)
            DateTime.parse(e['date_cal']): e['media_urls'] ?? 'No URL'
        };
        log("27 $datesWithData");
        return datesWithData;
      } catch (e) {
        log("error gwting something $e");
      }
      return {};
    } catch (e) {
      log('Error fetching dates: $e');
      return {};
    }
  }

  Future<void> _fetchDates() async {
    try {
      emit(CalendarLoading());
      datesWithData = await fetchDatesWithData();
      emit(CalendarLoaded(datesWithData: datesWithData));
    } catch (e) {
      emit(CalendarError(message: e.toString()));
    }
  }

  void addDateWithData(DateTime date, String? mediaUrl) {
    final updatedDates = Map<DateTime, String>.from(datesWithData);
    updatedDates[DateTime(date.year, date.month, date.day)] =
        mediaUrl ?? 'No URL';
    datesWithData = updatedDates;
    emit(CalendarLoaded(datesWithData: updatedDates));
  }

  bool hasData(DateTime date) {
    return datesWithData.keys.any(
      (key) =>
          key.year == date.year &&
          key.month == date.month &&
          key.day == date.day,
    );
  }
}
