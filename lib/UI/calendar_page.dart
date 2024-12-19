import 'package:baymax/UI/memories.dart';
import 'package:baymax/UI/reminders.dart';
import 'package:baymax/widgets/circular_day_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:table_calendar/table_calendar.dart';

// class CalendarPage extends StatefulWidget {
//   const CalendarPage({super.key});

//   @override
//   State<CalendarPage> createState() => _CalendarPageState();
// }

// class _CalendarPageState extends State<CalendarPage> {
//   final DateTime _focusedDay = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: 12, // For 12 months
//         itemBuilder: (context, index) {
//           final month =
//               DateTime(_focusedDay.year, _focusedDay.month - index, 1);
//           return _buildMonthCalendar(month);
//         },
//       ),
//     );
//   }

//   Widget _buildMonthCalendar(DateTime month) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         elevation: 4,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 DateFormat.yMMMM().format(month),
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             _buildWeekdayLabels(),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 7, // 7 days in a week
//                 crossAxisSpacing: 4.0,
//                 mainAxisSpacing: 4.0,
//               ),
//               itemCount: DateTime(month.year, month.month + 1, 0).day +
//                   DateTime(month.year, month.month, 1)
//                       .weekday, // Total days + offset for the first day
//               itemBuilder: (context, index) {
//                 final day =
//                     index - DateTime(month.year, month.month, 1).weekday + 1;
//                 return day > 0
//                     ? GestureDetector(
//                         onTap: () {
// showDialog(
//   context: context,
//   builder: (context) => CalendarView(
//       selectedDate:
//           DateTime(month.year, month.month, day)),
// );
//                         },
//                         child: CircularDayWidget(day: day),
//                       )
//                     : Container(); // Empty cells for days of previous month
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWeekdayLabels() {
//     final daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: daysOfWeek
//             .map((day) =>
//                 Text(day, style: TextStyle(fontWeight: FontWeight.bold)))
//             .toList(),
//       ),
//     );
//   }
// }

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final ValueNotifier<List<DateTime>> _selectedDays;
  late final ValueNotifier<DateTime> _focusedDay;
  final int startyear = 2020;
  final int currentyear = DateTime.now().year;

  final DateTime startDate = DateTime(2022, 1); // Start from January 2022
  final DateTime endDate = DateTime.now()
      .add(const Duration(days: 365)); // End date 12 months from now

  // Calculate the total number of months dynamically
  int gettotalMonths() {
    return (endDate.year - startDate.year) * 12 +
        (endDate.month - startDate.month + 1);
  }

  int getCurrentMonthIndex() {
    final now = DateTime.now();
    const startYear = 2022;
    return (now.year - startYear) * 12 + now.month - 1;
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = ValueNotifier(DateTime.now());
    _selectedDays = ValueNotifier([DateTime.now()]);
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _selectedDays.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Icon(
                    color: Colors.white,
                    Icons.arrow_back_ios_rounded,
                  ),
                )),
          ),
          // Weekdays Header
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Sun',
                    style: TextStyle(color: Color.fromARGB(192, 68, 137, 255))),
                Text('Mon',
                    style: TextStyle(color: Color.fromARGB(192, 68, 137, 255))),
                Text('Tue',
                    style: TextStyle(color: Color.fromARGB(192, 68, 137, 255))),
                Text('Wed',
                    style: TextStyle(color: Color.fromARGB(192, 68, 137, 255))),
                Text('Thu',
                    style: TextStyle(color: Color.fromARGB(192, 68, 137, 255))),
                Text('Fri',
                    style: TextStyle(color: Color.fromARGB(192, 68, 137, 255))),
                Text('Sat',
                    style: TextStyle(color: Color.fromARGB(192, 68, 137, 255))),
              ],
            ),
          ),

          // Vertical scrollable list of months
          Expanded(
            child: ScrollablePositionedList.builder(
              initialScrollIndex: getCurrentMonthIndex(),
              // reverse: true,
              // itemCount: 24,
              itemCount: gettotalMonths(),
              itemBuilder: (context, index) {
                // final monthOffset = index; // Starts from the current month
                // final monthDate =
                //     DateTime.now().subtract(Duration(days: 30 * (index)));

                final monthOffset = index;
                final monthDate = DateTime(2022, 1).add(
                    Duration(days: 30 * monthOffset)); // From 2022 Jan onwards

                final monthName = DateFormat('MMMM yyyy').format(monthDate);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Center(
                        child: Text(
                          monthName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            // color: Color.fromARGB(77, 177, 254, 255)
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    TableCalendar(
                      availableGestures: AvailableGestures.none,
                      daysOfWeekVisible: false,
                      headerVisible: false,
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: monthDate,
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.blueAccent, // Highlight today's date
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.orange, // Highlight selected date
                          shape: BoxShape.circle,
                        ),
                        // weekendTextStyle: TextStyle(
                        //   color: Colors.red, // Color for weekends
                        //   fontWeight: FontWeight.bold,
                        // ),

                        // weekdayTextStyle: TextStyle(
                        //   color: Colors.white, // Color for weekdays
                        // ),
                        outsideTextStyle: TextStyle(
                          color: Colors
                              .grey, // Color for days outside the current month
                        ),
                        defaultTextStyle: TextStyle(
                          color: Colors.white, // Color for default days
                        ),
                      ),
                      selectedDayPredicate: (day) {
                        return _selectedDays.value.contains(day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _focusedDay.value = focusedDay;
                          if (selectedDay.isBefore(DateTime.now())) {
                            // _showDialog(context, Colors.blue, "Past Date");
                            showDialog(
                              context: context,
                              builder: (context) => MemoryView(
                                  selectedDate: DateTime(selectedDay.year,
                                      selectedDay.month, selectedDay.day)),
                            );
                          } else if (selectedDay.isAfter(DateTime.now())) {
                            // _showDialog(context, Colors.red, "Future Date");
                            showDialog(
                              context: context,
                              builder: (context) => ReminderView(
                                  selectedDate: DateTime(selectedDay.year,
                                      selectedDay.month, selectedDay.day)),
                            );
                          }
                          _selectedDays.value = [selectedDay];
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, Color color, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: color,
          title: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //   void _memories(BuildContext context, Color color, String message) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: color,
  //         title: Text(selectedDay),
  //         actions: [
  //           TextButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
