import 'dart:math';

import 'package:flutter/material.dart';

class DrawingCanvas extends CustomPainter {
  // Painting method, Canvas = the paper to draw and paint on it
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3;

    canvas.drawLine(Offset(50, 50), Offset(50, 150), paint);
    canvas.drawArc(
      // rect used to define the center to start drawing and the radius for the fromCircle
      Rect.fromCircle(center: Offset(300, 300), radius: 100),
      // it's okay to use from center when u do not want t perfect circle
      // Rect.fromCenter(center: Offset(300, 300), width: 350, height: 200),
      pi,
      2 * pi,
      false,
      paint,
    );

    Path path = Path();
    path.moveTo(700, 700);
    path.lineTo(800, 500);
    path.lineTo(900, 700);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return false;
  }
}
