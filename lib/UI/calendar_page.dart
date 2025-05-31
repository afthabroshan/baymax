import 'package:baymax/Cubits/cubit/calendar_cubit.dart';
import 'package:baymax/Globals/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:baymax/UI/memories.dart';
import 'package:baymax/UI/memory_view.dart';
import 'package:baymax/UI/reminders.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarCubit()..initialize(),
      child: Scaffold(
        backgroundColor: AppColors.bgcolor,
        body: Column(
          children: [
            SizedBox(height: 30.h),
            _buildBackButton(context),
            _buildWeekdayHeader(),
            Expanded(
              child: BlocBuilder<CalendarCubit, CalendarState>(
                  builder: (context, state) {
                if (state is CalendarLoading) {
                  return const Center(child: CustomCircularProgressIndicator());
                } else if (state is CalendarError) {
                  return Text("Error: ${state.message}");
                } else if (state is CalendarLoaded) {
                  return PagedVerticalCalendar(
                      minDate:
                          DateTime.now().subtract(const Duration(days: 180)),
                      maxDate: DateTime.now().add(const Duration(days: 60)),
                      initialDate: DateTime.now(),
                      invisibleMonthsThreshold: 1,
                      dayBuilder: (context, date) =>
                          _buildDayWidget(context, date, state.datesWithData),
                      monthBuilder: _buildMonthWidget,
                      onDayPressed: (date) {
                        final today = DateTime.now();
                        bool hasData =
                            context.read<CalendarCubit>().hasData(date);

                        if (date.isBefore(today)) {
                          final calendarCubit = context.read<CalendarCubit>();

                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return BlocProvider.value(
                                value:
                                    calendarCubit, // 👈 Pass the existing instance
                                child: hasData
                                    ? MemoryView(selectedDate: date)
                                    : Memoryadd(selectedDate: date),
                              );
                            },
                          );
                        } else if (date.isAfter(today)) {
                          // Show ReminderView dialog
                          showDialog(
                            context: context,
                            builder: (context) =>
                                ReminderView(selectedDate: date),
                          );
                        }
                      });
                }
                return const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: EdgeInsets.only(left: 15.sp),
          child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.textash),
        ),
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    const weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Padding(
      padding: EdgeInsets.all(6.0.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            weekDays.map((day) => Text(day, style: _weekdayStyle())).toList(),
      ),
    );
  }

  TextStyle _weekdayStyle() {
    return AppTextStyles.calendartextwhite.copyWith(color: AppColors.blue);
  }

  Widget _buildDayWidget(BuildContext context, DateTime date,
      Map<DateTime, String> datesWithData) {
    final today = DateTime.now();
    bool isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    bool hasData = context.read<CalendarCubit>().hasData(date);
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
                datesWithData[date] ?? "",
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

  Widget _buildMonthWidget(BuildContext context, int month, int year) {
    return Padding(
      padding: EdgeInsets.all(8.0.sp),
      child: Center(
        child: Text(
          '${DateFormat.MMMM().format(DateTime(year, month))} $year',
          style: AppTextStyles.calendarHeaders,
        ),
      ),
    );
  }
}
