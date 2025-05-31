// theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const bgcolor = Colors.black; // Green
  static const ash = Color.fromARGB(255, 34, 34, 34);
  static const blue = Color.fromARGB(255, 2, 95, 255);
  static const white = Colors.white;
  static const textash = Color.fromARGB(255, 142, 142, 142);
  static const red = Colors.red;
  static const lightgreen = Colors.green;
}

class AppTextStyles {
  static final calendarHeaders = TextStyle(
    fontSize: 22.sp,
    color: AppColors.white,
    fontFamily: 'Newsreader',
  );

  static final medContent = TextStyle(
    fontSize: 16.sp,
    // fontWeight: FontWeight.bold,
    color: AppColors.textash,
    fontFamily: 'Newsreader',
  );
  static const calendartextwhite = TextStyle(
    color: AppColors.white,
    fontFamily: 'Newsreader',
  );
  static const calendartextash = TextStyle(
    color: AppColors.textash,
    fontFamily: 'Newsreader',
  );
  static const smallContent = TextStyle(
    fontSize: 12,
    // fontWeight: FontWeight.bold,
    color: AppColors.textash,
    fontFamily: 'Newsreader',
  );
  static const aiContent = TextStyle(
    color: AppColors.white,
    fontSize: 14,
    fontFamily: 'Silkscreen',
  );
}

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
    );
  }
}

class CustomLinearProgressIndicator extends StatelessWidget {
  const CustomLinearProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
    );
  }
}
