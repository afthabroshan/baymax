import 'package:baymax/Cubits/cubit/AuthCubit.dart';
import 'package:baymax/Cubits/cubit/calendar_cubit.dart';
import 'package:baymax/Cubits/cubit/drawer_cubit.dart';
import 'package:baymax/Cubits/cubit/location_cubit.dart';
import 'package:baymax/Globals/fonts.dart';
import 'package:baymax/UI/AI_section.dart';
import 'package:baymax/UI/Users_list.dart';
import 'package:baymax/UI/add_notes.dart';
import 'package:baymax/UI/calendar_section.dart';
import 'package:baymax/UI/left_drawer.dart';
import 'package:baymax/UI/location_section.dart';
import 'package:baymax/UI/name_section.dart';
import 'package:baymax/UI/notes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final pic = user?.photoURL;
    final fullName = user?.displayName;
    String firstName = fullName?.split(' ').first ?? 'Guest';
    DateTime now = DateTime.now();
    DateTime firstDay = now;
    DateTime lastDay = now.add(Duration(days: 6));
    String month = DateFormat.MMMM().format(DateTime.now());

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CalendarCubit()..initialize(),
        ),
        BlocProvider(
          create: (context) => DrawerCubit()..fetchUsers(),
        ),
        BlocProvider(
          create: (context) => LocationCubit()..getCurrentLocation(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(GoogleSignIn(), FirebaseAuth.instance),
        ),
      ],
      child: Scaffold(
        drawer: const drawer(),
        backgroundColor: AppColors.bgcolor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Name_section(firstName: firstName, pic: pic),
              Calendar_Section(
                  month: month, now: now, firstDay: firstDay, lastDay: lastDay),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 7.w,
                  ),
                  Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        context.read<DrawerCubit>().fetchUsers();
                        Scaffold.of(context).openDrawer();
                      },
                      child: const Users_list(),
                    );
                  }),
                  SizedBox(
                    width: 7.w,
                  ),
                  AI_Section(firstName: firstName),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              const Location_Section(),
              Row(
                children: [Expanded(child: NotesScreen()), const AddNotes()],
              )
            ],
          ),
        ),
      ),
    );
  }
}
