import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Users_list extends StatelessWidget {
  const Users_list({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/users.png',
      height: 62.h,
      width: 100.w,
      fit: BoxFit.cover,
    );
  }
}
