import 'package:baymax/Globals/fonts.dart';
import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = AppColors.ash
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
