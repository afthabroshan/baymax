import 'dart:developer';

import 'package:baymax/Cubits/cubit/calendar_cubit.dart';
import 'package:baymax/Globals/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar_Section extends StatefulWidget {
  const Calendar_Section({
    super.key,
    required this.month,
    required this.now,
    required this.firstDay,
    required this.lastDay,
  });

  final String month;
  final DateTime now;
  final DateTime firstDay;
  final DateTime lastDay;

  @override
  State<Calendar_Section> createState() => _Calendar_SectionState();
}

class _Calendar_SectionState extends State<Calendar_Section> {
  bool isloading = false;
  void _navigateToCalendar() async {
    setState(() {
      isloading = true; // Show loading indicator
    });

    await Navigator.pushNamed(context, '/CalendarPage'); // Wait for navigation

    if (mounted) {
      setState(() {
        isloading = false; // Hide loading indicator after returning
      });
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<CalendarCubit>().initialize(); // initialize cubit on start
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        if (state is CalendarLoading) {
          return const Center(child: CustomCircularProgressIndicator());
        } else if (state is CalendarError) {
          return Center(child: Text("Error: ${state.message}"));
        } else if (state is CalendarLoaded) {
          final datesWithData = state.datesWithData;
          log("homepage$datesWithData");
          return Container(
            decoration: const BoxDecoration(
                color: AppColors.ash,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(45))),
            child: Column(
              children: [
                SizedBox(
                  height: 8.h,
                ),
                Text(widget.month, style: AppTextStyles.calendarHeaders),
                SizedBox(
                  height: 5.h,
                ),
                TableCalendar(
                  headerVisible: false,
                  daysOfWeekVisible: true,
                  daysOfWeekHeight: 25.h,
                  calendarFormat: CalendarFormat.twoWeeks,
                  focusedDay: widget.now,
                  firstDay: widget.firstDay,
                  lastDay: widget.lastDay,
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: AppTextStyles.calendartextwhite,
                    weekendTextStyle: AppTextStyles.calendartextash,
                    outsideTextStyle: AppTextStyles.calendartextash,
                    todayTextStyle: AppTextStyles.calendartextwhite,
                    selectedTextStyle: AppTextStyles.calendartextwhite,
                    disabledTextStyle: AppTextStyles.calendartextash,
                  ),
                  loadEventsForDisabledDays: true,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: AppTextStyles.calendartextwhite
                        .copyWith(color: AppColors.blue),
                    weekendStyle: AppTextStyles.calendartextash
                        .copyWith(color: AppColors.blue),
                  ),
                  calendarBuilders: CalendarBuilders(
                    disabledBuilder: (context, date, _) =>
                        _buildDayWidget(context, date, state.datesWithData),
                    defaultBuilder: (context, date, _) =>
                        _buildDayWidget(context, date, state.datesWithData),
                    // markerBuilder: (context, date, events) {
                    //   final normalizedDate =
                    //       DateTime(date.year, date.month, date.day);

                    //   if (datesWithData.containsKey(normalizedDate)) {
                    //     return Positioned(
                    //       bottom: 1,
                    //       child: Icon(
                    //         Icons.circle,
                    //         size: 6,
                    //         color: AppColors.blue,
                    //       ),
                    //     );
                    //   }

                    //   return null;
                    // },
                  ),
                ),
                GestureDetector(
                    onTap: _navigateToCalendar,
                    child: isloading
                        ? const CustomCircularProgressIndicator()
                        : Text("See All", style: AppTextStyles.medContent)),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

Widget _buildDayWidget(
    BuildContext context, DateTime date, Map<DateTime, String> datesWithData) {
  final today = DateTime.now();
  final normalizedDate = DateTime(date.year, date.month, date.day);
  final todayNormalized = DateTime(today.year, today.month, today.day);

  bool isToday = normalizedDate == todayNormalized;
  bool hasData = datesWithData.containsKey(normalizedDate);
  return Container(
    margin: EdgeInsets.all(4.sp),
    width: 40.w, // Fixed width for circle shape
    height: 40.h, // Fixed height for circle shape
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isToday
          ? AppColors.blue
          // ? const Color.fromARGB(255, 2, 95, 255)
          : Colors.transparent,
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Show circular image only if data exists
        if (hasData)
          ClipOval(
            child: Image.network(
              datesWithData[normalizedDate] ?? "",
              width: 40.w,
              height: 40.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.textash,
                );
              },
            ),
          ),

        // Show date number on top of image or alone
        Text(
          DateFormat.d().format(date),
          style: TextStyle(
              color: hasData
                  ? AppColors.white
                  : isToday
                      ? AppColors.white
                      : AppColors.textash,
              fontWeight: FontWeight.bold,
              fontFamily: 'Newsreader'),
        ),
      ],
    ),
  );
}
