// import 'package:baymax/UI/AI.dart';
// import 'package:baymax/UI/landing_page.dart';
// import 'package:baymax/UI/location.dart';
// import 'package:flutter/material.dart';
// import 'calendar_page.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int _selectedIndex = 0;
//   static  List<Widget> pages = <Widget>[
//     LandingPage(),
//     const CalendarPage(),
//      AIPage(),
//     LocationPage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: 'Calendar',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.adb),
//             label: 'AI',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.location_on),
//             label: 'Location',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Theme.of(context).colorScheme.primary,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
