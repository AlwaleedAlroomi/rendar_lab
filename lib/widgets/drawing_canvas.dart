import 'package:flutter/material.dart';
import 'package:rendar_lab/models/drawing_path_model.dart';

class DrawingCanvas extends CustomPainter {
  final List<DrawingPathModel> paths;
  final List<Offset> currentPaint;

  DrawingCanvas({
    super.repaint,
    required this.paths,
    required this.currentPaint,
  });
  // Painting method, Canvas = the paper to draw and paint on it
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (var drawingPath in paths) {
      Path path = Path();
      if (drawingPath.points.isNotEmpty) {
        path.moveTo(drawingPath.points.first.dx, drawingPath.points.first.dy);

        for (var i = 1; i < drawingPath.points.length; i++) {
          path.lineTo(drawingPath.points[i].dx, drawingPath.points[i].dy);
        }
      }
      canvas.drawPath(path, paint);
    }
    // for (var drawingPath in currentPaint) {
    if (currentPaint.isNotEmpty) {
      Path path = Path();

      path.moveTo(currentPaint.first.dx, currentPaint.first.dy);

      for (var i = 1; i < currentPaint.length; i++) {
        path.lineTo(currentPaint[i].dx, currentPaint[i].dy);
      }

      canvas.drawPath(path, paint);
    }
    // }
  }

  @override
  bool shouldRepaint(covariant DrawingCanvas oldDelegate) {
    return oldDelegate.paths.length != paths.length ||
        oldDelegate.currentPaint.length != currentPaint.length;
  }
}
