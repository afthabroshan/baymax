import 'package:baymax/UI/landing_page.dart';
import 'package:baymax/UI/side_bar_left.dart';
import 'package:flutter/material.dart';

class Sidebarlayoutl extends StatelessWidget {
  const Sidebarlayoutl({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const LandingPage(),
        SideBarLeft(),
      ],
    );
  }
}
