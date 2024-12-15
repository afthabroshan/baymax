import 'package:baymax/UI/calendar_view.dart';
import 'package:baymax/widgets/circular_day_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Perski Calendar'),
      ),
      body: ListView.builder(
        itemCount: 12, // For 12 months
        itemBuilder: (context, index) {
          final month = DateTime(_focusedDay.year, _focusedDay.month - index, 1);
          return _buildMonthCalendar(month);
        },
      ),
    );
  }

  Widget _buildMonthCalendar(DateTime month) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat.yMMMM().format(month),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            _buildWeekdayLabels(),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, // 7 days in a week
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: DateTime(month.year, month.month + 1, 0).day + DateTime(month.year, month.month, 1).weekday, // Total days + offset for the first day
              itemBuilder: (context, index) {
                final day = index - DateTime(month.year, month.month, 1).weekday + 1;
                return day > 0
                    ? GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CalendarView(selectedDate: DateTime(month.year, month.month, day)),
                          );
                        },
                        child: CircularDayWidget(day: day),
                      )
                    : Container(); // Empty cells for days of previous month
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayLabels() {
    final daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: daysOfWeek.map((day) => Text(day, style: TextStyle(fontWeight: FontWeight.bold))).toList(),
      ),
    );
  }
}
