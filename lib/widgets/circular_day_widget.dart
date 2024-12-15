import 'package:flutter/material.dart';

class CircularDayWidget extends StatelessWidget {
  final int day;

  const CircularDayWidget({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      //   shape: BoxShape.circle,
      //   image: DecorationImage(
      //     image: AssetImage('assets/images/day_$day.jpg'), // Example image
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 160, 160, 160).withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Text(
          day.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
