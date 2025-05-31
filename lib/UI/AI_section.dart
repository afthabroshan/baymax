import 'dart:math';

import 'package:baymax/Globals/AIgreeting.dart';
import 'package:baymax/Globals/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class AI_Section extends StatelessWidget {
  const AI_Section({
    super.key,
    required this.firstName,
  });

  final String firstName;

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final List<String> messages = AppMessages.greetings(firstName);
    final String randomMessage = messages[random.nextInt(messages.length)];
    return GestureDetector(
      onTap: () {
        // Navigate to AIPage when the container is tapped
        Navigator.pushNamed(context, '/AIPage');
      },
      child: Container(
        height: 90.h,
        width: 240.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.ash,
              AppColors.blue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(55.r),
            bottomLeft: Radius.circular(55.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.white,
            ),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.asset(
                      'assets/blob.json',
                    ),
                    Center(
                      child: Text(
                        randomMessage,
                        style: AppTextStyles.medContent.copyWith(
                            color: AppColors.white,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
