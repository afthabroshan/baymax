// import 'dart:ffi';

import 'dart:developer';
import 'dart:ui';

import 'package:baymax/UI/AI.dart';
import 'package:baymax/UI/calendar_page.dart';
import 'package:baymax/UI/fadeIn.dart';
import 'package:baymax/UI/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as Fmap;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as lat;
import 'package:lottie/lottie.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  lat.LatLng? _currentPosition;

  late AnimationController _controller1;
  late Animation<Offset> _animation1;

  late AnimationController _controller2;
  late Animation<Offset> _animation2;

  late AnimationController _controller3;
  late Animation<Offset> _animation3;

  // LatLng _currentPosition = LatLng(0.0, 0.0); // Default to the equator (0, 0)

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    // Initialize AnimationController
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Define Tween for sliding animation
    _animation1 = Tween<Offset>(
      begin: Offset(0.0, -1.0), // Start above the screen
      end: Offset.zero, // End at its original position
    ).animate(CurvedAnimation(
      parent: _controller1,
      curve: Curves.easeOut,
    ));
    _controller1.forward();

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Define Tween for sliding animation
    _animation2 = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Start above the screen
      end: Offset.zero, // End at its original position
    ).animate(CurvedAnimation(
      parent: _controller2,
      curve: Curves.easeOutCirc,
    ));
    _controller2.forward();

    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Define Tween for sliding animation
    _animation3 = Tween<Offset>(
      begin: Offset(0.0, 1.0), // Start above the screen
      end: Offset.zero, // End at its original position
    ).animate(CurvedAnimation(
      parent: _controller3,
      curve: Curves.easeOut,
    ));
    _controller3.forward();
    // Start the animation
    _getCurrentLocation();
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await _supabase.from('Users').select();

      if (response.isNotEmpty) {
        setState(() {
          _users = List<Map<String, dynamic>>.from(response);
          _isLoading = false;
        });
      } else {
        setState(() {
          _users = [];
          _isLoading = false;
        });
        log("no users found");
      }
    } catch (e) {
      log('Error fetching users: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool servicesEnabled;
    LocationPermission permission;

    servicesEnabled = await Geolocator.isLocationServiceEnabled();
    if (!servicesEnabled) {
      return Future.error("Location Services disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error('Location permissions are denied.');
      }
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = lat.LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
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
      drawer:
          //  Container(

          //     // backgroundColor: Colors.transparent,
          //     // color: Colors.transparent,
          //     // color: Colors.red,
          //     // shadowColor: Colors.white,
          //     // decoration: const BoxDecoration(
          //     //   color: Colors.transparent,
          //     //   shape: BoxShape.circle,
          //     //   // borderRadius: BorderRadius.all(Radius.circular(35))
          //     // ),
          //     width: 250.w,
          //     height: _users.length * 80,
          //     // width: 400,
          //     child:
          Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(35)),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 5.0, sigmaY: 5.0), // Adjust blur strength here
                child: SizedBox(
                  // color: Colors.black.withAlpha(50),
                  width: 200.w,
                  height: _users.length * 75,
                  // decoration: const BoxDecoration(
                  //     // color: Colors.black,
                  //     shape: BoxShape.rectangle,
                  //     borderRadius: BorderRadius.all(Radius.circular(35))
                  // borderRadius: BorderRadius.all(Radius.circular(35))
                  // ), // Optional dark overlay
                ),
              ),
            ),
          ),
          _isLoading
              ? Center(
                  child: Lottie.asset(
                    'assets/wood.json',
                  ),
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          final appUser = _users[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(appUser['photo_url'] ?? pic!),
                            ),
                            title: Text(
                              appUser['display_name'],
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }),
                  ),
                )
        ],
        // )
      ),
      endDrawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Right Drawer')),
            ListTile(title: Text('Option A')),
            ListTile(title: Text('Option B')),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 0.85,
                child: CustomPaint(
                  // size: Size(double.infinity, 150),
                  painter: WavePainter(),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 25.h,
                          left: 10.h,
                          child: Text('Hey',
                              style: GoogleFonts.abhayaLibre(
                                  fontSize: 50.sp,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 3,
                                  color: const Color.fromARGB(
                                      244, 220, 220, 220))),
                        ),
                        Positioned(
                          top: 60.h,
                          left: 34.h,
                          child: Text(firstName,
                              style: GoogleFonts.greatVibes(
                                  fontSize: 60.sp,
                                  letterSpacing: 2,
                                  color: const Color.fromARGB(
                                      255, 148, 187, 255))),
                        ),
                        Positioned(
                          right: 30,
                          top: 36,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(pic!),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SlideTransition(
              position: _animation1,
              child: Expanded(
                child: Container(
                  // color: Colors.amber,
                  // height: 205.h,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 34, 34, 34),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(45))
                      // borderRadius: BorderRadius.only(
                      //     bottomRight: Radius.circular(45),
                      //     bottomLeft: Radius.circular(45))
                      ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        month,
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                        width: 20.w,
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
                        lastDay: lastDay,
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
                        // headerStyle: HeaderStyle(
                        //   titleTextStyle: TextStyle(
                        //     color: Colors.white, // Title text color
                        //     fontSize: 20.sp,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        //   leftChevronIcon: Icon(
                        //     Icons.chevron_left,
                        //     color: Colors.white, // Chevron icon color
                        //   ),
                        //   rightChevronIcon: Icon(
                        //     Icons.chevron_right,
                        //     color: Colors.white, // Chevron icon color
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: Colors.grey[800], // Header background color
                        //   ),
                        // ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      // GestureDetector(
                      //     onVerticalDragUpdate: (details) {
                      //       if (details.delta.dy > 0) {
                      //         Navigator.push(
                      //           context,
                      //           PageRouteBuilder(
                      //             transitionDuration:
                      //                 const Duration(milliseconds: 800),
                      //             pageBuilder: (context, animation,
                      //                     secondaryAnimation) =>
                      //                 const CalendarPage(),
                      //             transitionsBuilder: (context, animation,
                      //                 secondaryAnimation, child) {
                      //               const begin = Offset(0.0, -1.0);
                      //               const end = Offset.zero;
                      //               const curve = Curves.easeIn;
                      //               final tween = Tween(begin: begin, end: end)
                      //                   .chain(CurveTween(curve: curve));
                      //               final offsetAnimation =
                      //                   animation.drive(tween);
                      //               return SlideTransition(
                      //                 position: offsetAnimation,
                      //                 child: child,
                      //               );
                      //             },
                      //           ),
                      //         );
                      //       }
                      //     },
                      //     child: const Icon(Icons.keyboard_arrow_down_sharp))
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/CalendarPage');
                        },
                        child: Text("See All",
                            style: TextStyle(
                                fontSize: 16.sp,
                                color:
                                    const Color.fromARGB(255, 142, 142, 142))),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 8.w,
                ),
                // FloatingActionButton(onPressed: () {
                //   ScaffoldMessenger.of(context).openDrawer();
                // }),
                Builder(builder: (context) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        // color: const Color.fromARGB(255, 50, 50, 50),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                              opacity: 0.6,
                              image: AssetImage('assets/users.png')),
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(
                  width: 8.w,
                ),
                SlideTransition(
                  position: _animation2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Expanded(
                      //   child: Container(
                      //     height: 100,
                      //     width: 100,
                      //     // color: Colors.white,
                      //     decoration: BoxDecoration(
                      //         color: Colors.white, shape: BoxShape.circle),
                      //   ),
                      // ),
                      Container(
                        // color: Colors.blue,
                        height: 100.h,
                        width: 240.h,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(255, 182, 246, 255)
                            ]),
                            // color: Color.fromARGB(255, 250, 251, 251),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(55),
                                bottomLeft: Radius.circular(55))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onHorizontalDragUpdate: (details) {
                                  if (details.delta.dx < 0) {
                                    // Detect right to left swipe
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 800),
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            AIPage(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(1.0,
                                              0.0); // Transition from right to left
                                          const end = Offset.zero;
                                          const curve = Curves.easeIn;
                                          final tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          final offsetAnimation =
                                              animation.drive(tween);
                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                                child:
                                    const Icon(Icons.arrow_back_ios_rounded)),
                            // Expanded(child: riv.asset())
                            Expanded(
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Lottie.asset(
                                      'assets/blob.json',
                                    ),
                                    // Lottie.network(
                                    //   // 'https://lottie.host/94c8794e-4d51-4c04-8f7a-4fed2a58242d/4dcxNaPUsq.json',
                                    //   "https://lottie.host/19aa6fc7-f805-4721-8693-703b66cac672/5OvsG78vTi.json",
                                    //   repeat: true,
                                    //   animate: true,
                                    //   reverse: false,
                                    //   frameRate: FrameRate(60), // Play speed control
                                    // ),
                                    Center(
                                      child: Text(
                                        "Hey $firstName, come let's talk!",
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                    255, 121, 87, 75)
                                                .withAlpha(200),
                                            fontStyle: FontStyle.italic,
                                            fontSize: 15.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            SlideTransition(
              position: _animation3,
              child: Container(
                height: 369.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 45, 45, 45),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45)),
                ),
                child: _currentPosition == null
                    ? Center(
                        child: Lottie.asset(
                          'assets/fingerL.json',
                        ),
                      )
                    : Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onVerticalDragUpdate: (details) {
                                if (details.delta.dy < 0) {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 800),
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          LocationPage(),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(0.0,
                                            1.0); // Transition from bottom to top
                                        const end = Offset.zero;
                                        const curve = Curves.easeIn;
                                        final tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        final offsetAnimation =
                                            animation.drive(tween);
                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                              child: const Icon(Icons.keyboard_arrow_up)),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            "You're here",
                            style: TextStyle(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                color: Colors.white.withValues(alpha: 0.5)),
                          ),
                          SizedBox(height: 10.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              height: 200.h,
                              width: 200.w,
                              decoration: const BoxDecoration(
                                // border: Border.all(),
                                // color: const Color.fromARGB(0, 255, 255, 255),
                                shape: BoxShape.rectangle,
                                // borderRadius: BorderRadius.circular(10),
                                // boxShadow: const [
                                //   BoxShadow(
                                //     color: Colors.black,
                                //     blurRadius: 30,
                                //     offset: Offset(0, 25),
                                //   ),
                                // ],
                              ),
                              child: Fmap.FlutterMap(
                                options: Fmap.MapOptions(
                                  initialCenter: _currentPosition!,
                                  initialZoom: 14.0,
                                ),
                                children: [
                                  Fmap.TileLayer(
                                    urlTemplate:
                                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                    // subdomains: ['a', 'b', 'c'],
                                  ),
                                  Fmap.MarkerLayer(
                                    markers: [
                                      Fmap.Marker(
                                        width: 80.0.w,
                                        height: 80.0.h,
                                        point: _currentPosition!,
                                        child: const Icon(
                                          Icons.location_pin,
                                          color: Colors.blue,
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 43, 43, 43)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.lineTo(0, size.height - 100); // Move up slightly on the left
    path.quadraticBezierTo(size.width / 5, size.height + 40, size.width + 40,
        size.height - 150); // Wave
    path.lineTo(0, -size.width); // Connect to bottom-right
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class UsersClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = const Color.fromARGB(255, 53, 53, 53);

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);

    // Curve to the middle-left
    // path.quadraticBezierTo(
    //   size.width * 0.5, // Control point X
    //   size.height * 0.25, // Control point Y
    //   0, // End point X
    //   size.height * 0.5, // End point Y
    // );

    // // Curve to the bottom-left
    // path.quadraticBezierTo(
    //   size.width * 0.5, // Control point X
    //   size.height * 0.75, // Control point Y
    //   0, // End point X
    //   size.height, // End point Y
    // );

    // // Close the path
    // path.lineTo(0, size.height);
    // path.close();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 10, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 10, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 50, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
