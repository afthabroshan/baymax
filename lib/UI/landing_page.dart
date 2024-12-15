import 'package:baymax/UI/AI.dart';
import 'package:baymax/UI/calendar_page.dart';
import 'package:baymax/UI/location.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime firstDay = now;
    DateTime lastDay = now.add(Duration(days: 6));
    String month = DateFormat.MMMM().format(DateTime.now());
    //   return Scaffold(
    //     body: SnappingSheet(
    //       child: Container(color: Colors.black,),
    //       grabbingHeight: 100,
    //       // grabbing: Container(color: Colors.red,),
    //       sheetAbove: SnappingSheetContent(child: Container(color: Colors.blue,),

    //     ),
    //     sheetBelow: SnappingSheetContent(child: Container(color: Colors.deepPurple,)),
    //   ));
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            // color: Colors.amber,
            height: 295.h,
            decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(45),
                    bottomLeft: Radius.circular(45))),
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  month,
                  style: TextStyle(fontSize: 20.sp),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TableCalendar(
                    headerVisible: false,
                    daysOfWeekVisible: true,
                    daysOfWeekHeight: 30.h,
                    calendarFormat: CalendarFormat.twoWeeks,
                    focusedDay: now,
                    firstDay: firstDay,
                    lastDay: lastDay),
                SizedBox(
                  height: 20,
                ),
                const Icon(Icons.keyboard_arrow_down_sharp)
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                // color: Colors.blue,
                height: 100.h,
                width: 260.h,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(55),
                        bottomLeft: Radius.circular(55))),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
              height: 275.h,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45))))
        ],
      ),
    );
  }
}
