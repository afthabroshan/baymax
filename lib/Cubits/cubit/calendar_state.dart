// part of 'calendar_cubit.dart';

// class CalendarState extends Equatable {
//   final DateTime selectedDay;
//   final Map<DateTime, String> datesWithData;

//   const CalendarState({required this.selectedDay, required this.datesWithData});

//   factory CalendarState.initial() {
//     return CalendarState(
//       selectedDay: DateTime.now(),
//       datesWithData: {},
//     );
//   }

//   CalendarState copyWith(
//       {DateTime? selectedDay, Map<DateTime, String>? datesWithData}) {
//     return CalendarState(
//       selectedDay: selectedDay ?? this.selectedDay,
//       datesWithData: datesWithData ?? this.datesWithData,
//     );
//   }

//   @override
//   List<Object> get props => [selectedDay, datesWithData];
// }

part of 'calendar_cubit.dart';

// abstract class CalendarState extends Equatable {
//   const CalendarState();

//   @override
//   List<Object> get props => [];
// }

// class CalendarLoading extends CalendarState {}

// class CalendarLoaded extends CalendarState {
//   final DateTime selectedDay;
//   final Map<DateTime, String> datesWithData;

//   const CalendarLoaded(
//       {required this.selectedDay, required this.datesWithData});

//   CalendarLoaded copyWith(
//       {DateTime? selectedDay, Map<DateTime, String>? datesWithData}) {
//     return CalendarLoaded(
//       selectedDay: selectedDay ?? this.selectedDay,
//       datesWithData: datesWithData ?? this.datesWithData,
//     );
//   }

//   @override
//   List<Object> get props => [selectedDay, datesWithData];
// }

// class CalendarError extends CalendarState {
//   final String message;
//   const CalendarError(this.message);

//   @override
//   List<Object> get props => [message];
// }

// abstract class CalendarState {}

// class CalendarLoading extends CalendarState {}

// class CalendarLoaded extends CalendarState {
//   final Map<DateTime, String> datesWithData;
//   final ValueNotifier<List<DateTime>> selectedDays;
//   // final DateTime focusedDay;
//   final ValueNotifier<DateTime> focusedDay;

//   CalendarLoaded({
//     required this.datesWithData,
//     required this.selectedDays,
//     required this.focusedDay,
//   });

//   CalendarLoaded copyWith({
//     Map<DateTime, String>? datesWithData,
//     // List<DateTime>? selectedDays,
//     final ValueNotifier<List<DateTime>>? selectedDays,
//     // DateTime? focusedDay,
//     final ValueNotifier<DateTime>? focusedDay,
//   }) {
//     return CalendarLoaded(
//       datesWithData: datesWithData ?? this.datesWithData,
//       selectedDays: selectedDays ?? this.selectedDays,
//       focusedDay: focusedDay ?? this.focusedDay,
//     );
//   }
// }

// part of 'calendar_cubit.dart';

@immutable
abstract class CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final Map<DateTime, String> datesWithData;

  CalendarLoaded({required this.datesWithData});
}

class CalendarError extends CalendarState {
  final String message;

  CalendarError({required this.message});
}
